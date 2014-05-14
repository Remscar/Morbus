// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
/*----------------------------------------------------------
IMPULSES
These things run every few seconds or what not
I hook them on timers just cause i can
----------------------------------------------------------*/

timer.Create("SecondImpulse",1,0,function() hook.Call("Impulse_Second") end)
timer.Create("Second4Impulse",4,0,function() hook.Call("Impulse_4Second") end)
timer.Create("Second15Impulse",15,0,function() hook.Call("Impulse_15Second") end)
timer.Create("Second20Impulse",20,0,function() hook.Call("Impulse_20Second") end)
timer.Create("QuarterSecondImpulse",0.25,0,function() hook.Call("Impulse_Quarter_Second") end)
