local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local PlayerScripts = game.Players.LocalPlayer:WaitForChild("PlayerScripts")
local ControlModule = require(PlayerScripts:WaitForChild("PlayerModule")):GetControls()

if CoreGui:FindFirstChild("Sxingz Fly") then
    CoreGui:FindFirstChild("Sxingz Fly"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sxingz Fly"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local plr = game.Players.LocalPlayer
local flying = false
local speed = 2.0
local minSpeed = 0.5
local maxSpeed = 50.0


local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true 

local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Parent = MainFrame
BackgroundImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Image = "rbxassetid://77044761659704"
BackgroundImage.ImageTransparency = 0
BackgroundImage.ZIndex = 1

local ImageCorner = Instance.new("UICorner")
ImageCorner.CornerRadius = UDim.new(0, 12)
ImageCorner.Parent = BackgroundImage

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.LineJoinMode = Enum.LineJoinMode.Round

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TopBar.BackgroundTransparency = 0.2
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
Title.TextSize = 13
Title.ZIndex = 2

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Text = "×"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Position = UDim2.new(0.85, 0, 0.15, 0)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.ZIndex = 2

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(1, 0)
CloseBtnCorner.Parent = CloseBtn

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleBtn.Text = "开启飞行"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.TextSize = 14
ToggleBtn.ZIndex = 2

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn

local SliderFrame = Instance.new("Frame")
SliderFrame.Parent = MainFrame
SliderFrame.BackgroundTransparency = 1
SliderFrame.Position = UDim2.new(0.1, 0, 0.65, 0)
SliderFrame.Size = UDim2.new(0.8, 0, 0, 40)
SliderFrame.ZIndex = 2

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Parent = SliderFrame
SliderLabel.Text = "飞行速度: 2.0"
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.Size = UDim2.new(1, 0, 0, 15)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextSize = 12

local SliderBack = Instance.new("Frame")
SliderBack.Parent = SliderFrame
SliderBack.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
SliderBack.Position = UDim2.new(0, 0, 0.7, 0)
SliderBack.Size = UDim2.new(1, 0, 0, 6)

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderBack
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SliderFill.Size = UDim2.new(0.2, 0, 1, 0) 
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)


CloseBtn.MouseButton1Click:Connect(function()
    flying = false
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.PlatformStand = false
    end
    ScreenGui:Destroy()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 170, 255), BackgroundTransparency = 0.1}):Play()
        ToggleBtn.Text = "飞行中..."
    else
        TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 50), BackgroundTransparency = 0.3}):Play()
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


RunService.Heartbeat:Connect(function()
    local hue = (tick() * 0.4) % 1
    local rainbowColor = Color3.fromHSV(hue, 0.7, 1)
    UIStroke.Color = rainbowColor
    
    if flying and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = plr.Character.HumanoidRootPart
        local hum = plr.Character.Humanoid
        local camera = workspace.CurrentCamera
        
        hum.PlatformStand = true
        
        local moveVector = ControlModule:GetMoveVector()
        
        local direction = camera.CFrame:VectorToWorldSpace(moveVector)
        
        local velocity = direction * speed
        local targetPosition = hrp.Position + velocity
        
        hrp.CFrame = CFrame.new(targetPosition, targetPosition + camera.CFrame.LookVector)
        
        hrp.Velocity = Vector3.new(0, 0.1, 0)
    end
end)