local Logo = {}

function Logo:Build(parent, size)
	local viewport = Instance.new("ViewportFrame")
	viewport.Size = UDim2.fromOffset(size, size)
	viewport.BackgroundTransparency = 1
	viewport.Ambient = Color3.new(1, 1, 1)
	viewport.LightColor = Color3.fromRGB(0, 150, 255)
	viewport.Parent = parent

	local cam = Instance.new("Camera")
	cam.Parent = viewport
	viewport.CurrentCamera = cam

	local world = Instance.new("WorldModel")
	world.Parent = viewport

	local scale = size / 34

	local function addDrop(cx, cy, radius, length)
		local head = Instance.new("Part")
		head.Shape = Enum.PartType.Ball
		head.Size = Vector3.new(radius * 2, radius * 2, radius * 2)
		head.Material = Enum.Material.Neon
		head.Color = Color3.fromRGB(0, 150, 255)
		head.CFrame = CFrame.new(cx, cy, 0)
		head.Anchored = true
		head.CanCollide = false
		head.CanQuery = false
		head.CanTouch = false
		head.Parent = world

		local tail = Instance.new("Part")
		tail.Size = Vector3.new(radius * 1.7, length, radius * 1.7)
		tail.Material = Enum.Material.Neon
		tail.Color = Color3.fromRGB(0, 150, 255)
		tail.Anchored = true
		tail.CanCollide = false
		tail.CanQuery = false
		tail.CanTouch = false
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshId = "rbxassetid://3270017"
		mesh.Parent = tail
		tail.CFrame = CFrame.new(cx, cy - radius - length / 2, 0) * CFrame.Angles(math.pi, 0, 0)
		tail.Parent = world
	end

	addDrop(-22 * scale, 0, 5.5 * scale, 15 * scale)
	addDrop(0, 1 * scale, 7 * scale, 21 * scale)
	addDrop(22 * scale, 0, 5.5 * scale, 15 * scale)

	cam.CFrame = CFrame.lookAt(Vector3.new(0, -10 * scale, 38 * scale), Vector3.new(0, -10 * scale, 0))

	return viewport
end

return Logo