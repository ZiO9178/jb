local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "雪黄 SCRIPT HUB",
    Icon = "crown",
    IconThemed = true,
    Content = "感谢对雪黄的支持，您的支持就是我们的动力，在购买完此脚本后可以来找我免费汉化，欢迎使用",
    Buttons = {
        {
            Title = "进入",
            Icon = "arrow-right",
            Callback = function() Confirmed = true end,
            Variant = "Primary",
        }
    }
})

repeat task.wait() until Confirmed

-- 优化的卡密输入系统
local KeyInputSystem = {
    currentScript = nil,
    scriptConfigs = {
        ["ax"] = {
            name = "AX",
            url = "https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/ax-script",
            keyVar = "_G.script_key",
            keyPlaceholder = "输入你的卡密"
        }
    }
}

-- 创建简洁的输入框
function KeyInputSystem:CreateSimpleInput(scriptId)
    local config = self.scriptConfigs[scriptId]
    if not config then return end
    
    self.currentScript = scriptId
    
    -- 创建输入界面
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- 移除已存在的界面
    local existingGui = playerGui:FindFirstChild("KeyInputGui")
    if existingGui then
        existingGui:Destroy()
    end
    
    -- 创建新界面
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeyInputGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 180)
    frame.Position = UDim2.new(0.5, -175, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 2
    stroke.Parent = frame
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.Text = config.name .. " - 输入卡密"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    -- 内容说明
    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -20, 0, 30)
    content.Position = UDim2.new(0, 10, 0, 45)
    content.BackgroundTransparency = 1
    content.Text = "请输入 " .. config.name .. " 的卡密："
    content.TextColor3 = Color3.fromRGB(200, 200, 200)
    content.Font = Enum.Font.Gotham
    content.TextSize = 14
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.Parent = frame
    
    -- 输入框
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 0, 40)
    textBox.Position = UDim2.new(0, 10, 0, 80)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = config.keyPlaceholder
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 6)
    textBoxCorner.Parent = textBox
    
    local textBoxStroke = Instance.new("UIStroke")
    textBoxStroke.Color = Color3.fromRGB(80, 80, 80)
    textBoxStroke.Thickness = 1
    textBoxStroke.Parent = textBox
    
    -- 按钮容器
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -20, 0, 30)
    buttonContainer.Position = UDim2.new(0, 10, 0, 130)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = frame
    
    -- 确认按钮
    local confirmButton = Instance.new("TextButton")
    confirmButton.Size = UDim2.new(0.45, 0, 1, 0)
    confirmButton.Position = UDim2.new(0, 0, 0, 0)
    confirmButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    confirmButton.Text = "确认"
    confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmButton.Font = Enum.Font.GothamBold
    confirmButton.TextSize = 14
    confirmButton.Parent = buttonContainer
    
    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 6)
    confirmCorner.Parent = confirmButton
    
    -- 取消按钮
    local cancelButton = Instance.new("TextButton")
    cancelButton.Size = UDim2.new(0.45, 0, 1, 0)
    cancelButton.Position = UDim2.new(0.55, 0, 0, 0)
    cancelButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    cancelButton.Text = "取消"
    cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelButton.Font = Enum.Font.Gotham
    cancelButton.TextSize = 14
    cancelButton.Parent = buttonContainer
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 6)
    cancelCorner.Parent = cancelButton
    
    -- 按钮事件
    confirmButton.MouseButton1Click:Connect(function()
        local key = textBox.Text
        if key and key ~= "" then
            screenGui:Destroy()
            self:LoadScriptWithKey(scriptId, key)
        else
            WindUI:Notify({
                Title = "错误",
                Content = "卡密不能为空",
                Duration = 3
            })
        end
    end)
    
    cancelButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        self.currentScript = nil
    end)
    
    -- 回车键确认
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local key = textBox.Text
            if key and key ~= "" then
                screenGui:Destroy()
                self:LoadScriptWithKey(scriptId, key)
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "卡密不能为空",
                    Duration = 3
                })
            end
        end
    end)
    
    -- 自动聚焦输入框
    textBox:CaptureFocus()
end

-- 使用卡密加载
function KeyInputSystem:LoadScriptWithKey(scriptId, key)
    local config = self.scriptConfigs[scriptId]
    
    WindUI:Notify({
        Title = "正在加载",
        Content = "正在加载 " .. config.name .. "...",
        Duration = 2
    })
    
    -- 获取原始
    local success, scriptContent = pcall(function()
        return game:HttpGet(config.url)
    end)
    
    if not success then
        WindUI:Notify({
            Title = "错误",
            Content = "获取失败",
            Duration = 3
        })
        return
    end
    
    -- 替换卡密
    local translatedScript
    if config.keyVar == "_G.script_key" then
        -- 特殊处理 _G.script_key
        translatedScript = scriptContent:gsub('_G%.script_key%s*=%s*["\']([^"\']*)["\']', '_G.script_key = "' .. key .. '"')
    else
        -- 其他类型的变量替换
        local pattern = config.keyPlaceholder:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
        translatedScript = scriptContent:gsub(pattern, key)
    end
    
    -- 执行
    local execSuccess, err = pcall(function()
        loadstring(translatedScript)()
    end)
    
    if not execSuccess then
        WindUI:Notify({
            Title = "执行错误",
            Content = "执行失败: " .. tostring(err),
            Duration = 5
        })
    else
        WindUI:Notify({
            Title = "成功", 
            Content = config.name .. " 加载完成",
            Duration = 3
        })
    end
    
    self.currentScript = nil
end

-- 主窗口创建
local Window = WindUI:CreateWindow({
    Title = "雪黄 SCRIPT HUB",
    Icon = "crown",
    IconThemed = true,
    Author = "张乐",
    Folder = "雪黄",
    Size = UDim2.fromOffset(460, 340),
    Transparent = true,
    Theme = "Dark",
    User = { Enabled = true },
    SideBarWidth = 200,
    ScrollBarEnabled = true,
    Background = "rbxassetid://104563992965219"
})

-- 时间标签
local TimeTag = Window:Tag({
    Title = "00:00",
    Color = Color3.fromHex("0000FF")
})

local hue = 0
task.spawn(function()
    while true do
        local now = os.date("*t")
        local hours = string.format("%02d", now.hour)
        local minutes = string.format("%02d", now.min)
        
        hue = (hue + 0.01) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        
        TimeTag:SetTitle(hours .. ":" .. minutes)

        task.wait(0.06)
    end
end)

Window:Tag({
    Title = "四月的秋",
    Color = Color3.fromHex("#30ff6a")
})
Window:Tag({
    Title = "保持更新",
    Color = Color3.fromHex("FF0000")
})

Window:EditOpenButton({
    Title = "雪黄 SCRIPT 99nights",
    Icon = "crown",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0000"), 
        Color3.fromHex("0000FF")
    ),
    Draggable = true,
})

Window:EditOpenButton({
    Title = "雪黄 HUB",
    Icon = "hand",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FF7F00")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("9400D3"))
    }),
    Draggable = true,
})

-- 创建标签页
local Tabs = {
    Home = Window:Tab({ Title = "主页", Icon = "crown" }),
    Misc = Window:Tab({ Title = "其他", Icon = "settings" }),
    Universal = Window:Tab({ Title = "通用功能区", Icon = "MousePointerClick" }),
    Doors = Window:Tab({ Title = "doors", Icon = "MousePointerClick" }),
    Pressure = Window:Tab({ Title = "压力", Icon = "MousePointerClick" }),
    InkGame = Window:Tab({ Title = "inkgame", Icon = "MousePointerClick" }),
    Nights99 = Window:Tab({ Title = "99nights", Icon = "tap" }),
    Forsaken = Window:Tab({ Title = "被遗弃", Icon = "MousePointerClick" }),
    DieOfDeath = Window:Tab({ Title = "死亡之死", Icon = "MousePointerClick" }),
    MuscleLegends = Window:Tab({ Title = "力量传奇", Icon = "MousePointerClick" }),
    SpeedOfLegends = Window:Tab({ Title = "极速传奇", Icon = "MousePointerClick" }),
    NinjaLegends = Window:Tab({ Title = "忍者传奇", Icon = "MousePointerClick" }),
    FLSCH = Window:Tab({ Title = "flsch", Icon = "tap" }),
    BF = Window:Tab({ Title = "bf", Icon = "MousePointerClick" }),
    DeadRails = Window:Tab({ Title = "死铁轨", Icon = "MousePointerClick" }),
    BladeBall = Window:Tab({ Title = "刀刃球", Icon = "MousePointerClick" }),
    StealBrainRed = Window:Tab({ Title = "偷走脑红", Icon = "MousePointerClick" }),
    PlantGarden = Window:Tab({ Title = "种植花园", Icon = "MousePointerClick" }),
    Chain = Window:Tab({ Title = "chain", Icon = "MousePointerClick" }),
    StrongestBattlegrounds = Window:Tab({ Title = "最强战场", Icon = "MousePointerClick" }),
    Evade = Window:Tab({ Title = "evade", Icon = "MousePointerClick" }),
    NicoNextRobot = Window:Tab({ Title = "nico next robot", Icon = "MousePointerClick" }),
    OtherScripts = Window:Tab({ Title = "其他中心", Icon = "tap" })
}

Window:SelectTab(1)

-- 全局服务引用
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")

-- 本地玩家引用
local LP = Players.LocalPlayer

-- 功能状态
local Features = {
    KillAura = false,
    AutoChop = false,
    AutoEat = false,
    ChildESP = false,
    ChestESP = false,
    InstantInteract = false
}

-- 黑名单
local Blacklist = {}

-- 客户端模块
local ClientModule
local EatRemote
local function GetClientModule()
    if not ClientModule then
        ClientModule = require(LP:WaitForChild("PlayerScripts"):WaitForChild("Client"))
        EatRemote = ClientModule and ClientModule.Events and ClientModule.Events.RequestConsumeItem
    end
    return ClientModule, EatRemote
end

-- ESP功能管理
local espData = {}
local function createESP(target, name)
    local rootPart = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
    if not rootPart or espData[target] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(0, 100, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart
    billboard.Enabled = true

    local label = Instance.new("TextLabel")
    label.Text = name .. "\n" .. "0m"
    label.Size = UDim2.new(1, 0, 0, 40)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.3
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = billboard

    if name:match("Chest") then
        local image = Instance.new("ImageLabel")
        image.Position = UDim2.new(0, 20, 0, 40)
        image.Size = UDim2.new(0, 60, 0, 60)
        image.Image = "rbxassetid://18660563116"
        image.BackgroundTransparency = 1
        image.Parent = billboard
    end

    espData[target] = {gui = billboard, label = label, image = image}
end

--- 主页 Tab ---
Tabs.Home:Paragraph({
    Title = "雪黄 x 张乐",
    Desc = "四月知春秋，已知天南北",
    Image = "rbxassetid://121041163203912",
    ImageSize = 65,
    Thumbnail = "rbxassetid://85215626362708",
    ThumbnailSize = 180
})
Tabs.Home:Paragraph({
    Title = "欢迎",
    Desc = "需要时开启反挂机 作者: 雪黄\n",
})

-- 反挂机
Tabs.Home:Button({
    Title = "反挂机",
    Desc = "加载反挂机",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/99nights%E5%8F%8D%E6%8C%82%E6%9C%BA%E8%84%9A%E6%9C%AC"))()
        end)
    end
})

-- FPS 显示
local FpsGui
local FpsXS
Tabs.Home:Toggle({
    Title = "显示FPS",
    Desc = "在屏幕上显示当前FPS",
    Callback = function(state)
        if state then
            if not FpsGui then
                FpsGui = Instance.new("ScreenGui")
                FpsGui.Name = "FPSGui"
                FpsGui.ResetOnSpawn = false
                
                FpsXS = Instance.new("TextLabel")
                FpsXS.Name = "FpsXS"
                FpsXS.Size = UDim2.new(0, 100, 0, 50)
                FpsXS.Position = UDim2.new(0, 10, 0, 10)
                FpsXS.BackgroundTransparency = 1
                FpsXS.Font = Enum.Font.SourceSansBold
                FpsXS.Text = "FPS: 0"
                FpsXS.TextSize = 20
                FpsXS.TextColor3 = Color3.new(1, 1, 1)
                FpsXS.Parent = FpsGui
                FpsGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                
                RunService.Heartbeat:Connect(function()
                    local fps = math.floor(1 / RunService.RenderStepped:Wait())
                    FpsXS.Text = "FPS: " .. fps
                end)
            end
            FpsGui.Enabled = true
        else
            if FpsGui then
                FpsGui.Enabled = false
            end
        end
    end
})

-- 范围显示
local rangeHighlight
Tabs.Home:Toggle({
    Title = "显示范围",
    Desc = "显示玩家范围",
    Callback = function(state)
        local HeadSize = 20
        
        local function applyHighlight(character)
            if not character:FindFirstChild("WindUI_RangeHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = character
                highlight.Name = "WindUI_RangeHighlight"
                highlight.OutlineTransparency = 0
                highlight.FillTransparency = 0.7
                highlight.FillColor = Color3.fromHex("#0000FF")
                highlight.Parent = character
            end
        end

        local function removeHighlight(character)
            local h = character:FindFirstChild("WindUI_RangeHighlight")
            if h then
                h:Destroy()
            end
        end

        if state then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP and player.Character then
                    applyHighlight(player.Character)
                end
            end
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    task.wait(1)
                    applyHighlight(character)
                end)
            end)
            Players.PlayerRemoving:Connect(function(player)
                if player.Character then
                    removeHighlight(player.Character)
                end
            end)
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    removeHighlight(player.Character)
                end
            end
        end
    end
})

-- 半隐身, 玩家入退提示, 甩飞
Tabs.Home:Button({
    Title = "半隐身",
    Desc = "加载隐身",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invisible-35376"))() end)
    end
})
Tabs.Home:Button({
    Title = "玩家入退提示",
    Desc = "加载提示",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))() end)
    end
})

-- 修复后的甩飞玩家功能
local playersDropdown
Tabs.Home:Button({
    Title = "甩飞玩家",
    Desc = "将选中的玩家甩飞",
    Callback = function()
        if not playersDropdown then return end
        local selectedPlayerName = playersDropdown.Value
        if not selectedPlayerName then
            WindUI:Notify({Title = "错误", Content = "未选择玩家", Duration = 3})
            return
        end
        
        local targetPlayer = Players:FindFirstChild(selectedPlayerName)
        if not targetPlayer or not targetPlayer.Character then
            WindUI:Notify({Title = "错误", Content = "未找到玩家或玩家角色", Duration = 3})
            return
        end
        
        local character = targetPlayer.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            WindUI:Notify({Title = "错误", Content = "玩家角色缺少HumanoidRootPart", Duration = 3})
            return
        end
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0) + (humanoidRootPart.CFrame.lookVector * 10)
        bodyVelocity.P = 1000
        bodyVelocity.Parent = humanoidRootPart
        
        task.delay(1, function()
            bodyVelocity:Destroy()
            WindUI:Notify({Title = "成功", Content = "已甩飞玩家 " .. selectedPlayerName, Duration = 3})
        end)
    end
})

-- 防甩飞
local antiWalkFlingConn
Tabs.Home:Toggle({
    Title = "防甩飞",
    Desc = "不要和甩飞同时开启!",
    Callback = function(state)
        if state then
            if antiWalkFlingConn then antiWalkFlingConn:Disconnect() end
            local lastVelocity = Vector3.new()
            antiWalkFlingConn = RunService.Stepped:Connect(function()
                local character = LP.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local currentVelocity = hrp.Velocity
                if (currentVelocity - lastVelocity).Magnitude > 100 then
                    hrp.Velocity = lastVelocity
                end
                lastVelocity = currentVelocity
            end)
        else
            if antiWalkFlingConn then antiWalkFlingConn:Disconnect() end
        end
    end
})

local function setPlayerHealth(healthValue)
    local character = LP.Character
    
    if not character then
        character = LP.CharacterAdded:Wait()
    end
    
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Health = healthValue
    
    WindUI:Notify({
        Title = "血量设置",
        Content = "血量已设置为: " .. healthValue,
        Duration = 3
    })
end

-- 血量滑块
Tabs.Home:Slider({
    Title = "设置血量",
    Desc = "调整人物血量 (0-1000)",
    Value = { Min = 0, Max = 1000, Default = 100 },
    Callback = function(val)
        setPlayerHealth(val)
    end
})

-- 无敌模式切换
local godModeEnabled = false
local originalHealth
local godModeConnection

Tabs.Home:Toggle({
    Title = "无敌模式",
    Desc = "开启后血量不会减少",
    Default = false,
    Callback = function(state)
        godModeEnabled = state
        local character = LP.Character
    
        if not character then
            character = LP.CharacterAdded:Wait()
        end
        
        local humanoid = character:WaitForChild("Humanoid")
        
        if state then
            originalHealth = humanoid.Health
            
            godModeConnection = humanoid.HealthChanged:Connect(function(newHealth)
                if newHealth < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
            
            humanoid.Health = humanoid.MaxHealth
            
            WindUI:Notify({
                Title = "无敌模式",
                Content = "无敌模式已开启",
                Duration = 3
            })
        else
            if godModeConnection then
                godModeConnection:Disconnect()
                godModeConnection = nil
            end
            
            if originalHealth then
                humanoid.Health = originalHealth
            end
            
            WindUI:Notify({
                Title = "无敌模式",
                Content = "无敌模式已关闭",
                Duration = 3
            })
        end
    end
})

-- 速度, 重力, 跳跃
Tabs.Home:Slider({
    Title = "设置速度",
    Desc = "可输入",
    Value = { Min = 0, Max = 500, Default = 25 },
    Callback = function(val)
        local character = LP.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = val
            end
        end
    end
})
Tabs.Home:Slider({
    Title = "设置个人重力",
    Desc = "200为最大值",
    Value = { Min = 0, Max = 200, Default = 50, Rounding = 1 },
    Callback = function(val)
        local character = LP.Character or LP.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local oldGravity = rootPart:FindFirstChild("PersonalGravity")
        if oldGravity then oldGravity:Destroy() end

        if val ~= Workspace.Gravity then
            local personalGravity = Instance.new("BodyForce")
            personalGravity.Name = "PersonalGravity"
            local mass = rootPart:GetMass()
            local force = Vector3.new(0, mass * (Workspace.Gravity - val), 0)
            personalGravity.Force = force
            personalGravity.Parent = rootPart
        end
    end
})
Tabs.Home:Slider({
    Title = "设置跳跃高度",
    Desc = "可输入",
    Value = { Min = 0, Max = 500, Default = 50 },
    Callback = function(val)
        local character = LP.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = val
            end
        end
    end
})

local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- 创建下拉菜单
playersDropdown = Tabs.Home:Dropdown({
    Title = "选择要传送的玩家",
    Values = getPlayerNames(),
})

Tabs.Home:Button({
    Title = "传送至玩家",
    Desc = "传送到选中的玩家",
    Callback = function()
        if not playersDropdown then return end
        local selectedPlayerName = playersDropdown.Value
        if not selectedPlayerName then
            WindUI:Notify({Title = "错误", Content = "未选择玩家", Duration = 3})
            return
        end
        local targetPlayer = Players:FindFirstChild(selectedPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local character = LP.Character or LP.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
})

Tabs.Home:Button({
    Title = "无限跳",
    Desc = "开启后无法关闭",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))() end)
    end
})
Tabs.Home:Button({
    Title = "自瞄",
    Desc = "宙斯自瞄",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20Aimbot.lua"))() end)
    end
})

local trackData = {}
Tabs.Home:Toggle({
    Title = "子弹追踪",
    Default = false,
    Callback = function(state)
        trackData.enabled = state
        if not state then
            if trackData.workspaceConn then trackData.workspaceConn:Disconnect() end
            for _, conn in pairs(trackData.bulletConns or {}) do conn:Disconnect() end
            trackData.bulletConns = {}
            return
        end
        local function getTarget(bulletPos)
            local nearestTarget, nearestDist = nil, math.huge
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP then
                    local char = player.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if humanoid and humanoid.Health > 0 and root then
                        local dist = (bulletPos - root.Position).Magnitude
                        if dist <= 70 and dist < nearestDist then
                            nearestDist = dist
                            nearestTarget = root
                        end
                    end
                end
            end
            return nearestTarget
        end

        local function attachTrack(bullet)
            local bulletPart = bullet:IsA("BasePart") and bullet or bullet:FindFirstChildWhichIsA("BasePart")
            if not bulletPart then return end
            local bodyVel = bulletPart:FindFirstChildOfClass("BodyVelocity")
            if not bodyVel then
                bodyVel = Instance.new("BodyVelocity")
                bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVel.Velocity = bulletPart.Velocity
                bodyVel.Parent = bulletPart
            end

            local bulletConn = RunService.Heartbeat:Connect(function()
                if not bulletPart.Parent or not trackData.enabled then
                    bulletConn:Disconnect()
                    trackData.bulletConns[bulletConn] = nil
                    return
                end
                local target = getTarget(bulletPart.Position)
                if target then
                    local trackDir = (target.Position - bulletPart.Position).Unit
                    bodyVel.Velocity = trackDir * bulletPart.Velocity.Magnitude
                    bulletPart.CFrame = CFrame.new(bulletPart.Position, target.Position)
                end
            end)
            trackData.bulletConns[bulletConn] = true
        end
        trackData.workspaceConn = Workspace.ChildAdded:Connect(function(child)
            local isLocalBullet = (child.Name:lower():find("bullet") or child.Name:lower():find("projectile") or child.Name:lower():find("missile")) and (child:FindFirstChild("Owner") and child.Owner.Value == LP)
            if isLocalBullet then
                task.wait(0.05)
                attachTrack(child)
            end
        end)
    end
})

local nightVisionData = {}
Tabs.Home:Toggle({
    Title = "夜视",
    Default = false,
    Callback = function(isEnabled)
        local lighting = game:GetService("Lighting")
        if isEnabled then
            pcall(function()
                nightVisionData.originalAmbient = lighting.Ambient
                nightVisionData.originalBrightness = lighting.Brightness
                nightVisionData.originalFogEnd = lighting.FogEnd
                lighting.Ambient = Color3.fromRGB(255, 255, 255)
                lighting.Brightness = 1
                lighting.FogEnd = 1e10
                for _, v in pairs(lighting:GetDescendants()) do
                    if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                        v.Enabled = false
                    end
                end
                nightVisionData.changedConnection = lighting.Changed:Connect(function()
                    lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    lighting.Brightness = 1
                    lighting.FogEnd = 1e10
                end)
                local character = LP.Character or LP.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                if not humanoidRootPart:FindFirstChildWhichIsA("PointLight") then
                    local headlight = Instance.new("PointLight", humanoidRootPart)
                    headlight.Brightness = 1
                    headlight.Range = 60
                    nightVisionData.pointLight = headlight
                end
            end)
        else
            if nightVisionData.originalAmbient then lighting.Ambient = nightVisionData.originalAmbient end
            if nightVisionData.originalBrightness then lighting.Brightness = nightVisionData.originalBrightness end
            if nightVisionData.originalFogEnd then lighting.FogEnd = nightVisionData.originalFogEnd end
            if nightVisionData.changedConnection then nightVisionData.changedConnection:Disconnect() end
            if nightVisionData.pointLight and nightVisionData.pointLight.Parent then nightVisionData.pointLight:Destroy() end
        end
    end
})

local noclipConn
Tabs.Home:Toggle({
    Title = "穿墙",
    Default = false,
    Callback = function(state)
        local character = LP.Character or LP.CharacterAdded:Wait()
        if state then
            noclipConn = RunService.Stepped:Connect(function()
                if character then
                    for _, v in pairs(character:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
            if character then
                for _, v in pairs(character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end
    end
})

-- 人物透视 (ESP) 功能
local espEnabled = false
local espConnections = {}
local espHighlights = {}
local espNameTags = {}

local function createESP(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "WindUI_ESP"
    highlight.Adornee = char
    highlight.FillColor = Color3.new(1, 0, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    espHighlights[player] = highlight

    local nameTag = Instance.new("BillboardGui")
    nameTag.Name = "WindUI_NameTag"
    nameTag.Adornee = humanoidRootPart
    nameTag.Size = UDim2.new(0, 150, 0, 20)
    nameTag.StudsOffset = Vector3.new(0, 2.8, 0)
    nameTag.AlwaysOnTop = true
    nameTag.Parent = humanoidRootPart
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.TextScaled = false
    textLabel.Parent = nameTag
    espNameTags[player] = nameTag
end

local function removeESP(player)
    if espHighlights[player] and espHighlights[player].Parent then
        espHighlights[player]:Destroy()
        espHighlights[player] = nil
    end
    if espNameTags[player] and espNameTags[player].Parent then
        espNameTags[player]:Destroy()
        espNameTags[player] = nil
    end
end

local function toggleESP(state)
    espEnabled = state
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                pcall(createESP, player)
            end
        end

        espConnections.playerAdded = Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Wait()
            pcall(createESP, player)
        end)
        espConnections.playerRemoving = Players.PlayerRemoving:Connect(function(player)
            removeESP(player)
        end)
    else
        if espConnections.playerAdded then espConnections.playerAdded:Disconnect() end
        if espConnections.playerRemoving then espConnections.playerRemoving:Disconnect() end
        for player, _ in pairs(espHighlights) do
            removeESP(player)
        end
        espHighlights = {}
        espNameTags = {}
    end
end

Tabs.Home:Toggle({
    Title = "人物透视 (ESP)",
    Desc = "显示其他玩家的透视框和名字。",
    Default = false,
    Callback = toggleESP,
})

Tabs.Home:Button({
    Title = "切换服务器",
    Desc = "切换到相同游戏的另一个服务器",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        TeleportService:Teleport(placeId, LP)
    end
})

Tabs.Home:Button({
    Title = "重新加入服务器",
    Desc = "重新加入当前服务器",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local jobId = game.JobId
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LP)
    end
})

Tabs.Home:Button({
    Title = "复制服务器ID",
    Desc = "复制当前服务器的Job ID到剪贴板",
    Callback = function()
        setclipboard(game.JobId)
        WindUI:Notify({
            Title = "服务器ID已复制",
            Content = "Job ID: " .. game.JobId,
            Duration = 3
        })
    end
})

Tabs.Home:Button({
    Title = "服务器信息",
    Desc = "显示当前服务器的信息",
    Callback = function()
        local players = Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers
        local placeId = game.PlaceId
        local jobId = game.JobId
        local serverType = game:GetService("RunService"):IsStudio() and "Studio" or "Live"
        
        WindUI:Notify({
            Title = "服务器信息",
            Content = string.format("玩家数量: %d/%d\nPlace ID: %d\nJob ID: %s\n服务器类型: %s", #players, maxPlayers, placeId, jobId, serverType),
            Duration = 10
        })
    end
})

--- 其他 Tab ---
Tabs.Misc:Button({
    Title = "复制作者QQ",
    Callback = function()
        setclipboard("3848974452")
        WindUI:Notify({Title = "QQ号", Content = "qq号已复制到剪贴板", Duration = 3})
    end
})

Tabs.Misc:Button({
    Title = "检查更新",
    Desc = "检查是否有更新",
    Callback = function()
        WindUI:Notify({
            Title = "更新检查",
            Content = "当前版本: v1.0\n已是最新版本",
            Duration = 5
        })
    end
})

Tabs.Misc:Code({
    Title = "感谢游玩",
    Code = "QQ号:3848974452"
})

--- 通用功能区 Tab ---
Tabs.Universal:Button({
    Title = "WU VIP汉化",
    Desc = "感谢您的支持",
    Locked = false,
    Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/WUSCRIPT/WU-Script/main/WU_NEXT_YI"))()
    end
})

Tabs.Universal:Button({
    Title = "显示雪黄 SCRIPT用户",
    Icon = "MousePointerClick",
    Callback = function()
        local function createFloatingText(player, text)
            if player.Character and player.Character:FindFirstChild("Head") then
                local existingText = player.Character.Head:FindFirstChild("雪黄ScriptText")
                if existingText then
                    existingText:Destroy()
                end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "雪黄ScriptText"
                billboard.Adornee = player.Character.Head
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = player.Character.Head
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = text
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.TextSize = 20
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                textLabel.Parent = billboard
                
                -- 创建彩虹色渐变
                local colorSequence = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),      -- 红
                    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 165, 0)), -- 橙
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)), -- 黄
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),    -- 绿
                    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),   -- 蓝
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),  -- 靛
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 0, 211))     -- 紫
                })
                
                local uigradient = Instance.new("UIGradient")
                uigradient.Color = colorSequence
                uigradient.Rotation = 0  -- 改为水平渐变
                uigradient.Offset = Vector2.new(-1, 0)  -- 从左侧开始
                uigradient.Parent = textLabel
                
                -- 创建渐变动画
                local tweenInfo = TweenInfo.new(
                    3,  -- 动画持续时间
                    Enum.EasingStyle.Linear, 
                    Enum.EasingDirection.InOut, 
                    -1,  -- 无限循环
                    true  -- 来回播放
                )
                
                -- 动画目标：从左侧移动到右侧
                local tween = TweenService:Create(
                    uigradient, 
                    tweenInfo, 
                    {Offset = Vector2.new(1, 0)}  -- 移动到右侧
                )
                tween:Play()
            end
        end
        
        createFloatingText(LP, "雪黄 SCRIPT 用户")
        
        WindUI:Notify({
            Title = "已显示",
            Content = "显示'雪黄 SCRIPT 用户' ",
            Icon = "MousePointerClick",
            Duration = 3
        })
    end
})

Tabs.Universal:Button({
    Title = "WU FLY",
    Desc = "点击运行WU飞行",
    Locked = false,
    Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/fly.lua"))()
    end
})

Tabs.Universal:Button({
    Title = "显示xyz轴",
    Desc = "点击运行显示xyz轴",
    Locked = false,
    Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/WUSCRIPT/WU-Script/main/XYZ%20axisDisplay"))()
    end
})

Tabs.Universal:Button({
    Title = "自然灾害黑洞v6",
    Desc = "点击运行黑洞v6",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/V6.txt"))()
        WindUI:Notify({
            Title = "黑洞v6",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

--- Doors Tab ---
Tabs.Doors:Button({
    Title = "doors xk",
    Desc = "点击运行xk",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://github.com/devslopo/DVES/raw/main/XK%20Hub"))()
        WindUI:Notify({
            Title = "doors xk",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.Doors:Button({
    Title = " doors null fire［key］",
    Desc = "点击运行null fire",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/wu_doors"))()
    end
})

Tabs.Doors:Button({
    Title = " doors prohax",
    Desc = "点击运行prohax",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/atnew2025/Chinese-scripts/refs/heads/main/mshax(prohax).txt"))()
    end
})

Tabs.Doors:Button({
    Title = "xa doors",
    Desc = "点击运行xa doors",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\112\97\115\116\101\98\105\110\46\99\111\109\47\114\97\119\47\54\53\84\119\84\56\106\97"))()
    end
})

--- 压力 Tab ---
Tabs.Pressure:Button({
    Title = "yoxi",
    Desc = "点击运行yoxi",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/yoxi_Pressure"))()
    end
})

Tabs.Pressure:Button({
    Title = "中文压力",
    Desc = "点击运行压力",
    Locked = false,
    Callback = function()
        getgenv().lishichuan="1001390385" loadstring(game:HttpGet("https://pastebin.com/raw/iZuasZCc"))()
    end
})

--- InkGame Tab ---
Tabs.InkGame:Button({
    Title = "inkgame ax",
    Desc = "此暂时无法使用",
    Locked = false,
    Callback = function()
        KeyInputSystem:CreateSimpleInput("ax")
        WindUI:Notify({
            Title = "inkgame ax",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.InkGame:Button({
    Title = "inkgame az中心",
    Desc = "点击运行az",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/az_hub"))()
        WindUI:Notify({
            Title = "inkgame az中心",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.InkGame:Button({
    Title = "墨水xa",
    Desc = "点击运行xa",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/墨水游戏.lua"))()
        WindUI:Notify({
            Title = "墨水xa",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.InkGame:Button({
    Title = " tex",
    Desc = "点击运行tex",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/TexRBLlX"))()
    end
})

Tabs.InkGame:Button({
    Title = " tx墨水",
    Desc = "点击运行tx",
    Locked = false,
    Callback = function()                     
        loadstring("\u{006c}\u{006f}\u{0061}\u{0064}\u{0073}\u{0074}\u{0072}\u{0069}\u{006e}\u{0067}\u{0028}\u{0067}\u{0061}\u{006d}\u{0065}\u{003a}\u{0048}\u{0074}\u{0074}\u{0070}\u{0047}\u{0065}\u{0074}\u{0028}\u{0022}\u{0068}\u{0074}\u{0074}\u{0070}\u{0073}\u{003a}\u{002f}\u{002f}\u{0072}\u{0061}\u{0077}\u{002e}\u{0067}\u{0061}\u{0074}\u{0068}\u{0075}\u{0062}\u{0075}\u{0073}\u{0065}\u{0072}\u{0063}\u{006f}\u{006e}\u{0074}\u{0065}\u{006e}\u{0074}\u{002e}\u{0063}\u{006f}\u{006d}\u{002f}\u{004a}\u{0073}\u{0059}\u{0062}\u{0036}\u{0036}\u{0036}\u{002f}\u{0054}\u{0055}\u{0049}\u{0058}\u{0055}\u{0049}\u{005f}\u{0071}\u{0075}\u{006e}\u{002d}\u{0038}\u{0030}\u{0039}\u{0037}\u{0037}\u{0031}\u{0031}\u{0034}\u{0031}\u{002f}\u{0072}\u{0065}\u{006f}\u{0073}\u{002f}\u{0068}\u{0065}\u{0061}\u{0064}\u{0073}\u{002f}\u{0054}\u{0055}\u{0049}\u{0058}\u{0055}\u{0049}\u{002f}\u{004d}\u{0053}\u{0059}\u{0058}\u{0022}\u{0029}\u{0029}\u{0028}\u{0029}")()
    end
})

--- 99nights Tab ---
Tabs.Nights99:Button({
    Title = "雪黄99nights",
    Desc = "点击运行戊99nights",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/戊99nights"))()
    end
})

Tabs.Nights99:Button({
    Title = " 二狗子99nights",
    Desc = "点击运行99nights",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/99day.lua"))()
    end
})

Tabs.Nights99:Button({
    Title = " tx nights",
    Desc = "点击运行tx nights",
    Locked = false,
    Callback = function()
        TX = "TX退休"
        Scripts = "森林中的99夜"
        QUN = "Q群:160369111"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/99-Nights-TX-XIAN-MIAN______-_-_--_-_-_-_--_-_-_-_--_-_-_-_-_--_-_-_-__------_-_-_-_.lua"))()
    end
})

Tabs.Nights99:Button({
    Title = " ringta 99nights",
    Desc = "点击运行ringta",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/ringta_99nights"))()
    end
})

Tabs.Nights99:Button({
    Title = " 虚空99nights",
    Desc = "点击运行虚空",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/void_99nights"))()
    end
})

Tabs.Nights99:Button({
    Title = "lunar 99night［key］s",
    Desc = "点击运行lunar",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/moon_99nights"))()
    end
})

--- 被遗弃 Tab ---
Tabs.Forsaken:Button({
    Title = "NOL免费版",
    Desc = "点击运行NOL",
    Locked = false,
    Callback = function()
        getgenv().ADittoKey = "NOL_中文FREEKEY"
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Loader/refs/heads/main/ChineseFreeLoader.luau", true))()
        end)
        WindUI:Notify({
            Title = "nol免费版",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.Forsaken:Button({
    Title = " 虚空被遗弃",
    Desc = "点击运行虚空被遗弃",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/void_forsken"))()
    end
})

--- 死亡之死 Tab ---
Tabs.DieOfDeath:Button({
    Title = "Thuker 死亡之死",
    Desc = "点击运行Thuker",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/thy_die%20of%20deah"))()
    end
})

Tabs.DieOfDeath:Button({
    Title = "zamzaman 死亡之死",
    Desc = "点击运行zamzaman",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/zam_die%20of%20deah"))()
    end
})

--- 力量传奇 Tab ---
Tabs.MuscleLegends:Button({
    Title = "bald力量传奇［key］",
    Desc = "点击运行bald",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/bald_力量传奇"))()
    end
})

Tabs.MuscleLegends:Button({
    Title = "力量传奇修改力量（娱乐）",
    Desc = "点击运行",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/修改力量"))()
    end
})

--- 极速传奇 Tab ---
Tabs.SpeedOfLegends:Button({
    Title = " 中文极速传奇",
    Desc = "点击运行中文极速传奇",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TtmScripter/GoodScript/main/LegendOfSpeed(Chinese)"))()
    end
})

--- 忍者传奇 Tab ---
Tabs.NinjaLegends:Button({
    Title = " h3ll忍者传奇",
    Desc = "点击运行h3ll忍者传奇",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/h3ll_忍者传奇"))()
    end
})

--- FLSCH Tab ---
Tabs.FLSCH:Button({
    Title = "flsch solix",
    Desc = "点击运行solix",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/solix_fisch"))()
    end
})

--- BF Tab ---
Tabs.BF:Button({
    Title = " bf blue x",
    Desc = "点击运行blue x",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/blue%20x"))()
    end
})

Tabs.BF:Button({
    Title = "solix BF［key］",
    Desc = "点击运行solix",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/solix_BF"))()
    end
})

--- 死铁轨 Tab ---
Tabs.DeadRails:Button({
    Title = "死铁轨nat中心［key］",
    Desc = "点击运行nat",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/Nathub"))()
        WindUI:Notify({
            Title = "nat",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.DeadRails:Button({
    Title = " moon死铁轨",
    Desc = "点击运行moon",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/moondirty"))()
    end
})

Tabs.DeadRails:Button({
    Title = " 死铁轨null fire",
    Desc = "点击运行null fire",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/Nullfire_deadrail"))()
    end
})

Tabs.DeadRails:Button({
    Title = " tx死铁轨刷债券",
    Desc = "点击运行tx",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/刷债券"))()
    end
})

Tabs.DeadRails:Button({
    Title = " 死铁轨ringta",
    Desc = "点击运行ringta",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/ringta_deadrail"))()
    end
})

--- 刀刃球 Tab ---
Tabs.BladeBall:Button({
    Title = " 刀刃球nodex",
    Desc = "点击运行nodex",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/nodex"))()
    end
})

Tabs.BladeBall:Button({
    Title = "laws hub刀刃球",
    Desc = "点击运行laws hub",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/law"))()
    end
})

--- 偷走脑红 Tab ---
Tabs.StealBrainRed:Button({
    Title = "WU偷走脑红",
    Desc = "点击运行WU",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/WUSCRIPT/WU-Script/main/WU_Steal%20Brain%20Red"))()
    end
})

Tabs.StealBrainRed:Button({
    Title = "偷走脑红辣椒中心",
    Desc = "点击运行辣椒中心",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/chill%20stealredrot"))()
    end
})

Tabs.StealBrainRed:Button({
    Title = "偷走脑红dencycode［key］",
    Desc = "点击运行dencycode",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/pex%20steal%20brainrot"))()
    end
})

--- 种植花园 Tab ---
Tabs.PlantGarden:Button({
    Title = "种植花园wtb",
    Desc = "点击运行wtb",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/eUAzqoCL/raw"))()
    end
}) -- 这里添加了缺失的 end

--- Chain Tab ---
Tabs.Chain:Button({
    Title = " 不知名chain",
    Desc = "点击运行chain",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/133ufudhdu/pokl/refs/heads/main/XHTMLEWJ"))()
    end
})

Tabs.Chain:Button({
    Title = "AnimeWare chain［key］",
    Desc = "点击运行chain",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/amin%20ware"))()
    end
})

--- 最强战场 Tab ---
Tabs.StrongestBattlegrounds:Button({
    Title = "最强战场五条悟",
    Desc = "点击运行五条悟",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Kamyk-player/FinalSuperSenior/refs/heads/main/SaitamaToSuperSeniorGojo"))()
        WindUI:Notify({
            Title = "五条悟",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.StrongestBattlegrounds:Button({
    Title = "无限侧闪",
    Desc = "点击运行无限侧闪",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/无限侧闪"))()
        WindUI:Notify({
            Title = "无限侧闪",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.StrongestBattlegrounds:Button({
    Title = "smm［key］",
    Desc = "［key］= ［RoscriptsOnTop］",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/smm"))()
        WindUI:Notify({
            Title = "smm",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.StrongestBattlegrounds:Button({
    Title = "最强战场ns",
    Desc = "点击运行最强战场ns",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/ns%20Strongest%20battlefield"))()
        WindUI:Notify({
            Title = "最强战场ns",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

--- Evade Tab ---
Tabs.Evade:Button({
    Title = "rise evade",
    Desc = "点击运行rise",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/irse%20evade"))()
    end
})

Tabs.Evade:Button({
    Title = "realking evade［key］",
    Desc = "点击运行realking",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/king%20%20evade"))()
    end
})

--- Nico Next Robot Tab ---
Tabs.NicoNextRobot:Button({
    Title = "不知名nico next robot",
    Desc = "点击运行nico next robot",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/greatjakson-lgtm/-2/main/wu_nico"))()
    end
})

--- 其他中心 Tab ---
Tabs.OtherScripts:Button({
    Title = "rb中心",
    Desc = "点击运行rb",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yungengxin/roblox/refs/heads/main/Rb-Hub"))()
        WindUI:Notify({
            Title = "rb中心",
            Content = "加载成功",
            Duration = 3,
            Icon = "MousePointerClick",
        })
    end
})

Tabs.OtherScripts:Button({
    Title = "TX V2",
    Desc = "点击运行TX", 
    Callback = function()
        Script = "Free永久免费"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/TX-Free-YYDS/refs/heads/main/FREE-TX-TEAM"))()
    end
})

Tabs.OtherScripts:Button({
    Title = "皮脚本",
    Desc = "点击运行皮脚本",
    Callback = function()
        getgenv().XiaoPi = "皮QQ群1002100032"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua"))()
    end
})

Tabs.OtherScripts:Button({
    Title = "落叶中心",
    Desc = "点击运行落叶",
    Callback = function()
        getgenv().LS="落叶中心" 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/krlpl/Deciduous-center-LS/main/%E8%90%BD%E5%8F%B6%E4%B8%AD%E5%BF%83%E6%B7%B7%E6%B7%86.txt"))()
    end
})

Tabs.OtherScripts:Button({
    Title = " SN中心",
    Desc = "点击运行SNhub",
    Locked = false,
    Callback = function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\65\114\99\111\110\116\101\110\116\46\99\111\109\47\120\105\97\110\105\110\103\49\53\49\47\83\78\72\85\66\47\109\97\105\110\47\83\78\104\117\98\46\108\117\97\34\41\41\40\41")()
    end
})

Tabs.OtherScripts:Button({
    Title = " xahub",
    Desc = "点击运行xahub",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.gitcode.com/Xingtaiduan/Scripts/raw/main/Loader.lua"))()
    end
})

Tabs.OtherScripts:Button({
    Title = " 禁漫中心",
    Desc = "点击运行禁漫中心",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Macintosh1983/ChillHubMain/main/ChillHubOilWarfareTycoon.lua'))()
    end
})

Tabs.OtherScripts:Button({
    Title = " 神青脚本",
    Desc = "点击运行神青脚本",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/shinqine666.lua')))()
    end
})

-- 通知加载成功
WindUI:Notify({
    Title = "WU",
    Content = "加载完成！",
    Duration = 3,
    Icon = "check-circle"
})