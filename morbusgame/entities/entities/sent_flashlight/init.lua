
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/props/cs_office/computer_mouse.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:DrawShadow( false )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
	
	end
	
	self.Entity:StartMotionController()
	
	self.ShadowParams = {}
	
end

function ENT:CreateLight( col, bright, size, len )

	self.FlashlightEnt = ents.Create( "env_projectedtexture" )
	self.FlashlightEnt:SetParent( self )
	self.FlashlightEnt:SetLocalPos( Vector(0,0,0) ) 
	self.FlashlightEnt:SetLocalAngles( Angle(0,0,0) )
	self.FlashlightEnt:SetKeyValue( "enableshadows", 0 )
	self.FlashlightEnt:SetKeyValue( "nearz", 20 ) 
	self.FlashlightEnt:SetKeyValue( "farz", len ) 
	self.FlashlightEnt:SetKeyValue( "fov", 90) 
	self.FlashlightEnt:SetKeyValue( "lightfov", size )
		
	self.FlashlightEnt:SetKeyValue( "lightcolor", Format( "%i %i %i 255", col.r * bright, col.g * bright, col.b * bright ) )
	self.FlashlightEnt:Spawn()
	self.FlashlightEnt:Input( "SpotlightTexture", NULL, NULL, "effects/Flashlight001.vmt" )

end

function ENT:PhysicsSimulate( phys, deltatime )

	if not IsValid( self.Entity:GetOwner() ) then return end
 
	phys:Wake()
 
	self.ShadowParams.secondstoarrive = 0.0001
	self.ShadowParams.pos = self.Entity:GetOwner():GetShootPos()
	self.ShadowParams.angle = self.Entity:GetOwner():GetAimVector():Angle()
	self.ShadowParams.maxangular = 10000
	self.ShadowParams.maxangulardamp = 20000
	self.ShadowParams.maxspeed = 10000
	self.ShadowParams.maxspeeddamp = 20000
	self.ShadowParams.dampfactor = 0.5
	self.ShadowParams.teleportdistance = 100000 
	self.ShadowParams.deltatime = deltatime 
 
	phys:ComputeShadowControl( self.ShadowParams )
 
end

function ENT:Think()

	if not IsValid( self.Entity:GetOwner() ) then
	
		self.Entity:Remove()
	
	end

end

function ENT:OnRemove()

	if IsValid( self.FlashlightEnt ) then
	
		self.FlashlightEnt:Remove()
		
	end

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS // needed?

end

