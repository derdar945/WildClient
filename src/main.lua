local Menu = getModule("gui/menu")
local HUD = getModule("hud/module")
local Movement = getModule("movement/module")
local Combat = getModule("combat/module")

Menu:Init()
HUD:Init()
Movement:Init()
Combat:Init()

Menu.OnOpenChanged = function(open)
	HUD:SetVisible(not open)
end

pcall(function()
	getgenv().WildClient = {
		Menu = Menu,
		HUD = HUD,
		Movement = Movement,
		Combat = Combat,
	}
end)

print("WildClient v4")

return true