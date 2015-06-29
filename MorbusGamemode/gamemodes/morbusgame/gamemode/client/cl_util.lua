// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
function FontHeight(fnt)
	if not _FH then _FH = {} end
	if not _FH[fnt] then
		surface.SetFont(fnt)
		
		local _,h = surface.GetTextSize("|")
		
		_FH[fnt] = h
	end
	
	return _FH[fnt]
end

function util.TextWidth(fnt,txt)
	if not _FW then _FW = {} end
	if not _FW[fnt] then _FW[fnt] = {} end
	if not _FW[fnt][txt] then
		surface.SetFont(fnt)
		
		local w,_ = surface.GetTextSize(txt)
		
		_FW[fnt][txt] = w
	end
	
	return _FW[fnt][txt]
end

function util.StringSize(fnt,txt)
	return util.TextWidth(fnt,txt),FontHeight(fnt)
end



local healthcolors = {
  healthy = Color(0,255,0,255),
  hurt    = Color(170,230,10,255),
  wounded = Color(230,215,10,255),
  badwound= Color(255,140,0,255),
  death   = Color(255,0,0,255)
}



local sanitycolors = {
  max  = Color(255,255,255,255),
  high = Color(255,240,135,255),
  med  = Color(245,220,60,255),
  low  = Color(255,170,0,255),
  min  = Color(255,120,0,255),
}

function util.HealthToString(health)
  if health > 90 then
     return "Healthy", healthcolors.healthy
  elseif health > 70 then
     return "Slightly Hurt", healthcolors.hurt
  elseif health > 45 then
     return "Wounded", healthcolors.wounded
  elseif health > 20 then
     return "Badly Wounded", healthcolors.badwound
  else
     return "Near Death", healthcolors.death
  end
end
function util.SanityToString(sanity)
  if sanity > 890 then
     return "Perfectly Sane", sanitycolors.max
  elseif sanity > 800 then
     return "Mildy Psychotic", sanitycolors.high
  elseif sanity > 650 then
     return "Psychotic", sanitycolors.med
  elseif sanity > 500 then
     return "Insane", sanitycolors.low
  else
     return "Bat Shit Crazy", sanitycolors.min
  end
end