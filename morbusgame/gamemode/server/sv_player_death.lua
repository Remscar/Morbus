---------------------------------LOCALIZATION
local math = math
local table = table
local umsg = umsg
local player = player
local timer = timer
local pairs = pairs
local umsg = umsg
local usermessage = usermessage
local file = file
---------------------------------------------
/*----------------------------------------------------
Player Death

Sounds.Alien.Death = "horror/die1.wav"
Sounds.Alien.Pain = {
   "horror/pain1.wav",
   "horror/pain2.wav",
   "horror/pain3.wav",
   "horror/pain4.wav",
}
----------------------------------------------------*/
local deathsounds = {}

local dmale = {
    "player/death1.wav",
    "player/death2.wav",
    "player/death3.wav",
    "player/death4.wav",
    "player/death5.wav",
    "player/death6.wav",
    "vo/npc/male01/pain07.wav",
    "vo/npc/male01/pain08.wav",
    "vo/npc/male01/pain09.wav",
    "vo/npc/male01/pain04.wav",
    "vo/npc/Barney/ba_pain06.wav",
    "vo/npc/Barney/ba_pain07.wav",
    "vo/npc/Barney/ba_pain09.wav",
    "vo/npc/Barney/ba_ohshit03.wav", --heh
    "vo/npc/Barney/ba_no01.wav",
    "vo/npc/male01/no02.wav",
    "hostage/hpain/hpain1.wav",
    "hostage/hpain/hpain2.wav",
    "hostage/hpain/hpain3.wav",
    "hostage/hpain/hpain4.wav",
    "hostage/hpain/hpain5.wav",
    "hostage/hpain/hpain6.wav"
}

deathsounds.Male = {
}

for k,v in pairs(dmale) do
   sound.Add({
    name =          "deathmale."..k,
    channel =       CHAN_USER_BASE+1,
    volume =        1.0,
    sound =             v
   })
   table.insert(deathsounds.Male,Sound("deathmale."..k))
end

deathsounds.Female = { }
local dfale ={
    "vo/npc/female01/pain01",
    "vo/npc/female01/pain02",
    "vo/npc/female01/pain03",
    "vo/npc/female01/pain04",
    "vo/npc/female01/pain05",
    "vo/npc/female01/pain06",
    "vo/npc/female01/pain07",
    "vo/npc/female01/pain08",
    "vo/npc/female01/pain09",
}

for k,v in pairs(dfale) do
   sound.Add({
    name =          "deathfemale."..k,
    channel =       CHAN_USER_BASE+1,
    volume =        1.0,
    sound =             v
   })
   table.insert(deathsounds.Female,Sound("deathfemale."..k))
end


deathsounds.Brood = { }
local dbrood = {
    "npc/zombie_poison/pz_die2.wav",
    "npc/zombie/zombie_pain2.wav",
    "npc/zombie/zombie_pain6.wav",
    "npc/headcrab_fast/die2.wav",
}

for k,v in pairs(dbrood) do
   sound.Add({
    name =          "deathbrood."..k,
    channel =       CHAN_USER_BASE+1,
    volume =        1.0,
    sound =             v
   })
   table.insert(deathsounds.Brood,Sound("deathbrood."..k))
end

deathsounds.Swarm = { }
local dswarm =
{
    "horror/die1.wav"
}

for k,v in pairs(dswarm) do
   sound.Add({
    name =          "deathswarm."..k,
    channel =       CHAN_USER_BASE+1,
    volume =        1.0,
    sound =             v
   })
   table.insert(deathsounds.Swarm,Sound("deathswarm."..k))
end

local function CreateDeathEffect(ent)
   local pos = ent:GetPos() + Vector(0, 0, 20)

   local jit = 35.0

   local jitter = Vector(math.Rand(-jit, jit), math.Rand(-jit, jit), 0)
   util.PaintDown(pos + jitter, "Blood", ent)

end

local function CreateCorpse(ply, attacker, dmginfo)
   if not IsValid(ply) then return end

   local rag = ents.Create("prop_ragdoll")
   if not IsValid(rag) then return nil end
   rag.ragdoll = true
   ply.Body = rag

   rag:SetPos(ply:GetPos())
   rag:SetModel(ply:GetModel())
   rag:SetAngles(ply:GetAngles())
   rag:SetNWBool("HumanBody",!ply:GetSwarm())
   rag:SetNWString("Name",ply:GetFName())
   rag:SetNWEntity("Player",ply)

   rag:Spawn()
   rag:Activate()

   -- nonsolid to players, but can be picked up and shot
   rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)


end


function GM:SpectatorThink(ply)

   

   if GetRoundState() == ROUND_WAIT && ply:IsGame() then
      ply:Spectate(OBS_MODE_NONE)
      if (CurTime()>=ply.NextSpawnTime) then
         ply:SetRole(ROLE_HUMAN)
         ply:SpectateEntity(nil)
         ply:UnSpectate()
         ply:Spawn()
      end
      //return true
   end


   if ply:IsBrood() && ply:IsGame() then
      if (CurTime()>=ply.NextSpawnTime) then
          ply:Spawn()
      end
      return true
   end

   if ply:IsSwarm() && ply:IsGame() then
      ply:Spectate(OBS_MODE_NONE)
      if (CurTime()>=ply.NextSpawnTime) then
          ply:Spawn()
          ply:UnSpectate()
      end
      return true
   end
   -- when spectating a ragdoll after death
   if ply:GetMoveType() < MOVETYPE_NOCLIP and ply:GetMoveType() > 0 or ply:GetMoveType() == MOVETYPE_LADDER then
      ply:Spectate(OBS_MODE_ROAMING)
   end

   -- when speccing a player
   if ply:GetObserverMode() != OBS_MODE_ROAMING then
      local tgt = ply:GetObserverTarget()
      if IsValid(tgt) and tgt:IsPlayer() then
         if (not tgt:IsGame()) or (not tgt:Alive()) then
            -- stop speccing as soon as target dies
            ply:Spectate(OBS_MODE_ROAMING)
            ply:SpectateEntity(nil)
         elseif GetRoundState() == ROUND_ACTIVE then
            -- Sync position to target. Uglier than parenting, but unlike
            -- parenting this is less sensitive to breakage: if we are
            -- no longer spectating, we will never sync to their position.
            ply:SetPos(tgt:GetPos())
         end
      end
   end
end

GM.PlayerDeathThink = GM.SpectatorThink



local function PlayDeathSound(victim) -- TO DO
   if not ValidEntity(victim) then return end

   if victim:IsSpec() then return end

   if victim:IsBrood() then
      sound.Play(table.Random(deathsounds.Brood), victim:GetPos(), 300, 100)
   elseif victim:IsSwarm() then
      sound.Play(table.Random(deathsounds.Swarm), victim:GetPos(), 300, 100)
   elseif victim.Gender == GENDER_FEMALE then
      sound.Play(table.Random(deathsounds.Female), victim:GetPos(), 300, 100)
   else
      sound.Play(table.Random(deathsounds.Male), victim:GetPos(), 300, 100)
   end

end

function GM:PlayerDeathSound() return true end //When you return true it overrides, yes i know

function GM:DoPlayerDeath(ply, attacker, dmginfo)

   LIGHT.TurnOff(ply)

   ply.Killer = ents.Create("info_player_start")
   if ValidEntity(ply.Killer) then
      ply.Killer:SetPos(ply:GetPos())
      ply.Killer:Spawn()
   end



   if GetRoundState() == ROUNT_ACTIVE then

      if ply.FreeKill < CurTime() then
         if attacker:GetHuman() && ply:GetHuman() then
            attacker.FreeKill = CurTime() + 5
         end
         SANITY.Killed(attacker, ply, dmginfo)
      end
      
   end

   


   
	for k, wep in pairs(ply:GetWeapons()) do
      WEPS.DropNotifiedWeapon(ply, wep, true) -- with ammo in them
      wep:DampenDrop()
   end

   ply:LightReset()
   PlayDeathSound(ply)
   if ply:IsBrood() then
      ply:SetModel(Models.Brood)
   end
    if ply:IsSwarm() then
      //ply:SetModel("models/characters/xenomorph.mdl")
   end

   if (!ply:IsSpec()) then

          if true then
      --if !IsValid(attacker) || !IsValid(attacker:GetActiveWeapon()) || (!(attacker:GetActiveWeapon():GetClass() == "weapon_mor_brood") || !(attacker:GetActiveWeapon():GetClass() == "weapon_mor_swarm"))  then
         local rag = CreateCorpse(ply, attacker, dmginfo)
         ply.ragdoll = rag

    

      else
         ply:CreateRagdoll()
      end
   
 
      return
   end

   CreateDeathEffect(ply)



end

function GM:PlayerDeath(victim, weapon, killer)

   

   if killer:GetClass() == "env_explosion" then
      killer = killer:GetOwner()
   end


   if (victim:IsSpec()) then


      return
   end

   






   if killer:IsPlayer() && killer!=victim && victim:IsAlien() && !killer:GetNWBool("alienform",false) then
      if killer.Gender == GENDER_FEMALE then
         killer:EmitSound(table.Random(Response.Female.KillAlien),100,100)
      else
         killer:EmitSound(table.Random(Response.Male.KillAlien),100,100)
      end
   end




   if (GetRoundState() != ROUND_ACTIVE) then victim.NextSpawnTime = CurTime() + 5 return end

   if !victim:IsAlien() then
      if victim.BroodInfect > CurTime() && victim.BroodHit then
         LogInfect(victim.BroodHit,victim,"Brood")
         player_infect_brood(victim,weapon,victim.BroodHit)
         return
      end
   end

   if not killer:IsPlayer() then -- IF THE weapon WASNT A PLAYER
   
      LogDeath(victim,"Unknown")
      player_death(victim,weapon,killer)
   
   elseif killer:GetActiveWeapon() == NULL or weapon == victim then -- IF THE PLAYER SUICIDES

      LogDeath(victim,"Suicide")
      player_suicide(victim,weapon,killer)
	
	elseif killer:GetActiveWeapon():GetClass() == "weapon_mor_swarm" && !victim:IsAlien() then

      LogInfect(killer,victim,"Swarm")
      Round_Swarm_Infects = Round_Infects + 1
   	player_infect_swarm(victim,weapon,killer)

	elseif victim:IsBrood() then -- IF A brood DIED

      LogKill(victim,killer,"Brood Killed")
      Round_Brood_Kills = Round_Kills + 1
   	brood_dies(victim,weapon,killer)

	elseif victim:IsSwarm() then -- IF A SPAWN DIED

      LogKill(victim,killer,"Swarm Killed")
      Round_Swarm_Kills = Round_Kills + 1
   	swarm_dies(victim,weapon,killer)

   elseif killer:GetActiveWeapon():GetClass() ==  "weapon_mor_brood" && !victim:IsAlien() then

      LogInfect(killer,victim,"Brood")
      Round_Brood_Infects = Round_Infects + 1
   	player_infect_brood(victim,weapon,killer)

	else -- If the player did not suide, was not killed with brood/spawn weapon, if the player was not a brood or spawn

      if (victim:IsAlien() == killer:IsAlien()) then
         LogRDM(killer,victim,"RDM")
         Round_RDMs = Round_RDMs + 1
      else
         LogKill(victim,killer,"KILL")

      end

   	player_death_normal(victim,weapon,killer) --if you consider getting shot to death normal

	end

   

end

function player_death_normal(ply,weapon,killer)
   if ply:IsSwarm() then
      swarm_dies(ply,weapon,killer)
      return
   end
   ply:SetRole(ROLE_SWARM)
   NewAlien(ply,ROLE_SWARM)
   

   
end

function player_death(ply,weapon,killer)
   if ply:IsSwarm() then
      swarm_dies(ply,weapon,killer)
      return
   end
   player_death_normal(ply,weapon,killer)
end

function player_suicide(ply,weapon,killer)
   if ply:IsSwarm() then
      swarm_dies(ply,weapon,killer)
      return
   end
   player_death_normal(ply,weapon,killer)
end

function player_infect_swarm(ply,weapon,killer)


   if !RoundHistory["Infect"][killer] then
      RoundHistory["Infect"][killer] = 0
   end
   RoundHistory["Infect"][killer] = RoundHistory["Infect"][killer] + 1

   BroodInfected(ply)

   ply:SetRole(ROLE_BROOD)
   ply:LightReset()
   NewAlien(ply,ROLE_BROOD)
   ply.NextSpawnTime = CurTime() + 4


end

function brood_dies(ply,weapon,killer)
   player_death_normal(ply,weapon,killer)

   if ply != killer then
      if !RoundHistory["Kill"][killer] then
         RoundHistory["Kill"][killer] = 0
      end
      RoundHistory["Kill"][killer] = RoundHistory["Kill"][killer] + 1
   end
end

function swarm_dies(ply,weapon,killer)

   if (Swarm_Respawns > 0) then
      Swarm_Respawns = Swarm_Respawns - 1
      SetGlobalInt("morbus_swarm_spawns", Swarm_Respawns)
      ply.NextSpawnTime = CurTime() + 8
   else
      ply:MakeSpec()
   end

   

   if ply != killer then
      if !RoundHistory["Kill"][killer] then
         RoundHistory["Kill"][killer] = 0
      end
      RoundHistory["Kill"][killer] = RoundHistory["Kill"][killer] + 1
   end

   

end

function player_infect_brood(ply,weapon,killer)
   player_infect_swarm(ply,weapon,killer)
end








