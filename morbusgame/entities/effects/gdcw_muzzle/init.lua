

function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()

	local emitter = ParticleEmitter(self.Position)
		
		/*local particle = emitter:Add("sprites/heatwave", self.Position)
		particle:SetVelocity(80*self.Forward + 20*VectorRand())
		particle:SetDieTime(math.Rand(0.15,0.2))
		particle:SetStartSize(math.random(15,19))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetAirResistance(160)*/

		for i=0,1 do 
		local particle = emitter:Add("effects/muzzleflash"..math.random(1,4), self.Position)
		particle:SetVelocity(self.Forward*(10+(i*5)))
		particle:SetDieTime(0.06)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(7-i)
		particle:SetEndSize(15-i)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(Color(255,255,255))
		end

	emitter:Finish()

end


function EFFECT:Think()

	return false
	
end


function EFFECT:Render()

	
end



