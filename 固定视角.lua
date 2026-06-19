local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local locked = false
local originalCameraType = nil
local lockedCFrame = nil

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FreezeCameraGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 130)
frame.Position = UDim2.new(0.5, -110, 0.5, -65)
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 100, 0, 25)
titleLabel.Position = UDim2.new(0, 12, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "固定视角"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -28, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = frame

closeBtn.MouseEnter:Connect(function()
    closeBtn.TextColor3 = Color3.fromRGB(230, 75, 75)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

local instrLabel = Instance.new("TextLabel")
instrLabel.Size = UDim2.new(1, -24, 0, 20)
instrLabel.Position = UDim2.new(0, 12, 0, 35)
instrLabel.BackgroundTransparency = 1
instrLabel.Text = "在当拍击者时开启，直到恢复正常"
instrLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
instrLabel.Font = Enum.Font.Gotham
instrLabel.TextSize = 10
instrLabel.TextXAlignment = Enum.TextXAlignment.Left
instrLabel.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -24, 0, 15)
statusLabel.Position = UDim2.new(0, 12, 0, 58)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "状态：未固定"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -24, 0, 32)
toggleBtn.Position = UDim2.new(0, 12, 0, 84)
toggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
toggleBtn.Text = "固定视角"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

closeBtn.MouseButton1Click:Connect(function()
    if locked then
        camera.CameraType = originalCameraType or Enum.CameraType.Custom
        locked = false
    end
    screenGui:Destroy()
end)

local dragToggle, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragToggle then
        updateDrag(input)
    end
end)

local freezeConnection = nil
local function startFreeze()
    if freezeConnection then return end
    originalCameraType = camera.CameraType
    lockedCFrame = camera.CFrame
    camera.CameraType = Enum.CameraType.Scriptable
    freezeConnection = game:GetService("RunService").RenderStepped:Connect(function()
        camera.CFrame = lockedCFrame
    end)
end

local function stopFreeze()
    if freezeConnection then
        freezeConnection:Disconnect()
        freezeConnection = nil
    end
    camera.CameraType = originalCameraType or Enum.CameraType.Custom
    locked = false
end

toggleBtn.MouseButton1Click:Connect(function()
    locked = not locked
    if locked then
        startFreeze()
        toggleBtn.Text = "解除固定"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        statusLabel.Text = "状态：已固定"
        statusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
    else
        stopFreeze()
        toggleBtn.Text = "固定视角"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        statusLabel.Text = "状态：未固定"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)