local WindUI = loadstring(game:HttpGet("https://github.com/wsomoqaz/CX/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "困梦",
    Icon = "door-open",
    Author = "",
    Folder = "MyTestHub",
})

local Tab = Window:Tab({
    Title = "玩家",
    Icon = "user",
    Locked = false,
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local speedValue = 16 

local Input = Tab:Input({
    Title = "移动速度",
    Desc = "输入一个数字修改速度",
    Value = tostring(speedValue),
    InputIcon = "zap",
    Type = "Input",
    Placeholder = "例如: 50",
    Callback = function(input)
        local number = tonumber(input) 
        if number then
            speedValue = number
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
            end
            print("玩家速度已设置为: " .. speedValue)
        else
            warn("请输入有效的数字！")
        end
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local headSize = 2 -- 默认大小

local Input = Tab:Input({
    Title = "所有玩家头部大小",
    Desc = "输入一个数字修改除自己外的玩家头部大小",
    Value = tostring(headSize),
    InputIcon = "user",
    Type = "Input",
    Placeholder = "例如: 5",
    Callback = function(input)
        local number = tonumber(input)
        if number then
            headSize = number
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    -- 修改头部大小
                    player.Character.Head.Size = Vector3.new(headSize, headSize, headSize)
                    
                    -- 如果想更稳定，可以尝试修改 HumanoidDescription（可选）
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid:FindFirstChild("HumanoidDescription") then
                        humanoid.HumanoidDescription.HeadScale = headSize / 2
                    end
                end
            end
            print("除自己外的玩家头部大小已设置为: " .. headSize)
        else
            warn("请输入有效的数字！")
        end
    end
})

local Button = Tab:Button({
    Title = "飞行",
    Desc = "点击这里",
    Locked = false,
    Callback = function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "脚本已开启";
                Text ="飞行";
                Duration = 2.5;
            })
-- Gui to Lua
-- Version: 3.2

-- Instances:

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")

--Properties:

main.Name = "main"
main.Parent = game.CoreGui
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "卡卡飞行"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

Frame.Active = true -- main = gui
Frame.Draggable = true

onof.MouseButton1Down:connect(function()

	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true



		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end




	
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.LowerTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false



	





end)


up.MouseButton1Down:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,2,0)
	
end)


down.MouseButton1Down:connect(function()

	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-2,0)

end)


game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false

end)


plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then
		

	tpwalking = false
	for i = 1, speeds do
		spawn(function()

			local hb = game:GetService("RunService").Heartbeat	


			tpwalking = true
			local chr = game.Players.LocalPlayer.Character
			local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
			while tpwalking and hb:Wait() and chr and hum and hum.Parent do
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(hum.MoveDirection)
				end
			end

		end)
		end
		end
end)
mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'can not be less than 1'
		wait(1)
		speed.Text = speeds
	else
	speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
	tpwalking = false
	for i = 1, speeds do
		spawn(function()

			local hb = game:GetService("RunService").Heartbeat	


			tpwalking = true
			local chr = game.Players.LocalPlayer.Character
			local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
			while tpwalking and hb:Wait() and chr and hum and hum.Parent do
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(hum.MoveDirection)
				end
			end

		end)
		end
		end
		end
end)
        print("clicked")
    end
})

local Button = Tab:Button({
    Title = "坐标",
    Desc = "点击这里",
    Locked = false,
    Callback = function()
    local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 创建一个屏幕 UI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- 创建一个文本标签用于显示坐标
local positionLabel = Instance.new("TextLabel")
positionLabel.Size = UDim2.new(0, 200, 0, 50)
positionLabel.Position = UDim2.new(0, 10, 0, 10)
positionLabel.BackgroundTransparency = 0.5
positionLabel.TextScaled = true
positionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
positionLabel.Parent = screenGui

-- 更新位置的函数
local function updatePosition()
    while true do
        -- 获取当前坐标
        local position = humanoidRootPart.Position
        -- 设置显示的文本
        positionLabel.Text = string.format("X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z)
        -- 等待 0.1 秒再更新
        wait(0.1)
    end
end

-- 运行更新函数
spawn(updatePosition)
        print("clicked")
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local noclipConnection -- 保存循环

local Toggle = Tab:Toggle({
    Title = "穿墙",
    Desc = "开启后可以穿过物体",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        if state then
            print("穿墙开启")
            -- 每一帧把角色设置为无碰撞
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            print("穿墙关闭")
            -- 断开循环，还原碰撞
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local infJumpConnection

local Toggle = Tab:Toggle({
    Title = "无限跳跃",
    Desc = "允许你在空中反复跳跃",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            print("无限跳跃开启")
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            print("无限跳跃关闭")
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end
})

local Lighting = game:GetService("Lighting")

local oldBrightness = Lighting.Brightness
local oldAmbient = Lighting.Ambient
local oldOutdoorAmbient = Lighting.OutdoorAmbient

local Toggle = Tab:Toggle({
    Title = "夜视",
    Desc = "让环境变亮，黑夜如白天",
    Icon = "sun", -- 可以换成你喜欢的图标
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            print("夜视开启")
            -- 保存原始参数
            oldBrightness = Lighting.Brightness
            oldAmbient = Lighting.Ambient
            oldOutdoorAmbient = Lighting.OutdoorAmbient

            -- 设置夜视效果
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            print("夜视关闭")
            -- 还原原始效果
            Lighting.Brightness = oldBrightness
            Lighting.Ambient = oldAmbient
            Lighting.OutdoorAmbient = oldOutdoorAmbient
        end
    end
})

local Lighting = game:GetService("Lighting")

-- 保存原始参数
local oldConfig = {
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Technology = Lighting.Technology
}

local Toggle = Tab:Toggle({
    Title = "优化画质",
    Desc = "提升画质，地图更清晰",
    Icon = "monitor", -- 可以换其他图标
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            print("画质优化开启")
            -- 调整画质
            Lighting.Brightness = 2.5
            Lighting.FogEnd = 100000 -- 去掉雾
            Lighting.GlobalShadows = true -- 开启全局阴影
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            pcall(function()
                Lighting.Technology = Enum.Technology.Future -- 高质量渲染
            end)
        else
            print("画质优化关闭")
            -- 还原默认参数
            Lighting.Brightness = oldConfig.Brightness
            Lighting.FogEnd = oldConfig.FogEnd
            Lighting.GlobalShadows = oldConfig.GlobalShadows
            Lighting.Technology = oldConfig.Technology
        end
    end
})

local Lighting = game:GetService("Lighting")

-- 保存原始配置
local oldConfig = {
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Technology = Lighting.Technology
}

local effects = {}

local Toggle = Tab:Toggle({
    Title = "光污染",
    Desc = "变亮一些",
    Icon = "monitor-up", 
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            print("极清画质开启")
            -- Lighting 调整
            Lighting.Brightness = 3
            Lighting.FogEnd = 100000
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            pcall(function() Lighting.Technology = Enum.Technology.Future end)

            -- Bloom 光晕
            local bloom = Instance.new("BloomEffect", Lighting)
            bloom.Intensity = 0.5
            bloom.Size = 24
            bloom.Threshold = 0.8
            table.insert(effects, bloom)

            -- 色彩增强
            local cc = Instance.new("ColorCorrectionEffect", Lighting)
            cc.Contrast = 0.1
            cc.Saturation = 0.2
            cc.Brightness = 0.05
            table.insert(effects, cc)

            -- 阳光射线
            local sunrays = Instance.new("SunRaysEffect", Lighting)
            sunrays.Intensity = 0.1
            sunrays.Spread = 0.8
            table.insert(effects, sunrays)

            -- 大气环境
            local atmo = Instance.new("Atmosphere", Lighting)
            atmo.Density = 0.3
            atmo.Offset = 0.25
            atmo.Color = Color3.fromRGB(200, 200, 200)
            atmo.Decay = Color3.fromRGB(100, 100, 100)
            table.insert(effects, atmo)

        else
            print("极清画质关闭")
            -- 还原 Lighting
            Lighting.Brightness = oldConfig.Brightness
            Lighting.FogEnd = oldConfig.FogEnd
            Lighting.Ambient = oldConfig.Ambient
            Lighting.OutdoorAmbient = oldConfig.OutdoorAmbient
            Lighting.Technology = oldConfig.Technology

            -- 清除特效
            for _, eff in pairs(effects) do
                if eff and eff.Parent then
                    eff:Destroy()
                end
            end
            effects = {}
        end
    end
})

local Lighting = game:GetService("Lighting")

-- 保存原始 Sky
local oldSky = Lighting:FindFirstChildOfClass("Sky")

-- 星空 Sky（黑夜用）
local function createNightSky()
    local nightSky = Instance.new("Sky")
    nightSky.SkyboxBk = "http://www.roblox.com/asset/?id=151163749"
    nightSky.SkyboxDn = "http://www.roblox.com/asset/?id=151163749"
    nightSky.SkyboxFt = "http://www.roblox.com/asset/?id=151163749"
    nightSky.SkyboxLf = "http://www.roblox.com/asset/?id=151163749"
    nightSky.SkyboxRt = "http://www.roblox.com/asset/?id=151163749"
    nightSky.SkyboxUp = "http://www.roblox.com/asset/?id=151163749"
    return nightSky
end

local currentSky -- 当前的夜空 Sky

local Dropdown = Tab:Dropdown({
    Title = "天空模式选择",
    Values = { "白天", "日出", "日落", "黄昏", "傍晚", "黑夜" },
    Value = "白天",
    Callback = function(option) 
        print("选择的模式: " .. option)

        -- 清理夜晚 Sky
        if currentSky then
            currentSky:Destroy()
            currentSky = nil
        end
        if oldSky and not oldSky.Parent then
            oldSky.Parent = Lighting
        end

        if option == "白天" then
            Lighting.ClockTime = 14 -- 下午 2 点
        elseif option == "日出" then
            Lighting.ClockTime = 6 -- 早上 6 点
        elseif option == "日落" then
            Lighting.ClockTime = 17 -- 下午 5 点
        elseif option == "黄昏" then
            Lighting.ClockTime = 19 -- 晚上 7 点
        elseif option == "傍晚" then
            Lighting.ClockTime = 18 -- 傍晚 6 点
        elseif option == "黑夜" then
            Lighting.ClockTime = 0 -- 午夜
            if oldSky then oldSky.Parent = nil end
            currentSky = createNightSky()
            currentSky.Parent = Lighting
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- 用于存储ESP
local ESPs = {}

-- ESP开关状态
local ESPEnabled = false

-- 创建ESP函数
local function createESP(targetPlayer)
    if ESPs[targetPlayer] then return end

    local character = targetPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_GUI"
    billboard.Adornee = character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = game:GetService("CoreGui")

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = billboard

    ESPs[targetPlayer] = {Billboard = billboard, Label = label}
end

-- 删除ESP函数
local function removeESP(targetPlayer)
    if ESPs[targetPlayer] then
        ESPs[targetPlayer].Billboard:Destroy()
        ESPs[targetPlayer] = nil
    end
end

-- 更新ESP显示
local function updateESP()
    if not ESPEnabled then return end -- 开关关闭时不更新ESP
    for player, data in pairs(ESPs) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            data.Label.Text = player.Name .. "\n" .. string.format("%.1f 米", distance)
        else
            removeESP(player)
        end
    end
end

-- 为现有玩家创建ESP
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

-- 玩家加入/离开事件
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            createESP(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- 每帧更新ESP
RunService.RenderStepped:Connect(updateESP)

-- ====== GUI Toggle 控件 ======
local Toggle = Tab:Toggle({
    Title = "玩家ESP",
    Desc = "显示玩家名字与距离",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        ESPEnabled = state -- 根据Toggle状态开启/关闭ESP
        print("玩家ESP状态：" .. tostring(state))

        if not state then
            -- 如果关闭ESP，清空所有已创建的ESP
            for player, _ in pairs(ESPs) do
                removeESP(player)
            end
        else
            -- 如果开启ESP，为所有玩家重新创建ESP
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        end
    end
})

local Button = Tab:Button({
    Title = "防甩飞",
    Desc = "防止甩飞",
    Locked = false,
    Callback = function()
    -- 防甩飞 LocalScript
-- 放在 StarterPlayerScripts 下

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local MAX_SPEED = 50 -- 最大水平速度阈值，可根据游戏调节
local CHECK_INTERVAL = 0.1 -- 检查频率（秒）

-- 等待角色加载
local function onCharacterAdded(character)
    local root = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    -- 定期清理施加在角色上的外力
    RunService.Stepped:Connect(function()
        -- 移除可能施加的外力
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyForce") or v:IsA("VectorForce") or v:IsA("BodyThrust") then
                v:Destroy()
            end
        end
    end)

    -- 防甩飞核心：限制水平速度
    while character.Parent do
        local velocity = root.Velocity
        local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude

        if horizontalSpeed > MAX_SPEED then
            -- 保留Y方向（跳跃/重力），水平速度归零
            root.Velocity = Vector3.new(0, velocity.Y, 0)
        end
        wait(CHECK_INTERVAL)
    end
end

-- 角色第一次加载
if player.Character then
    onCharacterAdded(player.Character)
end

-- 监听角色重生
player.CharacterAdded:Connect(onCharacterAdded)
        print("clicked")
    end
})


local Tab = Window:Tab({
    Title = "aimbot/自瞄",
    Icon = "bird",
    Locked = false,
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- 状态变量
local AimbotEnabled = false
local TeamCheckEnabled = false

-- ESP存储
local ESPs = {}

-- 创建ESP函数
local function createESP(targetPlayer)
    if ESPs[targetPlayer] then return end
    local character = targetPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_GUI"
    billboard.Adornee = character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = game:GetService("CoreGui")

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = billboard

    ESPs[targetPlayer] = {Billboard = billboard, Label = label}
end

-- 删除ESP函数
local function removeESP(targetPlayer)
    if ESPs[targetPlayer] then
        ESPs[targetPlayer].Billboard:Destroy()
        ESPs[targetPlayer] = nil
    end
end

-- 强制锁定逻辑
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then
        -- 关闭Aimbot时清空ESP
        for player, _ in pairs(ESPs) do
            removeESP(player)
        end
        return
    end

    local closestPlayer
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if TeamCheckEnabled and player.Team == LocalPlayer.Team then
                continue
            end

            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude

            -- 更新或创建ESP
            createESP(player)
            ESPs[player].Label.Text = player.Name .. "\n" .. string.format("%.1f 米", distance)

            -- 锁敌：选择最近的玩家
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    -- 强制锁定
    if closestPlayer then
        -- 设置摄像头CFrame直接看向目标
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local targetPos = closestPlayer.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(root.Position, targetPos)
        end
    end
end)

-- 玩家加入/离开事件
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if AimbotEnabled then
            createESP(player)
        end
    end)
end)
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- ====== GUI 按钮 ======
local AimbotToggle = Tab:Toggle({
    Title = "强制Aimbot",
    Desc = "始终锁定最近敌人并显示ESP",
    Icon = "crosshair",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        AimbotEnabled = state
        if not state then
            for player, _ in pairs(ESPs) do
                removeESP(player)
            end
        end
        print("强制Aimbot状态：" .. tostring(state))
    end
})

local TeamToggle = Tab:Toggle({
    Title = "阵容判断",
    Desc = "避免锁友方",
    Icon = "shield",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        TeamCheckEnabled = state
        print("阵容判断状态：" .. tostring(state))
    end
})

local Button = Tab:Button({
    Title = "自瞄2",
    Desc = "建议使用这一个windui作者不怎么会做自瞄",
    Locked = false,
    Callback = function()
    local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- 创建ScreenGui
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "SciFiGui"

-- 主框架 (带发光边框)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 320)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- 发光边框
local GlowFrame = Instance.new("ImageLabel", MainFrame)
GlowFrame.Size = UDim2.new(1, 20, 1, 20)
GlowFrame.Position = UDim2.new(0, -10, 0, -10)
GlowFrame.BackgroundTransparency = 1
GlowFrame.Image = "rbxassetid://3521144369"
GlowFrame.ImageColor3 = Color3.fromRGB(0, 170, 255)
GlowFrame.ScaleType = Enum.ScaleType.Slice
GlowFrame.SliceCenter = Rect.new(10, 10, 118, 118)
GlowFrame.ZIndex = 0

-- 标题阴影
local TitleShadow = Instance.new("TextLabel", MainFrame)
TitleShadow.Size = UDim2.new(1, 0, 0, 30)
TitleShadow.Position = UDim2.new(0, 2, 0, 2)
TitleShadow.BackgroundTransparency = 1
TitleShadow.Text = "aimbot"
TitleShadow.TextColor3 = Color3.fromRGB(0, 255, 255)
TitleShadow.Font = Enum.Font.GothamBold
TitleShadow.TextScaled = true
TitleShadow.ZIndex = 2
TitleShadow.TextTransparency = 0.7

-- 主标题
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "aimbot"
Title.TextColor3 = Color3.fromRGB(0, 230, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.ZIndex = 3

-- 关闭按钮
local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 36, 0, 36)
CloseButton.Position = UDim2.new(1, -42, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextScaled = true
CloseButton.AutoButtonColor = false
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)
CloseButton.ZIndex = 4

-- 关闭按钮悬浮效果
CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
end)
CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

-- 内容容器
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.BackgroundTransparency = 1

-- 创建科幻风按钮函数
local function createSciFiButton(parent, text, posY)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -30, 0, 40)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(0, 100, 160)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = text
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 160)
    end)

    return btn
end

-- 按钮和输入框
local ToggleFov = createSciFiButton(ContentFrame, "FOV 环：关闭", 0)
local ToggleAimbot = createSciFiButton(ContentFrame, "Aimbot：关闭", 50)
local ToggleTeamCheck = createSciFiButton(ContentFrame, "阵容判断：开启", 100)

local InputBox = Instance.new("TextBox", ContentFrame)
InputBox.Size = UDim2.new(1, -30, 0, 40)
InputBox.Position = UDim2.new(0, 15, 0, 150)
InputBox.PlaceholderText = "输入 FOV 半径，例如 100"
InputBox.BackgroundColor3 = Color3.fromRGB(15, 25, 50)
InputBox.TextColor3 = Color3.fromRGB(0, 255, 255)
InputBox.Font = Enum.Font.GothamSemibold
InputBox.TextScaled = true
InputBox.Text = ""
InputBox.ZIndex = 5
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 12)
InputBox.TextStrokeTransparency = 0.7

-- 圆形悬浮按钮
local FloatingButton = Instance.new("ImageButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 50, 0, 50)
FloatingButton.Position = UDim2.new(0, 20, 0, 200)
FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
FloatingButton.Visible = false
FloatingButton.Image = ""
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(1, 0)
FloatingButton.ZIndex = 10

-- 悬浮按钮拖动变量
local fbDragging = false
local fbDragStart
local fbStartPos

local function updateFloatingButtonDrag(input)
    local delta = input.Position - fbDragStart
    local newX = math.clamp(fbStartPos.X.Offset + delta.X, 0, camera.ViewportSize.X - FloatingButton.AbsoluteSize.X)
    local newY = math.clamp(fbStartPos.Y.Offset + delta.Y, 0, camera.ViewportSize.Y - FloatingButton.AbsoluteSize.Y)
    FloatingButton.Position = UDim2.new(0, newX, 0, newY)
end

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        fbDragging = true
        fbDragStart = input.Position
        fbStartPos = FloatingButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                fbDragging = false
            end
        end)
    end
end)

FloatingButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and fbDragging then
        updateFloatingButtonDrag(input)
    end
end)

FloatingButton.MouseEnter:Connect(function()
    FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
end)
FloatingButton.MouseLeave:Connect(function()
    FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingButton.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingButton.Visible = true
end)

-- 自定义标题栏拖动（只绑定在标题Title）
local dragging = false
local dragStartPos = nil
local frameStartPos = nil

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = input.Position
        frameStartPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartPos
        MainFrame.Position = UDim2.new(
            frameStartPos.X.Scale,
            frameStartPos.X.Offset + delta.X,
            frameStartPos.Y.Scale,
            frameStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Drawing库绘制FOV圆
local FovCircle = Drawing.new("Circle")
FovCircle.Visible = false
FovCircle.Color = Color3.fromRGB(0, 170, 255)
FovCircle.Thickness = 2
FovCircle.NumSides = 100
FovCircle.Filled = false
FovCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
FovCircle.Radius = 100

-- Drawing名字和距离显示
local NameLabel = Drawing.new("Text")
NameLabel.Visible = false
NameLabel.Color = Color3.fromRGB(0, 255, 255)
NameLabel.Size = 18
NameLabel.Center = true
NameLabel.Outline = true
NameLabel.OutlineColor = Color3.new(0, 0, 0)

local DistanceLabel = Drawing.new("Text")
DistanceLabel.Visible = false
DistanceLabel.Color = Color3.fromRGB(0, 255, 255)
DistanceLabel.Size = 14
DistanceLabel.Center = true
DistanceLabel.Outline = true
DistanceLabel.OutlineColor = Color3.new(0, 0, 0)

-- 控制变量
local fovEnabled = false
local aimbotEnabled = false
local teamCheckEnabled = true

ToggleFov.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled
    FovCircle.Visible = fovEnabled
    ToggleFov.Text = fovEnabled and "FOV 环：关闭" or "FOV 环：开启"
end)

ToggleAimbot.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    ToggleAimbot.Text = aimbotEnabled and "Aimbot：关闭" or "Aimbot：开启"
end)

ToggleTeamCheck.MouseButton1Click:Connect(function()
    teamCheckEnabled = not teamCheckEnabled
    if teamCheckEnabled then
        ToggleTeamCheck.Text = "阵容判断：开启"
        ToggleTeamCheck.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
    else
        ToggleTeamCheck.Text = "阵容判断：关闭"
        ToggleTeamCheck.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    end
end)

InputBox.FocusLost:Connect(function(enter)
    if enter then
        local radius = tonumber(InputBox.Text)
        if radius and radius > 0 then
            FovCircle.Radius = radius
        else
            InputBox.Text = ""
            warn("请输入合法数字")
        end
    end
end)

-- Aimbot主逻辑
RunService.RenderStepped:Connect(function()
    if not (fovEnabled and aimbotEnabled) then
        NameLabel.Visible = false
        DistanceLabel.Visible = false
        return
    end

    local closestTarget = nil
    local shortestDistToScreenCenter = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("Head") then
            if not teamCheckEnabled or target.Team ~= player.Team then
                local headPos, onScreen = camera:WorldToViewportPoint(target.Character.Head.Position)
                if onScreen then
                    local screenPoint = Vector2.new(headPos.X, headPos.Y)
                    local distFromFovCenter = (screenPoint - FovCircle.Position).Magnitude

                    if distFromFovCenter <= FovCircle.Radius then
                        local distToCenter = (screenPoint - screenCenter).Magnitude
                        if distToCenter < shortestDistToScreenCenter then
                            shortestDistToScreenCenter = distToCenter
                            closestTarget = target
                        end
                    end
                end
            end
        end
    end

    if closestTarget and closestTarget.Character and closestTarget.Character:FindFirstChild("Head") then
        local headPos3 = closestTarget.Character.Head.Position
        camera.CFrame = CFrame.new(camera.CFrame.Position, headPos3)

        local screenPos, onScreen = camera:WorldToViewportPoint(headPos3)
        if onScreen then
            NameLabel.Visible = true
            DistanceLabel.Visible = true
            NameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 25)
            DistanceLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 5)
            NameLabel.Text = closestTarget.Name
            local dist = math.floor((player.Character.Head.Position - headPos3).Magnitude)
            DistanceLabel.Text = tostring(dist) .. " studs"
        else
            NameLabel.Visible = false
            DistanceLabel.Visible = false
        end
    else
        NameLabel.Visible = false
        DistanceLabel.Visible = false
    end
end)
        print("clicked")
    end
})

local Tab = Window:Tab({
    Title = "脚本",
    Icon = "user",
    Locked = false,
})

local Button = Tab:Button({
    Title = "99夜",
    Desc = "卡卡脚本",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wsomoQaz/rOblox/main/.github/99"))()
        print("clicked")
    end
})