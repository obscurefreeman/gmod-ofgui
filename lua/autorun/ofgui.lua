for _, f in pairs(file.Find("ofgui/*", "LUA")) do
	AddCSLuaFile("ofgui/" .. f)
end
for _, f in pairs(file.Find("ofgui/vgui/*", "LUA")) do
	AddCSLuaFile("ofgui/vgui/" .. f)
end

if SERVER then
	resource.AddWorkshop("2390567739")
else
	ofgui = {}
	for _, f in pairs(file.Find("ofgui/vgui/*", "LUA")) do
		include("ofgui/vgui/" .. f)
	end
	for _, f in pairs(file.Find("ofgui/*", "LUA")) do
		include("ofgui/" .. f)
	end
end