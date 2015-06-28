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

local rNum = tostring(math.random(1,1000000))
versionURL = "http://www.remscar.com/morbus/hotfix/version.txt".."?cacheBuster="..rNum


timer.Simple(1,function() http.Fetch( versionURL,
  function( body, len, headers, code )
    if tonumber(body) != GM_VERSION_SHORT then
      if !silenceVersionChecker then
        timer.Start("Version_Warning",120,0,function() SendAll("This server is running an older version of Morbus. Please notify a server admin or owner.") end)
      end
      MsgN("A newer version of Morbus is available at morbus.remscar.com or moddb.com/mods/morbus")
      SetGlobalBool("Morbus_Outdated",1)
    else
      SetGlobalBool("Morbus_Outdated",0)
    end
  end,
  function( error )
  end
) end)
