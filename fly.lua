local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("GeminiFlyV3") then
    CoreGui.GeminiFlyV3:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sxingz 飞行"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local plr = game.Players.LocalPlayer
local flying = false
local speed = 2.0
local minSpeed = 0.5
local maxSpeed = 50.0
local connection

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
TopBar.Size = UDim2.new(1, 0, 0, 35)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Text = "Sxingz 飞行"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Text = "×"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Position = UDim2.new(0.85, 0, 0.15, 0)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(1, 0)
CloseBtnCorner.Parent = CloseBtn

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleBtn.Text = "开启飞行"
ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.TextSize = 14

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn

local SliderFrame = Instance.new("Frame")
SliderFrame.Parent = MainFrame
SliderFrame.BackgroundTransparency = 1
SliderFrame.Position = UDim2.new(0.1, 0, 0.65, 0)
SliderFrame.Size = UDim2.new(0.8, 0, 0, 40)

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Parent = SliderFrame
SliderLabel.Text = "飞行速度: 2.0"
SliderLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SliderLabel.Size = UDim2.new(1, 0, 0, 15)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextSize = 12

local SliderBack = Instance.new("Frame")
SliderBack.Parent = SliderFrame
SliderBack.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
SliderBack.Position = UDim2.new(0, 0, 0.7, 0)
SliderBack.Size = UDim2.new(1, 0, 0, 6)
SliderBack.Active = true

local SliderBackCorner = Instance.new("UICorner")
SliderBackCorner.CornerRadius = UDim.new(1, 0)
SliderBackCorner.Parent = SliderBack

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderBack
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SliderFill.Size = UDim2.new(0.2, 0, 1, 0) 
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)


CloseBtn.MouseButton1Click:Connect(function()
    flying = false
    if connection then connection:Disconnect() end
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.PlatformStand = false
    end
    ScreenGui:Destroy()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 170, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        ToggleBtn.Text = "飞行中..."
    else
        TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(55, 55, 60), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        ToggleBtn.Text = "开启飞行"
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.PlatformStand = false
        end
    end
end)

local dragging = false
local function updateSlider(input)
    local percentage = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    speed = minSpeed + (percentage * (maxSpeed - minSpeed))
    SliderLabel.Text = string.format("飞行速度: %.1f", speed)
end

SliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = true 
        updateSlider(input) 
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
        updateSlider(input) 
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end
end)

connection = RunService.Heartbeat:Connect(function()
    if flying and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = plr.Character.HumanoidRootPart
        local hum = plr.Character.Humanoid
        local camera = workspace.CurrentCamera
        
        hum.PlatformStand = true
        local moveDir = hum.MoveDirection
        local lookVec = camera.CFrame.LookVector
        
        local targetPosition = hrp.Position + (lookVec * (moveDir.Magnitude > 0 and speed/2 or 0))
        hrp.CFrame = CFrame.new(targetPosition, targetPosition + lookVec)
        hrp.Velocity = Vector3.new(0, 0.1, 0)
    end
end)