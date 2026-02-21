local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

--// 库核心表
local Library = {
    Connections = {},
    Flags = {},
    Settings = {
        Theme = {
            Main = Color3.fromRGB(25, 25, 35),
            Secondary = Color3.fromRGB(35, 35, 45),
            Stroke = Color3.fromRGB(60, 60, 80),
            Accent = Color3.fromRGB(0, 122, 255), -- IOS Blue
            Text = Color3.fromRGB(240, 240, 240),
            TextDark = Color3.fromRGB(150, 150, 150),
            Success = Color3.fromRGB(52, 199, 89),
            Fail = Color3.fromRGB(255, 59, 48)
        },
        Font = Enum.Font.GothamBold,
        TextSizeBig = 18,
        TextSizeNormal = 15,
        TextSizeSmall = 13
    }
}

--// 辅助函数：保护UI不被游戏重置
local function ProtectGui(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    else
        gui.Parent = CoreGui
    end
end

--// 辅助函数：创建UI对象
local function Create(class, properties)
    local instance = Instance.new(class)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

--// 辅助函数：缓动动画
local function Tween(instance, info, properties)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

--// 辅助函数：拖拽逻辑
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            Tween(object, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
            })
        end
    end)
end

--// 辅助函数：水波纹效果 (Ripple)
local function CreateRipple(parent)
    spawn(function()
        local Ripple = Create("ImageLabel", {
            Name = "Ripple",
            Parent = parent,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Image = "rbxassetid://2708891598",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Fit,
            Position = UDim2.new(0, Mouse.X - parent.AbsolutePosition.X, 0, Mouse.Y - parent.AbsolutePosition.Y),
            Size = UDim2.new(0, 0, 0, 0),
            ZIndex = parent.ZIndex + 1
        })
        
        local targetSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 1.5
        
        Tween(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, targetSize, 0, targetSize),
            Position = UDim2.new(0.5, -targetSize/2, 0.5, -targetSize/2),
            ImageTransparency = 1
        })
        
        wait(0.5)
        Ripple:Destroy()
    end)
end

--// 窗口创建函数
function Library:Window(Config)
    -- 解构配置
    local Title = Config.Title or "LiquidGlass UI"
    local SubTitle = Config.SubTitle or "Developed by User"
    local Icon = Config.Icon or "rbxassetid://10709769508" -- 默认图标
    local FooterText = Config.Footer or "Ready"
    
    -- 1. 创建屏幕UI
    local ScreenGui = Create("ScreenGui", {
        Name = "LiquidGlassLib_" .. math.random(1000, 9999),
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    ProtectGui(ScreenGui)

    -- 2. 主框架 (Main Frame)
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Library.Settings.Theme.Main,
        BackgroundTransparency = 0.1, -- 玻璃质感
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 700, 0, 450),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })

    -- 圆角与描边
    Create("UICorner", { Parent = MainFrame, CornerRadius = UDim.new(0, 16) })
    Create("UIStroke", { Parent = MainFrame, Color = Library.Settings.Theme.Stroke, Thickness = 1.5, Transparency = 0.5 })

    -- 背景图片 (可选)
    if Config.BackgroundImage then
        local BgImage = Create("ImageLabel", {
            Parent = MainFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Image = Config.BackgroundImage,
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Slice,
            ZIndex = 0
        })
        Create("UICorner", { Parent = BgImage, CornerRadius = UDim.new(0, 16) })
    end

    -- 3. 侧边栏 (Sidebar)
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Library.Settings.Theme.Secondary,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 200, 1, 0),
        BorderSizePixel = 0
    })
    Create("UICorner", { Parent = Sidebar, CornerRadius = UDim.new(0, 16) })
    
    -- 侧边栏装饰：分割线
    local SidebarLine = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Library.Settings.Theme.Stroke,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0)
    })

    -- Logo区域
    local LogoContainer = Create("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 80),
        Name = "LogoContainer"
    })

    local LogoIcon = Create("ImageLabel", {
        Parent = LogoContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(0, 50, 0, 50),
        Image = Icon,
        ImageColor3 = Library.Settings.Theme.Accent
    })
    Create("UICorner", { Parent = LogoIcon, CornerRadius = UDim.new(0, 12) })

    local TitleLabel = Create("TextLabel", {
        Parent = LogoContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 75, 0, 20),
        Size = UDim2.new(0, 115, 0, 20),
        Font = Library.Settings.Font,
        Text = Title,
        TextColor3 = Library.Settings.Theme.Text,
        TextSize = Library.Settings.TextSizeBig,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SubTitleLabel = Create("TextLabel", {
        Parent = LogoContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 75, 0, 45),
        Size = UDim2.new(0, 115, 0, 15),
        Font = Enum.Font.GothamMedium,
        Text = SubTitle,
        TextColor3 = Library.Settings.Theme.TextDark,
        TextSize = Library.Settings.TextSizeSmall,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- 标签页按钮容器
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 90),
        Size = UDim2.new(1, -20, 1, -130),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    Create("UIListLayout", {
        Parent = TabContainer,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    -- 底部信息栏 (在侧边栏最下)
    local FooterFrame = Create("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, -40),
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    local FooterLabel = Create("TextLabel", {
        Parent = FooterFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        Font = Enum.Font.Gotham,
        Text = FooterText,
        TextColor3 = Library.Settings.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- 4. 内容区域 (Content Area)
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 210, 0, 50), -- 留出顶部做标题栏操作区
        Size = UDim2.new(1, -220, 1, -60)
    })

    -- 5. 顶部操作栏 (Top Bar - 最小化/关闭)
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200, 0, 0),
        Size = UDim2.new(1, -200, 0, 40)
    })
    MakeDraggable(TopBar, MainFrame) -- 允许通过顶部拖拽
    MakeDraggable(LogoContainer, MainFrame) -- 允许通过Logo拖拽

    local CloseBtn = Create("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0, 10),
        Size = UDim2.new(0, 30, 0, 30),
        Text = "×",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Library.Settings.Theme.TextDark,
        TextSize = 24
    })

    local MinBtn = Create("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -75, 0, 10),
        Size = UDim2.new(0, 30, 0, 30),
        Text = "-",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Library.Settings.Theme.TextDark,
        TextSize = 24
    })

    -- 关闭逻辑
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Library.Settings.Theme.Fail}) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Library.Settings.Theme.TextDark}) end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        wait(0.3)
        ScreenGui:Destroy()
    end)

    -- 最小化逻辑
    local Minimized = false
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, TweenInfo.new(0.2), {TextColor3 = Library.Settings.Theme.Accent}) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, TweenInfo.new(0.2), {TextColor3 = Library.Settings.Theme.TextDark}) end)
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 700, 0, 40), BackgroundTransparency = 0.5})
            Sidebar.Visible = false
            ContentArea.Visible = false
        else
            Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 700, 0, 450), BackgroundTransparency = 0.1})
            Sidebar.Visible = true
            ContentArea.Visible = true
        end
    end)
    
    -- 窗口对象
    local Window = {}
    local FirstTab = true

    --// 标签页 (Tab) 创建函数
    function Window:Tab(Config)
        local TabName = Config.Title or "Tab"
        local TabIcon = Config.Icon or ""

        -- 侧边栏按钮
        local TabButton = Create("TextButton", {
            Parent = TabContainer,
            BackgroundColor3 = Library.Settings.Theme.Secondary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            Text = "",
            AutoButtonColor = false
        })
        Create("UICorner", { Parent = TabButton, CornerRadius = UDim.new(0, 8) })

        local TabBtnTitle = Create("TextLabel", {
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(1, -15, 1, 0),
            Text = TabName,
            Font = Library.Settings.Font,
            TextColor3 = Library.Settings.Theme.TextDark,
            TextSize = Library.Settings.TextSizeNormal,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- 内容容器
        local TabContent = Create("ScrollingFrame", {
            Parent = ContentArea,
            Name = TabName .. "_Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Settings.Theme.Accent,
            Visible = false
        })
        
        Create("UIListLayout", {
            Parent = TabContent,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        Create("UIPadding", {
            Parent = TabContent,
            PaddingTop = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 10)
        })

        -- 切换逻辑
        local function Activate()
            -- 重置所有Tab
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, TweenInfo.new(0.3), {BackgroundTransparency = 1})
                    Tween(v.TextLabel, TweenInfo.new(0.3), {TextColor3 = Library.Settings.Theme.TextDark})
                end
            end
            for _, v in pairs(ContentArea:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end

            -- 激活当前
            TabContent.Visible = true
            Tween(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.8, BackgroundColor3 = Library.Settings.Theme.Accent})
            Tween(TabBtnTitle, TweenInfo.new(0.3), {TextColor3 = Library.Settings.Theme.Text})
        end

        TabButton.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            Activate()
        end

        -- Tab对象，包含组件
        local TabObj = {}

        --// 1. Label/Section 组件
        function TabObj:Section(Config)
            local SectionTitle = Config.Title or "Section"
            local SectionFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30)
            })
            
            Create("TextLabel", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -10, 1, 0),
                Text = SectionTitle,
                Font = Library.Settings.Font,
                TextColor3 = Library.Settings.Theme.Accent,
                TextSize = Library.Settings.TextSizeSmall,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        --// 2. Button 组件
        function TabObj:Button(Config)
            local Title = Config.Title or "Button"
            local Desc = Config.Desc or ""
            local Callback = Config.Callback or function() end
            local Locked = Config.Locked or false

            local ButtonFrame = Create("TextButton", {
                Parent = TabContent,
                BackgroundColor3 = Library.Settings.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 45),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", { Parent = ButtonFrame, CornerRadius = UDim.new(0, 10) })
            Create("UIStroke", { Parent = ButtonFrame, Color = Library.Settings.Theme.Stroke, Thickness = 1, Transparency = 0.6 })

            local BtnTitle = Create("TextLabel", {
                Parent = ButtonFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Text = Title,
                Font = Library.Settings.Font,
                TextColor3 = Library.Settings.Theme.Text,
                TextSize = Library.Settings.TextSizeNormal,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Icon = Create("ImageLabel", {
                Parent = ButtonFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = "rbxassetid://10709791437", -- 鼠标点击图标
                ImageColor3 = Library.Settings.Theme.TextDark
            })

            if Desc ~= "" then
                BtnTitle.Position = UDim2.new(0, 15, 0, 5)
                BtnTitle.Size = UDim2.new(1, -40, 0, 20)
                Create("TextLabel", {
                    Parent = ButtonFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 25),
                    Size = UDim2.new(1, -40, 0, 15),
                    Text = Desc,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Library.Settings.Theme.TextDark,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end

            -- 交互
            ButtonFrame.MouseEnter:Connect(function()
                if Locked then return end
                Tween(ButtonFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)})
                Tween(Icon, TweenInfo.new(0.3), {ImageColor3 = Library.Settings.Theme.Accent})
            end)

            ButtonFrame.MouseLeave:Connect(function()
                if Locked then return end
                Tween(ButtonFrame, TweenInfo.new(0.3), {BackgroundColor3 = Library.Settings.Theme.Secondary})
                Tween(Icon, TweenInfo.new(0.3), {ImageColor3 = Library.Settings.Theme.TextDark})
            end)

            ButtonFrame.MouseButton1Click:Connect(function()
                if Locked then return end
                CreateRipple(ButtonFrame)
                Tween(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 41)})
                wait(0.1)
                Tween(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 45)})
                Callback()
            end)
        end

        --// 3. Toggle 组件
        function TabObj:Toggle(Config)
            local Title = Config.Title or "Toggle"
            local Default = Config.Default or false
            local Callback = Config.Callback or function() end
            
            local State = Default

            local ToggleFrame = Create("TextButton", {
                Parent = TabContent,
                BackgroundColor3 = Library.Settings.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", { Parent = ToggleFrame, CornerRadius = UDim.new(0, 10) })
            Create("UIStroke", { Parent = ToggleFrame, Color = Library.Settings.Theme.Stroke, Thickness = 1, Transparency = 0.6 })

            Create("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Text = Title,
                Font = Library.Settings.Font,
                TextColor3 = Library.Settings.Theme.Text,
                TextSize = Library.Settings.TextSizeNormal,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            -- 开关背景槽
            local SwitchBg = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = State and Library.Settings.Theme.Accent or Color3.fromRGB(60, 60, 70),
                Position = UDim2.new(1, -50, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20)
            })
            Create("UICorner", { Parent = SwitchBg, CornerRadius = UDim.new(1, 0) })

            -- 开关圆点
            local SwitchDot = Create("Frame", {
                Parent = SwitchBg,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            Create("UICorner", { Parent = SwitchDot, CornerRadius = UDim.new(1, 0) })

            local function UpdateToggle()
                local TargetPos = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local TargetColor = State and Library.Settings.Theme.Accent or Color3.fromRGB(60, 60, 70)
                
                Tween(SwitchDot, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = TargetPos})
                Tween(SwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = TargetColor})
                Callback(State)
            end

            ToggleFrame.MouseButton1Click:Connect(function()
                State = not State
                UpdateToggle()
            end)
            
            -- 初始化调用一次
            if Default then Callback(State) end
        end

        --// 4. Slider 组件
        function TabObj:Slider(Config)
            local Title = Config.Title or "Slider"
            local Min = Config.Min or 0
            local Max = Config.Max or 100
            local Default = Config.Default or Min
            local Callback = Config.Callback or function() end
            
            local Value = math.clamp(Default, Min, Max)

            local SliderFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Library.Settings.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 60)
            })
            Create("UICorner", { Parent = SliderFrame, CornerRadius = UDim.new(0, 10) })
            Create("UIStroke", { Parent = SliderFrame, Color = Library.Settings.Theme.Stroke, Thickness = 1, Transparency = 0.6 })

            Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 10),
                Size = UDim2.new(1, -30, 0, 20),
                Text = Title,
                Font = Library.Settings.Font,
                TextColor3 = Library.Settings.Theme.Text,
                TextSize = Library.Settings.TextSizeNormal,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -65, 0, 10),
                Size = UDim2.new(0, 50, 0, 20),
                Text = tostring(Value),
                Font = Enum.Font.GothamMedium,
                TextColor3 = Library.Settings.Theme.TextDark,
                TextSize = Library.Settings.TextSizeNormal,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local SliderBg = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                Position = UDim2.new(0, 15, 0, 40),
                Size = UDim2.new(1, -30, 0, 6)
            })
            Create("UICorner", { Parent = SliderBg, CornerRadius = UDim.new(1, 0) })

            local SliderFill = Create("Frame", {
                Parent = SliderBg,
                BackgroundColor3 = Library.Settings.Theme.Accent,
                Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            })
            Create("UICorner", { Parent = SliderFill, CornerRadius = UDim.new(1, 0) })

            local SliderBtn = Create("TextButton", {
                Parent = SliderBg,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            local IsDragging = false

            local function UpdateSlider(Input)
                local SizeX = math.clamp((Input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                local NewValue = math.floor(Min + ((Max - Min) * SizeX))
                
                Tween(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(SizeX, 0, 1, 0)})
                ValueLabel.Text = tostring(NewValue)
                Callback(NewValue)
            end

            SliderBtn.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = true
                    UpdateSlider(Input)
                end
            end)

            UserInputService.InputChanged:Connect(function(Input)
                if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(Input)
                end
            end)

            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = false
                end
            end)
        end

        --// 5. Textbox 组件
        function TabObj:Textbox(Config)
            local Title = Config.Title or "Textbox"
            local Placeholder = Config.Placeholder or "Enter text..."
            local Callback = Config.Callback or function() end

            local TextboxFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Library.Settings.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 70)
            })
            Create("UICorner", { Parent = TextboxFrame, CornerRadius = UDim.new(0, 10) })
            Create("UIStroke", { Parent = TextboxFrame, Color = Library.Settings.Theme.Stroke, Thickness = 1, Transparency = 0.6 })

            Create("TextLabel", {
                Parent = TextboxFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 10),
                Size = UDim2.new(1, -30, 0, 20),
                Text = Title,
                Font = Library.Settings.Font,
                TextColor3 = Library.Settings.Theme.Text,
                TextSize = Library.Settings.TextSizeNormal,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local InputBg = Create("Frame", {
                Parent = TextboxFrame,
                BackgroundColor3 = Color3.fromRGB(20, 20, 25),
                Position = UDim2.new(0, 15, 0, 35),
                Size = UDim2.new(1, -30, 0, 30)
            })
            Create("UICorner", { Parent = InputBg, CornerRadius = UDim.new(0, 6) })
            
            local InputBox = Create("TextBox", {
                Parent = InputBg,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = "",
                PlaceholderText = Placeholder,
                TextColor3 = Library.Settings.Theme.Text,
                PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false
            })

            InputBox.FocusLost:Connect(function(Enter)
                Callback(InputBox.Text)
            end)
        end

        --// 6. Dropdown 组件
        function TabObj:Dropdown(Config)
            local Title = Config.Title or "Dropdown"
            local Options = Config.Options or {}
            local Default = Config.Default or Options[1]
            local Callback = Config.Callback or function() end
            
            local IsOpen = false
            local CurrentOption = Default

            local DropdownFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Library.Settings.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 45), -- Default Height
                ClipsDescendants = true
            })
            Create("UICorner", { Parent = DropdownFrame, CornerRadius = UDim.new(0, 10) })
            local Stroke = Create("UIStroke", { Parent = DropdownFrame, Color = Library.Settings.Theme.Stroke, Thickness = 1, Transparency = 0.6 })

            local ClickArea = Create("TextButton", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45),
                Text = ""
            })

            Create("TextLabel", {
                Parent = ClickArea,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Text = Title,
                Font = Library.Settings.Font,
                TextColor3 = Library.Settings.Theme.Text,
                TextSize = Library.Settings.TextSizeNormal,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local StatusLabel = Create("TextLabel", {
                Parent = ClickArea,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -120, 0, 0),
                Size = UDim2.new(0, 80, 1, 0),
                Text = CurrentOption,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Library.Settings.Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Arrow = Create("ImageLabel", {
                Parent = ClickArea,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = "rbxassetid://6034818372", -- Down Arrow
                ImageColor3 = Library.Settings.Theme.TextDark
            })

            local OptionContainer = Create("ScrollingFrame", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 50),
                Size = UDim2.new(1, -20, 0, 0), -- Dynamic
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 2,
                AutomaticCanvasSize = Enum.AutomaticSize.Y
            })
            Create("UIListLayout", { Parent = OptionContainer, Padding = UDim.new(0, 5) })

            local function RefreshOptions()
                for _, v in pairs(OptionContainer:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end

                for _, opt in pairs(Options) do
                    local OptBtn = Create("TextButton", {
                        Parent = OptionContainer,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                        Size = UDim2.new(1, 0, 0, 30),
                        Text = opt,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Library.Settings.Theme.TextDark,
                        TextSize = 14,
                        AutoButtonColor = false
                    })
                    Create("UICorner", { Parent = OptBtn, CornerRadius = UDim.new(0, 6) })

                    OptBtn.MouseButton1Click:Connect(function()
                        CurrentOption = opt
                        StatusLabel.Text = opt
                        Callback(opt)
                        IsOpen = false
                        Tween(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 45)})
                        Tween(Arrow, TweenInfo.new(0.3), {Rotation = 0})
                    end)
                end
            end

            ClickArea.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                if IsOpen then
                    RefreshOptions()
                    local ListHeight = math.min(#Options * 35, 150)
                    Tween(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 50 + ListHeight)})
                    OptionContainer.Size = UDim2.new(1, -20, 0, ListHeight)
                    Tween(Arrow, TweenInfo.new(0.3), {Rotation = 180})
                else
                    Tween(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 45)})
                    Tween(Arrow, TweenInfo.new(0.3), {Rotation = 0})
                end
            end)
        end

        return TabObj
    end

    return Window
end