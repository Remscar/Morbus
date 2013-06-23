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


/* Running this function is VERY laggy and takes a LOT of time to run
   However it saves us time from manually doing all the files, one at a time */


local function ProcessFolder ( Location )
	local files, directories = file.Find(Location .. '*',"GAME")
	for k, v in pairs(files) do
		if file.IsDir(Location .. v,"GAME") then
			ProcessFolder(Location .. v .. '/')
		else
			local OurLocation = string.gsub(Location .. v, 'gamemodes/' .. FOLDER_NAME .. '/content/', '')
			if string.sub(OurLocation, -3) == "vmt" || string.sub(OurLocation, -3) == "vtf" || string.sub(OurLocation, -3) == "mdl" || string.sub(OurLocation, -3) == "wav" || string.sub(OurLocation, -3) == "mp3" || string.sub(OurLocation, -3) == "ttf" || string.sub(OurLocation, -3) == "txt" then			
				resource.AddFile(OurLocation)
				if false then
					MsgN("resource.AddFile(\""..OurLocation.."\")") -- for dumping to console
				end
			end
		end
	end
	for k, v in pairs(directories) do
		if file.IsDir(Location .. v,"GAME") then
			ProcessFolder(Location .. v .. '/')
		else
			local OurLocation = string.gsub(Location .. v, 'gamemodes/' .. FOLDER_NAME .. '/content/', '')
			if string.sub(OurLocation, -3) == "vmt" || string.sub(OurLocation, -3) == "vtf" || string.sub(OurLocation, -3) == "mdl" || string.sub(OurLocation, -3) == "wav" || string.sub(OurLocation, -3) == "mp3" || string.sub(OurLocation, -3) == "ttf" || string.sub(OurLocation, -3) == "txt" then			
				resource.AddFile(OurLocation)
				if false then
					MsgN("resource.AddFile(\""..OurLocation.."\")") -- for dumping to console
				end
			end
		end
	end
end



if true then 
	ProcessFolder('gamemodes/' .. FOLDER_NAME .. '/content/models/')
	ProcessFolder('gamemodes/' .. FOLDER_NAME .. '/content/materials/')
	ProcessFolder('gamemodes/' .. FOLDER_NAME .. '/content/resource/')
	ProcessFolder('gamemodes/' .. FOLDER_NAME .. '/content/sound/')
	ProcessFolder('gamemodes/' .. FOLDER_NAME .. '/content/scripts/')
end

