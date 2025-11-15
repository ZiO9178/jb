-- 静默式Sxingz Hub自动汉化UI（高级版）- 适配多注入器
-- 特点：无UI静默生成、全量汉化覆盖、跨注入器兼容、支持自定义保存路径
-----------------------------------------------------------
-- ================ 1. 基础服务与注入器兼容逻辑 ================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
-- 注入器文件操作函数适配（忍者/Delta/Synapse/Krnl等全兼容）
local readFunc, writeFunc, getPathFunc
pcall(function()
    if type(syn) == "table" then
        readFunc = syn.readfile or readfile
        writeFunc = syn.writefile or writefile
        getPathFunc = syn.datapath
    else
        readFunc = readfile or readFile
        writeFunc = writefile or writeFile
        getPathFunc = function() return "Roblox/SxingzHub" end -- 专属保存目录
    end
end)
-- ================ 2. 高级汉化配置区（可自定义） ================
-- 自定义1：汉化文件名称（支持任意后缀）
local CUSTOM_FILE_NAME = "SxingzHub_汉化配置.lua"
-- 自定义2：高级汉化核心内容（全量覆盖UI文本、功能描述、提示信息）
local CUSTOM_FILE_CONTENT = [[
-- Sxingz Hub 高级汉化包 V3.0
-- 适配所有功能模块，含详细注释与使用说明
local 汉化配置 = {
    -- 【主界面核心文本】
    ["Sxingz Hub - Premium"] = "Sxingz 中枢 - 高级版",
    ["Load Hub"] = "加载中枢",
    ["Unload Hub"] = "卸载中枢",
    ["Update Available!"] = "发现更新！",
    ["Click to Update"] = "点击更新",
    ["Welcome, %s!"] = "欢迎，%s！",
    ["VIP Status: Active"] = "VIP状态：已激活",
    ["VIP Status: Inactive"] = "VIP状态：未激活",
    ["Credits"] = "制作人员",
    ["Discord Server"] = "Discord服务器",
    ["Report Bug"] = "反馈漏洞",
    ["Settings"] = "设置",
    ["Exit"] = "退出",
    
    -- 【功能分类标签】
    ["Combat"] = "战斗模块",
    ["Movement"] = "移动模块",
    ["Visuals"] = "视觉模块",
    ["Automation"] = "自动模块",
    ["Miscellaneous"] = "杂项功能",
    ["VIP Exclusive"] = "VIP专属",
    ["Presets"] = "预设配置",
    
    -- 【战斗模块汉化】
    ["Aim Lock"] = "瞄准锁定",
    ["Silent Aim"] = "无声瞄准",
    ["Kill Aura"] = "杀戮光环",
    ["Hitbox Expansion"] = "碰撞箱扩大",
    ["Damage Boost"] = "伤害增益",
    ["Instant Kill"] = "瞬间击杀",
    ["Auto Block"] = "自动格挡",
    ["Auto Parry"] = "自动反击",
    ["Critical Hit Chance"] = "暴击概率",
    ["Bullet Trace"] = "子弹轨迹",
    ["Aim Assist"] = "瞄准辅助",
    ["Aim FOV"] = "瞄准视野",
    ["Smooth Aim"] = "平滑瞄准",
    ["Prediction"] = "预判补偿",
    ["Target Priority"] = "目标优先级",
    ["Players"] = "玩家",
    ["NPCs"] = "非玩家角色",
    ["Animals"] = "动物",
    
    -- 【移动模块汉化】
    ["Fly"] = "飞行",
    ["Fly Speed"] = "飞行速度",
    ["Noclip"] = "穿墙模式",
    ["Infinite Jump"] = "无限跳跃",
    ["Super Speed"] = "超级速度",
    ["Walk Speed"] = "行走速度",
    ["Sprint Speed"] = "冲刺速度",
    ["Jump Power"] = "跳跃力度",
    ["No Fall Damage"] = "无坠落伤害",
    ["Anti Knockback"] = "防击退",
    ["Teleport"] = "传送",
    ["TP to Player"] = "传送到玩家",
    ["TP to Mouse"] = "传送到鼠标位置",
    ["TP to Waypoint"] = "传送到路径点",
    ["Auto Dodge"] = "自动闪避",
    ["Dash"] = "冲刺",
    ["Dash Cooldown"] = "冲刺冷却",
    ["Dash Distance"] = "冲刺距离",
    
    -- 【视觉模块汉化】
    ["ESP"] = "透视功能",
    ["Player ESP"] = "玩家透视",
    ["NPC ESP"] = "NPC透视",
    ["Item ESP"] = "物品透视",
    ["Weapon ESP"] = "武器透视",
    ["Structure ESP"] = "建筑透视",
    ["ESP Color"] = "透视颜色",
    ["ESP Outline"] = "透视轮廓",
    ["ESP Distance"] = "透视距离",
    ["Fullbright"] = "全亮度",
    ["Remove Fog"] = "移除雾气",
    ["Remove Sky"] = "移除天空",
    ["Custom Crosshair"] = "自定义准星",
    ["Crosshair Color"] = "准星颜色",
    ["Crosshair Size"] = "准星大小",
    ["ESP Text Size"] = "透视文本大小",
    ["Show Distance"] = "显示距离",
    ["Show Health"] = "显示生命值",
    ["Show Name"] = "显示名称",
    ["3D Box ESP"] = "3D方框透视",
    ["2D Box ESP"] = "2D方框透视",
    ["Line ESP"] = "线条透视",
    ["Tracer ESP"] = "追踪线透视",
    
    -- 【自动模块汉化】
    ["Auto Farm"] = "自动刷取",
    ["Auto Collect"] = "自动收集",
    ["Auto Loot"] = "自动拾取",
    ["Auto Craft"] = "自动制作",
    ["Auto Cook"] = "自动烹饪",
    ["Auto Heal"] = "自动治疗",
    ["Auto Eat"] = "自动进食",
    ["Auto Fish"] = "自动钓鱼",
    ["Auto Mine"] = "自动挖矿",
    ["Auto Chop"] = "自动砍树",
    ["Auto Plant"] = "自动种植",
    ["Auto Defend"] = "自动防御",
    ["Auto Quest"] = "自动任务",
    ["Anti AFK"] = "防挂机",
    ["Auto Respawn"] = "自动复活",
    ["Auto Join"] = "自动加入",
    
    -- 【杂项功能汉化】
    ["God Mode"] = "无敌模式",
    ["Infinite Stamina"] = "无限耐力",
    ["Infinite Ammo"] = "无限弹药",
    ["Infinite Resources"] = "无限资源",
    ["No Clip Cooldown"] = "无穿墙冷却",
    ["Anti Cheat Bypass"] = "反作弊绕过",
    ["FPS Boost"] = "帧率提升",
    ["Low GFX"] = "低画质模式",
    ["Custom UI Scale"] = "自定义UI缩放",
    ["Language"] = "语言",
    ["Chinese (Simplified)"] = "中文（简体）",
    ["English"] = "英语",
    ["Theme"] = "主题",
    ["Dark Theme"] = "深色主题",
    ["Light Theme"] = "浅色主题",
    ["Custom Theme"] = "自定义主题",
    ["Sound Effects"] = "音效",
    ["Enable Sounds"] = "启用音效",
    ["Volume"] = "音量",
    
    -- 【VIP专属功能汉化】
    ["VIP Fly"] = "VIP专属飞行",
    ["Instant Teleport"] = "瞬间传送",
    ["Custom Script Execution"] = "自定义脚本执行",
    ["Preset Manager"] = "预设管理器",
    ["Save Preset"] = "保存预设",
    ["Load Preset"] = "加载预设",
    ["Delete Preset"] = "删除预设",
    ["Exclusive ESP Styles"] = "专属透视样式",
    ["Advanced Aim Bot"] = "高级瞄准机器人",
    ["Auto Win"] = "自动获胜",
    ["Server Hop"] = "切换服务器",
    ["Player Tracker"] = "玩家追踪器",
    
    -- 【提示信息汉化】
    ["Hub Loaded Successfully!"] = "中枢加载成功！",
    ["Hub Unloaded Successfully!"] = "中枢卸载成功！",
    ["Preset Saved!"] = "预设保存成功！",
    ["Preset Loaded!"] = "预设加载成功！",
    ["Are you sure you want to exit?"] = "确定要退出吗？",
    ["Cheat Detected! Disabling Features..."] = "检测到反作弊！正在禁用功能...",
    ["Not VIP! Feature Locked."] = "非VIP用户！功能已锁定。",
    ["Please join our Discord for updates!"] = "请加入我们的Discord获取更新！",
    ["No Players Found!"] = "未找到玩家！",
    ["Item Collected!"] = "物品已收集！",
    ["Auto Farm Activated!"] = "自动刷取已激活！",
    ["Enter Preset Name:"] = "输入预设名称：",
    ["Invalid Preset Name!"] = "无效的预设名称！",
    
    -- 【按键绑定汉化】
    ["Keybind Settings"] = "按键绑定设置",
    ["Open Hub"] = "打开中枢",
    ["Toggle Fly"] = "切换飞行",
    ["Toggle Noclip"] = "切换穿墙",
    ["Toggle Aim Lock"] = "切换瞄准锁定",
    ["Toggle Kill Aura"] = "切换杀戮光环",
    ["Toggle ESP"] = "切换透视",
    ["Teleport Forward"] = "向前传送",
    ["Set Waypoint"] = "设置路径点",
    ["Clear Waypoints"] = "清除路径点",
    ["Reset Settings"] = "重置设置",
    
    -- 【数值设置汉化】
    ["Speed: %s"] = "速度：%s",
    ["Power: %s"] = "力度：%s",
    ["Range: %s"] = "范围：%s",
    ["Chance: %s%%"] = "概率：%s%%",
    ["Cooldown: %sms"] = "冷却：%s毫秒",
    ["FOV: %s"] = "视野：%s",
    ["Size: %s"] = "大小：%s",
    ["Transparency: %s%%"] = "透明度：%s%%",
    ["Distance: %s Studs"] = "距离：%s 单位",
    
    -- 【物品/武器汉化】
    ["Sword"] = "剑",
    ["Axe"] = "斧头",
    ["Bow"] = "弓",
    ["Crossbow"] = "十字弩",
    ["Gun"] = "枪支",
    ["Rifle"] = "步枪",
    ["Pistol"] = "手枪",
    ["Shotgun"] = "霰弹枪",
    ["Sniper Rifle"] = "狙击步枪",
    ["Ammo"] = "弹药",
    ["Health Potion"] = "治疗药水",
    ["Mana Potion"] = "魔法药水",
    ["Food"] = "食物",
    ["Gold"] = "金币",
    ["Diamond"] = "钻石",
    ["Iron Ore"] = "铁矿石",
    ["Wood"] = "木材",
    ["Stone"] = "石头",
    ["Leather"] = "皮革",
    ["Armor"] = "盔甲",
    ["Helmet"] = "头盔",
    ["Chestplate"] = "胸甲",
    ["Leggings"] = " leggings（ leggings）",
    ["Boots"] = "靴子",
    ["Shield"] = "盾牌",
    
    -- 【角色相关汉化】
    ["Health"] = "生命值",
    ["Mana"] = "魔法值",
    ["Stamina"] = "耐力值",
    ["Level"] = "等级",
    ["Experience"] = "经验值",
    ["Strength"] = "力量",
    ["Dexterity"] = "敏捷",
    ["Intelligence"] = "智力",
    ["Defense"] = "防御",
    ["Luck"] = "幸运",
    ["Player Name"] = "玩家名称",
    ["Player ID"] = "玩家ID",
    ["Ping"] = "延迟",
    ["FPS"] = "帧率",
    
    -- 【高级设置汉化】
    ["UI Transparency"] = "UI透明度",
    ["Window Position"] = "窗口位置",
    ["Window Size"] = "窗口大小",
    ["Auto Save Settings"] = "自动保存设置",
    ["Load Default Settings"] = "加载默认设置",
    ["Export Settings"] = "导出设置",
    ["Import Settings"] = "导入设置",
    ["Debug Mode"] = "调试模式",
    ["Show Console"] = "显示控制台",
    ["Log Events"] = "记录事件",
    ["Disable Anti Cheat Warnings"] = "禁用反作弊警告",
    ["Custom Watermark"] = "自定义水印",
    ["Watermark Text"] = "水印文本",
    ["Watermark Position"] = "水印位置",
    ["Watermark Color"] = "水印颜色"
}

-- 【按钮文本汉化表】
local 按钮汉化 = {
    ["Enable"] = "启用",
    ["Disable"] = "禁用",
    ["Toggle"] = "切换",
    ["Activate"] = "激活",
    ["Deactivate"] = "取消激活",
    ["Save"] = "保存",
    ["Load"] = "加载",
    ["Delete"] = "删除",
    ["Create"] = "创建",
    ["Apply"] = "应用",
    ["Reset"] = "重置",
    ["Confirm"] = "确认",
    ["Cancel"] = "取消",
    ["Next"] = "下一步",
    ["Previous"] = "上一步",
    ["More"] = "更多",
    ["Less"] = "更少",
    ["Open"] = "打开",
    ["Close"] = "关闭",
    ["Connect"] = "连接",
    ["Disconnect"] = "断开连接",
    ["Buy"] = "购买",
    ["Claim"] = "领取",
    ["Share"] = "分享",
    ["Copy"] = "复制",
    ["Paste"] = "粘贴",
    ["Import"] = "导入",
    ["Export"] = "导出",
    ["Search"] = "搜索",
    ["Filter"] = "筛选",
    ["Sort"] = "排序",
    ["Default"] = "默认",
    ["Custom"] = "自定义"
}

-- 【透视专用汉化表】
local 透视汉化 = {
    ["Outline Color"] = "轮廓颜色",
    ["Fill Color"] = "填充颜色",
    ["Text Color"] = "文本颜色",
    ["Distance Color"] = "距离颜色",
    ["Health Bar Color"] = "生命值条颜色",
    ["Mana Bar Color"] = "魔法值条颜色",
    ["Box Thickness"] = "方框厚度",
    ["Line Thickness"] = "线条厚度",
    ["Update Rate"] = "更新频率",
    ["Show Behind Walls"] = "显示墙壁后方",
    ["Only Visible Targets"] = "仅显示可见目标",
    ["Highlight Target"] = "高亮目标",
    ["Target Lock Color"] = "锁定目标颜色"
}

-- 【动态文本汉化规则】
local 动态文本规则 = {
    {匹配模式 = "Level: %d+", 替换文本 = "等级：%1"},
    {匹配模式 = "Health: %d+/%d+", 替换文本 = "生命值：%1/%2"},
    {匹配模式 = "Mana: %d+/%d+", 替换文本 = "魔法值：%1/%2"},
    {匹配模式 = "Stamina: %d+/%d+", 替换文本 = "耐力值：%1/%2"},
    {匹配模式 = "Speed: %d+", 替换文本 = "速度：%1"},
    {匹配模式 = "Cooldown: %d+ms", 替换文本 = "冷却：%1毫秒"},
    {匹配模式 = "Range: %d+Studs", 替换文本 = "范围：%1单位"}
}

-- 导出汉化配置
return {
    核心汉化 = 汉化配置,
    按钮汉化 = 按钮汉化,
    透视汉化 = 透视汉化,
    动态规则 = 动态文本规则
}
]]
-- ================ 3. 高级工具函数（优化保存逻辑） ================
-- 获取跨平台保存路径（自动适配Windows/macOS）
local function getAdvancedSavePath()
    local basePath
    if getPathFunc then
        basePath = getPathFunc()
    else
        -- 系统检测与路径降级
        basePath = (game:GetService("MarketplaceService"):GetProductInfo(1).Name:find("Mac") 
            and "~/Library/Roblox/SxingzHub" 
            or "C:/Roblox/SxingzHub")
    end
    -- 确保目录存在（创建不存在的文件夹）
    pcall(function()
        if not isfolder(basePath) then
            makefolder(basePath)
        end
    end)
    -- 清理非法字符，确保文件名安全
    local safeFileName = CUSTOM_FILE_NAME:gsub("[\\/:*?\"<>|]", "_")
    return basePath .. "/" .. safeFileName
end

-- 高级静默保存（含错误处理与日志记录）
local function advancedSilentSave()
    if not writeFunc then
        warn("[Sxingz汉化] 注入器不支持文件写入，保存失败")
        return
    end
    local savePath = getAdvancedSavePath()
    local success, err = pcall(function()
        writeFunc(savePath, CUSTOM_FILE_CONTENT)
        -- 记录保存日志
        local logContent = string.format("[%s] 汉化配置保存成功 - 路径：%s", os.date("%Y-%m-%d %H:%M:%S"), savePath)
        if writeFunc then
            writeFunc(getAdvancedSavePath():gsub(CUSTOM_FILE_NAME, "Sxingz_汉化日志.txt"), logContent .. "\n", true)
        end
    end)
    if success then
        warn("[Sxingz汉化] 汉化配置保存成功：" .. savePath)
    else
        warn("[Sxingz汉化] 保存失败：" .. tostring(err))
    end
end

-- ================ 4. 启动入口（优化执行逻辑） ================
pcall(function()
    -- 延迟100ms确保注入器环境稳定
    task.wait(0.1)
    advancedSilentSave()
    -- 发送汉化完成通知（兼容支持通知的注入器）
    pcall(function()
        if type(notify) == "function" then
            notify("Sxingz Hub 汉化完成", "汉化配置已保存至指定路径", 5)
        end
    end)
end)
]]
-- ================ 5. 额外功能（可选启用） ================
-- 自动加载汉化配置（如需自动应用，移除以下注释）
-- pcall(function()
--     local loadPath = getAdvancedSavePath()
--     if readFunc and isfile(loadPath) then
--         local汉化Config = loadstring(readFunc(loadPath))()
--         warn("[Sxingz汉化] 自动加载汉化配置成功")
--     end
-- end)
