LIGHT = {}

function LIGHT.Regen(x)
	return (0.0005*(x^2))+(0.0225*x) + 2 --does this cause lagg?
end
function LIGHT.Precent(x)
	return math.Round((x/LIGHT_BATTERY)*100)
end
function LIGHT.ToTime(x)
	return (x/100)*LIGHT_BATTERY
end