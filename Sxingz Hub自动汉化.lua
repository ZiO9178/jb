if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- 服务初始化
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 清除旧UI残留
local function clearOldUI()
    local oldUI = CoreGui:FindFirstChild("AdvancedTranslatorPro")
    if oldUI then oldUI:Destroy() end
    oldUI = playerGui:FindFirstChild("TranslatorCache")
    if oldUI then oldUI:Destroy() end
end
clearOldUI()

-- 核心配置
local config = {
    rainbowSpeed = 3.5,          -- 彩虹动画速度
    defaultScanCooldown = 0.2,   -- 默认扫描冷却
    cacheExpireTime = 3600,      -- 缓存过期时间(秒)
    maxCacheSize = 5000,         -- 最大缓存数量
    translationModes = {
        {name = "快速匹配", desc = "完全匹配词典，速度最快", priority = 1},
        {name = "智能分词", desc = "支持词组拆分与组合翻译", priority = 2},
        {name = "深度解析", desc = "上下文语义分析，准确率最高", priority = 3},
        {name = "自定义规则", desc = "按用户规则优先翻译", priority = 4}
    },
    theme = {
        primary = Color3.fromRGB(45, 45, 55),
        secondary = Color3.fromRGB(60, 60, 70),
        accent = Color3.fromRGB(100, 150, 255),
        text = Color3.fromRGB(255, 255, 255),
        success = Color3.fromRGB(80, 200, 80),
        warning = Color3.fromRGB(255, 165, 0),
        error = Color3.fromRGB(220, 50, 50)
    }
}

-- 彩虹色序列（增强版）
local rainbowColors = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.125, Color3.fromRGB(255, 127, 0)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.375, Color3.fromRGB(127, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.625, Color3.fromRGB(0, 255, 127)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.875, Color3.fromRGB(0, 127, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
})

-- 主UI容器
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedTranslatorPro"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

-- 缓存存储
local translationCache = {
    data = {},
    timestamps = {}
}

-- 自定义规则存储
local customRules = {
    -- 示例规则：{模式, 匹配规则, 替换内容, 优先级}
    {1, "Premium %w+", "高级%1", 10},
    {2, "Auto(%a+)", "自动%1", 10}
}

-- 增强版翻译词典（分类细化）
local phraseDictionary = {
    -- 基础游戏术语
    ["Player"] = "玩家",
    ["NPC"] = "非玩家角色",
    ["Enemy"] = "敌人",
    ["Boss"] = "首领",
    ["Ally"] = "盟友",
    ["Neutral"] = "中立",
    
    -- 界面核心元素
    ["Menu"] = "菜单",
    ["Button"] = "按钮",
    ["Slider"] = "滑块",
    ["Toggle"] = "开关",
    ["Dropdown"] = "下拉菜单",
    ["Input Field"] = "输入框",
    ["Checkbox"] = "复选框",
    ["Tooltip"] = "提示框",
    ["Notification"] = "通知",
    
    -- 游戏机制
    ["Health"] = "生命值",
    ["Stamina"] = "耐力",
    ["Mana"] = "法力值",
    ["Experience"] = "经验值",
    ["Level"] = "等级",
    ["Damage"] = "伤害",
    ["Defense"] = "防御",
    ["Critical Hit"] = "暴击",
    ["Dodge"] = "闪避",
    ["Block"] = "格挡",
    ["Respawn"] = "重生",
    ["Cooldown"] = "冷却时间",
    
    -- 功能模块
    ["Automation"] = "自动化",
    ["Visuals"] = "视觉效果",
    ["Teleport"] = "传送",
    ["Esp"] = "透视",
    ["Aimbot"] = "自动瞄准",
    ["Wallhack"] = "穿墙透视",
    ["NoClip"] = "穿墙模式",
    ["Fly"] = "飞行",
    ["Speed Hack"] = "速度修改",
    
    -- 状态提示
    ["Enabled"] = "已启用",
    ["Disabled"] = "已禁用",
    ["Loading"] = "加载中",
    ["Processing"] = "处理中",
    ["Ready"] = "准备就绪",
    ["Success"] = "成功",
    ["Failed"] = "失败",
    ["Warning"] = "警告",
    ["Error"] = "错误",
    
    -- 新增高级术语
    ["Synchronize"] = "同步",
    ["Desynchronize"] = "不同步",
    ["Encryption"] = "加密",
    ["Decryption"] = "解密",
    ["Validation"] = "验证",
    ["Authorization"] = "授权",
    ["Configuration"] = "配置",
    ["Optimization"] = "优化",
    ["Debug"] = "调试",
    ["Logging"] = "日志记录"
}

-- 创建浮动控制按钮（增强交互）
local controlButton = Instance.new("TextButton")
controlButton.Name = "ControlButton"
controlButton.Size = UDim2.new(0, 65, 0, 65)
controlButton.Position = UDim2.new(0, 25, 0, 25)
controlButton.BackgroundColor3 = config.theme.primary
controlButton.Text = "汉"
controlButton.TextColor3 = config.theme.text
controlButton.TextSize = 24
controlButton.Font = Enum.Font.GothamBold
controlButton.ZIndex = 1000
controlButton.Parent = screenGui
controlButton.Active = true

-- 按钮美化
local controlCorner = Instance.new("UICorner")
controlCorner.CornerRadius = UDim.new(0, 32)
controlCorner.Parent = controlButton

local controlStroke = Instance.new("UIStroke")
controlStroke.Color = Color3.fromRGB(255, 255, 255)
controlStroke.Thickness = 2
controlStroke.Parent = controlButton

local controlGradient = Instance.new("UIGradient")
controlGradient.Color = rainbowColors
controlGradient.Rotation = 0
controlGradient.Parent = controlStroke

-- 呼吸动画
local breathTween = TweenService:Create(
    controlButton,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1),
    {Size = UDim2.new(0, 70, 0, 70)}
)
breathTween:Play()

-- 彩虹旋转动画
local rainbowTween = TweenService:Create(
    controlGradient,
    TweenInfo.new(config.rainbowSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Rotation = 360}
)
rainbowTween:Play()

-- 主界面（增强布局）
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 520)
mainFrame.Position = UDim2.new(0, 100, 0, 25)
mainFrame.BackgroundColor3 = config.theme.primary
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 999
mainFrame.Parent = screenGui

-- 主界面美化
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = rainbowColors
mainGradient.Rotation = 0
mainGradient.Parent = mainStroke

local mainGradientTween = TweenService:Create(
    mainGradient,
    TweenInfo.new(config.rainbowSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Rotation = 360}
)
mainGradientTween:Play()

-- 标题栏（带拖拽功能）
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = config.theme.secondary
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Sxingz Hub自动汉化"
titleLabel.TextColor3 = config.theme.text
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = config.theme.error
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 17)
closeCorner.Parent = closeButton

-- 翻译模式选择区
local modeFrame = Instance.new("Frame")
modeFrame.Name = "ModeFrame"
modeFrame.Size = UDim2.new(0.95, 0, 0, 100)
modeFrame.Position = UDim2.new(0.025, 0, 0, 50)
modeFrame.BackgroundTransparency = 1
modeFrame.Parent = mainFrame

local modeTitle = Instance.new("TextLabel")
modeTitle.Name = "ModeTitle"
modeTitle.Size = UDim2.new(1, 0, 0, 20)
modeTitle.BackgroundTransparency = 1
modeTitle.Text = "翻译模式选择"
modeTitle.TextColor3 = config.theme.accent
modeTitle.TextSize = 14
modeTitle.Font = Enum.Font.GothamBold
modeTitle.Parent = modeFrame

-- 模式按钮容器
local modeButtonsFrame = Instance.new("Frame")
modeButtonsFrame.Name = "ModeButtonsFrame"
modeFrame.Size = UDim2.new(1, 0, 0, 80)
modeButtonsFrame.Position = UDim2.new(0, 0, 0, 25)
modeButtonsFrame.BackgroundTransparency = 1
modeButtonsFrame.Parent = modeFrame

local currentMode = 2 -- 默认智能分词模式
local modeButtons = {}

-- 创建模式按钮
for i, modeData in ipairs(config.translationModes) do
    local button = Instance.new("TextButton")
    button.Name = "ModeButton_" .. i
    button.Size = UDim2.new(0.23, -5, 0, 60)
    button.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    button.BackgroundColor3 = i == currentMode and config.theme.accent or config.theme.secondary
    button.Text = modeData.name .. "\n" .. modeData.desc
    button.TextColor3 = config.theme.text
    button.TextSize = 11
    button.Font = Enum.Font.Gotham
    button.TextWrapped = true
    button.TextYAlignment = Enum.TextYAlignment.Top
    button.Parent = modeButtonsFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = i == currentMode and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    buttonStroke.Thickness = 1.5
    buttonStroke.Parent = button
    
    -- 点击事件
    button.MouseButton1Click:Connect(function()
        currentMode = i
        for j, btn in ipairs(modeButtons) do
            btn.BackgroundColor3 = j == currentMode and config.theme.accent or config.theme.secondary
            btn:FindFirstChildOfClass("UIStroke").Color = j == currentMode and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        end
        updateStatus("已切换至：" .. modeData.name .. " - " .. modeData.desc)
    end)
    
    table.insert(modeButtons, button)
end

-- 核心控制区
local controlFrame = Instance.new("Frame")
controlFrame.Name = "ControlFrame"
controlFrame.Size = UDim2.new(0.95, 0, 0, 120)
controlFrame.Position = UDim2.new(0.025, 0, 0, 160)
controlFrame.BackgroundColor3 = config.theme.secondary
controlFrame.Parent = mainFrame

local controlCorner = Instance.new("UICorner")
controlCorner.CornerRadius = UDim.new(0, 10)
controlCorner.Parent = controlFrame

-- 执行按钮
local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(0.45, 0, 0, 45)
executeButton.Position = UDim2.new(0.05, 0, 0, 20)
executeButton.BackgroundColor3 = config.theme.success
executeButton.Text = "开始汉化"
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 16
executeButton.Font = Enum.Font.GothamBold
executeButton.Parent = controlFrame

local executeCorner = Instance.new("UICorner")
executeCorner.CornerRadius = UDim.new(0, 8)
executeCorner.Parent = executeButton

-- 停止按钮
local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Size = UDim2.new(0.45, 0, 0, 45)
stopButton.Position = UDim2.new(0.5, 0, 0, 20)
stopButton.BackgroundColor3 = config.theme.error
stopButton.Text = "停止汉化"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.TextSize = 16
stopButton.Font = Enum.Font.GothamBold
stopButton.Parent = controlFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 8)
stopCorner.Parent = stopButton

-- 高级设置按钮
local settingsButton = Instance.new("TextButton")
settingsButton.Name = "SettingsButton"
settingsButton.Size = UDim2.new(0.9, 0, 0, 30)
settingsButton.Position = UDim2.new(0.05, 0, 0, 75)
settingsButton.BackgroundColor3 = config.theme.secondary
settingsButton.Text = "设置"
settingsButton.TextColor3 = config.theme.accent
settingsButton.TextSize = 12
settingsButton.Font = Enum.Font.Gotham
settingsButton.Parent = controlFrame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 5)
settingsCorner.Parent = settingsButton

-- 状态显示区
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(0.95, 0, 0, 140)
statusFrame.Position = UDim2.new(0.025, 0, 0, 290)
statusFrame.BackgroundColor3 = config.theme.secondary
statusFrame.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusFrame

-- 状态标题
local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, 0, 0, 20)
statusTitle.Position = UDim2.new(0, 0, 0, 5)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "运行状态"
statusTitle.TextColor3 = config.theme.accent
statusTitle.TextSize = 12
statusTitle.Font = Enum.Font.GothamBold
statusTitle.Parent = statusFrame

-- 状态文本
local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(0.95, 0, 0, 20)
statusText.Position = UDim2.new(0.025, 0, 0, 30)
statusText.BackgroundTransparency = 1
statusText.Text = "当前状态：待机"
statusText.TextColor3 = config.theme.text
statusText.TextSize = 11
statusText.Font = Enum.Font.Gotham
statusText.Parent = statusFrame

-- 统计信息
local statsText = Instance.new("TextLabel")
statsText.Name = "StatsText"
statsText.Size = UDim2.new(0.95, 0, 0, 20)
statsText.Position = UDim2.new(0.025, 0, 0, 55)
statusText.BackgroundTransparency = 1
statsText.Text = "已翻译：0 | 缓存命中：0 | 速度：0 词/秒"
statsText.TextColor3 = config.theme.text
statsText.TextSize = 11
statsText.Font = Enum.Font.Gotham
statsText.Parent = statusFrame

-- 最近翻译
local recentText = Instance.new("TextLabel")
recentText.Name = "RecentText"
recentText.Size = UDim2.new(0.95, 0, 0, 40)
recentText.Position = UDim2.new(0.025, 0, 0, 80)
recentText.BackgroundTransparency = 1
recentText.Text = "最近翻译：无"
recentText.TextColor3 = config.theme.text
recentText.TextSize = 10
recentText.Font = Enum.Font.Gotham
recentText.TextWrapped = true
recentText.Parent = statusFrame

-- 高级设置窗口
local settingsWindow = Instance.new("Frame")
settingsWindow.Name = "SettingsWindow"
settingsWindow.Size = UDim2.new(0, 420, 0, 380)
settingsWindow.Position = UDim2.new(0.5, -210, 0.5, -190)
settingsWindow.BackgroundColor3 = config.theme.primary
settingsWindow.Visible = false
settingsWindow.ZIndex = 1001
settingsWindow.Parent = screenGui

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 15)
settingsCorner.Parent = settingsWindow

local settingsStroke = Instance.new("UIStroke")
settingsStroke.Thickness = 2
settingsStroke.Parent = settingsWindow

local settingsGradient = Instance.new("UIGradient")
settingsGradient.Color = rainbowColors
settingsGradient.Rotation = 0
settingsGradient.Parent = settingsStroke

-- 设置窗口标题栏
local settingsTitleBar = Instance.new("Frame")
settingsTitleBar.Name = "SettingsTitleBar"
settingsTitleBar.Size = UDim2.new(1, 0, 0, 40)
settingsTitleBar.BackgroundColor3 = config.theme.secondary
settingsTitleBar.Parent = settingsWindow

local settingsTitleLabel = Instance.new("TextLabel")
settingsTitleLabel.Name = "SettingsTitleLabel"
settingsTitleLabel.Size = UDim2.new(1, -40, 1, 0)
settingsTitleLabel.BackgroundTransparency = 1
settingsTitleLabel.Text = "设置"
settingsTitleLabel.TextColor3 = config.theme.text
settingsTitleLabel.TextSize = 16
settingsTitleLabel.Font = Enum.Font.GothamBold
settingsTitleLabel.Parent = settingsTitleBar

local settingsCloseButton = Instance.new("TextButton")
settingsCloseButton.Name = "SettingsCloseButton"
settingsCloseButton.Size = UDim2.new(0, 30, 0, 30)
settingsCloseButton.Position = UDim2.new(1, -35, 0, 5)
settingsCloseButton.BackgroundColor3 = config.theme.error
settingsCloseButton.Text = "×"
settingsCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsCloseButton.TextSize = 18
settingsCloseButton.Font = Enum.Font.GothamBold
settingsCloseButton.Parent = settingsTitleBar

local settingsCloseCorner = Instance.new("UICorner")
settingsCloseCorner.CornerRadius = UDim.new(0, 15)
settingsCloseCorner.Parent = settingsCloseButton

-- 缓存设置
local cacheSettingsFrame = Instance.new("Frame")
cacheSettingsFrame.Name = "CacheSettingsFrame"
cacheSettingsFrame.Size = UDim2.new(0.9, 0, 0, 70)
cacheSettingsFrame.Position = UDim2.new(0.05, 0, 0, 50)
cacheSettingsFrame.BackgroundTransparency = 1
cacheSettingsFrame.Parent = settingsWindow

local cacheTitle = Instance.new("TextLabel")
cacheTitle.Name = "CacheTitle"
cacheTitle.Size = UDim2.new(1, 0, 0, 20)
cacheTitle.BackgroundTransparency = 1
cacheTitle.Text = "缓存设置"
cacheTitle.TextColor3 = config.theme.accent
cacheTitle.TextSize = 13
cacheTitle.Font = Enum.Font.GothamBold
cacheTitle.Parent = cacheSettingsFrame

local cacheToggle = Instance.new("TextButton")
cacheToggle.Name = "CacheToggle"
cacheToggle.Size = UDim2.new(0.45, 0, 0, 30)
cacheToggle.Position = UDim2.new(0, 0, 0, 25)
cacheToggle.BackgroundColor3 = config.theme.success
cacheToggle.Text = "启用缓存"
cacheToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
cacheToggle.TextSize = 12
cacheToggle.Font = Enum.Font.Gotham
cacheToggle.Parent = cacheSettingsFrame

local cacheClearButton = Instance.new("TextButton")
cacheClearButton.Name = "CacheClearButton"
cacheClearButton.Size = UDim2.new(0.45, 0, 0, 30)
cacheClearButton.Position = UDim2.new(0.55, 0, 0, 25)
cacheClearButton.BackgroundColor3 = config.theme.warning
cacheClearButton.Text = "清空缓存"
cacheClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cacheClearButton.TextSize = 12
cacheToggle.Font = Enum.Font.Gotham
cacheClearButton.Parent = cacheSettingsFrame

-- 扫描速度设置
local speedSettingsFrame = Instance.new("Frame")
speedSettingsFrame.Name = "SpeedSettingsFrame"
speedSettingsFrame.Size = UDim2.new(0.9, 0, 0, 70)
speedSettingsFrame.Position = UDim2.new(0.05, 0, 0, 130)
speedSettingsFrame.BackgroundTransparency = 1
speedSettingsFrame.Parent = settingsWindow

local speedTitle = Instance.new("TextLabel")
speedTitle.Name = "SpeedTitle"
speedTitle.Size = UDim2.new(1, 0, 0, 20)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "扫描速度设置"
speedTitle.TextColor3 = config.theme.accent
speedTitle.TextSize = 13
speedTitle.Font = Enum.Font.GothamBold
speedTitle.Parent = speedSettingsFrame

-- 速度滑块
local speedSlider = Instance.new("Frame")
speedSlider.Name = "SpeedSlider"
speedSlider.Size = UDim2.new(1, 0, 0, 30)
speedSlider.Position = UDim2.new(0, 0, 0, 25)
speedSlider.BackgroundTransparency = 1
speedSlider.Parent = speedSettingsFrame

local speedBar = Instance.new("Frame")
speedBar.Name = "SpeedBar"
speedBar.Size = UDim2.new(1, 0, 0, 6)
speedBar.Position = UDim2.new(0, 0, 0.5, -3)
speedBar.BackgroundColor3 = config.theme.secondary
speedBar.Parent = speedSlider

local speedBarCorner = Instance.new("UICorner")
speedBarCorner.CornerRadius = UDim.new(0, 3)
speedBarCorner.Parent = speedBar

local speedFill = Instance.new("Frame")
speedFill.Name = "SpeedFill"
speedFill.Size = UDim2.new(0.5, 0, 1, 0)
speedFill.BackgroundColor3 = config.theme.accent
speedFill.Parent = speedBar

local speedFillCorner = Instance.new("UICorner")
speedFillCorner.CornerRadius = UDim.new(0, 3)
speedFillCorner.Parent = speedFill

local speedHandle = Instance.new("TextButton")
speedHandle.Name = "SpeedHandle"
speedHandle.Size = UDim2.new(0, 18, 0, 18)
speedHandle.Position = UDim2.new(0.5, -9, 0.5, -9)
speedHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedHandle.Text = ""
speedHandle.ZIndex = 1002
speedHandle.Parent = speedSlider

local speedHandleCorner = Instance.new("UICorner")
speedHandleCorner.CornerRadius = UDim.new(0, 9)
speedHandleCorner.Parent = speedHandle

-- 自定义规则设置
local customRulesFrame = Instance.new("Frame")
customRulesFrame.Name = "CustomRulesFrame"
customRulesFrame.Size = UDim2.new(0.9, 0, 0, 100)
customRulesFrame.Position = UDim2.new(0.05, 0, 0, 210)
customRulesFrame.BackgroundTransparency = 1
customRulesFrame.Parent = settingsWindow

local customRulesTitle = Instance.new("TextLabel")
customRulesTitle.Name = "CustomRulesTitle"
customRulesTitle.Size = UDim2.new(1, 0, 0, 20)
customRulesTitle.BackgroundTransparency = 1
customRulesTitle.Text = "自定义翻译规则"
customRulesTitle.TextColor3 = config.theme.accent
customRulesTitle.TextSize = 13
customRulesTitle.Font = Enum.Font.GothamBold
customRulesTitle.Parent = customRulesFrame

-- 规则输入框
local ruleInput = Instance.new("TextBox")
ruleInput.Name = "RuleInput"
ruleInput.Size = UDim2.new(0.7, 0, 0, 25)
ruleInput.Position = UDim2.new(0, 0, 0, 25)
ruleInput.BackgroundColor3 = config.theme.secondary
ruleInput.TextColor3 = config.theme.text
ruleInput.PlaceholderText = "格式：匹配文本|替换文本"
ruleInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
ruleInput.TextSize = 11
ruleInput.Font = Enum.Font.Gotham
ruleInput.Parent = customRulesFrame

local addRuleButton = Instance.new("TextButton")
addRuleButton.Name = "AddRuleButton"
addRuleButton.Size = UDim2.new(0.25, 0, 0, 25)
addRuleButton.Position = UDim2.new(0.75, 0, 0, 25)
addRuleButton.BackgroundColor3 = config.theme.success
addRuleButton.Text = "添加规则"
addRuleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
addRuleButton.TextSize = 11
addRuleButton.Font = Enum.Font.Gotham
addRuleButton.Parent = customRulesFrame

-- 保存设置按钮
local saveSettingsButton = Instance.new("TextButton")
saveSettingsButton.Name = "SaveSettingsButton"
saveSettingsButton.Size = UDim2.new(0.6, 0, 0, 35)
saveSettingsButton.Position = UDim2.new(0.2, 0, 0, 320)
saveSettingsButton.BackgroundColor3 = config.theme.success
saveSettingsButton.Text = "保存设置"
saveSettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveSettingsButton.TextSize = 14
saveSettingsButton.Font = Enum.Font.GothamBold
saveSettingsButton.Parent = settingsWindow

local saveSettingsCorner = Instance.new("UICorner")
saveSettingsCorner.CornerRadius = UDim.new(0, 8)
saveSettingsCorner.Parent = saveSettingsButton

-- 工具函数：更新状态
local function updateStatus(message, isError)
    statusText.Text = "当前状态：" .. message
    statusText.TextColor3 = isError and config.theme.error or config.theme.text
end

-- 工具函数：更新统计
local function updateStats(translatedCount, cacheHits, speed)
    statsText.Text = string.format("已翻译：%d | 缓存命中：%d | 速度：%d 词/秒", translatedCount, cacheHits, speed)
end

-- 工具函数：更新最近翻译
local function updateRecentTranslation(original, translated)
    local displayText = original .. " → " .. translated
    if #displayText > 60 then
        displayText = displayText:sub(1, 57) .. "..."
    end
    recentText.Text = "最近翻译：" .. displayText
end

-- 缓存管理函数
local function manageCache()
    -- 清除过期缓存
    local currentTime = tick()
    for key, timestamp in pairs(translationCache.timestamps) do
        if currentTime - timestamp > config.cacheExpireTime then
            translationCache.data[key] = nil
            translationCache.timestamps[key] = nil
        end
    end
    
    -- 限制缓存大小
    local cacheKeys = {}
    for key in pairs(translationCache.data) do
        table.insert(cacheKeys, key)
    end
    
    if #cacheKeys > config.maxCacheSize then
        -- 按时间排序，删除最早的
        table.sort(cacheKeys, function(a, b)
            return translationCache.timestamps[a] < translationCache.timestamps[b]
        end)
        
        for i = 1, #cacheKeys - config.maxCacheSize do
            translationCache.data[cacheKeys[i]] = nil
            translationCache.timestamps[cacheKeys[i]] = nil
        end
    end
end

-- 翻译核心函数（增强版）
local function translateText(text)
    if not text or type(text) ~= "string" or text == "" then
        return text, false
    end
    
    -- 先检查自定义规则
    for _, rule in ipairs(customRules) do
        if rule[1] == currentMode then
            local pattern = rule[2]
            local replacement = rule[3]
            local newText, count = text:gsub(pattern, replacement)
            if count > 0 then
                return newText, true
            end
        end
    end
    
    -- 检查缓存
    manageCache()
    if translationCache.data[text] then
        translationCache.timestamps[text] = tick() -- 更新访问时间
        return translationCache.data[text], true
    end
    
    local translatedText = text
    local hasTranslated = false
    
    -- 根据模式执行翻译
    if currentMode == 1 then
        -- 快速匹配：完全匹配
        if phraseDictionary[text] then
            translatedText = phraseDictionary[text]
            hasTranslated = true
        end
        
    elseif currentMode == 2 then
        -- 智能分词：单词级匹配
        local words = {}
        for word in text:gmatch("%S+") do
            table.insert(words, phraseDictionary[word] or word)
        end
        translatedText = table.concat(words, " ")
        hasTranslated = translatedText ~= text
        
    elseif currentMode == 3 then
        -- 深度解析：长句优先匹配
        local sortedKeys = {}
        for key in pairs(phraseDictionary) do
            table.insert(sortedKeys, key)
        end
        
        -- 按长度排序，优先匹配长文本
        table.sort(sortedKeys, function(a, b)
            return #a > #b
        end)
        
        for _, key in ipairs(sortedKeys) do
            local pattern = "%f[%w_]" .. key:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1") .. "%f[^%w_]"
            local replacement = phraseDictionary[key]
            local newText, count = translatedText:gsub(pattern, replacement)
            if count > 0 then
                translatedText = newText
                hasTranslated = true
            end
        end
        
    elseif currentMode == 4 then
        -- 自定义规则：已在最前面处理
    end
    
    -- 存入缓存
    if hasTranslated then
        translationCache.data[text] = translatedText
        translationCache.timestamps[text] = tick()
    end
    
    return translatedText, hasTranslated
end

-- 安全设置文本（防止报错）
local function safeSetText(element, text)
    if not element or not element.Parent then
        return false
    end
    
    local success, err = pcall(function()
        element.Text = text
    end)
    
    return success
end

-- UI扫描与翻译函数
local isTranslating = false
local translationStats = {
    total = 0,
    cacheHits = 0,
    lastCheckTime = 0,
    lastCount = 0
}

local function scanAndTranslate()
    if not isTranslating then
        return
    end
    
    -- 计算翻译速度
    local currentTime = tick()
    if currentTime - translationStats.lastCheckTime >= 1 then
        local speed = translationStats.total - translationStats.lastCount
        updateStats(translationStats.total, translationStats.cacheHits, speed)
        translationStats.lastCount = translationStats.total
        translationStats.lastCheckTime = currentTime
    end
    
    -- 收集所有文本元素
    local textElements = {}
    
    local function collectElements(parent)
        if not parent or not parent.Parent then
            return
        end
        
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                table.insert(textElements, child)
            end
            collectElements(child)
        end
    end
    
    -- 扫描玩家UI和核心UI
    collectElements(playerGui)
    collectElements(CoreGui)
    
    -- 执行翻译
    for _, element in ipairs(textElements) do
        if isTranslating and element.Parent then
            local originalText = element.Text
            if originalText and originalText ~= "" then
                local translatedText, wasTranslated = translateText(originalText)
                if wasTranslated and translatedText ~= originalText then
                    if safeSetText(element, translatedText) then
                        translationStats.total = translationStats.total + 1
                        updateRecentTranslation(originalText, translatedText)
                        
                        -- 检查是否是缓存命中
                        if translationCache.data[originalText] then
                            translationStats.cacheHits = translationStats.cacheHits + 1
                        end
                    end
                end
            end
        end
    end
end

-- 开始翻译
local function startTranslation()
    if isTranslating then
        updateStatus("已在翻译中", true)
        return
    end
    
    isTranslating = true
    executeButton.BackgroundColor3 = config.theme.warning
    executeButton.Text = "翻译中..."
    updateStatus(config.translationModes[currentMode].name .. " 正在执行翻译")
    
    -- 重置统计
    translationStats = {
        total = 0,
        cacheHits = 0,
        lastCheckTime = tick(),
        lastCount = 0
    }
    
    -- 启动扫描循环
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not isTranslating then
            connection:Disconnect()
            return
        end
        scanAndTranslate()
    end)
end

-- 停止翻译
local function stopTranslation()
    if not isTranslating then
        updateStatus("未在翻译中", true)
        return
    end
    
    isTranslating = false
    executeButton.BackgroundColor3 = config.theme.success
    executeButton.Text = "开始汉化"
    updateStatus("翻译已停止")
end

-- 清空缓存
local function clearCache()
    translationCache.data = {}
    translationCache.timestamps = {}
    updateStatus("缓存已清空")
    updateStats(translationStats.total, 0, 0)
end

-- 添加自定义规则
local function addCustomRule(inputText)
    local parts = string.split(inputText, "|")
    if #parts ~= 2 then
        updateStatus("规则格式错误，正确格式：匹配文本|替换文本", true)
        return
    end
    
    local pattern = parts[1]:trim()
    local replacement = parts[2]:trim()
    
    if pattern == "" or replacement == "" then
        updateStatus("匹配文本和替换文本不能为空", true)
        return
    end
    
    -- 添加到当前模式的规则
    table.insert(customRules, {currentMode, pattern, replacement, #customRules + 1})
    updateStatus("已添加自定义规则：" .. pattern .. " → " .. replacement)
    ruleInput.Text = ""
end

-- UI交互事件
controlButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

executeButton.MouseButton1Click:Connect(startTranslation)
stopButton.MouseButton1Click:Connect(stopTranslation)

settingsButton.MouseButton1Click:Connect(function()
    settingsWindow.Visible = true
end)

settingsCloseButton.MouseButton1Click:Connect(function()
    settingsWindow.Visible = false
end)

cacheToggle.MouseButton1Click:Connect(function()
    local isEnabled = cacheToggle.BackgroundColor3 == config.theme.success
    cacheToggle.BackgroundColor3 = isEnabled and config.theme.error or config.theme.success
    cacheToggle.Text = isEnabled and "禁用缓存" or "启用缓存"
    config.cacheEnabled = not isEnabled
    updateStatus("缓存已" .. (isEnabled and "禁用" or "启用"))
end)

cacheClearButton.MouseButton1Click:Connect(clearCache)

addRuleButton.MouseButton1Click:Connect(function()
    addCustomRule(ruleInput.Text)
end)

saveSettingsButton.MouseButton1Click:Connect(function()
    settingsWindow.Visible = false
    updateStatus("设置已保存")
end)

-- 速度滑块拖拽
local isDraggingSpeed = false
speedHandle.MouseButton1Down:Connect(function()
    isDraggingSpeed = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingSpeed = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
        local absolutePos = speedSlider.AbsolutePosition
        local absoluteSize = speedSlider.AbsoluteSize
        local mouseX = input.Position.X - absolutePos.X
        
        -- 限制在滑块范围内
        local percentage = math.clamp(mouseX / absoluteSize.X, 0, 1)
        speedHandle.Position = UDim2.new(percentage, -9, 0.5, -9)
        speedFill.Size = UDim2.new(percentage, 0, 1, 0)
        
        -- 更新扫描速度（百分比越高，速度越快，冷却时间越短）
        config.defaultScanCooldown = 0.5 - (percentage * 0.45)
        updateStatus("扫描速度已设置为：" .. string.format("%.2f", 1/config.defaultScanCooldown) .. " 次/秒")
    end
end)

-- 窗口拖拽功能
local function makeDraggable(window, dragHandle)
    local isDragging = false
    local startPos = Vector2.new()
    local windowStartPos = UDim2.new()
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            startPos = input.Position
            windowStartPos = window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startPos
            window.Position = UDim2.new(
                0, windowStartPos.X.Offset + delta.X,
                0, windowStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
end

-- 启用窗口拖拽
makeDraggable(mainFrame, titleBar)
makeDraggable(settingsWindow, settingsTitleBar)
makeDraggable(controlButton, controlButton)

-- 初始化
local function initialize()
    print("========================================")
    print("Sxingz Hub自动汉化 已加载")
    print("当前翻译模式：" .. config.translationModes[currentMode].name)
    print("功能特性：")
    print("  - 四种翻译模式，适应不同场景")
    print("  - 智能缓存系统，提升翻译效率")
    print("  - 自定义翻译规则，灵活扩展")
    print("  - 实时统计监控，翻译状态可视化")
    print("========================================")
    
    -- 初始设置
    config.cacheEnabled = true
    updateStatus("准备就绪，点击开始汉化")
    updateStats(0, 0, 0)
end

-- 启动初始化
initialize()
