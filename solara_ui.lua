local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Background = Color3.fromRGB(10, 11, 17)
local Secondary = Color3.fromRGB(15, 17, 25)
local Text = Color3.fromRGB(235, 240, 250)

local gui = Instance.new("ScreenGui")
gui.Name = "WildClient"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local ok = pcall(function()
	gui.Parent = game:GetService("CoreGui")
end)
if not ok then
	gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")

local overlay = Instance.new("TextButton")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.new(0, 0, 0)
overlay.BackgroundTransparency = 1
overlay.BorderSizePixel = 0
overlay.Text = ""
overlay.ZIndex = 1
overlay.Visible = false
overlay.Parent = gui

local width = 560
local height = 380

local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.fromOffset(width, height)
window.Position = UDim2.new(0.5, 0, 0.5, 0)
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.BackgroundColor3 = Background
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.ZIndex = 2
window.Visible = false
window.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = window

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new(Background, Secondary)
grad.Rotation = 90
grad.Parent = window

local titlebar = Instance.new("Frame")
titlebar.Size = UDim2.new(1, 0, 0, 38)
titlebar.BackgroundColor3 = Color3.fromRGB(12, 13, 21)
titlebar.BackgroundTransparency = 1
titlebar.BorderSizePixel = 0
titlebar.Parent = window

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titlebar

local cover = Instance.new("Frame")
cover.Size = UDim2.new(1, 0, 0, 19)
cover.Position = UDim2.new(0, 0, 0, 19)
cover.BackgroundColor3 = Color3.fromRGB(12, 13, 21)
cover.BackgroundTransparency = 1
cover.BorderSizePixel = 0
cover.ZIndex = 3
cover.Parent = titlebar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 1, 0)
title.Position = UDim2.new(0, 16, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Wild Client"
title.TextColor3 = Text
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 5
title.Parent = titlebar

local dragging = false
local dragStart = Vector2.zero
local startPos = window.Position

titlebar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = window.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local function tween(object, goal, duration)
	TweenService:Create(object, TweenInfo.new(duration or 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
end

local open = false

local function setOpen(value)
	open = value
	if open then
		window.Visible = true
		overlay.Visible = true
		tween(blur, { Size = 8 }, 0.2)
		tween(overlay, { BackgroundTransparency = 0.65 }, 0.2)

		window.Position = UDim2.new(0.5, 0, 0.5, 60)
		window.BackgroundTransparency = 1
		titlebar.BackgroundTransparency = 1
		cover.BackgroundTransparency = 1
		task.delay(0.03, function()
			tween(window, { Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0 }, 0.35)
			tween(titlebar, { BackgroundTransparency = 0 }, 0.35)
			tween(cover, { BackgroundTransparency = 0 }, 0.35)
		end)
	else
		overlay.Visible = false
		tween(blur, { Size = 0 }, 0.25)
		window.Visible = false
	end
end

overlay.MouseButton1Click:Connect(function()
	setOpen(false)
end)

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightShift then
		setOpen(not open)
	end
end)