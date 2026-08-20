local Movement = {}

local Players = game:GetService("Players")

local function getCharacter()
	local player = Players.LocalPlayer
	if not player then
		return nil
	end
	return player.Character
end

function Movement:Init()
end

function Movement:SetWalkspeed(value)
	local char = getCharacter()
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = value
	end
end

function Movement:SetJumpPower(value)
	local char = getCharacter()
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.JumpPower = value
	end
end

return Movement