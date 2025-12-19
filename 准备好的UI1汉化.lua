local AlexchadLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/jb/refs/heads/main/Sxingz%20Hub%20UI.lua"))()

local Window = AlexchadLibrary:CreateWindow({
    Name = "Sxingz Hub",
    Subtitle = "Z某人",
    Version = "免费版",
    LoadingTitle = "Sxingz Hub加载中", -- 加载界面标题
    LoadingSubtitle = "请稍后...", -- 加载界面副标题
    Theme = "Default", -- 主题: Default, Midnight, Ocean, Emerald, Light, Dark
    AnimationSpeed = 0.2, -- 动画速度
    RippleEnabled = false, -- 是否启用点击波纹效果
    RippleSpeed = 0.35, -- 波纹扩散速度
    CornerRadius = 12, -- 窗口圆角
    ElementCornerRadius = 10, -- 元素圆角
    BlurEnabled = true, -- 窗口最大化时是否启用背景模糊
    ConfigurationSaving = {
        Enabled = false, -- 是否启用配置保存
        FolderName = "AlexchadLibraryExample", -- 配置文件夹名称
        FileName = "Config" -- 配置文件名
    },
    ToggleKey = Enum.KeyCode.RightShift -- UI 显示/隐藏的热键 (右侧 Shift)
})

-- 标签页：开关
local Tab1 = Window:CreateTab({
    Name = "主要功能",
    Icon = ""
})

Section1:CreateToggle({
    Name = "简单开关",
    Flag = "Toggle1", -- 配置标识符，请确保唯一
    CurrentValue = false, -- 默认状态
    Callback = function(value)
        print("开关 1 状态:", value)
    end
})

Section1:CreateToggle({
    Name = "默认开启开关",
    Flag = "Toggle2",
    CurrentValue = true,
    Callback = function(value)
        print("开关 2 状态:", value)
    end
})

-- 标签页：滑动条
local Tab2 = Window:CreateTab({
    Name = "滑动条",
    Icon = "🎚️"
})

local Section2 = Tab2:CreateSection("滑动条示例")

Section2:CreateSlider({
    Name = "基础滑动条",
    Flag = "Slider1",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(value)
        print("滑动条 1 数值:", value)
    end
})

Section2:CreateSlider({
    Name = "速度调节",
    Flag = "Slider2",
    Range = {16, 500},
    Increment = 5,
    CurrentValue = 16,
    Suffix = " 速度",
    Callback = function(value)
        print("滑动条 2 数值:", value)
    end
})

-- 标签页：下拉菜单
local Tab3 = Window:CreateTab({
    Name = "下拉菜单",
    Icon = "📋"
})

local Section3 = Tab3:CreateSection("下拉菜单示例")

Section3:CreateDropdown({
    Name = "单选模式",
    Flag = "Dropdown1",
    Options = {"选项 A", "选项 B", "选项 C"},
    CurrentOption = "选项 A",
    Callback = function(option)
        print("已选择:", option)
    end
})

Section3:CreateDropdown({
    Name = "多选模式",
    Flag = "Dropdown2",
    Options = {"红色", "绿色", "蓝色", "黄色"},
    CurrentOption = {"红色"},
    MultiSelect = true,
    Callback = function(options)
        print("已选择列表:", table.concat(options, ", "))
    end
})

-- 标签页：按钮
local Tab4 = Window:CreateTab({
    Name = "按钮",
    Icon = "🔲"
})

local Section4 = Tab4:CreateSection("按钮示例")

Section4:CreateButton({
    Name = "点击测试",
    Callback = function()
        print("按钮被点击了！")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/zhizi/refs/heads/main/通缉.lua"))()
    end
})

Section4:CreateButton({
    Name = "显示通知",
    Callback = function()
        Window:Notify({
            Title = "操作成功",
            Content = "您点击了通知按钮！",
            Duration = 3,
            Type = "Success"
        })
    end
})

Section4:CreateButton({
    Name = "显示确认对话框",
    Callback = function()
        Window:Dialog({
            Title = "操作确认",
            Content = "你确定要执行此操作吗？",
            Buttons = {
                {
                    Title = "取消",
                    Callback = function()
                        print("已取消")
                    end
                },
                {
                    Title = "确定",
                    Primary = true,
                    Callback = function()
                        print("已确认")
                    end
                }
            }
        })
    end
})

-- 标签页：输入
local Tab5 = Window:CreateTab({
    Name = "输入与绑定",
    Icon = "⌨️"
})

local Section5 = Tab5:CreateSection("输入框示例")

Section5:CreateInput({
    Name = "文本输入",
    Flag = "Input1",
    PlaceholderText = "请输入内容...",
    Callback = function(text)
        print("输入内容:", text)
    end
})

Section5:CreateKeybind({
    Name = "按键绑定",
    Flag = "Keybind1",
    CurrentKeybind = "Q",
    Callback = function()
        print("绑定的按键被按下！")
    end
})

-- 标签页：颜色
local Tab6 = Window:CreateTab({
    Name = "颜色",
    Icon = "🎨"
})

local Section6 = Tab6:CreateSection("调色板示例")

Section6:CreateColorPicker({
    Name = "选择颜色",
    Flag = "ColorPicker1",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("当前颜色:", color)
    end
})

-- 标签页：文本展示
local Tab7 = Window:CreateTab({
    Name = "文本",
    Icon = "📝"
})

local Section7 = Tab7:CreateSection("文本显示示例")

Section7:CreateLabel("这是一个简单的文本标签")

Section7:CreateParagraph({
    Title = "段落标题",
    Content = "这是一个可以显示多行文本的段落组件。\n它非常适合用来展示脚本说明、\n更新日志或者注意事项！"
})

-- 标签页：主题
local Tab8 = Window:CreateTab({
    Name = "主题",
    Icon = "🎭"
})

local Section8 = Tab8:CreateSection("主题切换器")

Section8:CreateDropdown({
    Name = "选择主题",
    Flag = "Theme",
    Options = Window:GetThemes(),
    CurrentOption = Window:GetTheme(),
    Callback = function(theme)
        Window:SetTheme(theme)
    end
})

-- 标签页：通知
local Tab9 = Window:CreateTab({
    Name = "通知",
    Icon = "🔔"
})

local Section9 = Tab9:CreateSection("各类通知演示")

Section9:CreateButton({
    Name = "普通信息通知",
    Callback = function()
        Window:Notify({
            Title = "提示",
            Content = "这是一条普通通知",
            Duration = 3,
            Type = "Info"
        })
    end
})

Section9:CreateButton({
    Name = "成功通知",
    Callback = function()
        Window:Notify({
            Title = "成功",
            Content = "操作已成功完成！",
            Duration = 3,
            Type = "Success"
        })
    end
})

Section9:CreateButton({
    Name = "警告通知",
    Callback = function()
        Window:Notify({
            Title = "警告",
            Content = "请注意此项操作！",
            Duration = 3,
            Type = "Warning"
        })
    end
})

Section9:CreateButton({
    Name = "错误通知",
    Callback = function()
        Window:Notify({
            Title = "发生错误",
            Content = "程序遇到了一些问题！",
            Duration = 3,
            Type = "Error"
        })
    end
})

-- 初始欢迎通知
Window:Notify({
    Title = "Alexchad 库已加载",
    Content = "所有 UI 元素已汉化并展示完毕！",
    Duration = 5,
    Type = "Success"
})