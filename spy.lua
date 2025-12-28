local Translations = {
["Home"] = "首页",
    ["RSpy"] = "远程监听 (RSpy)",
    ["ESpy"] = "事件监听 (ESpy)",
    ["HTTPSpy"] = "HTTP 监听",
    ["ScriptScanner"] = "脚本扫描器",
    ["MemoryScanner"] = "内存扫描器",
    ["Settings"] = "设置",
    ["Back"] = "返回",
    ["Close"] = "关闭",
    ["Minimize"] = "最小化",
    ["Unavailable"] = "不可用",
    ["THIS TOOL IS UNAVAILABLE IN YOUR EXECUTOR"] = "当前执行器不支持此工具",
    ["The page you are looking for does not exist."] = "您查看的页面不存在。",
    ["NotFound"] = "未找到",
    ["Label"] = "标签",
    ["Search for scripts..."] = "搜索脚本...",
    ["Scan Results"] = "扫描结果",
    ["Matches"] = "匹配项",
    ["Loading scripts..."] = "正在加载脚本...",
    ["Start Scanning"] = "开始扫描",
    ["CopyCode"] = "复制代码",
    ["CopyPath"] = "复制路径",
    ["Enchant"] = "注入脚本",
    ["Search for values..."] = "搜索内存数值...",
    ["Enter value..."] = "输入数值...",
    ["Generate code"] = "生成代码",
    ["Set parent"] = "设置父级",
    ["Value"] = "数值",
    ["Search logs..."] = "搜索日志...",
    ["To"] = "发送 (To)",
    ["From"] = "接收 (From)",
    ["Copy args to clipboard"] = "复制参数到剪贴板",
    ["Copy result to clipboard"] = "复制结果到剪贴板",
    ["Copy caller to clipboard"] = "复制调用来源",
    ["Run code"] = "运行代码",
    ["Changelogs"] = "更新日志",
    ["Ketamine"] = "Ketamine 调试器",
    ["Log calls called only by game scripts"] = "仅记录游戏原生脚本调用",
    ["UI Shadow Settings"] = "界面阴影设置",
    ["Log Settings"] = "日志设置"
}

local function translateText(text)
    if not text or type(text) ~= "string" then return text end
    
    if Translations[text] then
        return Translations[text]
    end
    
    for en, cn in pairs(Translations) do
        if text:find(en) then
            return text:gsub(en, cn)
        end
    end
    
    return text
end

local function setupTranslationEngine()
    local success, err = pcall(function()
        local oldIndex = getrawmetatable(game).__newindex
        setreadonly(getrawmetatable(game), false)
        
        getrawmetatable(game).__newindex = newcclosure(function(t, k, v)
            if (t:IsA("TextLabel") or t:IsA("TextButton") or t:IsA("TextBox")) and k == "Text" then
                v = translateText(tostring(v))
            end
            return oldIndex(t, k, v)
        end)
        
        setreadonly(getrawmetatable(game), true)
    end)
    
    if not success then
        warn("元表劫持失败:", err)
       
        local translated = {}
        local function scanAndTranslate()
            for _, gui in ipairs(game:GetService("CoreGui"):GetDescendants()) do
                if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) and not translated[gui] then
                    pcall(function()
                        local text = gui.Text
                        if text and text ~= "" then
                            local translatedText = translateText(text)
                            if translatedText ~= text then
                                gui.Text = translatedText
                                translated[gui] = true
                            end
                        end
                    end)
                end
            end
            
            local player = game:GetService("Players").LocalPlayer
            if player and player:FindFirstChild("PlayerGui") then
                for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
                    if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) and not translated[gui] then
                        pcall(function()
                            local text = gui.Text
                            if text and text ~= "" then
                                local translatedText = translateText(text)
                                if translatedText ~= text then
                                    gui.Text = translatedText
                                    translated[gui] = true
                                end
                            end
                        end)
                    end
                end
            end
        end
        
        local function setupDescendantListener(parent)
            parent.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                    task.wait(0.1)
                    pcall(function()
                        local text = descendant.Text
                        if text and text ~= "" then
                            local translatedText = translateText(text)
                            if translatedText ~= text then
                                descendant.Text = translatedText
                            end
                        end
                    end)
                end
            end)
        end
        
        pcall(setupDescendantListener, game:GetService("CoreGui"))
        local player = game:GetService("Players").LocalPlayer
        if player and player:FindFirstChild("PlayerGui") then
            pcall(setupDescendantListener, player.PlayerGui)
        end
        
        while true do
            scanAndTranslate()
            task.wait(3)
        end
    end
end

task.wait(2)

setupTranslationEngine()

local success, err = pcall(function()
--这下面填加载外部脚本
loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/jb/refs/heads/main/spy.lua"))()


end)

if not success then
    warn("加载失败:", err)
end
