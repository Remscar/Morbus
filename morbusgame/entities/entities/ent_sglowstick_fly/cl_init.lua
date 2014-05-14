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
		dlight.r = 255
		dlight.g = 127
		dlight.b = 0
		dlight.Brightness = 1
		dlight.Size = 600
		dlight.Decay = 600
		dlight.DieTime = CurTime() + 1
	end 
	end
end
