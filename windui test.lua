-- 创建加载界面
local LoadingUI = Instance.new("ScreenGui")
LoadingUI.Name = "ZScriptLoadingUI"
LoadingUI.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 200)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = LoadingUI

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Z脚本 正在加载..."
Title.Size = UDim2.new(0.8, 0, 0, 40)
Title.Position = UDim2.new(0.1, 0, 0.1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local Author = Instance.new("TextLabel")
Author.Text = "作者: Z某人"
Author.Size = UDim2.new(0.8, 0, 0, 20)
Author.Position = UDim2.new(0.1, 0, 0.3, 0)
Author.BackgroundTransparency = 1
Author.TextColor3 = Color3.fromRGB(200, 200, 200)
Author.Font = Enum.Font.Gotham
Author.TextSize = 14
Author.TextXAlignment = Enum.TextXAlignment.Left
Author.Parent = MainFrame

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0.8, 0, 0, 10)
ProgressBar.Position = UDim2.new(0.1, 0, 0.6, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = MainFrame

local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(1, 0)
ProgressBarCorner.Parent = ProgressBar

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBar

local ProgressFillCorner = Instance.new("UICorner")
ProgressFillCorner.CornerRadius = UDim.new(1, 0)
ProgressFillCorner.Parent = ProgressFill

local StatusText = Instance.new("TextLabel")
StatusText.Text = "初始化中..."
StatusText.Size = UDim2.new(0.8, 0, 0, 20)
StatusText.Position = UDim2.new(0.1, 0, 0.7, 0)
StatusText.BackgroundTransparency = 1
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 14
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = MainFrame

-- 动画效果
spawn(function()
    local tweenService = game:GetService("TweenService")
    
    -- 进度条动画
    local progressTween = tweenService:Create(
        ProgressFill,
        TweenInfo.new(2, Enum.EasingStyle.Linear),
        {Size = UDim2.new(1, 0, 1, 0)}
    )
    
    -- 背景闪烁动画
    local bgTween = tweenService:Create(
        MainFrame,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}
    )
    
    progressTween:Play()
    bgTween:Play()
    
    -- 更新状态文本
    local statusMessages = {
        "加载反挂机系统...",
        "初始化用户界面...",
        "准备功能模块...",
        "加载音效资源...",
        "验证脚本完整性...",
        "准备就绪..."
    }
    
    for i, message in ipairs(statusMessages) do
        StatusText.Text = message
        wait(0.3)
    end
    
    -- 完成加载后淡出
    local fadeOut = tweenService:Create(
        MainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 1}
    )
    
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        LoadingUI:Destroy()
    end)
end)

-- 在这里放置您的原始脚本内容
-- 当加载界面消失后，原始脚本会继续执行

print("反挂机开启")
		local vu = game:GetService("VirtualUser")
		game:GetService("Players").LocalPlayer.Idled:connect(function()
		   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		   wait(1)
		   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		end)

local Sound = Instance.new("Sound")
        Sound.Parent = game.SoundService
        Sound.SoundId = "rbxassetid://4590662766"
        Sound.Volume = 3
        Sound.PlayOnRemove = true
        Sound:Destroy()

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/CNHM/asg/refs/heads/main/wind%20ui.lua"))()

local Window = WindUI:CreateWindow({
        Title = "Z脚本",
        Icon = "user-check",
        Author = "作者:Z某人",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(580, 460),
        Transparent = true,
        Theme = "Dark",
        Resizable = true,
        SideBarWidth = 200,
        Background = "",
        BackgroundImageTransparency = 0.42,
        HideSearchBar = false,
        ScrollBarEnabled = true,
        User = {
            Enabled = true,
            Anonymous = false,
            Callback = function()
                print("clicked")
            end,
        },
        KeySystem = {
            Key = { "ZMRENPBGHTCY", "5678" },
            Note = "Example Key System.",
            Thumbnail = {
                Image = "rbxassetid://",
                Title = "Z某人",
            },
            URL = "ZMRENPBGHTCY",
            SaveKey = false,
        },
    })
        
Window:EditOpenButton({
    Title = "   打开Z脚本   ",
    Icon = "shield-check",
    CornerRadiu = UDim.new(0,16),
    StrokeThickness = 3,
    Color = ColorSequence.new( 
        Color3.fromHex("000000"), 
        Color3.fromHex("FFFFFF"), 
        Color3.fromHex("000000")   
    ),
    Draggable = true,
})

local Tab = Window:Tab({
    Title = "公告",
    Icon = "app-window",
    Locked = false,
})

local Section = Tab:Section({ 
    Title = "重做脚本",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local Section = Tab:Section({ 
    Title = "QQ群11007580643",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local Section = Tab:Section({ 
    Title = "QQ群21045061775",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local Tab = Window:Tab({
    Title = "通用",
    Icon = "bolt",
    Locked = false,
})

local Slider = Tab:Slider({
    Title = "移动速度",
    
    Step = 1,
    
    Value = {
        Min = 0,
        Max = 320,
        Default = 16,
    },
    Callback = function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

local Slider = Tab:Slider({
    Title = "跳跃高度",
    
    Step = 1,
    
    Value = {
        Min = 50,
        Max = 1000,
        Default = 50,
    },
    Callback = function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

local Slider = Tab:Slider({
    Title = "重力",
    
    -- To make float number supported, 
    -- make the Step a float number.
    -- example: Step = 0.1
    Step = 1,
    
    Value = {
        Min = 0,
        Max = 1000,
        Default = 196,
    },
    Callback = function(value)
    game.Workspace.Gravity = value
    end
})

local Button = Tab:Button({
    Title = "爬墙",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Wall-Walk-9153"))()
    end
})

local Button = Tab:Button({
    Title = "无限跳",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))()
    end
})

local Button = Tab:Button({
    Title = "选人甩飞",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Auto%20Fling%20Player'))()
    end
})

local Button = Tab:Button({
    Title = "飞行V3",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CNHM/asg/refs/heads/main/fly.lua"))()
    end
})

local Button = Tab:Button({
    Title = "穿墙",
    Desc = "大部分服务器通用",
    Locked = false,
    Callback = function()
    local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "NoclipGUI"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "穿墙"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextScaled = true
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0.1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "关闭"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = titleBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0.1, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
minimizeButton.Text = "收缩"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Parent = titleBar

local toggleNoclipButton = Instance.new("TextButton")
toggleNoclipButton.Size = UDim2.new(0.8, 0, 0, 40)
toggleNoclipButton.Position = UDim2.new(0.1, 0, 0.4, 0)
toggleNoclipButton.Text = "穿墙: 关闭"
toggleNoclipButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleNoclipButton.TextColor3 = Color3.new(1, 1, 1)
toggleNoclipButton.Parent = frame

local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, 0, 0, 20)
creditLabel.Position = UDim2.new(0, 0, 0.85, 0)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = ""
creditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
creditLabel.TextScaled = true
creditLabel.Font = Enum.Font.SourceSansBold
creditLabel.Parent = frame

-- Noclip Functionality
local noclip = false
local function toggleNoclip()
    noclip = not noclip
    toggleNoclipButton.Text = noclip and "穿墙: 开启" or "穿墙: 关闭"
    toggleNoclipButton.BackgroundColor3 = noclip and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)

    while noclip do
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
        task.wait()
    end
end

toggleNoclipButton.MouseButton1Click:Connect(toggleNoclip)

-- Minimize GUI Function
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, obj in pairs(frame:GetChildren()) do
        if obj ~= titleBar and obj ~= creditLabel then
            obj.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 150)
    minimizeButton.Text = minimized and "展开" or "收缩"
end)

-- Close GUI Function
closeButton.MouseButton1Click:Connect(function()
    noclip = false
    screenGui:Destroy()
end)

print("穿墙UI加载成功！")
    end
})

local Button = Tab:Button({
    Title = "快速互动",
    Desc = "",
    Locked = false,
    Callback = function()
    game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(v)
    v.HoldDuration = 0
end)
    end
})

local Button = Tab:Button({
    Title = "电脑键盘",
    Desc = "高级版",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Xxtan31/Ata/main/deltakeyboardcrack.txt", true))()
    end
})

local Button = Tab:Button({
    Title = "透视",
    Desc = "Z某制作",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ZIONPCE/raw/refs/heads/main/ESP.lua"))()
    end
})

local Button = Tab:Button({
    Title = "导",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/FWwdST5Y"))()
    end
})

local Tab = Window:Tab({
    Title = "99天",
    Icon = "trees",
    Locked = false,
})

local Button = Tab:Button({
    Title = "VEX",
    Desc = "Z某汉化",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ZIONPCE/JB/refs/heads/main/99%20nights%20in%20the%20forest.lua"))()
    end
})

local Tab = Window:Tab({
    Title = "建造一架飞机",
    Icon = "plane",
    Locked = false,
})

local Button = Tab:Button({
    Title = "自动飞行",
    Desc = "上升下降等",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ZIONPCE/JB/refs/heads/main/fait.lua"))()
    end
})

local Button = Tab:Button({
    Title = "NEPT",
    Desc = "Z某汉化",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ZIONPCE/JB/refs/heads/main/b.lua"))()
    end
})

local Tab = Window:Tab({
    Title = "死铁轨",
    Icon = "train-track",
    Locked = false,
})

local Button = Tab:Button({
    Title = "The Darkones",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/refs/heads/main/Dead%20Rails%20GUI'))()
    end
})

local Button = Tab:Button({
    Title = "SpeedHubX",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end
})

local Button = Tab:Button({
    Title = "攻速",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/HeadHarse/DeadRails/refs/heads/main/V4SWING"))()
    end
})

local Button = Tab:Button({
    Title = "NovazHub",
    Desc = "Z某汉化",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ZIONPCE/JB/refs/heads/main/autofarmbond.lua"))()
    end
})

local Tab = Window:Tab({
    Title = "被遗弃",
    Icon = "drama",
    Locked = false,
})

local Button = Tab:Button({
    Title = "Sigmasaken V9",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/sigmaboy-sigma-boy/sigmaboy-sigma-boy/refs/heads/main/StaminaSettings.ESP.PIDC.raw'))()
    end
})

local Button = Tab:Button({
    Title = "XA",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet(('https://github.com/DevSloPo/Main/raw/main/Forsaken')))()
    end
})

local Button = Tab:Button({
    Title = "Httadmin",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet"https://raw.githubusercontent.com/OWOWOWWOW/HTT/main/HT.lua")()
    end
})

local Tab = Window:Tab({
    Title = "DOORS",
    Icon = "door-open",
    Locked = false,
})

local Button = Tab:Button({
    Title = "MS",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://www.msdoors.xyz/script"))()
    end
})

local Button = Tab:Button({
    Title = "暗影脉冲Alpha",
    Desc = "功能比较少",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ZIONPCE/JB/refs/heads/main/0wyaeC6y.lua"))()
    end
})

local Button = Tab:Button({
    Title = "Blackking",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KINGHUB01/BlackKing-obf/main/Doors%20Blackking%20And%20BobHub"))()
    end
})

local Tab = Window:Tab({
    Title = "自然灾害",
    Icon = "building",
    Locked = false,
})    

local Button = Tab:Button({
    Title = "假延迟",
    Desc = "",
    Locked = false,
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DROID-cell-sys/ANTI-UTTP-SCRIPTT/refs/heads/main/EGOR%20SCRIPT%20BY%20ANTI-UTTP"))()
    end
})

local Tab = Window:Tab({
    Title = "强力模拟器",
    Icon = "warehouse",
    Locked = false,
})

local Button = Tab:Button({
    Title = "自动锻炼",
    Desc = "要拿锻炼器材",
    Locked = false,
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("Common"):WaitForChild("Library"):WaitForChild("Network"):WaitForChild("RemoteFunction")

local function OptimizedSpam()
    while true do
        RemoteFunction:InvokeServer("S_Tools_Activate", {})
        task.wait(0.001)
    end
end

coroutine.wrap(OptimizedSpam)()
    end
})

local Tabs = {
    Main = Window:Section({ Title = "犯罪大亨|未完", Opened = true })
}

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "装备枪", Icon = "layout-grid", Desc = "装备枪" })
}

TabHandles.Elements:Button({
    Title = "散弹枪",
    Icon = "bell",   --图片
    Callback = function()
local args = {
	6,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "AK47",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	1,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "M16",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	9,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "QBZ",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	4,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "乌兹",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	14,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "伤害5",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	11,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "M9",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	10,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "M4",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	3,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "蜂蜜",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	2,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "狙击手",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	7,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "伤疤",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	5,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "塔克",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	8,
	1
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("FirearmService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "装备甲", Icon = "layout-grid", Desc = "装备甲" })
}

TabHandles.Elements:Button({
    Title = "+20生命值",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	3
}
game:GetService("ReplicatedStorage"):WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("VestService"):WaitForChild("RF"):WaitForChild("Equip"):InvokeServer(unpack(args))
    end
})

local Tabs = {
    Main = Window:Section({ Title = "挖出后院", Opened = true })
}

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "全部", Icon = "layout-grid", Desc = "全部" })
}

local toggleState = false
local running = false  -- 用于跟踪循环是否正在运行

local featureToggle = TabHandles.Elements:Toggle({
    Title = "自动出售",
    Desc = "60秒一次",
    Value = false,
    Callback = function(state) 
        toggleState = state
        WindUI:Notify({
            Title = "自动出售",
            Content = state and "功能已启用" or "功能已关闭",
            Icon = state and "check" or "x",
            Duration = 2
        })
        
        if state then
            -- 如果功能启用，启动循环
            if not running then
                running = true
                local args = {"SellOres"}
                local delay = 60 -- 每60秒执行一次（可根据需要调整）
                
                -- 使用coroutine来运行循环，这样可以不阻塞主线程
                coroutine.wrap(function()
                    while toggleState and running do
                        game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Features"):WaitForChild("MiningSystem"):WaitForChild("MineUtil"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                        wait(delay)
                    end
                    running = false
                end)()
            end
        else
            -- 如果功能关闭，设置running为false，循环会在下一次检查时停止
            running = false
        end
    end
})

TabHandles.Elements:Button({
    Title = "升级铲子",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	"BuyUpgrade",
	"Shovel"
}
game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Features"):WaitForChild("MiningSystem"):WaitForChild("UpgradeUtil"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "升级背包",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	"BuyUpgrade",
	"Backpack"
}
game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Features"):WaitForChild("MiningSystem"):WaitForChild("UpgradeUtil"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "升级能量",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	"BuyUpgrade",
	"Energy"
}
game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Features"):WaitForChild("MiningSystem"):WaitForChild("UpgradeUtil"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end
})

TabHandles.Elements:Button({
    Title = "升级喷气背包",
    Icon = "bell",   --图片
    Callback = function()
    local args = {
	"BuyUpgrade",
	"Jetpack"
}
game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Features"):WaitForChild("MiningSystem"):WaitForChild("UpgradeUtil"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end
})

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "传送", Icon = "layout-grid", Desc = "传送" })
}

TabHandles.Elements:Button({
    Title = "传送到地面",
    Icon = "bell",   --图片
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(474.3276672363281, 30.063386917114258, -656.1741333007812)
    end
})

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "透视", Icon = "layout-grid", Desc = "透视" })
}

TabHandles.Elements:Button({
    Title = "透视所有矿石",
    Icon = "bell",   --图片
    Callback = function()
    local SpawnedOres = workspace.SpawnedOres:GetChildren()

for _, ore in ipairs(SpawnedOres) do
    local hitbox = ore:FindFirstChild("Hitbox")
    
    if hitbox then
        -- 1. 添加 SelectionBox 透视
        local selectionBox = Instance.new("SelectionBox")
        selectionBox.Adornee = hitbox
        selectionBox.LineThickness = 0.05
        selectionBox.Color3 = Color3.new(1, 0, 0)  -- 红色
        selectionBox.Transparency = 0.7
        selectionBox.Parent = hitbox
        
        -- 2. 添加矿石名称标签（BillboardGui）
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = hitbox
        billboard.Size = UDim2.new(4, 0, 1.5, 0)  -- 宽度 4x，高度 1.5x
        billboard.StudsOffset = Vector3.new(0, 2, 0)  -- 在 Hitbox 上方 2 单位显示
        billboard.AlwaysOnTop = true
        billboard.LightInfluence = 0  -- 不受光照影响
        billboard.Parent = hitbox
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = ore.Name  -- 显示矿石名称（如 "岩石"、"金矿"）
        label.TextColor3 = Color3.new(1, 1, 1)  -- 白色文字
        label.TextScaled = true  -- 自动缩放文字大小
        label.BackgroundTransparency = 1  -- 透明背景
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard
    end
end

print("已为所有矿石添加透视 + 名称显示")
    end
})

local Tabs = {
    Main = Window:Section({ Title = "建造合集", Opened = true })
}

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "建造一艘火箭船", Icon = "layout-grid", Desc = "建造一艘火箭船" })
}

TabHandles.Elements:Button({
    Title = "刷钱|每次3000左右|要先启动",
    Icon = "bell",   --图片
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3342.96826171875, 112631.7578125, 8874.263671875)
    end
})

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "建造一架飞机", Icon = "layout-grid", Desc = "建造一架飞机" })
}

TabHandles.Elements:Button({
    Title = "刷钱|每次3000左右|要先启动",
    Icon = "bell",   --图片
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(110904.6953125, -114.71480560302734, -280.6292724609375)
    end
})

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "建造一辆车", Icon = "layout-grid", Desc = "建造一辆车" })
}

TabHandles.Elements:Button({
    Title = "刷钱|每次500到1000|要先启动",
    Icon = "bell",   --图片
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(196.47193908691406, -225.08038330078125, -17913.4453125)
    end
})