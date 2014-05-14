// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/* This is to load hotfixes from the Morbus website */

local useClientHotfix = false

local clientHotfix = ""; -- Blankness
local rNum = tostring(math.random(1,1000000))
clientHotfixURL = "http://www.remscar.com/morbus/hotfix/client/cl_hotfix.txt".."?cacheBuster="..rNum

timer.Simple(5,function() http.Fetch( clientHotfixURL,
  function( body, len, headers, code )
    -- The first argument is the HTML we asked for.
    clientHotfix = body
    if useClientHotfix then
      RunString(clientHotfix)
    end
  end,
  function( error )
    -- We failed. =( 
  end
 ) end)

