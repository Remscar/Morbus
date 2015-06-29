local PMeta = FindMetaTable( "Player" )
 
local function AddAccessor( name, network )
        PMeta[ "Get"..name ] = function( self, cb )
                if ( network ) then
                        return self:GetNWInt( name, cb )
                end
               
                return self[ name ] or cb
        end
       
        if ( SERVER ) then
                PMeta[ "Set"..name ] = function( self, val )   
                        if ( network ) then
                                return self:SetNWInt( name, val )
                        else
                                self[ name ] = val
                        end
                end
        end
end
 
 -- is it bad i have too many of these? :) ALONG WITH 10 RECURSIVE FUNCTIONS FOR CONTENT
 -- Base Stats

AddAccessor( "SwarmMod", true )
AddAccessor( "SwarmPoints", true )
AddAccessor( "HardGender", true )

AddAccessor( "Infections", true ) -- GetInfections(), SetInfections()
AddAccessor( "InfectionsPotential", true )
AddAccessor( "RDMScore", true ) -- GetRDMScore(), SetRDMScore()
AddAccessor( "RDMScorePotential", true )
AddAccessor( "AlienKills", true ) -- GetAlienKills(), SetAlienKills()
AddAccessor( "AlienKillsPotential", true )

AddAccessor( "MeleeOverride", true ) -- GetMeleeOverride(), SetMeleeOverride()

AddAccessor( "WfxGuns", true ) -- GetWfxGuns(), SetWfxGuns()
AddAccessor( "WfxBlaster", true ) -- GetWfxBlaster(), SetWfxBlaster()
AddAccessor( "WfxGamma", true ) -- GetWfxGamma(), SetWfxGamma()
AddAccessor( "WfxSmoke", true ) -- GetWfxSmoke(), SetWfxSmoke()
AddAccessor( "WfxTeslar", true ) -- GetWfxTeslar(), SetWfxTeslar()
AddAccessor( "WfxPhaser", true ) -- GetWfxPhaser(), SetWfxPhaser()
AddAccessor( "WfxPulsar", true ) -- GetWfxPulsar(), SetWfxPulsar()
AddAccessor( "WfxSwarm", true ) -- GetWfxSwarm(), SetWfxSwarm()
AddAccessor( "WfxBulldog", true ) -- GetWfxBulldog(), SetWfxBulldog()
AddAccessor( "DeathFX", true ) -- GetDeathFX(), SetDeathFX()