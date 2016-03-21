// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
/*--------------------------------------------
MORBUS MESSAGE SYSTEM
--------------------------------------------*/

local tex = surface.GetTextureID("vgui/morbus/HPBar")

surface.CreateFont("MSGFont", {
  font = "Verdana",
  size = 16,
  weight = 500,
})


MSYS = {}
MSYS.MESSAGES = {}
MSYS.last = 0

--Localization
local table = table
local surface = surface
local draw = draw
local pairs = pairs

--Constants
local margin = 5
local msg_font = "MSGFont"
local msg_width = 300

local text_width = msg_width - (margin * 2)
local text_height = draw.GetFontHeight(msg_font)

local top_y = margin
local top_x = ScrW()-msg_width-margin

local staytime = 8
local max_items = 4

local fadein = 0.05
local fadeout = 0.05

local movespeed = 2

local msg_colors = {
	alien_bg = Color(255,0,0,150),
	generic_text = Color(205,205,205,255),

	generic_bg = Color(40, 220, 235,150)
}

MSYS.width = msg_width + margin

function MSYS:AddColoredMessage(text, clr)
	local item = {}
	item.text = text
	item.col = clr
	item.bg = msg_colors.generic_bg

	self:AddMessageEx(item)
end

function MSYS:AddColoredBgMessage(text, bg_clr)
   local item = {}
   item.text = text
   item.col  = msg_colors.generic_text
   item.bg   = bg_clr

   self:AddMessageEx(item)
end

function MSYS:AddMessageEx(item)
	item.col = table.Copy(item.col or msgcolors.generic_text)
	item.col.a_max = item.col.a

	item.bg  = table.Copy(item.bg or msgcolors.generic_bg)
    item.bg.a_max = item.bg.a

    item.text = self:WrapText(item.text, text_width)
    item.height = (#item.text * text_height) + (margin * (1 + #item.text))

    item.time = CurTime()
    item.sounded = false
    item.move_y = -item.height

    if self.last > (item.time - 1) then
       item.time = self.last + 1
    end

    table.insert(self.MESSAGES, 1, item)

    self.last = item.time   
end

function MSYS:AddMessage(text, ao)
   self:AddColoredBgMessage(text, ao and msg_colors.alien_bg or msg_colors.generic_bg)
end

function CL_GameMessage(text)
   MSYS:AddMessage(text,false)
end

function MSYS:WrapText(text, width)
   surface.SetFont(msg_font)

   -- Any wrapping required?
   local w, _ = surface.GetTextSize(text)
   if w <= width then
      return {text} -- Nope, but wrap in table for uniformity
   end
   
   local words = string.Explode(" ", text) -- No spaces means you're screwed

   local lines = {""}
   for i, wrd in pairs(words) do
      local l = #lines
      local added = lines[l] .. " " .. wrd
      w, _ = surface.GetTextSize(added)

      if w > text_width then
         -- New line needed
         table.insert(lines, wrd)
      else
         -- Safe to tack it on
         lines[l] = added
      end
   end

   return lines
end

local msg_sound = Sound("Hud.Hint")
local base_spec = {
   font = msg_font,
   xalign = TEXT_ALIGN_CENTER,
   yalign = TEXT_ALIGN_TOP
}

function MSYS:Draw(client)
   if next(self.MESSAGES) == nil then return end -- fast empty check

   --refresh incase the client changes screen resolution
   top_x = ScrW()-msg_width-margin
   
   local running_y = top_y
   for k, item in pairs(self.MESSAGES) do
      if item.time < CurTime() then
         if item.sounded == false then
            client:EmitSound(msg_sound, 80, 250)
            item.sounded = true
         end

         -- Apply move effects to y
         local y = running_y + margin + item.move_y

         item.move_y = (item.move_y < 0) and item.move_y + movespeed or 0

         local delta = (item.time + staytime) - CurTime()
         delta = delta / staytime -- p

         -- Hurry up if we have too many
         if k >= max_items then
            delta = delta / 2
         end

         local alpha = 255
         -- These somewhat arcane delta and alpha equations are from
         -- HUDPickup stuff
         if delta > 1 - fadein then
            alpha = math.Clamp( (1.0 - delta) * (255 / fadein), 0, 255)
         elseif delta < fadeout then
            alpha = math.Clamp( delta * (255 / fadeout), 0, 255)
         end

         local height = item.height

         -- Background box
         item.bg.a = math.Clamp(alpha, 0, item.bg.a_max)
         surface.SetTexture(tex)
         surface.SetDrawColor(item.bg)
         surface.DrawTexturedRect(top_x, y, msg_width, height)
         --draw.RoundedBox(1, top_x, y, msg_width, height, item.bg)

         -- Text
         item.col.a = math.Clamp(alpha, 0, item.col.a_max)

         local spec = base_spec
         spec.color = item.col

         for i = 1, #item.text do
            spec.text=item.text[i]

            local tx = top_x + (msg_width / 2)
            
            --Fix an issue caused by a recent gmod update
            local ty = y + 20 + (i - 1) * (text_height + margin)
	    --old broken equation :
	    --local ty = y + margin + (i - 1) * (text_height + margin)
	    
            spec.pos={tx, ty}

            --draw.TextShadow(spec, 2, alpha)

            draw.SimpleTextOutlined(spec.text, spec.font, spec.pos[1], spec.pos[2], Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, Color(0,0,0,255))
         end

         if alpha == 0 then 
            self.MESSAGES[k] = nil 
         end

         running_y = y + height
      end
   end
end

function Clear_Messages()
   MSYS.MESSAGES = {}
   MSYS.last = 0
end

local function ReceiveGameMsg(um)
   local text = um:ReadString()
   local special = um:ReadBool()

   print(text)

   MSYS:AddMessage(text, special)
end
usermessage.Hook("game_msg", ReceiveGameMsg)

local function ReceiveCustomMsg(um)
   local text = um:ReadString()
   local clr = Color(255, 255, 255)

   clr.r = um:ReadShort()
   clr.g = um:ReadShort()
   clr.b = um:ReadShort()

   print(text)

   MSYS:AddColoredMessage(text, clr)
end
usermessage.Hook("game_msg_color", ReceiveCustomMsg)
