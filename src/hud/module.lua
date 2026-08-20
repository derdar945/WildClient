local HUD = {}

local Players = game:GetService("Players")

local gui = nil

local function makeBar(parent, width, height, position)
	local bar = Instance.new("Frame")
	bar.Size = UDim2.fromOffset(width, height)
	bar.Position = position
	bar.BackgroundColor3 = Color3.fromRGB(12, 13, 21)
	bar.BorderSizePixel = 0
	bar.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = bar
	return bar
end

local function makeText(parent, text, size, color, xalign)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextSize = size
	label.TextColor3 = color
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = xalign
	label.Parent = parent
	return label
end

function HUD:Init()
	local ok = pcall(function()
		gui = Instance.new("ScreenGui")
		gui.Name = "WildClientHUD"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		gui.Parent = game:GetService("CoreGui")
	end)
	if not ok then
		gui = Instance.new("ScreenGui")
		gui.Name = "WildClientHUD"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	local Logo = getModule("gui/logo")

	local barHeight = 38
	local mainWidth = 400
	local serverWidth = 220
	local gap = 8

	local mainBar = makeBar(gui, mainWidth, barHeight, UDim2.new(0.5, -mainWidth / 2, 0, 10))
	local serverBar = makeBar(gui, serverWidth, barHeight, UDim2.new(0.5, mainWidth / 2 + gap, 0, 10))

	local logoViewport = Logo:Build(mainBar, 26)
	logoViewport.Position = UDim2.new(0, 10, 0.5, -13)

	local title = makeText(mainBar, "Wild Client", 14, Color3.fromRGB(235, 240, 250), Enum.TextXAlignment.Left)
	title.Position = UDim2.new(0, 42, 0, 0)

	local timeLabel = makeText(mainBar, "00:00", 14, Color3.fromRGB(0, 150, 255), Enum.TextXAlignment.Right)

	local serverLabel = makeText(serverBar, game.Name, 14, Color3.fromRGB(235, 240, 250), Enum.TextXAlignment.Center)

	local function updateClock()
		timeLabel.Text = os.date("%H:%M")
	end
	updateClock()
	task.spawn(function()
		while true do
			task.wait(1)
			updateClock()
		end
	end)

	HUD._gui = gui
end

function HUD:SetVisible(visible)
	if gui then
		gui.Enabled = visible
	end
end

return HUD