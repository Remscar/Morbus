---------------------------------LOCALIZATION
local math = math
local table = table
local umsg = umsg
local player = player
local timer = timer
local pairs = pairs
local umsg = umsg
local usermessage = usermessage
local file = file
---------------------------------------------
function FontHeight(fnt)
	if not _FH then _FH = {} end
	if not _FH[fnt] then
		surface.SetFont(fnt)
		
		local _,h = surface.GetTextSize("|")
		
		_FH[fnt] = h
	end
	
	return _FH[fnt]
end

function TextWidth(fnt,txt)
	if not _FW then _FW = {} end
	if not _FW[fnt] then _FW[fnt] = {} end
	if not _FW[fnt][txt] then
		surface.SetFont(fnt)
		
		local w,_ = surface.GetTextSize(txt)
		
		_FW[fnt][txt] = w
	end
	
	return _FW[fnt][txt]
end

function StringSize(fnt,txt)
	return TextWidth(fnt,txt),FontHeight(fnt)
end