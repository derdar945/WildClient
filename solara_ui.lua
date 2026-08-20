local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Theme = {
	Background = Color3.fromRGB(10, 11, 17),
	Secondary  = Color3.fromRGB(15, 17, 25),
	Card       = Color3.fromRGB(20, 23, 34),
	Blue       = Color3.fromRGB(0, 150, 255),
	BlueDark   = Color3.fromRGB(0, 100, 220),
	Text       = Color3.fromRGB(235, 240, 250),
	Muted      = Color3.fromRGB(145, 152, 172),
}

local function corner(instance, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = instance
	return c
end

local function stroke(instance, color, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Theme.BlueDark
	s.Transparency = transparency or 0.4
	s.Thickness = 1
	s.Parent = instance
	return s
end

local function gradient(instance, top, bottom, rotation)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(top, bottom)
	g.Rotation = rotation or 90
	g.Parent = instance
	return g
end

local function tween(object, goal, duration)
	local t = TweenService:Create(object, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
	t:Play()
	return t
end

local function makeLabel(parent, text, size, color, font)
	local label = Instance.new("TextLabel")
	label.Text = text
	label.TextSize = size
	label.TextColor3 = color or Theme.Text
	label.Font = font or Enum.Font.GothamBold
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Parent = parent
	return label
end

function Library:CreateWindow(options)
	options = options or {}

	local gui = Instance.new("ScreenGui")
	gui.Name = options.name or "WildClient"
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
	overlay.Name = "Overlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.new(0, 0, 0)
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.Text = ""
	overlay.ZIndex = 1
	overlay.Parent = gui

	local width = options.width or 560
	local height = options.height or 420

	local window = Instance.new("Frame")
	window.Name = "Window"
	window.Size = UDim2.fromOffset(width, height)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.BackgroundColor3 = Theme.Background
	window.BorderSizePixel = 0
	window.ClipsDescendants = true
	window.ZIndex = 2
	window.Visible = false
	window.Parent = gui

	corner(window, 16)
	gradient(window, Theme.Background, Theme.Secondary, 90)

	local titlebar = Instance.new("Frame")
	titlebar.Name = "TitleBar"
	titlebar.Size = UDim2.new(1, 0, 0, 38)
	titlebar.BackgroundColor3 = Color3.fromRGB(12, 13, 21)
	titlebar.BorderSizePixel = 0
	titlebar.Parent = window

	corner(titlebar, 16)

	local cornerCover = Instance.new("Frame")
	cornerCover.Name = "CornerCover"
	cornerCover.Size = UDim2.new(1, 0, 0, 19)
	cornerCover.Position = UDim2.new(0, 0, 0, 19)
	cornerCover.BackgroundColor3 = Color3.fromRGB(12, 13, 21)
	cornerCover.BorderSizePixel = 0
	cornerCover.ZIndex = 3
	cornerCover.Parent = titlebar

	local titleDot = Instance.new("Frame")
	titleDot.Size = UDim2.fromOffset(10, 10)
	titleDot.Position = UDim2.new(0, 14, 0.5, -5)
	titleDot.BackgroundColor3 = Theme.Blue
	titleDot.BorderSizePixel = 0
	titleDot.ZIndex = 5
	titleDot.Parent = titlebar
	corner(titleDot, 5)

	local title = Instance.new("TextLabel")
	title.Text = options.title or "Wild Client"
	title.TextSize = 15
	title.TextColor3 = Theme.Text
	title.Font = Enum.Font.GothamBold
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -70, 1, 0)
	title.Position = UDim2.new(0, 32, 0, 0)
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

	local tabbar = Instance.new("Frame")
	tabbar.Name = "TabBar"
	tabbar.Size = UDim2.new(1, 0, 0, 36)
	tabbar.Position = UDim2.new(0, 0, 0, 38)
	tabbar.BackgroundTransparency = 1
	tabbar.BorderSizePixel = 0
	tabbar.Parent = window

	local tabList = Instance.new("UIListLayout")
	tabList.FillDirection = Enum.FillDirection.Horizontal
	tabList.Padding = UDim.new(0, 6)
	tabList.SortOrder = Enum.SortOrder.LayoutOrder
	tabList.Parent = tabbar

	local tabPad = Instance.new("UIPadding")
	tabPad.PaddingLeft = UDim.new(0, 12)
	tabPad.PaddingTop = UDim.new(0, 5)
	tabPad.Parent = tabbar

	local container = Instance.new("ScrollingFrame")
	container.Name = "Container"
	container.Size = UDim2.new(1, -16, 1, -86)
	container.Position = UDim2.new(0, 8, 0, 80)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 3
	container.ScrollBarImageColor3 = Theme.Blue
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	container.Parent = window

	local windowApi = {
		_tabs = {},
		Destroy = function()
			gui:Destroy()
		end,
	}

	local function addTab(name)
		if type(name) == "table" then
			name = name.Name or name.name or "Вкладка"
		end
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0, math.clamp(#name * 9 + 26, 80, 200), 0, 26)
		button.BackgroundColor3 = Theme.Card
		button.BorderSizePixel = 0
		button.Text = "  " .. name
		button.TextColor3 = Theme.Muted
		button.TextSize = 13
		button.Font = Enum.Font.GothamSemibold
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Parent = tabbar
		corner(button, 9)
		stroke(button, Theme.BlueDark, 0.3)

		local dot = Instance.new("Frame")
		dot.Size = UDim2.fromOffset(5, 5)
		dot.Position = UDim2.new(0, 9, 0.5, -2.5)
		dot.BackgroundColor3 = Theme.Blue
		dot.BorderSizePixel = 0
		dot.Parent = button
		corner(dot, 2.5)

		local page = Instance.new("Frame")
		page.Name = name .. "Page"
		page.Size = UDim2.new(1, 0, 0, 0)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.AutomaticSize = Enum.AutomaticSize.Y
		page.Visible = false
		page.Parent = container

		local layout = Instance.new("UIListLayout")
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 6)
		layout.Parent = page

		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 4)
		padding.PaddingRight = UDim.new(0, 4)
		padding.PaddingTop = UDim.new(0, 2)
		padding.PaddingBottom = UDim.new(0, 6)
		padding.Parent = page

		local tabApi = {}
		local active = false

		local function setActive()
			if active then return end
			for _, t in ipairs(windowApi._tabs) do
				if t ~= tabApi then
					t._setInactive()
				end
			end
			active = true
			tween(button, { BackgroundColor3 = Theme.Blue, TextColor3 = Color3.fromRGB(9, 11, 18) }, 0.15)
			tween(dot, { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, 0.15)
			page.Visible = true
		end

		local function setInactive()
			active = false
			tween(button, { BackgroundColor3 = Theme.Card, TextColor3 = Theme.Muted }, 0.15)
			tween(dot, { BackgroundColor3 = Theme.Blue }, 0.15)
			page.Visible = false
		end

		tabApi._setInactive = setInactive

		function tabApi:AddLabel(text)
			local card = Instance.new("Frame")
			card.Size = UDim2.new(1, 0, 0, 30)
			card.BackgroundTransparency = 1
			card.BorderSizePixel = 0
			card.Parent = page
			local label = makeLabel(card, text, 13, Theme.Muted, Enum.Font.GothamSemibold)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Position = UDim2.new(0, 12, 0, 0)
			label.Size = UDim2.new(1, -24, 1, 0)
		end

		function tabApi:AddDivider(text)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 0, 22)
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.Parent = page
			local dot = Instance.new("Frame")
			dot.Size = UDim2.fromOffset(6, 6)
			dot.Position = UDim2.new(0, 12, 0.5, -3)
			dot.BackgroundColor3 = Theme.Blue
			dot.BorderSizePixel = 0
			dot.Parent = frame
			corner(dot, 3)
			local label = makeLabel(frame, text or "", 12, Theme.Muted, Enum.Font.GothamBold)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Position = UDim2.new(0, 26, 0, 0)
			label.Size = UDim2.new(1, -36, 1, 0)
		end

		function tabApi:AddButton(text, callback)
			local card = Instance.new("Frame")
			card.Size = UDim2.new(1, 0, 0, 36)
			card.BackgroundColor3 = Theme.Card
			card.BorderSizePixel = 0
			card.Parent = page
			corner(card, 10)
			stroke(card, Theme.BlueDark, 0.3)

			local label = makeLabel(card, text, 13, Theme.Text, Enum.Font.GothamSemibold)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Position = UDim2.new(0, 14, 0, 0)
			label.Size = UDim2.new(1, -100, 1, 0)

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0, 76, 0, 26)
			btn.Position = UDim2.new(1, -88, 0.5, -13)
			btn.BackgroundColor3 = Theme.Secondary
			btn.BorderSizePixel = 0
			btn.Text = "Жми"
			btn.TextColor3 = Theme.Blue
			btn.TextSize = 12
			btn.Font = Enum.Font.GothamBold
			btn.Parent = card
			corner(btn, 8)
			stroke(btn, Theme.BlueDark, 0.3)

			btn.MouseEnter:Connect(function()
				tween(btn, { BackgroundColor3 = Theme.Blue, TextColor3 = Color3.fromRGB(9, 11, 18) }, 0.12)
			end)
			btn.MouseLeave:Connect(function()
				tween(btn, { BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.Blue }, 0.12)
			end)
			btn.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)
		end

		function tabApi:AddToggle(text, defaultValue, callback)
			local value = defaultValue or false
			local card = Instance.new("Frame")
			card.Size = UDim2.new(1, 0, 0, 36)
			card.BackgroundColor3 = Theme.Card
			card.BorderSizePixel = 0
			card.Parent = page
			corner(card, 10)
			stroke(card, Theme.BlueDark, 0.3)

			local label = makeLabel(card, text, 13, Theme.Text, Enum.Font.GothamSemibold)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Position = UDim2.new(0, 14, 0, 0)
			label.Size = UDim2.new(1, -80, 1, 0)

			local switch = Instance.new("Frame")
			switch.Size = UDim2.fromOffset(44, 24)
			switch.Position = UDim2.new(1, -56, 0.5, -12)
			switch.BackgroundColor3 = Theme.Secondary
			switch.BorderSizePixel = 0
			switch.Parent = card
			corner(switch, 12)
			stroke(switch, Theme.BlueDark, 0.3)

			local knob = Instance.new("Frame")
			knob.Size = UDim2.fromOffset(18, 18)
			knob.Position = UDim2.new(0, 3, 0.5, -9)
			knob.BackgroundColor3 = Theme.Muted
			knob.BorderSizePixel = 0
			knob.Parent = switch
			corner(knob, 9)

			local function apply()
				if value then
					tween(switch, { BackgroundColor3 = Theme.Blue }, 0.15)
					tween(knob, { Position = UDim2.new(0, 23, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, 0.15)
				else
					tween(switch, { BackgroundColor3 = Theme.Secondary }, 0.15)
					tween(knob, { Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Theme.Muted }, 0.15)
				end
			end
			apply()

			local click = Instance.new("TextButton")
			click.Size = UDim2.new(1, 0, 1, 0)
			click.BackgroundTransparency = 1
			click.Text = ""
			click.Parent = card

			click.MouseButton1Click:Connect(function()
				value = not value
				apply()
				if callback then callback(value) end
			end)
		end

		function tabApi:AddSlider(text, min, max, default, callback)
			min = min or 0
			max = max or 100
			local value = default or min

			local card = Instance.new("Frame")
			card.Size = UDim2.new(1, 0, 0, 56)
			card.BackgroundColor3 = Theme.Card
			card.BorderSizePixel = 0
			card.Parent = page
			corner(card, 10)
			stroke(card, Theme.BlueDark, 0.3)

			local label = makeLabel(card, text, 13, Theme.Text, Enum.Font.GothamSemibold)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Position = UDim2.new(0, 14, 0, 0)
			label.Size = UDim2.new(1, -90, 0, 24)

			local valueLabel = makeLabel(card, tostring(value), 13, Theme.Blue, Enum.Font.GothamBold)
			valueLabel.TextXAlignment = Enum.TextXAlignment.Right
			valueLabel.Position = UDim2.new(1, -90, 0, 0)
			valueLabel.Size = UDim2.new(0, 76, 0, 24)

			local track = Instance.new("Frame")
			track.Size = UDim2.new(1, -28, 0, 6)
			track.Position = UDim2.new(0, 14, 1, -16)
			track.BackgroundColor3 = Theme.Secondary
			track.BorderSizePixel = 0
			track.Parent = card
			corner(track, 3)
			stroke(track, Theme.BlueDark, 0.25)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3 = Theme.Blue
			fill.BorderSizePixel = 0
			fill.Parent = track
			corner(fill, 3)

			local knob = Instance.new("Frame")
			knob.Size = UDim2.fromOffset(14, 14)
			knob.Position = UDim2.new(0, -7, 0.5, -7)
			knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			knob.BorderSizePixel = 0
			knob.Parent = track
			corner(knob, 7)
			stroke(knob, Theme.BlueDark, 0.2)

			local function setValue(v)
				value = math.clamp(v, min, max)
				local ratio = (value - min) / (max - min)
				tween(fill, { Size = UDim2.new(ratio, 0, 1, 0) }, 0.08)
				tween(knob, { Position = UDim2.new(ratio, -7, 0.5, -7) }, 0.08)
				local rounded = math.round(value * 10) / 10
				valueLabel.Text = tostring(rounded)
				if callback then callback(value) end
			end

			setValue(value)

			local draggingSlider = false
			local function updateFromMouse()
				local rel = (UIS:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X
				setValue(min + math.clamp(rel, 0, 1) * (max - min))
			end

			track.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = true
					updateFromMouse()
				end
			end)
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = false
				end
			end)
			UIS.InputChanged:Connect(function(input)
				if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
					updateFromMouse()
				end
			end)
		end

		button.MouseButton1Click:Connect(function()
			setActive()
		end)

		table.insert(windowApi._tabs, tabApi)
		if #windowApi._tabs == 1 then
			setActive()
		end

		return tabApi
	end

	windowApi.AddTab = addTab
	windowApi._window = window

	local open = false

	local function setOpen(value)
		open = value
		if open then
			window.Visible = true
			overlay.Visible = true
			tween(blur, { Size = 8 }, 0.2)
			tween(overlay, { BackgroundTransparency = 0.65 }, 0.2)
			window.Size = UDim2.fromOffset(width * 0.94, height * 0.94)
			window.BackgroundTransparency = 0.4
			task.delay(0.05, function()
				tween(window, { Size = UDim2.fromOffset(width, height), BackgroundTransparency = 0 }, 0.3)
			end)
		else
			overlay.Visible = false
			tween(blur, { Size = 0 }, 0.25)
			window.Visible = false
		end
	end

	windowApi.SetOpen = setOpen
	windowApi.IsOpen = function()
		return open
	end

	overlay.MouseButton1Click:Connect(function()
		setOpen(false)
	end)

	UIS.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.RightShift then
			setOpen(not open)
		end
	end)

	return windowApi
end

local UI = Library:CreateWindow({
	name = "WildClient",
	title = "Wild Client",
	width = 560,
	height = 420,
})

local main = UI:AddTab("Главная")
main:AddDivider("Информация")
main:AddLabel("Добро пожаловать в Wild Client")
main:AddDivider("Основные функции")
main:AddButton("Проверить", function()
	print("Нажата кнопка!")
end)
main:AddToggle("Авто-фарм", false, function(v)
	print("Авто-фарм:", v)
end)
main:AddSlider("Скорость", 0, 100, 50, function(v)
	print("Скорость:", v)
end)

local settings = UI:AddTab("Настройки")
settings:AddDivider("Настройки")
settings:AddToggle("Безопасный режим", true, function(v)
	print("Безопасный режим:", v)
end)
settings:AddToggle("Тёмная тема", true, function(v)
	print("Тёмная тема:", v)
end)
settings:AddButton("Сбросить", function()
	print("Сброшено")
end)
