
EFFECT.Duration			= 0.5;
EFFECT.Size				= 16;

local MaterialGlow		= Material( "sprites/mor_pulseglow" );

function EFFECT:Init( data )

	self.Position = data:GetOrigin();
	self.Normal = data:GetNormal();
	self.LifeTime = self.Duration;

end


function EFFECT:Think()

	self.LifeTime = self.LifeTime - FrameTime();
	return self.LifeTime > 0;

end


function EFFECT:Render()

	local frac = math.max( 0, self.LifeTime / self.Duration );
	local rgb = 255 * frac;
	local color = Color( rgb, rgb, rgb, 255 );

	render.SetMaterial( MaterialGlow );
	render.DrawQuadEasy( self.Position + self.Normal, self.Normal, self.Size, self.Size, color );

end
