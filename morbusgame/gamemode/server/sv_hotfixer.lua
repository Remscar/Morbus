// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/* This is to load hotfixes from the Morbus website */

local useServerHotfix = false
local silenceVersionChecker = true



local serverHotfix = ""; -- Blankness
local rNum = tostring(math.random(1,1000000))
serverHotfixURL = "http://www.remscar.com/morbus/hotfix/server/sv_hotfix.txt".."?cacheBuster="..rNum


timer.Simple(1,function() http.Fetch( serverHotfixURL,
  function( body, len, headers, code )
    -- The first argument is the HTML we asked for.
    serverHotfix = body
    if useServerHotfix then
      RunString(serverHotfix)
    end
  end,
  function( error )
    -- We failed. =( 
  end
) end)
