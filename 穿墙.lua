local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game.Players
local Player = Players.LocalPlayer

local userId = Player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size100x100
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Gemini_Draggable_V3"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 240, 0, 110)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 255, 255)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Parent = MainFrame
AvatarImage.Size = UDim2.new(0, 50, 0, 50)
AvatarImage.Position = UDim2.new(0, 15, 0, 15)
AvatarImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImage.Image = content
local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

local PlayerName = Instance.new("TextLabel")
PlayerName.Parent = MainFrame
PlayerName.Size = UDim2.new(0, 130, 0, 20)
PlayerName.Position = UDim2.new(0, 75, 0, 20)
PlayerName.BackgroundTransparency = 1
PlayerName.Text = Player.DisplayName
PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerName.Font = Enum.Font.GothamBold
PlayerName.TextSize = 14
PlayerName.TextXAlignment = Enum.TextXAlignment.Left

local Toggle = Instance.new("TextButton")
Toggle.Parent = MainFrame
Toggle.Size = UDim2.new(0, 210, 0, 32)
Toggle.Position = UDim2.new(0, 15, 1, -42)
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Toggle.Text = "穿墙 : 开启"
Toggle.TextColor3 = Color3.fromRGB(150, 150, 150)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 13
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = Toggle

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16

local dragToggle = nil
local dragSpeed = 0.1
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(MainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
end

MainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

local noclip = false
local noclipConnection

task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        UIStroke.Color = Color3.fromHSV(hue, 0.7, 1)
    end
end)

Toggle.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        Toggle.Text = "穿墙 : 关闭"
        TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 150, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        Toggle.Text = "穿墙 : 开启"
        TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
    end
end)

noclipConnection = RunService.Stepped:Connect(function()
    if noclip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    noclip = false
    if noclipConnection then noclipConnection:Disconnect() end
    ScreenGui:Destroy()
end)