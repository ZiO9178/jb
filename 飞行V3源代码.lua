local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local main = Instance.new("ScreenGui")
main.Name = "FlyGuiV4"
main.ResetOnSpawn = false
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = main
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.Size = UDim2.new(0, 230, 0, 120)
frame.Position = UDim2.new(0.1, 0, 0.4, 0)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local shadow = Instance.new("ImageLabel", frame)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24, 24, 276, 276)

local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "FLY GUI V4"
title.Size = UDim2.new(1, -10, 0, 25)
title.Position = UDim2.new(0, 5, 0, 3)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextScaled = true
title.BackgroundTransparency = 1

local function newButton(text, pos, color)
	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 40)
	btn.Position = pos
	btn.Size = UDim2.new(0, 60, 0, 30)
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = (color or Color3.fromRGB(30, 30, 40)):Lerp(Color3.fromRGB(0, 170, 255), 0.3)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 40)
	end)
	return btn
end

local up = newButton("UP", UDim2.new(0.05, 0, 0.25, 0), Color3.fromRGB(0, 120, 255))
local down = newButton("DOWN", UDim2.new(0.05, 0, 0.6, 0), Color3.fromRGB(255, 100, 0))
local toggle = newButton("Fly", UDim2.new(0.65, 0, 0.25, 0), Color3.fromRGB(0, 200, 100))
local plus = newButton("+", UDim2.new(0.45, 0, 0.25, 0))
local minus = newButton("-", UDim2.new(0.45, 0, 0.6, 0))

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = frame
speedLabel.Text = "Speed: 1"
speedLabel.Size = UDim2.new(0.5, 0, 0, 25)
speedLabel.Position = UDim2.new(0.45, 0, 0.05, 0)
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.BackgroundTransparency = 1
speedLabel.TextScaled = true

local close = newButton("X", UDim2.new(0.85, 0, 0.6, 0), Color3.fromRGB(255, 60, 60))
close.TextSize = 16

local flying = false
local speed = 1
local bodyGyro, bodyVel

local function startFly()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	bodyGyro = Instance.new("BodyGyro", hrp)
	bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
	bodyGyro.P = 15000

	bodyVel = Instance.new("BodyVelocity", hrp)
	bodyVel.MaxForce = Vector3.new(400000, 400000, 400000)
	bodyVel.Velocity = Vector3.zero

	flying = true
	StarterGui:SetCore("SendNotification", {
		Title = "FLY ENABLED";
		Text = "You are now flying!";
		Duration = 3;
	})
	RunService.RenderStepped:Connect(function()
		if flying then
			local camCF = workspace.CurrentCamera.CFrame
			local dir = Vector3.zero
			if player:GetMouse().W then dir = dir + camCF.LookVector end
			if player:GetMouse().S then dir = dir - camCF.LookVector end
			if player:GetMouse().A then dir = dir - camCF.RightVector end
			if player:GetMouse().D then dir = dir + camCF.RightVector end
			bodyGyro.CFrame = camCF
			bodyVel.Velocity = dir * (speed * 5)
		end
	end)
end

local function stopFly()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVel then bodyVel:Destroy() end
	StarterGui:SetCore("SendNotification", {
		Title = "FLY DISABLED";
		Text = "Back to normal.";
		Duration = 3;
	})
end

toggle.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
	else
		startFly()
	end
end)

plus.MouseButton1Click:Connect(function()
	speed = speed + 1
	speedLabel.Text = "Speed: " .. speed
end)

minus.MouseButton1Click:Connect(function()
	if speed > 1 then
		speed = speed - 1
		speedLabel.Text = "Speed: " .. speed
	end
end)

up.MouseButton1Click:Connect(function()
	player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
end)

down.MouseButton1Click:Connect(function()
	player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -2, 0)
end)

close.MouseButton1Click:Connect(function()
	main:Destroy()
end)