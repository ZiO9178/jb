local Claude = loadstring(game:HttpGet("https://www.superscriptguy.store/loader.lua"))()

Claude:StartLoad()

wait(2)

local Window = Claude:Window({
    SubTitle = "示例 v1.0",
    Size = UDim2.new(0, 700, 0, 500),
    TabWidth = 150
})

local ShowcaseTab = Window:Tab("展示", "rbxassetid://10747373176")
local MainTab = Window:Tab("主功能", "rbxassetid://10723407389")
local ComponentsTab = Window:Tab("组件", "rbxassetid://10723415335")
local SettingsTab = Window:Tab("设置", "rbxassetid://10734950309")

ShowcaseTab:Seperator("🚀 下一代UI库")

ShowcaseTab:Label("✨ Claude UI - 高端脚本的现代化界面")
ShowcaseTab:Label("🎯 专业级组件与流程动画")
ShowcaseTab:Label("⚡ 适配所有脚本类型的优化性能")

ShowcaseTab:Line()

ShowcaseTab:Seperator("🔥 高级功能")

ShowcaseTab:Toggle("自动执行", true, "游戏加入时自动执行脚本", function(state)
    Claude:Notify(state and "自动执行已开启!" or "自动执行已关闭")
end)

ShowcaseTab:Toggle("高级模式", true, "解锁进阶功能与设置", function(state)
    Claude:Notify("P高级模式 " .. (state and "已激活" or "已停用"))
end)

ShowcaseTab:Dropdown("脚本分类", {"注入脚本", "游戏脚本", "工具脚本", "高级脚本"}, "高级脚本", function(category)
    Claude:Notify("已选择: " .. category)
end)

ShowcaseTab:Slider("执行速度", 1, 10, 8, function(speed)
end)

ShowcaseTab:Line()

ShowcaseTab:Seperator("⚙️ 高级控制")

ShowcaseTab:Button("🎮 启动脚本中心", function()
    Claude:Notify("脚本中心启动成功!")
end)

ShowcaseTab:Button("🔧 打开开发者工具", function()
    Claude:Notify("开发者工具已激活")
end)

ShowcaseTab:Button("💎 解锁高级权限", function()
    Claude:Notify("高级功能已解锁!")
end)

ShowcaseTab:Textbox("授权密钥", false, function(key)
    if key ~= "" then
        Claude:Notify("授权密钥已验证: " .. string.sub(key, 1, 8) .. "...")
    end
end)

ShowcaseTab:Line()

ShowcaseTab:Seperator("📊 状态面板")

local statusLabel = ShowcaseTab:Label("🟢 系统状态: 在线")
local versionLabel = ShowcaseTab:Label("📦 版本: v2.4.1 高级版")
local usersLabel = ShowcaseTab:Label("👥 活跃用户: 1,247")

spawn(function()
    local statuses = {
        "🟢 系统状态: 在线",
        "🟡 系统状态: 高负载",
        "🟢 系统状态: 最佳",
        "🔵 系统状态: 维护中"
    }
    local users = {1247, 1251, 1256, 1260, 1243}

    while wait(4) do
        statusLabel:Set(statuses[math.random(1, #statuses)])
        usersLabel:Set("👥 活跃用户: " .. users[math.random(1, #users)])
    end
end)

MainTab:Seperator("基础功能")

MainTab:Button("发送通知", function()
    Claude:Notify("来自Claude UI库的问候!")
end)

MainTab:Button("测试提醒", function()
    Claude:Notify("这是一条测试通知包含较长文本以展示换行效果.")
end)

MainTab:Line()

local autoEnabled = false
MainTab:Toggle("自动模式", false, "开启自动操作", function(state)
    autoEnabled = state
    Claude:Notify("自动模式" .. (state and "已开启" or "已关闭"))
end)

MainTab:Toggle("静音模式", true, "减少通知与声音", function(state)
    print("静音模式:", state)
end)

ComponentsTab:Seperator("选择类型组件")

local weaponList = {"剑", "弓", "法杖", "匕首", "锤子"}
local selectedWeapon = "剑"
ComponentsTab:Dropdown("选择武器", weaponList, selectedWeapon, function(weapon)
    selectedWeapon = weapon
    Claude:Notify("已选择武器: " .. weapon)
end)

local modeList = {"简单", "普通", "困难", "专家"}
ComponentsTab:Dropdown("难度", modeList, "普通", function(mode)
    Claude:Notify("难度已设置为: " .. mode)
end)

ComponentsTab:Line()

ComponentsTab:Seperator("数值类组件")

ComponentsTab:Slider("音量", 0, 100, 75, function(value)
    print("音量:", value)
end)

ComponentsTab:Slider("速度倍率", 0.1, 5.0, 1.0, function(value)
    print("速度倍率:", value)
end)

ComponentsTab:Textbox("玩家名称", false, function(text)
    Claude:Notify("名称已设置为: " .. text)
end)

ComponentsTab:Textbox("自定义指令", false, function(text)
    print("自定义指令:", text)
end)

ComponentsTab:Line()

ComponentsTab:Seperator("信息展示")

local statusLabel = ComponentsTab:Label("状态: 就绪")
local counterLabel = ComponentsTab:Label("计数器: 0")

local counter = 0
spawn(function()
    while wait(3) do
        counter = counter + 1
        counterLabel:Set("计数器: " .. counter)

        local statuses = {"就绪", "运行中", "处理中", "空闲"}
        local randomStatus = statuses[math.random(1, #statuses)]
        statusLabel:Set("状态: " .. randomStatus)
    end
end)

SettingsTab:Seperator("用户配置")

SettingsTab:Textbox("API密钥", false, function(key)
    print("API密钥已更新:", key)
end)

SettingsTab:Toggle("保存设置", true, "自动保存配置", function(state)
    print("保存设置:", state)
end)

SettingsTab:Toggle("自动更新", false, "自动检查更新", function(state)
    print("自动更新:", state)
end)

SettingsTab:Line()

SettingsTab:Seperator("性能设置")

SettingsTab:Slider("刷新率", 10, 60, 30, function(rate)
    print("刷新率:", rate, "Hz")
end)

SettingsTab:Slider("最大连接数", 1, 20, 5, function(connections)
    print("最大连接数:", connections)
end)

SettingsTab:Line()

SettingsTab:Seperator("高级设置")

local themeOptions = {"深色", "浅色", "蓝色", "红色", "绿色"}
SettingsTab:Dropdown("主题", themeOptions, "深色", function(theme)
    Claude:Notify("主题一切换为: " .. theme)
    if theme == "蓝色" then
        _G.Third = Color3.fromRGB(0, 100, 255)
    elseif theme == "绿色" then
        _G.Third = Color3.fromRGB(0, 255, 100)
    elseif theme == "红色" then
        _G.Third = Color3.fromRGB(255, 0, 0)
    end
end)

SettingsTab:Button("重置为默认值", function()
    Claude:Notify("设置已重置为默认值")
    print("所有设置已重置")
end)

SettingsTab:Button("导出配置", function()
    Claude:Notify("配置导出成功")
    print("配置已导出")
end)

Claude:Loaded()

wait(1)
Claude:Notify("Claude UI库加载成功!")

spawn(function()
    wait(5)
    local dropdown = ComponentsTab:Dropdown("动态列表", {"项目 1"}, "项目 1", function(item)
        print("已选择动态项目:", item)
    end)

    wait(2)
    dropdown:Add("项目 2")
    wait(2)
    dropdown:Add("项目 3")
    wait(3)
    dropdown:Clear()
    dropdown:Add("新项目 1")
    dropdown:Add("新项目 2")
end)