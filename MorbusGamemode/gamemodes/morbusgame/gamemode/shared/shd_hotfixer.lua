// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/* This is to load hotfixes from the Morbus website */

local useSharedHotfix = false

local sharedHotfix = ""; -- Blankness
local rNum = tostring(math.random(1,1000000))
local sharedHotfixURL = "http://www.remscar.com/morbus/hotfix/shared/shd_hotfix.txt".."?cacheBuster="..rNum

timer.Simple(1,function() http.Fetch( sharedHotfixURL,
  function( body, len, headers, code )
    -- The first argument is the HTML we asked for.
    sharedHotfix = body
    if useSharedHotfix then
      RunString(sharedHotfix)
    end
  end,
  function( error )
    -- We failed. =( 
  end
 ) end)

