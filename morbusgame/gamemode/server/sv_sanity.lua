--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

-- Sanity system
local math = math
local expdecay = math.ExponentialDecay
SANITY = {}

SANITY.RememberedPlayers = {}
SANITY.st = {} //settings
SANITY.st.Enabled = CreateConVar("mor_sanity", "1", FCVAR_ARCHIVE)
SANITY.st.Starting = CreateConVar("mor_sanity_starting", "1000")
SANITY.st.Max = CreateConVar("mor_sanity_max", "1000")
SANITY.st.KillBrood = 20
SANITY.st.KillSwarm = 10
SANITY.st.KillHuman = 20
SANITY.st.RDM = 90
SANITY.st.Dirty = 0.5
SANITY.st.Ratio = 0.0018
SANITY.st.AlienRatio = 0.0005
SANITY.st.Heal = 10

local cfg = SANITY.st

function SANITY.Init()
	SetGlobalBool("mor_sanity", cfg.Enabled:GetBool())
end

function SANITY.IsEnabled()
	return GetGlobalBool("mor_sanity", false)
end

-- For shooting someone who you shouldnt be
function SANITY.GetHurtPenalty(victim_sanity, dmg)
	return victim_sanity * math.Clamp(dmg * cfg.Ratio,0,1)
end

function SANITY.GetHurtReward(dmg)
	return cfg.Max:GetFloat() * math.Clamp(dmg * cfg.AlienRatio, 0, 1)
end

function SANITY.GetKillPenaltyHuman(victim_sanity)
	return SANITY.GetHurtPenalty(victim_sanity, cfg.RDM)
end

function SANITY.GetKillPenaltyAlien(victim_sanity)
	return SANITY.GetHurtPenalty(victim_sanity, cfg.RDM*4)
end

function SANITY.GetBroodKillReward()
	return SANITY.GetHurtReward(cfg.KillBrood)
end

function SANITY.GetSwarmKillReward()
	return SANITY.GetHurtReward(cfg.KillSwarm)
end

function SANITY.GetHumanKillReward()
	return SANITY.GetHurtReward(cfg.KillHuman)
end

function SANITY.GivePenalty(ply, penalty)
	ply:SetLiveSanity(math.max(ply:GetLiveSanity() - penalty, 0))
end

function SANITY.GiveReward(ply, reward)
	reward = SANITY.DecayedMultiplier(ply) * reward
	ply:SetLiveSanity(math.min(ply:GetLiveSanity() + reward, cfg.Max:GetFloat()))
	return reward
end

function SANITY.DecayedMultiplier(ply)
	local max   = cfg.Max:GetFloat()
	local start = cfg.Starting:GetFloat()
	local k     = ply:GetLiveSanity()

	if k < start then
		return 1
	elseif k < max then
		-- if falloff is enabled, then if our karma is above the starting value,
		-- our round bonus is going to start decreasing as our karma increases
		local basediff = max - start
		local plydiff  = k - start
		local half     = 0.3

		-- exponentially decay the bonus such that when the player's excess karma
		-- is at (basediff * half) the bonus is half of the original value
		return expdecay(basediff * half, plydiff)
	end
	return 1
end

function SANITY.ApplySanity(ply)
	local df = 1

	-- any karma at 1000 or over guarantees a df of 1, only when it's lower do we
	-- need the penalty curve
	if ply:GetBaseSanity() < 1000 then
		local k = ply:GetBaseSanity() - 1000

		df = 1 + -0.0000025 * (k^2)
	end
	ply:SetDamageFactor(math.Clamp(df, 0.1, 1.0))
end

function SANITY.Hurt(attacker, victim, dmginfo)
	if not IsValid(attacker) or not IsValid(victim) then return end
	if attacker == victim then return end
	if not attacker:IsPlayer() or not victim:IsPlayer() then return end

	local hurt_amount = math.min(victim:Health(), dmginfo:GetDamage()) -- Ignore excess damage

	if attacker:GetBrood() and victim:GetBrood() then
		local penalty = SANITY.GetHurtPenalty(victim:GetLiveSanity(), hurt_amount)

		SANITY.GivePenalty(attacker, penalty)
	elseif (not attacker:GetAlien()) then
		if victim:IsBrood() then
			local reward = SANITY.GetHurtReward(hurt_amount)

			reward = SANITY.GiveReward(attacker, reward)
		elseif victim:IsHuman() then
			local penalty = SANITY.GetHurtPenalty(victim:GetLiveSanity(), hurt_amount)

			SANITY.GivePenalty(attacker, penalty)
		end
	end
	if victim:IsHuman() && attacker:GetBrood() && attacker:GetNWBool("alienform") == false then
		local penalty = SANITY.GetHurtPenalty(victim:GetLiveSanity(), hurt_amount)

		SANITY.GivePenalty(attacker, penalty)
	end
end

-- Handle karma change due to one player killing another.
function SANITY.Killed(attacker, victim, dmginfo)
	if not IsValid(attacker) or not IsValid(victim) then return end
	if attacker == victim then return end
	if not attacker:IsPlayer() or not victim:IsPlayer() then return end

	if attacker:GetBrood() and victim:GetBrood() then
		local penalty = SANITY.GetKillPenaltyAlien(victim:GetLiveSanity())

		SANITY.GivePenalty(attacker, penalty)
	elseif (not attacker:GetAlien()) then
		if victim:IsBrood() then
			local reward = SANITY.GetBroodKillReward()

			reward = SANITY.GiveReward(attacker, reward)
		elseif vitcim:IsSwarm() then
			local reward = SANITY.GetSwarmKillReward()

			reward = SANITY.GiveReward(attacker, reward)
		elseif victim:IsHuman() then
			local penalty = SANITY.GetKillPenaltyAlien(victim:GetLiveSanity())

			SANITY.GivePenalty(attacker, penalty)
		end
	end
	if victim:IsHuman() && attacker:GetBrood() && attacker:GetNWBool("alienform") == false then
		local penalty = SANITY.GetKillPenaltyHuman(victim:GetLiveSanity()) * 1.2

		SANITY.GivePenalty(attacker, penalty)
	end
end

function SANITY.RoundIncrement()
	local healbonus = cfg.Heal

	for _, ply in pairs(player.GetAll()) do
		local bonus = healbonus

		SANITY.GiveReward(ply, bonus)
	end
end

function SANITY.Rebase()
	for _, ply in pairs(player.GetAll()) do
		ply:SetBaseSanity(ply:GetLiveSanity())
	end
end

-- Apply karma to damage factor for all players
function SANITY.ApplySanityAll()
	for _, ply in pairs(player.GetAll()) do
		SANITY.ApplySanity(ply)
	end
end

function SANITY.NotifyPlayer(ply)
	local df = ply:GetDamageFactor() or 1
	local k = math.Round(ply:GetBaseSanity())

	if df > 0.99 then
		PlayerMsg(ply,"You are completley sane, you are doing full daamge",false)
	else
		local num = math.ceil(df * 100)

		PlayerMsg(ply,"Your sanity is waning, you  only do "..num.."% damage (One third of that with guns as Brood Alien)",false)
	end
end

function SANITY.RoundEnd()
	if SANITY.IsEnabled() then
		SANITY.RoundIncrement()
		SANITY.Rebase() -- if karma trend needs to be shown in round report, may want to delay rebase until start of next round
		SANITY.RememberAll()
	end
end

function SANITY.RoundBegin()
	SANITY.Init()

	if SANITY.IsEnabled() then
		for _, ply in pairs(player.GetAll()) do
			SANITY.ApplySanity(ply)
			SANITY.NotifyPlayer(ply)
		end
	end
end

function SANITY.InitPlayer(ply)
	local k = SANITY.Recall(ply) or cfg.Starting:GetFloat()

	k = math.Clamp(k, 0, cfg.Max:GetFloat())

	ply:SetBaseSanity(k)
	ply:SetLiveSanity(k)
	ply:SetDamageFactor(1.0)
	SANITY.ApplySanity(ply) -- compute the damagefactor based on actual (possibly loaded) karma
end

function SANITY.Remember(ply)
	if ply.SteamID == nil then return end
	if (not ply:IsFullyAuthenticated()) then return end

	SANITY.RememberedPlayers[ply:SteamID()] = ply:GetLiveSanity() -- if persist is on, this is purely a backup method
end

function SANITY.Recall(ply)
	if ply.SteamID == nil then return end

	return SANITY.RememberedPlayers[ply:SteamID()]
end

function SANITY.LateRecallAndSet(ply)
	local k = SANITY.RememberedPlayers[ply:SteamID()]

	if k and k < ply:GetLiveSanity() then
		ply:SetBaseSanity(k)
		ply:SetLiveSanity(k)
	end
end

function SANITY.RememberAll()
	for _, ply in pairs(player.GetAll()) do
		SANITY.Remember(ply)
	end
end
