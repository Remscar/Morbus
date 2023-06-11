-- First of all, this code from "Hat maker" addon by CapsAdmin. So credits to him for this code. 
--_____________________________________________________________________
-- This is new "worldmodel" for GlowStick, because the model doesn't have custom holdtype animations and etc...

ENT.Type = "anim"  

if SERVER then   
	AddCSLuaFile("shared.lua")

	function ENT:Initialize()   
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
		self:DrawShadow(false)
		self:SetModel("models/weapons/w_eq_fraggrenade.mdl")
		
		local player = self:GetOwner() 
		self:SetColor(player:GetColor())
		self:SetMaterial(player:GetMaterial())	
	end
end  
  
if CLIENT then  
    function ENT:Draw() 
-- some lines of code were modified, cause i dont need all bones, only right hand.	
        local p = self:GetOwner():GetRagdollEntity() or self:GetOwner()
        local hand = p:LookupBone("ValveBiped.Bip01_R_Hand")  
        if hand then  
            local position, angles = p:GetBonePosition(hand)
			
            local x = angles:Up() * (-0.00 )
            local y = angles:Right() * 2.50  
            local z = angles:Forward() * 4.15
  
            local pitch = 0.00
            local yaw = 0.00
            local roll = 0.00

            angles:RotateAroundAxis(angles:Forward(), pitch)  
            angles:RotateAroundAxis(angles:Right(), yaw)  
            angles:RotateAroundAxis(angles:Up(), roll)  
			
            self:SetPos(position + x + y + z)  
            self:SetAngles(angles)  
        end  
	local eyepos = EyePos()  
	local eyepos2 = LocalPlayer():EyePos()  
	if  eyepos:Distance(eyepos2) > 5 or LocalPlayer() != self:GetOwner() then
		self:DrawModel()
	end
    end
end
