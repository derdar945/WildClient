local Menu = getModule("gui/menu")
local Movement = getModule("movement/module")
local Combat = getModule("combat/module")

Menu:Init()
Movement:Init()
Combat:Init()

pcall(function()
	getgenv().WildClient = {
		Menu = Menu,
		Movement = Movement,
		Combat = Combat,
	}
end)

print("WildClient v3")

return true