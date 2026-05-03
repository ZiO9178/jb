local DeltaXLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/jb/refs/heads/main/Sxingz%20Hub%20UI.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local playerAvatar = Players:GetUserThumbnailAsync(
    LocalPlayer.UserId,
    Enum.ThumbnailType.HeadShot, 
    Enum.ThumbnailSize.Size420x420
)

local Win = DeltaXLib:CreateWindow({
    Title = "Sxingz Hub",
    SubTitle = "by:Z某人",
    Footer = "玩家: " .. LocalPlayer.DisplayName .. " @" .. LocalPlayer.Name .." | 版本:V2",
    Icon = "rbxassetid://102585069490701",
    TitleIcon = playerAvatar,
    BackgroundImage = "rbxassetid://88207043917712"
})

local Tab = Win:CreateTab("自动翻译")

_G.AutoTranslate = false
local Initialized = false

Tab:Toggle({
    Title = "自动翻译",
    Default = false,
    Callback = function(Value)
        _G.AutoTranslate = Value
        print("自动翻译状态:", _G.AutoTranslate)

        if Initialized then return end
        Initialized = true

        local Http, Players, CoreGui = 
            game:GetService("HttpService"), 
            game:GetService("Players"), 
            game:GetService("CoreGui")

        local request = request or http_request or 
            (syn and syn.request) or 
            (fluxus and fluxus.request)

        if not (request and hookmetamethod) then
            warn("当前执行器不支持 request 或 hookmetamethod")
            return
        end

        local Encode, Decode, Spawn = 
            Http.UrlEncode, 
            Http.JSONDecode, 
            task.spawn

        local Cache, Queue, RealText, Locks = {}, {}, setmetatable({}, { __mode = "k" }), {}
        local API = "https://clients5.google.com/translate_a/t?client=dict-chrome-ex&sl=auto&tl=zh-CN&q="
        local MonitoredContainers = {}

        local OldIdx
        OldIdx = hookmetamethod(game, "__index", function(t, k)
            if k == "Text" and not checkcaller() then
                return RealText[t] or OldIdx(t, k)
            end
            return OldIdx(t, k)
        end)

        local function SetTrans(obj, origin, trans, vars)
            if not _G.AutoTranslate then return end
            if obj.Text ~= origin then return end
            
            local k = 0
            local val = trans:gsub("%s?{[nN]}%s?", function()
                k = k + 1
                return vars[k] or ""
            end)
            
            if obj.Text ~= val then
                Locks[obj] = 1
                RealText[obj] = origin
                obj.Text = val
                Locks[obj] = nil
            end
        end

        local function Process(obj)
            if not _G.AutoTranslate then return end
            if Locks[obj] then return end
            
            local txt = obj.Text
            if #txt < 2 or txt:match("^[%d%s%p]+$") then return end
            
            local vars = {}
            local skel = txt:gsub("[%+$%-¥]?%d+[%d%.%,:]*[%d%%]*", function(m)
                vars[#vars + 1] = m
                return "{n}"
            end)
            
            if Cache[skel] then
                return SetTrans(obj, txt, Cache[skel], vars)
            end
            
            local q = Queue[skel]
            if q then
                q[#q + 1] = { obj, vars, txt }
                return
            end
            
            Queue[skel] = { { obj, vars, txt } }
            Spawn(function()
                local s, r = pcall(request, { 
                    Url = API .. Encode(Http, skel), 
                    Method = "GET" 
                })
                local d = s and r.StatusCode == 200 and Decode(Http, r.Body)
                local res = type(d) == "table" and (type(d[1]) == "string" and d[1] or d[1][1])
                
                if res then
                    Cache[skel] = res
                    for _, i in next, Queue[skel] do
                        if i[1].Parent then
                            SetTrans(i[1], i[3], res, i[2])
                        end
                    end
                end
                Queue[skel] = nil
            end)
        end

        local function MonitorContainer(container)
            if MonitoredContainers[container] then return end
            MonitoredContainers[container] = true
            
            local function Bind(v)
                if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                    Process(v)
                    v:GetPropertyChangedSignal("Text"):Connect(function()
                        if _G.AutoTranslate then Process(v) end
                    end)
                end
            end

            for _, v in next, container:GetDescendants() do Bind(v) end
            container.DescendantAdded:Connect(Bind)
        end

        local Roots = { 
            Players.LocalPlayer:WaitForChild("PlayerGui"), 
            (gethui and gethui()) or CoreGui, 
            workspace 
        }

        for _, root in next, Roots do MonitorContainer(root) end
        
        workspace.DescendantAdded:Connect(function(child)
            if child:IsA("SurfaceGui") or child:IsA("BillboardGui") then
                MonitorContainer(child)
            end
        end)
    end
})

local Tab = Win:CreateTab("主要")

Tab:Label({
Title = "欢迎使用Sxingz Hub", 
Color = Color3.fromRGB(0, 255, 180)
})

local lp = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local speedValue = 16

RunService.PreSimulation:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hum = lp.Character.Humanoid
        if speedValue > 16 and hum.MoveDirection.Magnitude > 0 then
            local moveOffset = hum.MoveDirection * (speedValue / 100) 
            lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame + moveOffset
        end
    end
end)

local SliderSpeed = Tab:Slider({
    Title = "移动速度",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(v)
        speedValue = v
    end
})

local UIS = game:GetService("UserInputService")
local lp = game.Players.LocalPlayer
local jumpValue = 30

local SliderJump = Tab:Slider({
    Title = "跳跃力度",
    Min = 30,
    Max = 200,
    Default = 30,
    Callback = function(v)
        jumpValue = v
    end
})

UIS.JumpRequest:Connect(function()
    local character = lp.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and rootPart and humanoid.FloorMaterial ~= Enum.Material.Air then
        task.wait(0.05)
        rootPart.AssemblyLinearVelocity = Vector3.new(
            rootPart.AssemblyLinearVelocity.X, 
            jumpValue, 
            rootPart.AssemblyLinearVelocity.Z
        )
    end
end)

Tab:Button({
    Title = "无限跳跃",
    Callback = function()
     print("")
     loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))()
     end
})

Tab:Button({
    Title = "飞行",
    Callback = function()
     print("")
     loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/jb/refs/heads/main/fly.lua"))()
     end
})

Tab:Button({
    Title = "穿墙",
    Callback = function()
     print("")
     loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/jb/refs/heads/main/穿墙.lua"))()
     end
})

Tab:Button({
    Title = "ESP",
    Callback = function()
     print("")
     loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/other/refs/heads/main/透视.lua"))()
     end
})

local Tab = Win:CreateTab("枪地FFA")

Tab:Button({
    Title = "枪地FFA",
    Callback = function()
        local TargetPlaceId = 12137249458

        if game.PlaceId == TargetPlaceId then
            print("服务器正确，正在执行脚本..")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/zhizi/refs/heads/main/枪地FFA.lua"))()
        else
            game.Players.LocalPlayer:Kick("由于服务器不匹配，你已被踢出该服务器")
        end
    end
})

local Tab = Win:CreateTab("极速传奇")

Tab:Button({
    Title = "极速传奇",
    Callback = function()
        local TargetPlaceId = 3101667897

        if game.PlaceId == TargetPlaceId then
            print("服务器正确，正在执行脚本..")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/zhizi/refs/heads/main/%E6%9E%81%E9%80%9F%E4%BC%A0%E5%A5%87.lua"))()
        else
            game.Players.LocalPlayer:Kick("由于服务器不匹配，你已被踢出该服务器")
        end
    end
})

local Tab = Win:CreateTab("戒网瘾中心")

Tab:Button({
    Title = "戒网瘾中心",
    Callback = function()
        local TargetPlaceId = 97362459421282

        if game.PlaceId == TargetPlaceId then
            print("服务器正确，正在执行脚本..")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ZiO9178/zhizi/refs/heads/main/%E6%88%92%E7%BD%91%E7%98%BE%E4%B8%AD%E5%BF%83.lua"))()
        else
            game.Players.LocalPlayer:Kick("由于服务器不匹配，你已被踢出该服务器")
        end
    end
})