/*----------------------------------------------------
Player Damage
----------------------------------------------------*/
function GM:EntityTakeDamage(ent, dmginfo)
   if not ValidEntity(ent) then return end
   local att = dmginfo:GetAttacker()
   local infl = dmginfo:GetInflictor()

   if not GAMEMODE:AllowPVP() then
      if (ent:IsPlayer() and ValidEntity(att) and att:IsPlayer()) then
         dmginfo:ScaleDamage(0)
         dmginfo:SetDamage(0)
      end
   elseif ent:IsPlayer() then
      GAMEMODE:PlayerTakeDamage(ent, infl, att, amount, dmginfo)
   end
end

function GM:PlayerTakeDamage(ent, infl, att, amount, dmginfo)
   -- For unknown reasons, damage is doubled by gmod. Compensate for that here.
   dmginfo:SetDamage(dmginfo:GetBaseDamage() / 2)


   //MsgN("Player: "..ent.."|Inflictor: "..infl.."|Attacker: "..att:Nick())

   if (!infl:IsWeapon()) && att:IsPlayer() && dmginfo:IsBulletDamage() then
      infl = att:GetActiveWeapon()
   end

   if att:GetClass() == "ent_explosion" then
      att = att:GetOwner()
   end


   if att:IsPlayer() then

      // Infection timer
      if att:IsSwarm() && !ent:IsAlien() then
         ent.BroodInfect = CurTime() + 5
         ent.BroodHit = att
      end

      // Brood Alien Need-Reduction poison
      if att:IsBrood() && att:GetNWBool("alienform",false) && (infl:GetClass() == "weapon_mor_brood") then
         ent.BroodInfect = CurTime() + 5
         ent.BroodHit = att
         if att.Upgrades[UPGRADE.EXHAUST] then
            if (ent.Mission != MISSION_NONE) then
               ent.Mission_End = ent.Mission_End - (att.Upgrades[UPGRADE.EXHAUST]*UPGRADE.EXHAUST_AMOUNT)
               ent:SendMission()
            else
               ent.Mission_Next = ent.Mission_Next - (att.Upgrades[UPGRADE.EXHAUST]*UPGRADE.EXHAUST_AMOUNT*2)
            end
         end
      end

      // Brood Alien lifesteal upgrade
      if att:IsBrood() && att:GetNWBool("alienform",false) && (infl:GetClass() == "weapon_mor_brood") then
         if att.Upgrades[UPGRADE.LIFESTEAL] then
            att:SetHealth(math.Clamp(att:Health() + (att.Upgrades[UPGRADE.LIFESTEAL]*UPGRADE.LIFESTEAL_AMOUNT),0,att.MaxHealth))
         end
      end

      // Brood Aliens do reduced gun damage
      if att:IsBrood() && !(att:GetNWBool("alienform",false)) && !(infl:GetClass() == "weapon_mor_brood") then
         dmginfo:ScaleDamage(0.3)
      end

      // Brood Aliens take extra damage when in human form *DISABLED in 1.5.7*
      if ent:IsBrood() && !ent:GetNWBool("alienform",false) then
         if dmginfo:IsBulletDamage() then
            //dmginfo:ScaleDamage(1.2)
         end
      end

   end

   // Brood Alien damage reudction upgrades
   if ent:GetNWBool("alienform",false) == true then

      // Passive Brood Alien damage reduction
      dmginfo:ScaleDamage(0.85)

      // Upgraded Carapace
      if ent.Upgrades[UPGRADE.CARAPACE] then
         dmginfo:ScaleDamage(1 - ((UPGRADE.CARAPACE_AMOUNT*ent.Upgrades[UPGRADE.CARAPACE])/100))
      end

      // Small Arms defense upgrade
      if ent.Upgrades[UPGRADE.SDEFENSE] then
         if infl.Kind && (infl.Kind == WEAPON_PISTOL || infl.Kind == WEAPON_LIGHT) then
            dmginfo:ScaleDamage(1 - (UPGRADE.SDEFENSE_AMOUNT/100))
         end
      end

      // Heavy Weapon defense upgrade
      if ent.Upgrades[UPGRADE.HDEFENSE] then
         if infl.Kind && (infl.Kind == WEAPON_RIFLE || infl.Kind == WEAPON_HEAVY) then
            dmginfo:ScaleDamage(1 - (UPGRADE.HDEFENSE_AMOUNT/100))
         end
      end
   end


   -- Perform damage scaling
   ent.DMG = 0 -- clear
   GAMEMODE:ScalePlayerDamage(ent, ent:LastHitGroup() or HITGROUP_GENERIC, dmginfo, true)
   
   local gender = ent.Gender
   local alienform = ent:GetNWBool("alienform",false)
   local swarm = ent:IsSwarm()

   if (math.floor(dmginfo:GetDamage()) > 0) then

      if swarm == true then
         ent:EmitSound(table.Random(Sounds.Swarm.Pain),200,100)
      end

      if alienform == true then
         ent:EmitSound(table.Random(Sounds.Brood.Pain),250,100)
      end

      if gender == GENDER_MALE then
         ent:EmitSound(table.Random(Sounds.Male.Pain),200,100)
      else
         ent:EmitSound(table.Random(Sounds.Female.Pain),200,100)
      end

      util.StartBleeding(ent, dmginfo:GetDamage(), 10)
   end

   -- general actions for pvp damage
   
   if ent != att and ValidEntity(att) and att:IsPlayer() and GetRoundState() == ROUND_ACTIVE and math.floor(dmginfo:GetDamage()) > 0 then
      local txt = ""
      if infl:GetClass() == "env_explosion" then
         infl = "Grenade"
         txt = infl..": "..tostring(math.Round(ent.DMG))
      else
         txt = (infl.PrintName or tostring(infl))..": "..tostring(math.Round(ent.DMG))
      end
      LogDMG(att,ent,txt)
   end
end


function GM:ScalePlayerDamage(ply, hitgroup, dmginfo, real)
   -- There's a phantom call to this function made by gmod, ignore it.
   if not real then return end

   local atkr = dmginfo:GetAttacker()

   ply.was_headshot = false


   -- actual damage scaling
   if hitgroup == HITGROUP_HEAD then
      -- headshot if it was dealt by a bullet
      ply.was_headshot = dmginfo:IsBulletDamage()
      local s = 2.2
      dmginfo:ScaleDamage(s * 2/3)
   else
      if (hitgroup == HITGROUP_LEFTARM or
           hitgroup == HITGROUP_RIGHTARM or 
           hitgroup == HITGROUP_LEFTLEG or
           hitgroup == HITGROUP_RIGHTLEG or
           hitgroup == HITGROUP_GEAR ) then
      
         dmginfo:ScaleDamage(0.85)
      end
      dmginfo:ScaleDamage(2.5)
   end

   local mult = math.Clamp(#player.GetAll(),3,20)
   mult = (mult-3)/30
   mult = 1*mult




   if ply:IsSwarm() == true then
      dmginfo:ScaleDamage(1+mult)
   end

   if atkr:IsPlayer() then

      local df = atkr:GetDamageFactor()
      if df then
         dmginfo:ScaleDamage(df)
      end

      if ply:GetNWBool("alienform",false) && atkr:IsAlien() then dmginfo:SetDamage(0) end
      if ply:IsAlien() && atkr:IsSwarm() then dmginfo:SetDamage(0) end
      if ply:IsAlien() && atkr:GetNWBool("alienform") then dmginfo:SetDamage(0) end
   end

   ply.DMG = dmginfo:GetDamage()

   if ply != atkr and IsValid(atkr) and atkr:IsPlayer() and GetRoundState() == ROUND_ACTIVE and math.floor(dmginfo:GetDamage()) > 0 then

      timer.Simple(0.005, function() 
                if IsValid(ply) && ply:Alive() then

                    for i=1,1 do
                        for b=1,1 do
                            local effectdata = EffectData()
                            effectdata:SetOrigin(ply:GetPos() + Vector(0,0,i*40) )
                            effectdata:SetNormal(ply:GetVelocity():GetNormal())
                            util.Effect("bloodstream",effectdata)
                            util.Effect("bloodsplash",effectdata)
                        end
                    end
                end

            end)


      if ply.FreeKill < CurTime() then
         if atkr:GetHuman() && ply:GetHuman() then
            atkr.FreeKill = CurTime() + 3
         end
         SANITY.Hurt(atkr, ply, dmginfo)
      end
   end

end


function GM:AllowPVP()
   local rs = GetRoundState()
   return not (rs == ROUND_PREP or (rs == ROUND_POST and not true))
end
