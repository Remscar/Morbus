// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
local render = render -- hurr durr

local MaterialBlurX = Material( "pp/blurx" )
local MaterialBlurY = Material( "pp/blury" )
local MaterialWhite = CreateMaterial( "WhiteMaterial", "VertexLitGeneric", {
    ["$basetexture"] = "color/white",
    ["$vertexalpha"] = "1",
    ["$model"] = "1",
} )
local MaterialComposite = CreateMaterial( "CompositeMaterial", "UnlitGeneric", {
    ["$basetexture"] = "_rt_FullFrameFB",
    ["$additive"] = "1",
} )

local RT1 = GetRenderTarget( "SRT1",512,512 )
local RT2 = GetRenderTarget( "SRT2",512,512 )

--Coders note
--I really hate how my bots alwasys run away from me, i just want to infect them... what assholes

local function RenderScene( Origin, Angles )
 
   local oldRT = render.GetRenderTarget()
        render.SetRenderTarget( RT1 )
        render.Clear( 0, 0, 0, 255, true )
        render.SetRenderTarget( oldRT )

        

 
end
hook.Add( "RenderScene", "ResetGlow", RenderScene )


function AlienScent()
  render.ClearStencil()
  local ply = LocalPlayer()

  if !ply:IsAlien() || !HUD_DEBUG[13] then return end
  --if Morbus.AlienScent < CurTime() then return end
  local distance = 1800

  if ply:IsBrood() && Morbus.Upgrades[UPGRADE.SMELLRANGE] then
    distance = distance + (Morbus.Upgrades[UPGRADE.SMELLRANGE] * UPGRADE.SMELLRANGE_AMOUNT)
  end

  for k, ent in pairs(player.GetAll()) do
    if ent != ply then


      if ((ply:GetPos():Distance(ent:GetPos()) < distance && ent:Alive()) || (ent:IsAlien() && ent:Alive())) && ent:Team() == TEAM_GAME then
        A(ent)
        B(ent)

      end

    end

  end


end
hook.Add( "PreDrawTranslucentRenderables", "PostDrawing", AlienScent)




function A(ent)

  render.SetStencilEnable( true )
  render.SetStencilFailOperation( STENCILOPERATION_KEEP )
  render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
  render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
  render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
  render.SetStencilWriteMask( 1 )
  render.SetStencilReferenceValue( 1 )
  render.SuppressEngineLighting( true )
  render.SetColorModulation( 1, 1, 1)

  cam.IgnoreZ( true )
    render.SetBlend( 0 )

    render.MaterialOverride( MaterialWhite )

    ent:DrawModel()


    render.MaterialOverride()

    render.SetBlend( 1 )
    cam.IgnoreZ( false )
    render.SuppressEngineLighting( false )
    render.SetStencilEnable( false )
end

function B(ent)
  local w, h = ScrW(), ScrH()
  local oldRT = render.GetRenderTarget()
  render.SetRenderTarget( RT1 )

  cam.IgnoreZ( true )


  render.SuppressEngineLighting( true )
  local HP = ent:Health()
  if ent:IsAlien() then
    if LocalPlayer():IsSwarm() || LocalPlayer():GetNWBool("alienform",false) then
      HP = Color(255,0,255)
    else
      HP = Color(255,0,255)
    end
  else
    -- Humans should only have 100 max HP so this function should be okay
    -- Lerp between pure Green (100 hp) and pure Red (0 hp)
    HP = Color(255-(HP*2.55),HP*2.55,0)
  end

  render.SetColorModulation(HP.r/255,HP.g/255,HP.b/255) -- 0-1 scale ):
  render.SetViewPort( 0, 0, 512, 512 )

  render.MaterialOverride( MaterialWhite )

  ent:DrawModel()

  render.MaterialOverride()
  render.SuppressEngineLighting( false )


  cam.IgnoreZ( false )
  render.SetViewPort( 0, 0, w, h )
  render.SetRenderTarget( oldRT )

end


local function RenderScreenspaceEffects( )

  if !LocalPlayer():IsAlien() then return end
  --if Morbus.AlienScent < CurTime() then return end

    DrawDistortionAlien()

 
    MaterialBlurX:SetTexture( "$basetexture", RT1 )
    MaterialBlurY:SetTexture( "$basetexture", RT2 )
    MaterialBlurX:SetFloat( "$size", 2.5 )
    MaterialBlurY:SetFloat( "$size", 2.5 )
       
    local oldRT = render.GetRenderTarget()


   

    render.SetRenderTarget( RT2 )
    render.SetMaterial( MaterialBlurX )
    render.DrawScreenQuad()
 

    render.SetRenderTarget( RT1 )
    render.SetMaterial( MaterialBlurY )
    render.DrawScreenQuad()
 
    render.SetRenderTarget( oldRT )
   

    render.SetStencilEnable( true )
    render.SetStencilReferenceValue( 0 )
    render.SetStencilTestMask( 1 )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render.SetStencilPassOperation( STENCILOPERATION_KEEP )


    

    MaterialComposite:SetTexture( "$basetexture", RT1 )
    render.SetMaterial( MaterialComposite )
    render.DrawScreenQuad()
 
    render.SetStencilEnable( false )


    

    --DrawAmmoScreenTexture()
 
end
hook.Add( "RenderScreenspaceEffects", "CompositeGlow", RenderScreenspaceEffects );