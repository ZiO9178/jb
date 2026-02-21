--=============================================================================
-- Delta X Injector - iOS 26 Liquid Glass UI Library
-- 版本: 2.0 (极致液态玻璃版)
-- 特性: 全圆角化, 毛玻璃背景, 丝滑缓动动画, 清晰字体排版, 高级事件托管
--=============================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--=============================================================================
-- 核心配置与工具函数
--=============================================================================

local LiquidGlassUI = {}
LiquidGlassUI.Elements = {}
LiquidGlassUI.Theme = {
    MainBackground = Color3.fromRGB(20, 20, 25),
    MainTransparency = 0.4,
    StrokeColor = Color3.fromRGB(255, 255, 255),
    StrokeTransparency = 0.85,
    AccentColor = Color3.fromRGB(10, 132, 255), -- iOS Blue
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(180, 180, 180),
    ElementBackground = Color3.fromRGB(35, 35, 40),
    ElementTransparency = 0.5,
    HoverBackground = Color3.fromRGB(45, 45, 55),
    FontMain = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 14),
    AnimTime = 0.35,
    AnimStyle = Enum.EasingStyle.Quint,
    AnimDirection = Enum.EasingDirection.Out
}

local function CreateTween(instance, properties, duration)
    duration = duration or LiquidGlassUI.Theme.AnimTime
    local tweenInfo = TweenInfo.new(duration, LiquidGlassUI.Theme.AnimStyle, LiquidGlassUI.Theme.AnimDirection)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(topbar, frame)
    local dragging = false
    local dragInput, mousePos, framePos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            local newPos = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
            CreateTween(frame, {Position = newPos}, 0.1)
        end
    end)
end

local function CreateRipple(parent, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Parent = parent
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.6
    ripple.ZIndex = parent.ZIndex + 1
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, x, 0, y)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    ripple.Size = UDim2.new(0, 0, 0, 0)
    
    local tween = TweenService:Create(ripple, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, parent.AbsoluteSize.X * 2, 0, parent.AbsoluteSize.X * 2),
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

--=============================================================================
-- UI库核心：创建窗口 (Window)
--=============================================================================

function LiquidGlassUI:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "Delta X 注入器"
    local Subtitle = options.Subtitle or "未命名副标题"
    local BottomText = options.BottomText or "就绪"
    local WindowIcon = options.Icon or "rbxassetid://110034606276800"
    local BackgroundImage = options.BackgroundImage or ""
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeltaXLiquidGlassUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    -- 兼容不同的执行器环境
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end

    -- 主框架
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = LiquidGlassUI.Theme.MainBackground
    MainFrame.BackgroundTransparency = LiquidGlassUI.Theme.MainTransparency
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.ClipsDescendants = false

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = LiquidGlassUI.Theme.CornerRadius
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = LiquidGlassUI.Theme.StrokeColor
    MainStroke.Transparency = LiquidGlassUI.Theme.StrokeTransparency
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    -- 毛玻璃背景图层 / 模糊模拟
    if BackgroundImage ~= "" then
        local BgImage = Instance.new("ImageLabel")
        BgImage.Name = "BackgroundImage"
        BgImage.Parent = MainFrame
        BgImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BgImage.BackgroundTransparency = 1
        BgImage.Size = UDim2.new(1, 0, 1, 0)
        BgImage.ZIndex = 0
        BgImage.Image = BackgroundImage
        BgImage.ImageTransparency = 0.5
        BgImage.ScaleType = Enum.ScaleType.Crop
        local BgCorner = Instance.new("UICorner")
        BgCorner.CornerRadius = LiquidGlassUI.Theme.CornerRadius
        BgCorner.Parent = BgImage
    end

    -- 投影效果
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "DropShadow"
    Shadow.Parent = MainFrame
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -30, 0, -30)
    Shadow.Size = UDim2.new(1, 60, 1, 60)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://5554865466"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.3
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(95, 95, 205, 205)

    -- 顶栏 (Topbar)
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Topbar.BackgroundTransparency = 1
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    
    MakeDraggable(Topbar, MainFrame)

    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Name = "Icon"
    IconLabel.Parent = Topbar
    IconLabel.BackgroundTransparency = 1
    IconLabel.Position = UDim2.new(0, 15, 0, 12)
    IconLabel.Size = UDim2.new(0, 26, 0, 26)
    IconLabel.Image = WindowIcon

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = Topbar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 50, 0, 8)
    TitleLabel.Size = UDim2.new(0, 300, 0, 20)
    TitleLabel.Font = LiquidGlassUI.Theme.FontBold
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = LiquidGlassUI.Theme.TextColor
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Parent = Topbar
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 50, 0, 28)
    SubtitleLabel.Size = UDim2.new(0, 300, 0, 14)
    SubtitleLabel.Font = LiquidGlassUI.Theme.FontMain
    SubtitleLabel.Text = Subtitle
    SubtitleLabel.TextColor3 = LiquidGlassUI.Theme.AccentColor
    SubtitleLabel.TextSize = 13
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- 顶栏分割线
    local TopDivider = Instance.new("Frame")
    TopDivider.Name = "TopDivider"
    TopDivider.Parent = MainFrame
    TopDivider.BackgroundColor3 = LiquidGlassUI.Theme.StrokeColor
    TopDivider.BackgroundTransparency = 0.9
    TopDivider.Position = UDim2.new(0, 0, 0, 50)
    TopDivider.Size = UDim2.new(1, 0, 0, 1)

    -- 控制按钮容器 (关闭、最小化)
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Parent = Topbar
    Controls.BackgroundTransparency = 1
    Controls.Position = UDim2.new(1, -90, 0, 0)
    Controls.Size = UDim2.new(0, 90, 1, 0)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = Controls
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(0, 50, 0, 15)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
    CloseBtn.TextSize = 18

    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "MinBtn"
    MinBtn.Parent = Controls
    MinBtn.BackgroundTransparency = 1
    MinBtn.Position = UDim2.new(0, 15, 0, 15)
    MinBtn.Size = UDim2.new(0, 20, 0, 20)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
    MinBtn.TextSize = 18

    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            CreateTween(MainFrame, {Size = UDim2.new(0, 700, 0, 50)})
            for _, child in pairs(MainFrame:GetChildren()) do
                if child.Name ~= "Topbar" and child.Name ~= "UICorner" and child.Name ~= "UIStroke" and child.Name ~= "DropShadow" and child.Name ~= "BackgroundImage" then
                    CreateTween(child, {BackgroundTransparency = 1})
                    if child:IsA("TextLabel") then CreateTween(child, {TextTransparency = 1}) end
                    child.Visible = false
                end
            end
        else
            CreateTween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)})
            for _, child in pairs(MainFrame:GetChildren()) do
                if child.Name ~= "Topbar" and child.Name ~= "UICorner" and child.Name ~= "UIStroke" and child.Name ~= "DropShadow" and child.Name ~= "BackgroundImage" then
                    child.Visible = true
                    CreateTween(child, {BackgroundTransparency = 0})
                    if child:IsA("TextLabel") then CreateTween(child, {TextTransparency = 0}) end
                end
            end
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        local closeTween = CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        for _, child in pairs(MainFrame:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                CreateTween(child, {TextTransparency = 1})
            elseif child:IsA("ImageLabel") then
                CreateTween(child, {ImageTransparency = 1})
            elseif child:IsA("UIStroke") then
                CreateTween(child, {Transparency = 1})
            elseif child:IsA("Frame") or child:IsA("ScrollingFrame") then
                CreateTween(child, {BackgroundTransparency = 1})
            end
        end
        closeTween.Completed:Wait()
        ScreenGui:Destroy()
    end)

    -- 底栏 (Bottom Info Bar)
    local BottomBar = Instance.new("Frame")
    BottomBar.Name = "BottomBar"
    BottomBar.Parent = MainFrame
    BottomBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BottomBar.BackgroundTransparency = 1
    BottomBar.Position = UDim2.new(0, 0, 1, -30)
    BottomBar.Size = UDim2.new(1, 0, 0, 30)

    local BottomDivider = Instance.new("Frame")
    BottomDivider.Name = "BottomDivider"
    BottomDivider.Parent = BottomBar
    BottomDivider.BackgroundColor3 = LiquidGlassUI.Theme.StrokeColor
    BottomDivider.BackgroundTransparency = 0.9
    BottomDivider.Position = UDim2.new(0, 0, 0, 0)
    BottomDivider.Size = UDim2.new(1, 0, 0, 1)

    local BottomInfo = Instance.new("TextLabel")
    BottomInfo.Name = "BottomInfo"
    BottomInfo.Parent = BottomBar
    BottomInfo.BackgroundTransparency = 1
    BottomInfo.Position = UDim2.new(0, 15, 0, 0)
    BottomInfo.Size = UDim2.new(1, -30, 1, 0)
    BottomInfo.Font = LiquidGlassUI.Theme.FontMain
    BottomInfo.Text = BottomText
    BottomInfo.TextColor3 = LiquidGlassUI.Theme.SubTextColor
    BottomInfo.TextSize = 13
    BottomInfo.TextXAlignment = Enum.TextXAlignment.Left

    -- 侧边栏 (导航选项卡)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Sidebar.BackgroundTransparency = 0.8
    Sidebar.Position = UDim2.new(0, 0, 0, 51)
    Sidebar.Size = UDim2.new(0, 180, 1, -81)

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 0) -- 直角或可以自定义
    SidebarCorner.Parent = Sidebar

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 15)

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Name = "SidebarDivider"
    SidebarDivider.Parent = Sidebar
    SidebarDivider.BackgroundColor3 = LiquidGlassUI.Theme.StrokeColor
    SidebarDivider.BackgroundTransparency = 0.9
    SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)

    -- 内容容器 (Content Area)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 180, 0, 51)
    ContentContainer.Size = UDim2.new(1, -180, 1, -81)

    local WindowObj = {
        MainFrame = MainFrame,
        ContentContainer = ContentContainer,
        Sidebar = Sidebar,
        Tabs = {},
        CurrentTab = nil
    }

    --=============================================================================
    -- UI组件库：创建选项卡 (Tab)
    --=============================================================================

    function WindowObj:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local TabTitle = tabOptions.Title or "新标签页"
        local TabIcon = tabOptions.Icon or "rbxassetid://10888331510"

        -- 导航按钮
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. TabTitle
        TabButton.Parent = Sidebar
        TabButton.BackgroundColor3 = LiquidGlassUI.Theme.AccentColor
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, -20, 0, 40)
        TabButton.Font = LiquidGlassUI.Theme.FontBold
        TabButton.Text = ""
        TabButton.AutoButtonColor = false

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 10)
        TabBtnCorner.Parent = TabButton

        local TabBtnIcon = Instance.new("ImageLabel")
        TabBtnIcon.Name = "Icon"
        TabBtnIcon.Parent = TabButton
        TabBtnIcon.BackgroundTransparency = 1
        TabBtnIcon.Position = UDim2.new(0, 15, 0.5, -10)
        TabBtnIcon.Size = UDim2.new(0, 20, 0, 20)
        TabBtnIcon.Image = TabIcon
        TabBtnIcon.ImageColor3 = LiquidGlassUI.Theme.SubTextColor

        local TabBtnText = Instance.new("TextLabel")
        TabBtnText.Name = "Title"
        TabBtnText.Parent = TabButton
        TabBtnText.BackgroundTransparency = 1
        TabBtnText.Position = UDim2.new(0, 45, 0, 0)
        TabBtnText.Size = UDim2.new(1, -50, 1, 0)
        TabBtnText.Font = LiquidGlassUI.Theme.FontBold
        TabBtnText.Text = TabTitle
        TabBtnText.TextColor3 = LiquidGlassUI.Theme.SubTextColor
        TabBtnText.TextSize = 15
        TabBtnText.TextXAlignment = Enum.TextXAlignment.Left

        -- 内容页面 (ScrollingFrame)
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = "Page_" .. TabTitle
        TabPage.Parent = ContentContainer
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness = 4
        TabPage.ScrollBarImageColor3 = LiquidGlassUI.Theme.AccentColor
        TabPage.Visible = false
        TabPage.BorderSizePixel = 0
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = TabPage
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = TabPage
        PagePadding.PaddingTop = UDim.new(0, 15)
        PagePadding.PaddingBottom = UDim.new(0, 15)

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
        end)

        -- 标签切换逻辑
        local function ActivateTab()
            if WindowObj.CurrentTab then
                WindowObj.CurrentTab.Page.Visible = false
                CreateTween(WindowObj.CurrentTab.Button, {BackgroundTransparency = 1})
                CreateTween(WindowObj.CurrentTab.Icon, {ImageColor3 = LiquidGlassUI.Theme.SubTextColor})
                CreateTween(WindowObj.CurrentTab.Text, {TextColor3 = LiquidGlassUI.Theme.SubTextColor})
            end
            
            TabPage.Visible = true
            CreateTween(TabButton, {BackgroundTransparency = 0.8})
            CreateTween(TabBtnIcon, {ImageColor3 = LiquidGlassUI.Theme.AccentColor})
            CreateTween(TabBtnText, {TextColor3 = LiquidGlassUI.Theme.TextColor})
            
            -- 加入切换动画
            TabPage.Position = UDim2.new(0, 20, 0, 0)
            TabPage.CanvasPosition = Vector2.new(0, 0)
            CreateTween(TabPage, {Position = UDim2.new(0, 0, 0, 0)}, 0.4)
            
            WindowObj.CurrentTab = {Page = TabPage, Button = TabButton, Icon = TabBtnIcon, Text = TabBtnText}
        end

        TabButton.MouseButton1Click:Connect(ActivateTab)
        
        -- 默认选中第一个
        if #WindowObj.Tabs == 0 then
            ActivateTab()
        end
        
        table.insert(WindowObj.Tabs, TabPage)

        local TabObj = {
            Page = TabPage
        }

        --=============================================================================
        -- UI组件：按钮 (Button)
        --=============================================================================
        function TabObj:CreateButton(btnOptions)
            btnOptions = btnOptions or {}
            local BtnTitle = btnOptions.Title or "按钮组件"
            local BtnDesc = btnOptions.Desc or ""
            local BtnIcon = btnOptions.Icon or "rbxassetid://10888331510"
            local BtnLocked = btnOptions.Locked or false
            local Callback = btnOptions.Callback or function() end

            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = "Button_" .. BtnTitle
            ButtonFrame.Parent = TabPage
            ButtonFrame.BackgroundColor3 = LiquidGlassUI.Theme.ElementBackground
            ButtonFrame.BackgroundTransparency = LiquidGlassUI.Theme.ElementTransparency
            ButtonFrame.Size = UDim2.new(1, -30, 0, 50)
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Text = ""
            ButtonFrame.ClipsDescendants = true

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = LiquidGlassUI.Theme.CornerRadius
            BtnCorner.Parent = ButtonFrame

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = LiquidGlassUI.Theme.StrokeColor
            BtnStroke.Transparency = LiquidGlassUI.Theme.StrokeTransparency
            BtnStroke.Thickness = 1
            BtnStroke.Parent = ButtonFrame

            local TitleLbl = Instance.new("TextLabel")
            TitleLbl.Parent = ButtonFrame
            TitleLbl.BackgroundTransparency = 1
            TitleLbl.Position = UDim2.new(0, 15, 0, BtnDesc == "" and 0 or 8)
            TitleLbl.Size = UDim2.new(1, -50, BtnDesc == "" and 1 or 0, BtnDesc == "" and 0 or 18)
            TitleLbl.Font = LiquidGlassUI.Theme.FontBold
            TitleLbl.Text = BtnTitle
            TitleLbl.TextColor3 = LiquidGlassUI.Theme.TextColor
            TitleLbl.TextSize = 16
            TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

            if BtnDesc ~= "" then
                local DescLbl = Instance.new("TextLabel")
                DescLbl.Parent = ButtonFrame
                DescLbl.BackgroundTransparency = 1
                DescLbl.Position = UDim2.new(0, 15, 0, 26)
                DescLbl.Size = UDim2.new(1, -50, 0, 16)
                DescLbl.Font = LiquidGlassUI.Theme.FontMain
                DescLbl.Text = BtnDesc
                DescLbl.TextColor3 = LiquidGlassUI.Theme.SubTextColor
                DescLbl.TextSize = 13
                DescLbl.TextXAlignment = Enum.TextXAlignment.Left
            end

            local ActionIcon = Instance.new("ImageLabel")
            ActionIcon.Parent = ButtonFrame
            ActionIcon.BackgroundTransparency = 1
            ActionIcon.Position = UDim2.new(1, -35, 0.5, -10)
            ActionIcon.Size = UDim2.new(0, 20, 0, 20)
            ActionIcon.Image = BtnLocked and "rbxassetid://10888331510" or "rbxassetid://10888331510" -- Lock/Click icon
            ActionIcon.ImageColor3 = LiquidGlassUI.Theme.SubTextColor

            -- 交互动画
            ButtonFrame.MouseEnter:Connect(function()
                if not BtnLocked then
                    CreateTween(ButtonFrame, {BackgroundColor3 = LiquidGlassUI.Theme.HoverBackground})
                    CreateTween(ActionIcon, {Position = UDim2.new(1, -30, 0.5, -10), ImageColor3 = LiquidGlassUI.Theme.AccentColor})
                end
            end)

            ButtonFrame.MouseLeave:Connect(function()
                if not BtnLocked then
                    CreateTween(ButtonFrame, {BackgroundColor3 = LiquidGlassUI.Theme.ElementBackground})
                    CreateTween(ActionIcon, {Position = UDim2.new(1, -35, 0.5, -10), ImageColor3 = LiquidGlassUI.Theme.SubTextColor})
                end
            end)

            ButtonFrame.MouseButton1Down:Connect(function()
                if not BtnLocked then
                    CreateTween(ButtonFrame, {Size = UDim2.new(1, -36, 0, 46)})
                end
            end)

            ButtonFrame.MouseButton1Up:Connect(function()
                if not BtnLocked then
                    CreateTween(ButtonFrame, {Size = UDim2.new(1, -30, 0, 50)})
                end
            end)

            ButtonFrame.MouseButton1Click:Connect(function()
                if not BtnLocked then
                    CreateRipple(ButtonFrame, Mouse.X - ButtonFrame.AbsolutePosition.X, Mouse.Y - ButtonFrame.AbsolutePosition.Y)
                    pcall(Callback)
                end
            end)
        end

        --=============================================================================
        -- UI组件：开关 (Toggle)
        --=============================================================================
        function TabObj:CreateToggle(tglOptions)
            tglOptions = tglOptions or {}
            local TglTitle = tglOptions.Title or "开关组件"
            local TglDesc = tglOptions.Desc or ""
            local Default = tglOptions.Default or false
            local Callback = tglOptions.Callback or function() end

            local State = Default

            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Name = "Toggle_" .. TglTitle
            ToggleFrame.Parent = TabPage
            ToggleFrame.BackgroundColor3 = LiquidGlassUI.Theme.ElementBackground
            ToggleFrame.BackgroundTransparency = LiquidGlassUI.Theme.ElementTransparency
            ToggleFrame.Size = UDim2.new(1, -30, 0, 50)
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Text = ""

            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = LiquidGlassUI.Theme.CornerRadius
            TglCorner.Parent = ToggleFrame

            local TglStroke = Instance.new("UIStroke")
            TglStroke.Color = LiquidGlassUI.Theme.StrokeColor
            TglStroke.Transparency = LiquidGlassUI.Theme.StrokeTransparency
            TglStroke.Thickness = 1
            TglStroke.Parent = ToggleFrame

            local TitleLbl = Instance.new("TextLabel")
            TitleLbl.Parent = ToggleFrame
            TitleLbl.BackgroundTransparency = 1
            TitleLbl.Position = UDim2.new(0, 15, 0, TglDesc == "" and 0 or 8)
            TitleLbl.Size = UDim2.new(1, -90, TglDesc == "" and 1 or 0, TglDesc == "" and 0 or 18)
            TitleLbl.Font = LiquidGlassUI.Theme.FontBold
            TitleLbl.Text = TglTitle
            TitleLbl.TextColor3 = LiquidGlassUI.Theme.TextColor
            TitleLbl.TextSize = 16
            TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

            if TglDesc ~= "" then
                local DescLbl = Instance.new("TextLabel")
                DescLbl.Parent = ToggleFrame
                DescLbl.BackgroundTransparency = 1
                DescLbl.Position = UDim2.new(0, 15, 0, 26)
                DescLbl.Size = UDim2.new(1, -90, 0, 16)
                DescLbl.Font = LiquidGlassUI.Theme.FontMain
                DescLbl.Text = TglDesc
                DescLbl.TextColor3 = LiquidGlassUI.Theme.SubTextColor
                DescLbl.TextSize = 13
                DescLbl.TextXAlignment = Enum.TextXAlignment.Left
            end

            -- 开关视觉部分 (iOS Switch 风格)
            local SwitchBg = Instance.new("Frame")
            SwitchBg.Parent = ToggleFrame
            SwitchBg.BackgroundColor3 = State and LiquidGlassUI.Theme.AccentColor or Color3.fromRGB(60, 60, 65)
            SwitchBg.Position = UDim2.new(1, -60, 0.5, -12)
            SwitchBg.Size = UDim2.new(0, 46, 0, 24)

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = SwitchBg

            local SwitchCircle = Instance.new("Frame")
            SwitchCircle.Parent = SwitchBg
            SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SwitchCircle.Position = State and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            SwitchCircle.Size = UDim2.new(0, 20, 0, 20)

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = SwitchCircle

            local CircleShadow = Instance.new("UIStroke")
            CircleShadow.Color = Color3.fromRGB(0,0,0)
            CircleShadow.Transparency = 0.8
            CircleShadow.Thickness = 1
            CircleShadow.Parent = SwitchCircle

            local function UpdateToggle()
                if State then
                    CreateTween(SwitchBg, {BackgroundColor3 = LiquidGlassUI.Theme.AccentColor})
                    CreateTween(SwitchCircle, {Position = UDim2.new(1, -22, 0.5, -10)})
                else
                    CreateTween(SwitchBg, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)})
                    CreateTween(SwitchCircle, {Position = UDim2.new(0, 2, 0.5, -10)})
                end
            end

            ToggleFrame.MouseButton1Click:Connect(function()
                State = not State
                UpdateToggle()
                pcall(Callback, State)
            end)
            
            pcall(Callback, State)
        end

        --=============================================================================
        -- UI组件：滑块 (Slider)
        --=============================================================================
        function TabObj:CreateSlider(sldOptions)
            sldOptions = sldOptions or {}
            local SldTitle = sldOptions.Title or "滑块组件"
            local SldDesc = sldOptions.Desc or ""
            local Min = sldOptions.Min or 0
            local Max = sldOptions.Max or 100
            local Default = sldOptions.Default or Min
            local Callback = sldOptions.Callback or function() end

            local Value = math.clamp(Default, Min, Max)

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider_" .. SldTitle
            SliderFrame.Parent = TabPage
            SliderFrame.BackgroundColor3 = LiquidGlassUI.Theme.ElementBackground
            SliderFrame.BackgroundTransparency = LiquidGlassUI.Theme.ElementTransparency
            SliderFrame.Size = UDim2.new(1, -30, 0, 65)

            local SldCorner = Instance.new("UICorner")
            SldCorner.CornerRadius = LiquidGlassUI.Theme.CornerRadius
            SldCorner.Parent = SliderFrame

            local SldStroke = Instance.new("UIStroke")
            SldStroke.Color = LiquidGlassUI.Theme.StrokeColor
            SldStroke.Transparency = LiquidGlassUI.Theme.StrokeTransparency
            SldStroke.Thickness = 1
            SldStroke.Parent = SliderFrame

            local TitleLbl = Instance.new("TextLabel")
            TitleLbl.Parent = SliderFrame
            TitleLbl.BackgroundTransparency = 1
            TitleLbl.Position = UDim2.new(0, 15, 0, 8)
            TitleLbl.Size = UDim2.new(1, -80, 0, 18)
            TitleLbl.Font = LiquidGlassUI.Theme.FontBold
            TitleLbl.Text = SldTitle
            TitleLbl.TextColor3 = LiquidGlassUI.Theme.TextColor
            TitleLbl.TextSize = 16
            TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

            if SldDesc ~= "" then
                local DescLbl = Instance.new("TextLabel")
                DescLbl.Parent = SliderFrame
                DescLbl.BackgroundTransparency = 1
                DescLbl.Position = UDim2.new(0, 15, 0, 26)
                DescLbl.Size = UDim2.new(1, -80, 0, 16)
                DescLbl.Font = LiquidGlassUI.Theme.FontMain
                DescLbl.Text = SldDesc
                DescLbl.TextColor3 = LiquidGlassUI.Theme.SubTextColor
                DescLbl.TextSize = 13
                DescLbl.TextXAlignment = Enum.TextXAlignment.Left
            end

            local ValueBox = Instance.new("TextBox")
            ValueBox.Parent = SliderFrame
            ValueBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            ValueBox.BackgroundTransparency = 0.8
            ValueBox.Position = UDim2.new(1, -65, 0, 10)
            ValueBox.Size = UDim2.new(0, 50, 0, 24)
            ValueBox.Font = LiquidGlassUI.Theme.FontBold
            ValueBox.Text = tostring(Value)
            ValueBox.TextColor3 = LiquidGlassUI.Theme.AccentColor
            ValueBox.TextSize = 14

            local ValCorner = Instance.new("UICorner")
            ValCorner.CornerRadius = UDim.new(0, 6)
            ValCorner.Parent = ValueBox

            local SliderArea = Instance.new("TextButton")
            SliderArea.Parent = SliderFrame
            SliderArea.BackgroundTransparency = 1
            SliderArea.Position = UDim2.new(0, 15, 1, -20)
            SliderArea.Size = UDim2.new(1, -30, 0, 10)
            SliderArea.Text = ""

            local SliderBg = Instance.new("Frame")
            SliderBg.Parent = SliderArea
            SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            SliderBg.Size = UDim2.new(1, 0, 1, 0)
            local BgCorner = Instance.new("UICorner")
            BgCorner.CornerRadius = UDim.new(1, 0)
            BgCorner.Parent = SliderBg

            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBg
            SliderFill.BackgroundColor3 = LiquidGlassUI.Theme.AccentColor
            local percent = (Value - Min) / (Max - Min)
            SliderFill.Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0)
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill

            local SliderKnob = Instance.new("Frame")
            SliderKnob.Parent = SliderFill
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderKnob.Position = UDim2.new(1, -8, 0.5, -8)
            SliderKnob.Size = UDim2.new(0, 16, 0, 16)
            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = SliderKnob

            local dragging = false

            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + ((Max - Min) * pos))
                ValueBox.Text = tostring(Value)
                CreateTween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                pcall(Callback, Value)
            end

            SliderArea.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                    CreateTween(SliderKnob, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -10, 0.5, -10)}, 0.2)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        CreateTween(SliderKnob, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -8, 0.5, -8)}, 0.2)
                    end
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)

            ValueBox.FocusLost:Connect(function()
                local num = tonumber(ValueBox.Text)
                if num then
                    Value = math.clamp(num, Min, Max)
                    local pos = (Value - Min) / (Max - Min)
                    ValueBox.Text = tostring(Value)
                    CreateTween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.3)
                    pcall(Callback, Value)
                else
                    ValueBox.Text = tostring(Value)
                end
            end)
            
            pcall(Callback, Value)
        end

        --=============================================================================
        -- UI组件：下拉菜单 (Dropdown)
        --=============================================================================
        function TabObj:CreateDropdown(dpOptions)
            dpOptions = dpOptions or {}
            local DpTitle = dpOptions.Title or "下拉菜单"
            local Options = dpOptions.Options or {}
            local Callback = dpOptions.Callback or function() end
            
            local IsOpen = false
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown_" .. DpTitle
            DropdownFrame.Parent = TabPage
            DropdownFrame.BackgroundColor3 = LiquidGlassUI.Theme.ElementBackground
            DropdownFrame.BackgroundTransparency = LiquidGlassUI.Theme.ElementTransparency
            DropdownFrame.Size = UDim2.new(1, -30, 0, 50)
            DropdownFrame.ClipsDescendants = true

            local DpCorner = Instance.new("UICorner")
            DpCorner.CornerRadius = LiquidGlassUI.Theme.CornerRadius
            DpCorner.Parent = DropdownFrame

            local DpStroke = Instance.new("UIStroke")
            DpStroke.Color = LiquidGlassUI.Theme.StrokeColor
            DpStroke.Transparency = LiquidGlassUI.Theme.StrokeTransparency
            DpStroke.Thickness = 1
            DpStroke.Parent = DropdownFrame

            local TopButton = Instance.new("TextButton")
            TopButton.Parent = DropdownFrame
            TopButton.BackgroundTransparency = 1
            TopButton.Size = UDim2.new(1, 0, 0, 50)
            TopButton.Text = ""

            local TitleLbl = Instance.new("TextLabel")
            TitleLbl.Parent = TopButton
            TitleLbl.BackgroundTransparency = 1
            TitleLbl.Position = UDim2.new(0, 15, 0, 0)
            TitleLbl.Size = UDim2.new(1, -50, 1, 0)
            TitleLbl.Font = LiquidGlassUI.Theme.FontBold
            TitleLbl.Text = DpTitle
            TitleLbl.TextColor3 = LiquidGlassUI.Theme.TextColor
            TitleLbl.TextSize = 16
            TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local ArrowIcon = Instance.new("ImageLabel")
            ArrowIcon.Parent = TopButton
            ArrowIcon.BackgroundTransparency = 1
            ArrowIcon.Position = UDim2.new(1, -30, 0.5, -8)
            ArrowIcon.Size = UDim2.new(0, 16, 0, 16)
            ArrowIcon.Image = "rbxassetid://10888331510" -- Replace with actual arrow ID
            ArrowIcon.ImageColor3 = LiquidGlassUI.Theme.SubTextColor
            ArrowIcon.Rotation = 90

            local SelectedLbl = Instance.new("TextLabel")
            SelectedLbl.Parent = TopButton
            SelectedLbl.BackgroundTransparency = 1
            SelectedLbl.Position = UDim2.new(1, -150, 0, 0)
            SelectedLbl.Size = UDim2.new(0, 110, 1, 0)
            SelectedLbl.Font = LiquidGlassUI.Theme.FontMain
            SelectedLbl.Text = "请选择..."
            SelectedLbl.TextColor3 = LiquidGlassUI.Theme.AccentColor
            SelectedLbl.TextSize = 14
            SelectedLbl.TextXAlignment = Enum.TextXAlignment.Right

            local OptionsContainer = Instance.new("ScrollingFrame")
            OptionsContainer.Parent = DropdownFrame
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.Position = UDim2.new(0, 0, 0, 50)
            OptionsContainer.Size = UDim2.new(1, 0, 1, -50)
            OptionsContainer.ScrollBarThickness = 2
            OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            OptionsContainer.BorderSizePixel = 0

            local OptLayout = Instance.new("UIListLayout")
            OptLayout.Parent = OptionsContainer
            OptLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local function RefreshOptions(optList)
                for _, v in pairs(OptionsContainer:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                
                local ySize = 0
                for _, opt in pairs(optList) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Parent = OptionsContainer
                    OptBtn.BackgroundColor3 = LiquidGlassUI.Theme.HoverBackground
                    OptBtn.BackgroundTransparency = 1
                    OptBtn.Size = UDim2.new(1, 0, 0, 35)
                    OptBtn.Font = LiquidGlassUI.Theme.FontMain
                    OptBtn.Text = "  " .. opt
                    OptBtn.TextColor3 = LiquidGlassUI.Theme.SubTextColor
                    OptBtn.TextSize = 14
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.AutoButtonColor = false
                    
                    OptBtn.MouseEnter:Connect(function()
                        CreateTween(OptBtn, {BackgroundTransparency = 0.5, TextColor3 = LiquidGlassUI.Theme.TextColor})
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        CreateTween(OptBtn, {BackgroundTransparency = 1, TextColor3 = LiquidGlassUI.Theme.SubTextColor})
                    end)
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        SelectedLbl.Text = opt
                        IsOpen = false
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, -30, 0, 50)})
                        CreateTween(ArrowIcon, {Rotation = 90})
                        pcall(Callback, opt)
                    end)
                    ySize = ySize + 35
                end
                OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, ySize)
            end

            RefreshOptions(Options)

            TopButton.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                if IsOpen then
                    local targetHeight = math.clamp(50 + (#Options * 35), 50, 200)
                    CreateTween(DropdownFrame, {Size = UDim2.new(1, -30, 0, targetHeight)})
                    CreateTween(ArrowIcon, {Rotation = -90})
                else
                    CreateTween(DropdownFrame, {Size = UDim2.new(1, -30, 0, 50)})
                    CreateTween(ArrowIcon, {Rotation = 90})
                end
            end)
        end

        --=============================================================================
        -- UI组件：输入框 (Textbox)
        --=============================================================================
        function TabObj:CreateTextbox(tbOptions)
            tbOptions = tbOptions or {}
            local TbTitle = tbOptions.Title or "输入框"
            local Placeholder = tbOptions.Placeholder or "在此输入文本..."
            local ClearOnFocus = tbOptions.ClearOnFocus or false
            local Callback = tbOptions.Callback or function() end

            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = "Textbox_" .. TbTitle
            TextboxFrame.Parent = TabPage
            TextboxFrame.BackgroundColor3 = LiquidGlassUI.Theme.ElementBackground
            TextboxFrame.BackgroundTransparency = LiquidGlassUI.Theme.ElementTransparency
            TextboxFrame.Size = UDim2.new(1, -30, 0, 50)

            local TbCorner = Instance.new("UICorner")
            TbCorner.CornerRadius = LiquidGlassUI.Theme.CornerRadius
            TbCorner.Parent = TextboxFrame

            local TbStroke = Instance.new("UIStroke")
            TbStroke.Color = LiquidGlassUI.Theme.StrokeColor
            TbStroke.Transparency = LiquidGlassUI.Theme.StrokeTransparency
            TbStroke.Thickness = 1
            TbStroke.Parent = TextboxFrame

            local TitleLbl = Instance.new("TextLabel")
            TitleLbl.Parent = TextboxFrame
            TitleLbl.BackgroundTransparency = 1
            TitleLbl.Position = UDim2.new(0, 15, 0, 0)
            TitleLbl.Size = UDim2.new(0, 150, 1, 0)
            TitleLbl.Font = LiquidGlassUI.Theme.FontBold
            TitleLbl.Text = TbTitle
            TitleLbl.TextColor3 = LiquidGlassUI.Theme.TextColor
            TitleLbl.TextSize = 16
            TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local InputBox = Instance.new("TextBox")
            InputBox.Parent = TextboxFrame
            InputBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            InputBox.BackgroundTransparency = 0.7
            InputBox.Position = UDim2.new(1, -215, 0.5, -15)
            InputBox.Size = UDim2.new(0, 200, 0, 30)
            InputBox.Font = LiquidGlassUI.Theme.FontMain
            InputBox.PlaceholderText = Placeholder
            InputBox.Text = ""
            InputBox.TextColor3 = LiquidGlassUI.Theme.TextColor
            InputBox.TextSize = 14
            InputBox.ClearTextOnFocus = ClearOnFocus

            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 8)
            InputCorner.Parent = InputBox

            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    pcall(Callback, InputBox.Text)
                end
            end)
        end

        --=============================================================================
        -- UI组件：标签 (Label)
        --=============================================================================
        function TabObj:CreateLabel(lblOptions)
            lblOptions = lblOptions or {}
            local Text = lblOptions.Text or "提示文本"
            
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label_" .. Text
            LabelFrame.Parent = TabPage
            LabelFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
            LabelFrame.BackgroundTransparency = 0.8
            LabelFrame.Size = UDim2.new(1, -30, 0, 40)

            local LblCorner = Instance.new("UICorner")
            LblCorner.CornerRadius = LiquidGlassUI.Theme.CornerRadius
            LblCorner.Parent = LabelFrame

            local TheLabel = Instance.new("TextLabel")
            TheLabel.Parent = LabelFrame
            TheLabel.BackgroundTransparency = 1
            TheLabel.Position = UDim2.new(0, 15, 0, 0)
            TheLabel.Size = UDim2.new(1, -30, 1, 0)
            TheLabel.Font = LiquidGlassUI.Theme.FontMain
            TheLabel.Text = Text
            TheLabel.TextColor3 = LiquidGlassUI.Theme.AccentColor
            TheLabel.TextSize = 15
            TheLabel.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        --=============================================================================
        -- UI组件：颜色选择器 (ColorPicker)
        --=============================================================================
        function TabObj:CreateColorPicker(cpOptions)
            cpOptions = cpOptions or {}
            local CpTitle = cpOptions.Title or "颜色选择器"
            local Default = cpOptions.Default or Color3.fromRGB(255, 255, 255)
            local Callback = cpOptions.Callback or function() end

            local CpFrame = Instance.new("Frame")
            CpFrame.Name = "ColorPicker_" .. CpTitle
            CpFrame.Parent = TabPage
            CpFrame.BackgroundColor3 = LiquidGlassUI.Theme.ElementBackground
            CpFrame.BackgroundTransparency = LiquidGlassUI.Theme.ElementTransparency
            CpFrame.Size = UDim2.new(1, -30, 0, 50)

            local CpCorner = Instance.new("UICorner")
            CpCorner.CornerRadius = LiquidGlassUI.Theme.CornerRadius
            CpCorner.Parent = CpFrame

            local CpStroke = Instance.new("UIStroke")
            CpStroke.Color = LiquidGlassUI.Theme.StrokeColor
            CpStroke.Transparency = LiquidGlassUI.Theme.StrokeTransparency
            CpStroke.Thickness = 1
            CpStroke.Parent = CpFrame

            local TitleLbl = Instance.new("TextLabel")
            TitleLbl.Parent = CpFrame
            TitleLbl.BackgroundTransparency = 1
            TitleLbl.Position = UDim2.new(0, 15, 0, 0)
            TitleLbl.Size = UDim2.new(0, 200, 1, 0)
            TitleLbl.Font = LiquidGlassUI.Theme.FontBold
            TitleLbl.Text = CpTitle
            TitleLbl.TextColor3 = LiquidGlassUI.Theme.TextColor
            TitleLbl.TextSize = 16
            TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local ColorDisplay = Instance.new("TextButton")
            ColorDisplay.Parent = CpFrame
            ColorDisplay.BackgroundColor3 = Default
            ColorDisplay.Position = UDim2.new(1, -55, 0.5, -15)
            ColorDisplay.Size = UDim2.new(0, 40, 0, 30)
            ColorDisplay.Text = ""

            local DisplayCorner = Instance.new("UICorner")
            DisplayCorner.CornerRadius = UDim.new(0, 8)
            DisplayCorner.Parent = ColorDisplay
            
            local DisplayStroke = Instance.new("UIStroke")
            DisplayStroke.Color = Color3.fromRGB(255,255,255)
            DisplayStroke.Transparency = 0.5
            DisplayStroke.Parent = ColorDisplay

            ColorDisplay.MouseButton1Click:Connect(function()
                -- 简易版交互，实际通常展开面板
                local rColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
                CreateTween(ColorDisplay, {BackgroundColor3 = rColor})
                pcall(Callback, rColor)
            end)
        end

        return TabObj
    end

    return WindowObj
end