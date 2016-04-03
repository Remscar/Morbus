include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Think()
	if self:GetPos():Distance(LocalPlayer():GetPos()) < 4000 then
    local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos()
		dlight.r = 12
		dlight.g = 239
		dlight.b = 251
		dlight.Brightness = 1
		dlight.Size = 600
		dlight.Decay = 600
		dlight.DieTime = CurTime() + 1
	end 
	end
end
