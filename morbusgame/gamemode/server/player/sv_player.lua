--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

-- PLAYER SPAWN
local fallsounds = {
	Sound("player/damage1.wav"),
	Sound("player/damage2.wav"),
	Sound("player/damage3.wav"),
}
local SpawnTypes = {
	"info_player_deathmatch",
	"info_player_combine",
	"info_player_rebel",
	"info_player_counterterrorist",
	"info_player_terrorist",
	"info_player_axis",
	"info_player_allies",
	"gmod_player_start",
	"info_player_teamspawn",
}

function GM:PlayerInitialSpawn(ply)
	local sid = string.gsub(ply:SteamID(),":","")
	local rstate = GetRoundState() or ROUND_WAIT
	local tm = nil
	local plys = nil

	ply.NextSpawnTime = 0
	ply.Touching = MISSION_NONE
	ply.Has_Spawned = false
	ply.DoingMission = false
	ply.Gender = -1
	ply.Weight = 0
	ply.Gagged = false
	ply.OldPos = Vector(0,0,0)
	ply.WantsSpec = false
	ply.Human_Model = nil
	ply.MaxHealth = 100
	ply.Mission_Doing = false
	ply.Mission_Next = CurTime() + math.random(15,75)
	ply.Jump = DEFAULT_JUMP
	ply.Killer = ply
	ply.FreeKill = 0
	ply.DamageFactor = 1
	ply:InitSanity()
	ply:SetNWInt("Mute_Status",0)
	ply.Evo_Points = 0
	ply.Upgrades = {}
	ply:SetTeam(TEAM_GAME)
	ply.ForceName = nil
	ply.ForceGender = nil
	ply:SetNWInt("Donator",0)

	if file.Exists("Morbus/"..sid..".txt","DATA") then
		local txt = file.Read("Morbus/"..sid..".txt")
		txt = string.Explode("|",txt)

		if tostring(txt[1]) != "" then
			ply.ForceName = txt[1]
		end
		if txt[2] != "" then
			ply.ForceGender = tonumber(txt[2])
		end
		if tonumber(txt[3]) > 0 then
			ply:SetNWInt("Donator",tonumber(txt[3]))
		end
	end
	if (ply:SteamID() == "STEAM_0:0:20749231") then --PLease leave [Remscar Original Dev]
		ply.ForceName = "Zachary Nawar" --This is me the Dev, this just gives me my name and Red scoreboard name color
		ply.ForceGender = 2
		ply:SetNWInt("Donator",2)
	end
	if (ply:SteamID() == "STEAM_0:1:7305295") then -- [Sonoran Warrior - Did a lot of maps]
		ply.ForceName = "Tits McGee"
		ply.ForceGender = 2
		ply:SetNWInt("Donator",2)
	end
	if (ply:SteamID() == "STEAM_0:0:30843196") then -- [The Dondi - Lots of advice / ideas]
		ply.ForceName = "Chuck Testa"
		ply.ForceGender = 2
		ply:SetNWInt("Donator",2)
	end
	if (ply:SteamID() == "STEAM_0:0:22105310") then -- [CvG admin who helped]
		ply.ForceName = "Misty Temple"
		ply.ForceGender = 1
		ply:SetNWInt("Donator",2)
	end
	if (ply:SteamID() == "STEAM_0:1:10651334") then
		ply.ForceName = "Fur Ball"
		ply.ForceGender = 2
		ply:SetNWInt("Donator",2)
	end
	if (ply:SteamID() == "STEAM_0:0:30900996") then
		ply.ForceName = "Talroc Robinson"
		ply.ForceGender = 2
		ply:SetNWInt("Donator",2)
	end
	if (ply:SteamID() == "STEAM_0:1:19539784") then -- Rocket Scientist
		ply.ForceName = "Cmdr. John Shepard"
		ply.ForceGender = 2
		ply:SetNWInt("Donator",2)
	end

	-- TODO Move what we can to the other group of ply: settings
	ply:SetCanZoom(false)
	ply:SetJumpPower(ply.Jump)
	ply:SetCrouchedWalkSpeed(0.7)
	GAMEMODE:SetPlayerSpeed(ply,HUMAN_SPEED,HUMAN_SPEED)
	ply:ResetStatus()
	ply:StripAll(true)
	ply:SetupPlayer()

	if rstate <= ROUND_PREP then
		ply:SetRole(ROLE_HUMAN)
	else
		if Swarm_Respawns > 0 || rstate == ROUND_EVAC then
			ply:SetRole(ROLE_SWARM)

			if rstate == ROUND_ACTIVE then
				Swarm_Respawns = Swarm_Respawns - 1
				SetGlobalInt("morbus_swarm_spawns", Swarm_Respawns)
			end
			timer.Simple(5,function() NewAlien(ply,ROLE_SWARM) end)
		else
			ply:SetTeam(TEAM_SPEC)
			ply:SetRole(ROLE_SWARM)
		end
	end
	SendRoundState(rstate,ply)
end

function GM:NetworkIDValidated( name, steamid )
	-- edge case where player authed after initspawn
	for _, p in pairs(player.GetAll()) do
		if IsValid(p) and p:SteamID() == steamid then
			SANITY.LateRecallAndSet(p)
			return
		end
	end
end

function GM:PlayerSpawn(ply)
	if (GetRoundState() == ROUND_ACTIVE) && (ply.NextSpawnTime && ply.NextSpawnTime > CurTime()) then return end

	ply:ResetViewRoll()
	ply:SetNWBool("alienform", false)
	ply:Freeze(false)

	if ply:IsSpec() then
		ply:Kill()
		ply:StripAll(false)
		ply:Spectate(OBS_MODE_ROAMING)
		ply:SpectateEntity(nil)
		return
	end
	hook.Call("PlayerLoadout", GAMEMODE, ply)
	if GAMEMODE.Nightmare && ply:IsGame() && !ply:IsSwarm() then
		if !ply:HasWeapon("weapon_glowstick_special") then
			ply:Give("weapon_glowstick_special")
		end
	end
	ply:SetSpeed()
	self:PlayerSetModel(ply)
end

function GM:PlayerSetModel( pl )
	local modelname = pl.WantedModel

	if (pl:IsSwarm()) then
		modelname = Models.Swarm
	end
	pl:SetModel( modelname )
end

function GM:ShowHelp( ply )
	ply:ConCommand("helpme")
end

function GM:ShowTeam(ply)
	ply:ConCommand("show_rules")
end

function GM:ShowSpare1( ply )
	ply:ConCommand("morbus_settings")
end

-- Player Functions
function GM:CanPlayerSuicide(ply)
	return true
end

function GM:PlayerUse(ply, ent)
	return ply:Team() != TEAM_SPEC
end

function GM:PlayerDisconnected(ply)
	if IsValid(ply) then
		ply:SetRole(ROLE_NONE)
	end
end

function GM:Tick()
	plys = player.GetAll()

	for i= 1, #plys do
		ply = plys[i]
		tm = ply:Team()

		if tm == TEAM_GAME and ply:Alive() then
			if ply:WaterLevel() == 3 then -- Drowning
				if ply:IsOnFire() then
					ply:Extinguish()
				end
				if ply.drowning then
					if ply.drowning < CurTime() then
						local dmginfo = DamageInfo()

						dmginfo:SetDamage(15)
						dmginfo:SetDamageType(DMG_DROWN)
						dmginfo:SetAttacker(game.GetWorld())
						dmginfo:SetInflictor(game.GetWorld())
						dmginfo:SetDamageForce(Vector(0,0,1))
						ply:TakeDamageInfo(dmginfo)
						ply.drowning = CurTime() + 1 -- have started drowning properly
					end
				else
					ply.drowning = CurTime() + 8 -- will start drowning soon
				end
			else
				ply.drowning = nil
			end
		end
	end
end

-- Player Fall
function GM:GetFallDamage(ply, speed)
	return 1
end

function GM:OnPlayerHitGround(ply, in_water, on_floater, speed)
	if in_water or speed < 450 or not IsValid(ply) then return end

	-- Everything over a threshold hurts you, rising exponentially with speed
	local damage = math.pow(0.05 * (speed - 400), 1.75)

	-- I don't know exactly when on_floater is true, but it's probably when
	-- landing on something that is in water.
	if on_floater then damage = damage / 2 end

	-- if we fell on a dude, that hurts (him)
	local ground = ply:GetGroundEntity()

	if IsValid(ground) and ground:IsPlayer() then
		if math.floor(damage) > 0 then
			local dmg = DamageInfo()

			dmg:SetDamageType(DMG_CRUSH + DMG_PHYSGUN) -- hijack physgun damage as a marker of this type of kill
			dmg:SetAttacker(ply)
			dmg:SetInflictor(ply)
			dmg:SetDamageForce(Vector(0,0,-1))
			dmg:SetDamage(damage)
			ground:TakeDamageInfo(dmg)
		end
		damage = damage / 3 -- our own falling damage is cushioned
	end
	if math.floor(damage) > 0 then
		local dmg = DamageInfo()

		dmg:SetDamageType(DMG_FALL)
		dmg:SetAttacker(game.GetWorld())
		dmg:SetInflictor(game.GetWorld())
		dmg:SetDamageForce(Vector(0,0,1))

		if ply:GetNWBool("alienform",false) == true then
			dmg:SetDamage(damage)

			if ply.Upgrades[UPGRADE.FALL] then
				dmg:ScaleDamage(1 - ( (ply.Upgrades[UPGRADE.FALL]*UPGRADE.FALL_AMOUNT) /100) )
			end
		elseif ply:IsSwarm() then
			dmg:SetDamage(1)
		else
			dmg:SetDamage(damage)
		end
		ply:TakeDamageInfo(dmg)
		if damage > 5 then -- play CS:S fall sound if we got somewhat significant damage
			sound.Play(table.Random(fallsounds), ply:GetShootPos(), 55 + math.Clamp(damage, 0, 50), 100)
		end
	end
end

-- SPAWN POINT STUFF
function GM:IsSpawnpointSuitable(ply, spwn, force, rigged)
	if not ValidEntity(ply) or not ply:IsGame() then return true end
	if not rigged and (not ValidEntity(spwn) or not spwn:IsInWorld()) then return false end

	local pos = rigged and spwn or spwn:GetPos()
	local tr = {}

	tr.start = pos
	tr.endpos = pos + Vector(0,0,80)
	tr.mask = MASK_PLAYERSOLID_BRUSHONLY

	local trace = util.TraceLine(tr)

	if trace.HitWorld == true then return false end
	if not util.IsInWorld(pos + Vector(0,0,40)) then return false end
	if not util.IsInWorld(pos) then return false end

	local blocking = ents.FindInBox(pos + Vector( -16, -16, 0 ), pos + Vector( 16, 16, 64 ))

	for k, p in pairs(blocking) do
		if ValidEntity(p) and p:IsPlayer() and p:IsGame() and p:Alive() and p!=ply then
			if force then
				p:Kill()
			else
				return false
			end
		end
	end
	return true
end

function GetSpawnEnts(shuffled, force_all)
	local tbl = {}

	for k, classname in pairs(SpawnTypes) do
		for _, e in pairs(ents.FindByClass(classname)) do
			if ValidEntity(e) and (not e.BeingRemoved) then
				table.insert(tbl, e)
			end
		end
	end
	if force_all or #tbl == 0 then
		for _, e in pairs(ents.FindByClass("info_player_start")) do
			if ValidEntity(e) and (not e.BeingRemoved) then
				table.insert(tbl, e)
			end
		end
	end
	if shuffled then
		table.Shuffle(tbl)
	end
	return tbl
end

function GM:PlayerSelectSpawn(ply)
	local picked = nil

	if ply:IsActiveBrood() then
		if self:IsSpawnpointSuitable(ply, ply, false) then
			return ply
		end
	end
	if  !ply:IsSwarm() && !ply:IsBrood() then
		if (not self.SpawnPoints) or (table.Count(self.SpawnPoints) == 0) or (not IsTableOfEntitiesValid(self.SpawnPoints)) then
			self.SpawnPoints = GetSpawnEnts(true, false)
			--[[
				One might think that we have to regenerate our spawnpoint
				cache. Otherwise, any rigged spawn entities would not get reused, and
				MORE new entities would be made instead. In reality, the map cleanup at
				round start will remove our rigged spawns, and we'll have to create new
				ones anyway.
			]]
		end

		local num = table.Count(self.SpawnPoints)

		if num == 0 then
			Error("No spawn entity found!\n")
			return
		end
		table.Shuffle(self.SpawnPoints) -- Just always shuffle, it's not that costly and should help spawn randomness.
		for k, spwn in pairs(self.SpawnPoints) do -- Optimistic attempt: assume there are sufficient spawns for all and one is free
			if self:IsSpawnpointSuitable(ply, spwn, false) then
				return spwn
			end
		end
		for k, spwn in pairs(self.SpawnPoints) do -- That did not work, so now look around spawns
			picked = spwn -- just to have something if all else fails
		end
		for k, spwn in pairs(self.SpawnPoints) do -- Last attempt, force one
			if self:IsSpawnpointSuitable(ply, spwn, true) then
				return spwn
			end
		end
		return picked
	else
		if (not self.ASpawnPoints) or (table.Count(self.ASpawnPoints) == 0) or (not IsTableOfEntitiesValid(self.ASpawnPoints)) then
			tbl = {}
			for _, e in pairs(ents.FindByClass("info_alien_spawn")) do
				if ValidEntity(e) and (not e.BeingRemoved) then
					table.insert(tbl, e)
				end
			end
			self.ASpawnPoints = tbl
		end
		local num = table.Count(self.ASpawnPoints)
		if num == 0 then
			Error("No spawn entity found!\n")
			return
		end
		table.Shuffle(self.ASpawnPoints)
		for k, spwn in pairs(self.ASpawnPoints) do
			if self:IsSpawnpointSuitable(ply, spwn, false) then
				return spwn
			end
		end
		return table.Random(self.ASpawnPoints)
	end
end

function GM:KeyPress(ply, key)
	if not IsValid(ply) then return end

	if ply:Team() == TEAM_SPEC  then -- Spectator keys
		ply:ResetViewRoll()

		if key == IN_ATTACK then
			local alive = util.GetAlivePlayers()
			local target = table.Random(alive)

			ply:Spectate(OBS_MODE_ROAMING) -- snap to random guy
			ply:SpectateEntity(nil)

			if #alive < 1 then return end

			if IsValid(target) then
				ply:SetPos(target:EyePos())
			end
		elseif key == IN_ATTACK2 then -- spectate either the next guy or a random guy in chase
			local target = util.GetNextAlivePlayer(ply:GetObserverTarget())

			if IsValid(target) then
				ply:Spectate(ply.spec_mode or OBS_MODE_CHASE)
				ply:SpectateEntity(target)
			end
		elseif key == IN_DUCK then
			if ply:IsSpec() then
				GAMEMODE:PlayerSwitchFlashlight(ply,true)
			end
			return true
		elseif key == IN_JUMP then -- unfuck if you're on a ladder etc
			if not (ply:GetMoveType() == MOVETYPE_NOCLIP) then
				ply:SetMoveType(MOVETYPE_NOCLIP)
			end
		elseif key == IN_RELOAD then
			local tgt = ply:GetObserverTarget()

			if not IsValid(tgt) or not tgt:IsPlayer() then return end

			if not ply.spec_mode or ply.spec_mode == OBS_MODE_CHASE then
				ply.spec_mode = OBS_MODE_IN_EYE
			elseif ply.spec_mode == OBS_MODE_IN_EYE then
				ply.spec_mode = OBS_MODE_CHASE
			end
			ply:Spectate(ply.spec_mode) -- roam stays roam
		end
	end
end
