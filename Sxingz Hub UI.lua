local DeltaXLib = {
    Flags = {},
    Theme = {
        Main = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Placeholder = Color3.fromRGB(120, 120, 120),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
        Rounded = UDim.new(0, 10),
        TweenSpeed = 0.3
    },
    Tabs = {},
    CurrentTab = nil,
    SearchQuery = "",
    IsDraggingSlider = false,
    IsPromptOpen = false
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

local function Create(ClassName, Properties)
    local Instance = Instance.new(ClassName)
    for i, v in pairs(Properties) do
        Instance[i] = v
    end
    return Instance
end

local function GetTweenInfo(Speed, Style)
    return TweenInfo.new(Speed or DeltaXLib.Theme.TweenSpeed, Style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
end

local function ApplyTween(Object, Properties, Speed)
    local Info = GetTweenInfo(Speed)
    local Tween = TweenService:Create(Object, Info, Properties)
    Tween:Play()
    return Tween
end

local function MakeDraggable(Frame, DragHandle)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPos = nil

    DragHandle.InputBegan:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and not DeltaXLib.IsPromptOpen then
            Dragging = true
            DragStart = Input.Position
            StartPos = Frame.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    DragHandle.InputChanged:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and not DeltaXLib.IsPromptOpen then
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging and not DeltaXLib.IsPromptOpen then
            local Delta = Input.Position - DragStart
            local TargetPos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            ApplyTween(Frame, {Position = TargetPos}, 0.1)
        end
    end)
end

local function Ripple(Button)
    if DeltaXLib.IsPromptOpen then return end
    task.spawn(function()
        local Circle = Create("ImageLabel", {
            Parent = Button,
            BackgroundTransparency = 1,
            Image = "rbxassetid://108621904172785",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.7,
            ZIndex = 10,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, Mouse.X - Button.AbsolutePosition.X, 0, Mouse.Y - Button.AbsolutePosition.Y)
        })
        Button.ClipsDescendants = true
        local Size = Button.AbsoluteSize.X > Button.AbsoluteSize.Y and Button.AbsoluteSize.X or Button.AbsoluteSize.Y
        ApplyTween(Circle, {
            Size = UDim2.new(0, Size * 2.5, 0, Size * 2.5),
            Position = UDim2.new(0.5, -Size * 1.25, 0.5, -Size * 1.25),
            ImageTransparency = 1
        }, 0.6)
        task.wait(0.6)
        Circle:Destroy()
    end)
end

function DeltaXLib:CreateWindow(Options)
    local Config = {
        Title = Options.Title or "Delta X",
        SubTitle = Options.SubTitle or "V2.0",
        FooterText = Options.Footer or "Delta X Lib",
        IconId = Options.Icon or "",
        TitleIcon = Options.TitleIcon or "",
        BgImg = Options.BackgroundImage or ""
    }

    local ScreenGui = Create("ScreenGui", {
        Name = "DeltaX_V2_PRO",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local MinimizedBall = Create("Frame", {
        Name = "MinimizedBall",
        Parent = ScreenGui,
        BackgroundColor3 = DeltaXLib.Theme.Accent,
        Position = UDim2.new(0.05, 0, 0.4, 0),
        Size = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 2000,
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = MinimizedBall, CornerRadius = UDim.new(1, 0)})
    
    local BallIcon = Create("ImageLabel", {
        Parent = MinimizedBall,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Image = Config.IconId,
        ImageColor3 = DeltaXLib.Theme.White,
        ScaleType = Enum.ScaleType.Stretch
    })
    Create("UICorner", {Parent = BallIcon, CornerRadius = UDim.new(1, 0)})
    
    local BallBtn = Create("TextButton", {
        Parent = MinimizedBall,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    MakeDraggable(MinimizedBall, MinimizedBall)

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = DeltaXLib.Theme.Main,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true,
        ZIndex = 1
    })
    Create("UICorner", {Parent = MainFrame, CornerRadius = DeltaXLib.Theme.Rounded})
    MakeDraggable(MainFrame, MainFrame)

    if Config.BgImg ~= "" then
        local FullBg = Create("ImageLabel", {
            Parent = MainFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Image = Config.BgImg,
            ImageTransparency = 0.8,
            ZIndex = 0,
            ScaleType = Enum.ScaleType.Crop
        })
    end

    local SideBar = Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = DeltaXLib.Theme.Secondary,
        BackgroundTransparency = 0.2,
        Size = UDim2.new(0, 160, 1, 0),
        ZIndex = 2
    })
    Create("UICorner", {Parent = SideBar, CornerRadius = DeltaXLib.Theme.Rounded})

    local LogoArea = Create("Frame", {
        Parent = SideBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 80)
    })
    
    local FooterLabel = Create("TextLabel", {
        Parent = SideBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 1, -30),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = Config.FooterText,
        TextColor3 = Color3.fromRGB(100, 100, 110),
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    })
    
    local HeaderIcon = Create("ImageLabel", {
        Parent = LogoArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 25),
        Size = UDim2.new(0, 35, 0, 35),
        Image = Config.TitleIcon,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ScaleType = Enum.ScaleType.Fit
    })

    local TitleLabel = Create("TextLabel", {
        Parent = LogoArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 58, 0, 22),
        Size = UDim2.new(1, -65, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = Config.Title,
        TextColor3 = DeltaXLib.Theme.Accent,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SubLabel = Create("TextLabel", {
        Parent = LogoArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 58, 0, 42),
        Size = UDim2.new(1, -65, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = Config.SubTitle,
        TextColor3 = DeltaXLib.Theme.TextDark,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TabContainer = Create("ScrollingFrame", {
        Parent = SideBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 85),
        Size = UDim2.new(1, -20, 1, -155),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    local TabListLayout = Create("UIListLayout", {
        Parent = TabContainer, 
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.Name
    })

    local TopArea = Create("Frame", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 160, 0, 0),
        Size = UDim2.new(1, -160, 0, 50),
        ZIndex = 5
    })

    local ControlBtns = Create("Frame", {
        Parent = TopArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -70, 0.5, -14),
        Size = UDim2.new(0, 60, 0, 28)
    })
    
    local CloseBtn = Create("TextButton", {
        Parent = ControlBtns,
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        Position = UDim2.new(1, -28, 0, 0),
        Size = UDim2.new(0, 28, 0, 28),
        Text = "×",
        TextColor3 = DeltaXLib.Theme.White,
        Font = Enum.Font.GothamBold,
        TextSize = 20
    })
    Create("UICorner", {Parent = CloseBtn, CornerRadius = UDim.new(0, 8)})

    local MinBtn = Create("TextButton", {
        Parent = ControlBtns,
        BackgroundColor3 = Color3.fromRGB(255, 160, 50),
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 28, 0, 28),
        Text = "−",
        TextColor3 = DeltaXLib.Theme.White,
        Font = Enum.Font.GothamBold,
        TextSize = 20
    })
    Create("UICorner", {Parent = MinBtn, CornerRadius = UDim.new(0, 8)})

    local SearchBoxFrame = Create("Frame", {
        Parent = TopArea,
        BackgroundColor3 = DeltaXLib.Theme.White,
        Position = UDim2.new(1, -280, 0.5, -15),
        Size = UDim2.new(0, 200, 0, 30)
    })
    Create("UICorner", {Parent = SearchBoxFrame, CornerRadius = UDim.new(0, 15)})
    
    local IconBorder = Create("Frame", {
        Parent = SearchBoxFrame,
        BackgroundColor3 = DeltaXLib.Theme.Black,
        Position = UDim2.new(0, 4, 0.5, -11),
        Size = UDim2.new(0, 22, 0, 22)
    })
    Create("UICorner", {Parent = IconBorder, CornerRadius = UDim.new(1, 0)})
    
    local IconInner = Create("Frame", {
        Parent = IconBorder,
        BackgroundColor3 = DeltaXLib.Theme.White,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(0, 20, 0, 20)
    })
    Create("UICorner", {Parent = IconInner, CornerRadius = UDim.new(1, 0)})
    
    local SearchIcon = Create("ImageLabel", {
        Parent = IconInner,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.15, 0, 0.15, 0),
        Size = UDim2.new(0.7, 0, 0.7, 0),
        Image = "rbxassetid://85328226988655",
        ImageColor3 = DeltaXLib.Theme.Black,
        ScaleType = Enum.ScaleType.Fit
    })

    local SearchBox = Create("TextBox", {
        Parent = SearchBoxFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 35, 0, 0),
        Size = UDim2.new(1, -45, 1, 0),
        Font = Enum.Font.GothamMedium,
        PlaceholderText = "搜索功能...",
        Text = "",
        TextColor3 = DeltaXLib.Theme.Black,
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ContentHolder = Create("Frame", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 60),
        Size = UDim2.new(1, -180, 1, -70),
        ZIndex = 1
    })

    local PromptMask = Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = DeltaXLib.Theme.Black,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 500,
        Visible = false
    })
    Create("UICorner", {Parent = PromptMask, CornerRadius = DeltaXLib.Theme.Rounded})

    local PromptFrame = Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = DeltaXLib.Theme.Secondary,
        Position = UDim2.new(0.5, -150, 0.5, -75),
        Size = UDim2.new(0, 0, 0, 0),
        ZIndex = 501,
        ClipsDescendants = true,
        Visible = false
    })
    Create("UICorner", {Parent = PromptFrame, CornerRadius = DeltaXLib.Theme.Rounded})
    Create("UIStroke", {Parent = PromptFrame, Color = DeltaXLib.Theme.Accent, Thickness = 2})

    local PromptIcon = Create("ImageLabel", {
        Parent = PromptFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(0, 25, 0, 25),
        Image = "rbxassetid://116492635500052",
        ScaleType = Enum.ScaleType.Fit
    })

    local PromptTitle = Create("TextLabel", {
        Parent = PromptFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 50, 0, 15),
        Size = UDim2.new(1, -60, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "提示",
        TextColor3 = DeltaXLib.Theme.White,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local PromptContent = Create("TextLabel", {
        Parent = PromptFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 50),
        Size = UDim2.new(1, -30, 0, 40),
        Font = Enum.Font.Gotham,
        Text = "你确定是否关闭这个脚本?关闭后将无法再次打开！",
        TextColor3 = DeltaXLib.Theme.TextDark,
        TextSize = 14,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    local PromptCancel = Create("TextButton", {
        Parent = PromptFrame,
        BackgroundColor3 = Color3.fromRGB(50, 180, 100),
        Position = UDim2.new(0.05, 0, 1, -45),
        Size = UDim2.new(0.42, 0, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = "取消",
        TextColor3 = DeltaXLib.Theme.White,
        TextSize = 14
    })
    Create("UICorner", {Parent = PromptCancel, CornerRadius = UDim.new(0, 8)})

    local PromptConfirm = Create("TextButton", {
        Parent = PromptFrame,
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        Position = UDim2.new(0.53, 0, 1, -45),
        Size = UDim2.new(0.42, 0, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = "确认",
        TextColor3 = DeltaXLib.Theme.White,
        TextSize = 14
    })
    Create("UICorner", {Parent = PromptConfirm, CornerRadius = UDim.new(0, 8)})

    CloseBtn.MouseButton1Click:Connect(function()
        DeltaXLib.IsPromptOpen = true
        PromptMask.Visible = true
        PromptFrame.Visible = true
        ApplyTween(PromptMask, {BackgroundTransparency = 0.5}, 0.3)
        ApplyTween(PromptFrame, {Size = UDim2.new(0, 300, 0, 150)}, 0.4)
    end)

    PromptCancel.MouseButton1Click:Connect(function()
        ApplyTween(PromptMask, {BackgroundTransparency = 1}, 0.3)
        ApplyTween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        PromptMask.Visible = false
        PromptFrame.Visible = false
        DeltaXLib.IsPromptOpen = false
    end)

    PromptConfirm.MouseButton1Click:Connect(function()
        ApplyTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}, 0.4)
        task.wait(0.4)
        ScreenGui:Destroy()
    end)

    MinBtn.MouseButton1Click:Connect(function()
        ApplyTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.4)
        task.wait(0.4)
        MainFrame.Visible = false
        MinimizedBall.Visible = true
        ApplyTween(MinimizedBall, {Size = UDim2.new(0, 60, 0, 60)}, 0.4)
    end)

    BallBtn.MouseButton1Click:Connect(function()
        ApplyTween(MinimizedBall, {Size = UDim2.new(0, 0, 0, 0)}, 0.4)
        task.wait(0.2)
        MinimizedBall.Visible = false
        MainFrame.Visible = true
        MainFrame.BackgroundTransparency = 0
        ApplyTween(MainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.4)
    end)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        DeltaXLib.SearchQuery = string.lower(SearchBox.Text)
        local FoundFirst = false
        for i, TabPage in pairs(ContentHolder:GetChildren()) do
            if TabPage:IsA("ScrollingFrame") then
                local TabFound = false
                for _, Component in pairs(TabPage:GetChildren()) do
                    if Component:IsA("Frame") and Component:FindFirstChild("TitleLabel") then
                        local Title = string.lower(Component.TitleLabel.Text)
                        if string.find(Title, DeltaXLib.SearchQuery) then
                            Component.Visible = true
                            TabFound = true
                        else
                            Component.Visible = false
                        end
                    end
                end
                
                if DeltaXLib.SearchQuery ~= "" then
                    if TabFound and not FoundFirst then
                        TabPage.Visible = true
                        FoundFirst = true
                        for _, v in pairs(TabContainer:GetChildren()) do
                            if v:IsA("TextButton") and string.find(v.Name, TabPage.Name) then
                                ApplyTween(v, {TextColor3 = DeltaXLib.Theme.Accent, BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
                            elseif v:IsA("TextButton") then
                                ApplyTween(v, {TextColor3 = DeltaXLib.Theme.TextDark, BackgroundColor3 = DeltaXLib.Theme.Secondary}, 0.2)
                            end
                        end
                    else
                        TabPage.Visible = false
                    end
                else
                   if DeltaXLib.CurrentTab == TabPage then
                       TabPage.Visible = true
                   else
                       TabPage.Visible = false
                   end
                end
            end
        end
    end)

    local TabCount = 0
    function DeltaXLib:CreateTab(Name)
        TabCount = TabCount + 1
        local TabBtn = Create("TextButton", {
            Parent = TabContainer,
            BackgroundColor3 = DeltaXLib.Theme.Secondary,
            Size = UDim2.new(1, 0, 0, 38),
            Font = Enum.Font.GothamBold,
            Text = "   " .. Name,
            TextColor3 = DeltaXLib.Theme.TextDark,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Name = string.format("%02d", TabCount) .. "_" .. Name,
            LayoutOrder = TabCount
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 8)})
        
        local TabPage = Create("ScrollingFrame", {
            Parent = ContentHolder,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = DeltaXLib.Theme.Accent,
            Visible = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Name = Name
        })
        Create("UIListLayout", {Parent = TabPage, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})
        Create("UIPadding", {Parent = TabPage, PaddingLeft = UDim.new(0, 5), PaddingTop = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})

        TabBtn.MouseButton1Click:Connect(function()
            if DeltaXLib.IsPromptOpen then return end
            for _, v in pairs(ContentHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then 
                    ApplyTween(v, {TextColor3 = DeltaXLib.Theme.TextDark, BackgroundColor3 = DeltaXLib.Theme.Secondary}, 0.2) 
                end 
            end
            TabPage.Visible = true
            DeltaXLib.CurrentTab = TabPage
            ApplyTween(TabBtn, {TextColor3 = DeltaXLib.Theme.Accent, BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
            Ripple(TabBtn)
        end)

        if DeltaXLib.CurrentTab == nil then
            DeltaXLib.CurrentTab = TabPage
            TabPage.Visible = true
            TabBtn.TextColor3 = DeltaXLib.Theme.Accent
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        end

        local CompLib = {}

        function CompLib:Button(Config)
            local BtnFrame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = DeltaXLib.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 50),
                Name = Config.Title .. "_Btn"
            })
            Create("UICorner", {Parent = BtnFrame, CornerRadius = DeltaXLib.Theme.Rounded})
            
            local TitleLabel = Create("TextLabel", {
                Name = "TitleLabel",
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 8),
                Size = UDim2.new(1, -30, 0, 18),
                Font = Enum.Font.GothamBold,
                Text = Config.Title,
                TextColor3 = DeltaXLib.Theme.White,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local DescLabel = Create("TextLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 26),
                Size = UDim2.new(1, -30, 0, 15),
                Font = Enum.Font.Gotham,
                Text = Config.Desc or "点击执行功能",
                TextColor3 = DeltaXLib.Theme.TextDark,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local RealBtn = Create("TextButton", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            RealBtn.MouseButton1Click:Connect(function()
                if DeltaXLib.IsPromptOpen then return end
                Ripple(BtnFrame)
                if Config.Callback then Config.Callback() end
            end)

            return BtnFrame
        end

        function CompLib:Toggle(Config)
            local State = Config.Default or false
            local TglFrame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = DeltaXLib.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 45)
            })
            Create("UICorner", {Parent = TglFrame, CornerRadius = DeltaXLib.Theme.Rounded})

            local TitleLabel = Create("TextLabel", {
                Name = "TitleLabel",
                Parent = TglFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -100, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = Config.Title,
                TextColor3 = DeltaXLib.Theme.White,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SwitchBG = Create("Frame", {
                Parent = TglFrame,
                BackgroundColor3 = State and DeltaXLib.Theme.Accent or Color3.fromRGB(50, 50, 60),
                Position = UDim2.new(1, -55, 0.5, -12),
                Size = UDim2.new(0, 45, 0, 24)
            })
            Create("UICorner", {Parent = SwitchBG, CornerRadius = UDim.new(1, 0)})

            local Dot = Create("Frame", {
                Parent = SwitchBG,
                BackgroundColor3 = DeltaXLib.Theme.White,
                Position = State and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18)
            })
            Create("UICorner", {Parent = Dot, CornerRadius = UDim.new(1, 0)})

            local ClickBtn = Create("TextButton", {
                Parent = TglFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            ClickBtn.MouseButton1Click:Connect(function()
                if DeltaXLib.IsPromptOpen then return end
                State = not State
                ApplyTween(SwitchBG, {BackgroundColor3 = State and DeltaXLib.Theme.Accent or Color3.fromRGB(50, 50, 60)}, 0.3)
                ApplyTween(Dot, {Position = State and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.3)
                if Config.Callback then Config.Callback(State) end
            end)

            return TglFrame
        end

        function CompLib:Slider(Config)
            local Min = Config.Min or 0
            local Max = Config.Max or 100
            local Default = Config.Default or 50
            local Value = Default
            local IsThisDragging = false

            local SliderFrame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = DeltaXLib.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 60)
            })
            Create("UICorner", {Parent = SliderFrame, CornerRadius = DeltaXLib.Theme.Rounded})

            local TitleLabel = Create("TextLabel", {
                Name = "TitleLabel",
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 10),
                Size = UDim2.new(1, -30, 0, 15),
                Font = Enum.Font.GothamBold,
                Text = Config.Title,
                TextColor3 = DeltaXLib.Theme.White,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -65, 0, 10),
                Size = UDim2.new(0, 50, 0, 15),
                Font = Enum.Font.GothamBold,
                Text = tostring(Value),
                TextColor3 = DeltaXLib.Theme.Accent,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local BarBG = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                Position = UDim2.new(0, 15, 0, 38),
                Size = UDim2.new(1, -30, 0, 8)
            })
            Create("UICorner", {Parent = BarBG, CornerRadius = UDim.new(1, 0)})

            local BarFill = Create("Frame", {
                Parent = BarBG,
                BackgroundColor3 = DeltaXLib.Theme.Accent,
                Size = UDim2.new((Value - Min)/(Max - Min), 0, 1, 0)
            })
            Create("UICorner", {Parent = BarFill, CornerRadius = UDim.new(1, 0)})

            local function UpdateSlider(Input)
                if DeltaXLib.IsPromptOpen then return end
                local Pos = math.clamp((Input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + (Max - Min) * Pos)
                ValueLabel.Text = tostring(Value)
                ApplyTween(BarFill, {Size = UDim2.new(Pos, 0, 1, 0)}, 0.1)
                if Config.Callback then Config.Callback(Value) end
            end

            SliderFrame.InputBegan:Connect(function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and not DeltaXLib.IsDraggingSlider and not DeltaXLib.IsPromptOpen then
                    IsThisDragging = true
                    DeltaXLib.IsDraggingSlider = true
                    UpdateSlider(Input)
                end
            end)

            UserInputService.InputChanged:Connect(function(Input)
                if IsThisDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(Input)
                end
            end)

            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsThisDragging = false
                    DeltaXLib.IsDraggingSlider = false
                end
            end)

            return SliderFrame
        end

        function CompLib:Section(Config)
            local Expanded = Config.Default or false
            local SectionFrame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = SectionFrame, CornerRadius = DeltaXLib.Theme.Rounded})
            Create("UIStroke", {Parent = SectionFrame, Color = DeltaXLib.Theme.Accent, Thickness = 1, Transparency = 0.8})

            local Header = Create("TextButton", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = ""
            })

            local TitleLabel = Create("TextLabel", {
                Name = "TitleLabel",
                Parent = Header,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = Config.Title,
                TextColor3 = DeltaXLib.Theme.Accent,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Arrow = Create("ImageLabel", {
                Parent = Header,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -35, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = "rbxassetid://6034829095",
                ImageColor3 = DeltaXLib.Theme.Accent,
                Rotation = Expanded and 180 or 0,
                ScaleType = Enum.ScaleType.Fit
            })

            local Container = Create("Frame", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 45),
                Size = UDim2.new(1, -10, 0, 0)
            })
            local Layout = Create("UIListLayout", {Parent = Container, Padding = UDim.new(0, 8)})

            local function ToggleSection()
                if DeltaXLib.IsPromptOpen then return end
                Expanded = not Expanded
                local TargetHeight = Expanded and (Layout.AbsoluteContentSize.Y + 55) or 40
                ApplyTween(SectionFrame, {Size = UDim2.new(1, 0, 0, TargetHeight)}, 0.4)
                ApplyTween(Arrow, {Rotation = Expanded and 180 or 0}, 0.4)
                task.wait(0.4)
                TabPage.CanvasSize = UDim2.new(0, 0, 0, TabPage.UIListLayout.AbsoluteContentSize.Y + 20)
            end

            Header.MouseButton1Click:Connect(ToggleSection)

            local SectionItems = {}
            function SectionItems:Button(c) 
                c.Parent = Container
                local b = CompLib:Button(c)
                if Expanded then SectionFrame.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 55) end
                return b
            end
            function SectionItems:Toggle(c) 
                c.Parent = Container
                local t = CompLib:Toggle(c)
                if Expanded then SectionFrame.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 55) end
                return t
            end

            return SectionItems
        end

        function CompLib:Input(Config)
            local InputFrame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = DeltaXLib.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 65)
            })
            Create("UICorner", {Parent = InputFrame, CornerRadius = DeltaXLib.Theme.Rounded})

            local TitleLabel = Create("TextLabel", {
                Name = "TitleLabel",
                Parent = InputFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 10),
                Size = UDim2.new(1, -30, 0, 15),
                Font = Enum.Font.GothamBold,
                Text = Config.Title,
                TextColor3 = DeltaXLib.Theme.White,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local BoxBG = Create("Frame", {
                Parent = InputFrame,
                BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                Position = UDim2.new(0, 12, 0, 32),
                Size = UDim2.new(1, -24, 0, 25)
            })
            Create("UICorner", {Parent = BoxBG, CornerRadius = UDim.new(0, 6)})

            local Box = Create("TextBox", {
                Parent = BoxBG,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamMedium,
                Text = "",
                PlaceholderText = Config.Placeholder or "输入内容...",
                TextColor3 = DeltaXLib.Theme.White,
                PlaceholderColor3 = DeltaXLib.Theme.Placeholder,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            Box.FocusLost:Connect(function()
                if DeltaXLib.IsPromptOpen then return end
                if Config.Callback then Config.Callback(Box.Text) end
            end)

            return InputFrame
        end
        
        function CompLib:Dropdown(Config)
            local Dropped = false
            local DropFrame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = DeltaXLib.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 45),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = DropFrame, CornerRadius = DeltaXLib.Theme.Rounded})

            local TopBtn = Create("TextButton", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45),
                Text = ""
            })

            local TitleLabel = Create("TextLabel", {
                Name = "TitleLabel",
                Parent = TopBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = Config.Title .. " : " .. (Config.Options[1] or "无"),
                TextColor3 = DeltaXLib.Theme.White,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local List = Create("Frame", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 45),
                Size = UDim2.new(1, 0, 0, #Config.Options * 30)
            })
            Create("UIListLayout", {Parent = List})

            for _, opt in pairs(Config.Options) do
                local OptBtn = Create("TextButton", {
                    Parent = List,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = opt,
                    TextColor3 = DeltaXLib.Theme.TextDark,
                    TextSize = 12
                })
                OptBtn.MouseButton1Click:Connect(function()
                    if DeltaXLib.IsPromptOpen then return end
                    TitleLabel.Text = Config.Title .. " : " .. opt
                    Dropped = false
                    ApplyTween(DropFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.3)
                    if Config.Callback then Config.Callback(opt) end
                end)
            end

            TopBtn.MouseButton1Click:Connect(function()
                if DeltaXLib.IsPromptOpen then return end
                Dropped = not Dropped
                ApplyTween(DropFrame, {Size = UDim2.new(1, 0, 0, Dropped and (45 + #Config.Options * 30) or 45)}, 0.3)
                task.wait(0.3)
                TabPage.CanvasSize = UDim2.new(0, 0, 0, TabPage.UIListLayout.AbsoluteContentSize.Y + 20)
            end)

            return DropFrame
        end

        function CompLib:Label(Config)
            local Lab = Create("Frame", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30)
            })
            local T = Create("TextLabel", {
                Name = "TitleLabel",
                Parent = Lab,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = Config.Title,
                TextColor3 = Config.Color or DeltaXLib.Theme.TextDark,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            return Lab
        end

        return CompLib
    end

    return DeltaXLib
end

return DeltaXLib