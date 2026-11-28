--[[
	ZephyrUI v1.0.0
	WindUI 风格的 Roblox 界面库。单文件，不依赖外部图片资源。

	用法：
		local Zephyr = loadstring(game:HttpGet("https://example.com/ZephyrUI.lua"))()
		local Window = Zephyr:CreateWindow({ Title = "Zephyr", Icon = "wind" })
		local Tab = Window:Tab({ Title = "Main", Icon = "home" })
		Tab:Button({ Title = "Hello", Callback = function() Zephyr:Notify({ Title = "Hi" }) end })

	图标默认用字体字形，也可以传 rbxassetid:// 图片地址。

	License: MIT
]]

local Zephyr = {}
Zephyr.__index = Zephyr
Zephyr.Version = "1.0.0"

--------------------------------------------------------------------------------
-- services
--------------------------------------------------------------------------------

local function service(name)
	local ok, svc = pcall(function()
		return cloneref and cloneref(game:GetService(name)) or game:GetService(name)
	end)
	if ok and svc then
		return svc
	end
	return game:GetService(name)
end

local Players = service("Players")
local UserInputService = service("UserInputService")
local TweenService = service("TweenService")
local RunService = service("RunService")
local TextService = service("TextService")
local Lighting = service("Lighting")
local GuiService = service("GuiService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- tiny helpers
--------------------------------------------------------------------------------

local function New(class, props, parent)
	local obj = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			obj[k] = v
		end
	end
	if parent then
		obj.Parent = parent
	end
	return obj
end

local function Round(obj, radius)
	return New("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, obj)
end

local function Stroke(obj, color, thickness, transparency)
	return New("UIStroke", {
		Color = color or Color3.new(1, 1, 1),
		Thickness = thickness or 1,
		Transparency = transparency or 0.9,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, obj)
end

local function Pad(obj, top, right, bottom, left)
	return New("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingRight = UDim.new(0, right or 0),
		PaddingBottom = UDim.new(0, bottom or 0),
		PaddingLeft = UDim.new(0, left or 0),
	}, obj)
end

local function Tween(obj, props, time, style, dir)
	local info = TweenInfo.new(
		time or 0.18,
		style or Enum.EasingStyle.Quad,
		dir or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(obj, info, props)
	tween:Play()
	return tween
end

local function Measure(text, size, width, font)
	local ok, result = pcall(function()
		return TextService:GetTextSize(
			tostring(text or ""),
			size or 13,
			font or Enum.Font.Gotham,
			Vector2.new(width or 300, 10000)
		)
	end)
	if ok and result then
		return result
	end
	return Vector2.new(width or 300, (size or 13) * 2)
end

local function Hex(value)
	local ok, color = pcall(function()
		return Color3.fromHex(value)
	end)
	if ok then
		return color
	end
	return Color3.fromRGB(255, 255, 255)
end

local function LerpColor(a, b, alpha)
	return a:Lerp(b, alpha)
end

local Fonts = {}
do
	local names = {
		Regular = { "Gotham", "SourceSans" },
		Medium = { "GothamMedium", "Gotham", "SourceSans" },
		Semibold = { "GothamSemibold", "GothamBold", "Gotham", "SourceSans" },
		Bold = { "GothamBold", "GothamSemibold", "Gotham", "SourceSans" },
	}
	for key, list in pairs(names) do
		Fonts[key] = Enum.Font.SourceSans
		for _, name in ipairs(list) do
			local ok, font = pcall(function()
				return Enum.Font[name]
			end)
			if ok and font then
				Fonts[key] = font
				break
			end
		end
	end
end

--------------------------------------------------------------------------------
-- icons (glyph first, asset ids also accepted)
--------------------------------------------------------------------------------

local Glyphs = {
	wind = "≣",
	home = "⌂",
	settings = "✳",
	user = "◎",
	users = "◎",
	search = "⌕",
	close = "✕",
	minimize = "−",
	maximize = "□",
	chevron_down = "▾",
	chevron_up = "▴",
	chevron_left = "◂",
	chevron_right = "▸",
	check = "✓",
	plus = "+",
	minus = "−",
	dot = "●",
	circle = "○",
	star = "☆",
	heart = "♡",
	bolt = "↯",
	power = "⏻",
	clock = "◷",
	folder = "▤",
	code = "‹›",
	info = "ⓘ",
	warning = "△",
	trash = "⌫",
	refresh = "↻",
	play = "▶",
	pause = "‖",
	copy = "⧉",
	link = "↔",
	shield = "◊",
	sparkles = "✦",
	palette = "◐",
	sliders = "☰",
	grid = "▦",
	key = "⚿",
	mouse = "◉",
	globe = "◍",
	terminal = ">_",
	layers = "≡",
	image = "▣",
	bell = "◔",
	download = "⤓",
	upload = "⤑",
	eye = "◉",
	lock = "⚿",
	book = "▤",
	rocket = "↗",
	gift = "✦",
	tag = "◇",
	hammer = "◫",
	wave = "≈",
	music = "♫",
	camera = "◉",
	chat = "◌",
}

-- names that map a WindUI-style icon name onto the glyph table
local IconAliases = {
	["house"] = "home",
	["cog"] = "settings",
	["gear"] = "settings",
	["magnify"] = "search",
	["x"] = "close",
	["times"] = "close",
	["dash"] = "minimize",
	["check-circle"] = "check",
	["alert"] = "warning",
	["exclamation"] = "warning",
	["zap"] = "bolt",
	["lightning"] = "bolt",
	["account"] = "user",
	["person"] = "user",
	["profile"] = "user",
	["dashboard"] = "grid",
	["list"] = "layers",
	["terminal-square"] = "terminal",
	["window"] = "grid",
	["brush"] = "palette",
}

local function ResolveGlyph(name)
	if type(name) ~= "string" then
		return nil
	end
	return Glyphs[IconAliases[name] or name]
end

--------------------------------------------------------------------------------
-- themes
--------------------------------------------------------------------------------

local Themes = {
	Dark = {
		Panel = Hex("#12121A"),
		Sidebar = Hex("#0D0D14"),
		Control = Hex("#1C1C27"),
		ControlHover = Hex("#242432"),
		Hover = Hex("#FFFFFF"),
		HoverTransparency = 0.955,
		Text = Hex("#F4F4F8"),
		SubText = Hex("#9E9EAF"),
		Muted = Hex("#6A6A7B"),
		Stroke = Hex("#FFFFFF"),
		StrokeTransparency = 0.92,
		Accent = Hex("#4D8DFF"),
		AccentText = Hex("#FFFFFF"),
		Success = Hex("#3DD68C"),
		Warning = Hex("#F5B544"),
		Danger = Hex("#FF5C5C"),
		Overlay = Hex("#000000"),
		OverlayTransparency = 0.45,
		Shadow = Hex("#000000"),
	},
	Light = {
		Panel = Hex("#FFFFFF"),
		Sidebar = Hex("#F4F5F8"),
		Control = Hex("#F1F2F6"),
		ControlHover = Hex("#E7E9F0"),
		Hover = Hex("#000000"),
		HoverTransparency = 0.965,
		Text = Hex("#14141A"),
		SubText = Hex("#5C5C6B"),
		Muted = Hex("#8E8E9C"),
		Stroke = Hex("#000000"),
		StrokeTransparency = 0.9,
		Accent = Hex("#2F6BFF"),
		AccentText = Hex("#FFFFFF"),
		Success = Hex("#16A34A"),
		Warning = Hex("#D97706"),
		Danger = Hex("#DC2626"),
		Overlay = Hex("#0B0B10"),
		OverlayTransparency = 0.45,
		Shadow = Hex("#000000"),
	},
	Midnight = {
		Panel = Hex("#0B1220"),
		Sidebar = Hex("#070D18"),
		Control = Hex("#131C2E"),
		ControlHover = Hex("#1A2740"),
		Hover = Hex("#FFFFFF"),
		HoverTransparency = 0.955,
		Text = Hex("#EAF2FF"),
		SubText = Hex("#8FA3C0"),
		Muted = Hex("#5F7391"),
		Stroke = Hex("#7FB4FF"),
		StrokeTransparency = 0.9,
		Accent = Hex("#38BDF8"),
		AccentText = Hex("#04121E"),
		Success = Hex("#34D399"),
		Warning = Hex("#FBBF24"),
		Danger = Hex("#F87171"),
		Overlay = Hex("#000000"),
		OverlayTransparency = 0.4,
		Shadow = Hex("#000000"),
	},
	Rose = {
		Panel = Hex("#1A0F16"),
		Sidebar = Hex("#140B11"),
		Control = Hex("#251520"),
		ControlHover = Hex("#301B29"),
		Hover = Hex("#FFFFFF"),
		HoverTransparency = 0.955,
		Text = Hex("#FFF1F7"),
		SubText = Hex("#C6A0B4"),
		Muted = Hex("#8A6A7C"),
		Stroke = Hex("#FFB3D1"),
		StrokeTransparency = 0.92,
		Accent = Hex("#F472B6"),
		AccentText = Hex("#2A0A18"),
		Success = Hex("#4ADE80"),
		Warning = Hex("#FBBF24"),
		Danger = Hex("#FB7185"),
		Overlay = Hex("#000000"),
		OverlayTransparency = 0.42,
		Shadow = Hex("#000000"),
	},
}

local state = {
	themeName = "Dark",
	theme = Themes.Dark,
	accent = Themes.Dark.Accent,
	root = nil,
	scaler = nil,
	scale = nil,
	scaleValue = 1,
	windows = {},
	bindings = {},
	blur = nil,
	blurUsers = 0,
	notificationHolder = nil,
	dialogHolder = nil,
	toasts = {},
	popups = {},
	searchIndex = {},
}

local function Color(key)
	if key == "Accent" then
		return state.accent
	end
	return state.theme[key] or Color3.new(1, 1, 1)
end

local function Bind(fn)
	table.insert(state.bindings, fn)
	fn()
end

local function BindColor(obj, prop, key)
	Bind(function()
		obj[prop] = Color(key)
	end)
end

--------------------------------------------------------------------------------
-- accent gradient helper
--------------------------------------------------------------------------------

local function AccentGradient(obj, rotation)
	local gradient = New("UIGradient", {
		Rotation = rotation or 90,
	}, obj)
	Bind(function()
		local a = Color("Accent")
		local b = a:Lerp(Color3.new(1, 1, 1), 0.28)
		gradient.Color = ColorSequence.new(a, b)
	end)
	return gradient
end

--------------------------------------------------------------------------------
-- root gui
--------------------------------------------------------------------------------

local function guiParent()
	if gethui then
		local ok, hui = pcall(gethui)
		if ok and hui then
			return hui
		end
	end
	local ok, core = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok and core then
		return core
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local function viewport()
	local camera = workspace.CurrentCamera
	if camera then
		return camera.ViewportSize
	end
	return Vector2.new(1280, 720)
end

local function updateScale()
	if not state.scale then
		return
	end
	local vp = viewport()
	local s = math.min(vp.X / 1280, vp.Y / 720)
	state.scaleValue = math.clamp(s, 0.5, 1.3)
	state.scale.Scale = state.scaleValue
end

local function ensureRoot()
	if state.root and state.root.Parent then
		return state.root
	end

	local sg = New("ScreenGui", {
		Name = "ZephyrUI",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 999999,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = guiParent(),
	})

	local scaler = New("Frame", {
		Name = "Scaler",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent = sg,
	})
	New("UIScale", { Scale = 1 }, scaler)

	state.root = sg
	state.scaler = scaler
	state.scale = scaler:FindFirstChildOfClass("UIScale")
	updateScale()

	local camera = workspace.CurrentCamera
	if camera then
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
	end
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		updateScale()
		local cam = workspace.CurrentCamera
		if cam then
			cam:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
		end
	end)

	return sg
end

local function setBlur(on)
	if on then
		state.blurUsers = state.blurUsers + 1
		if state.blurUsers == 1 and not state.blur then
			local ok, blur = pcall(function()
				local effect = Instance.new("BlurEffect")
				effect.Name = "ZephyrUIBlur"
				effect.Size = 18
				effect.Parent = Lighting
				return effect
			end)
			if ok then
				state.blur = blur
			end
		end
	else
		state.blurUsers = math.max(0, state.blurUsers - 1)
		if state.blurUsers == 0 and state.blur then
			pcall(function()
				state.blur:Destroy()
			end)
			state.blur = nil
		end
	end
end

--------------------------------------------------------------------------------
-- notification system
--------------------------------------------------------------------------------

local toastHolder

local function ensureToastHolder()
	if toastHolder and toastHolder.Parent then
		return toastHolder
	end
	ensureRoot()
	toastHolder = New("Frame", {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -16, 0, 16),
		Size = UDim2.fromOffset(340, 0),
		BackgroundTransparency = 1,
		Parent = state.scaler,
	})
	return toastHolder
end

local function relayoutToasts()
	local y = 0
	for _, toast in ipairs(state.toasts) do
		if toast.root.Parent then
			Tween(toast.root, { Position = UDim2.new(1, 0, 0, y) }, 0.22, Enum.EasingStyle.Quart)
			y = y + toast.height + 8
		end
	end
end

local function removeToast(toast)
	for i, item in ipairs(state.toasts) do
		if item == toast then
			table.remove(state.toasts, i)
			break
		end
	end
	toast.dismissed = true
	if toast.root.Parent then
		Tween(toast.root, {
			GroupTransparency = 1,
			Position = UDim2.new(1, 32, 0, toast.root.Position.Y.Offset),
		}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.delay(0.22, function()
			if toast.root then
				toast.root:Destroy()
			end
		end)
	end
	task.delay(0.1, relayoutToasts)
end

local TypeColors = {
	Info = "Accent",
	Success = "Success",
	Warning = "Warning",
	Error = "Danger",
	Danger = "Danger",
}

local function typeColor(kind)
	return Color(TypeColors[kind] or "Accent")
end

--------------------------------------------------------------------------------
-- dialog system
--------------------------------------------------------------------------------

local function ensureDialogHolder()
	if state.dialogHolder and state.dialogHolder.Parent then
		return state.dialogHolder
	end
	ensureRoot()
	state.dialogHolder = New("Frame", {
		Name = "Dialogs",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 500,
		Parent = state.scaler,
	})
	return state.dialogHolder
end
--------------------------------------------------------------------------------
-- notify
--------------------------------------------------------------------------------

function Zephyr:Notify(cfg)
	if type(cfg) == "string" then
		cfg = { Title = cfg }
	end
	cfg = cfg or {}

	local holder = ensureToastHolder()
	local accent = cfg.Accent or typeColor(cfg.Type)
	local width = cfg.Width or 336
	local innerWidth = width - 88
	local contentText = cfg.Content or ""
	local hasContent = contentText ~= ""
	local contentHeight = 0
	if hasContent then
		contentHeight = Measure(contentText, 12, innerWidth, Fonts.Regular).Y
	end

	local height = 16 + 18 + (hasContent and (5 + contentHeight) or 0) + 16
	height = math.max(height, 62)

	local root = New("CanvasGroup", {
		Name = "Toast",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 34, 0, 0),
		Size = UDim2.fromOffset(width, height),
		BackgroundColor3 = Color("Panel"),
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Parent = holder,
	})
	Round(root, 10)
	Stroke(root, Color("Stroke"), 1, state.theme.StrokeTransparency)

	local accentBar = New("Frame", {
		Size = UDim2.new(0, 3, 1, -20),
		Position = UDim2.fromOffset(0, 10),
		BackgroundColor3 = accent,
		BorderSizePixel = 0,
		Parent = root,
	})
	Round(accentBar, 2)

	local iconCircle = New("Frame", {
		Size = UDim2.fromOffset(28, 28),
		Position = UDim2.fromOffset(16, 15),
		BackgroundColor3 = accent,
		BackgroundTransparency = 0.82,
		BorderSizePixel = 0,
		Parent = root,
	})
	Round(iconCircle, 14)

	New("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = ResolveGlyph(cfg.Icon)
			or ResolveGlyph(({
				Success = "check",
				Warning = "warning",
				Error = "close",
				Danger = "close",
				Info = "info",
			})[cfg.Type or "Info"])
			or ResolveGlyph("info"),
		Font = Fonts.Semibold,
		TextSize = 13,
		TextColor3 = accent,
		Parent = iconCircle,
	})

	New("TextLabel", {
		Position = UDim2.fromOffset(54, 13),
		Size = UDim2.new(1, -104, 0, 18),
		BackgroundTransparency = 1,
		Text = cfg.Title or "提示",
		Font = Fonts.Semibold,
		TextSize = 13,
		TextColor3 = Color("Text"),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = root,
	})

	if hasContent then
		New("TextLabel", {
			Position = UDim2.fromOffset(54, 33),
			Size = UDim2.new(1, -104, 0, contentHeight),
			BackgroundTransparency = 1,
			Text = contentText,
			Font = Fonts.Regular,
			TextSize = 12,
			TextColor3 = Color("SubText"),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			Parent = root,
		})
	end

	local closeButton = New("TextButton", {
		Position = UDim2.new(1, -30, 0, 11),
		Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1,
		Text = ResolveGlyph("close"),
		Font = Fonts.Regular,
		TextSize = 11,
		TextColor3 = Color("Muted"),
		Parent = root,
	})

	local progress = New("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 10, 1, -1),
		Size = UDim2.new(1, -20, 0, 2),
		BackgroundColor3 = accent,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Parent = root,
	})
	Round(progress, 1)

	local toast = {
		root = root,
		height = height,
		dismissed = false,
	}

	function toast:Close()
		if not self.dismissed then
			removeToast(self)
		end
	end

	closeButton.MouseEnter:Connect(function()
		closeButton.TextColor3 = Color("Text")
	end)
	closeButton.MouseLeave:Connect(function()
		closeButton.TextColor3 = Color("Muted")
	end)
	closeButton.MouseButton1Click:Connect(function()
		toast:Close()
	end)

	local targetY = 0
	for _, item in ipairs(state.toasts) do
		if item ~= toast and item.root and item.root.Parent then
			targetY = targetY + item.height + 8
		end
	end

	table.insert(state.toasts, 1, toast)
	if #state.toasts > 5 then
		local oldest = table.remove(state.toasts)
		if oldest and oldest.root then
			oldest.root:Destroy()
		end
	end

	root.Position = UDim2.new(1, 34, 0, targetY)
	relayoutToasts()

	Tween(root, {
		GroupTransparency = 0,
		Position = UDim2.new(1, 0, 0, targetY),
	}, 0.32, Enum.EasingStyle.Quart)

	local duration = cfg.Duration
	if duration == nil then
		duration = 4
	end

	if duration and duration > 0 then
		Tween(progress, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear)
		task.delay(duration, function()
			if not toast.dismissed then
				toast:Close()
			end
		end)
	else
		progress.Visible = false
	end

	return toast
end

--------------------------------------------------------------------------------
-- dialog
--------------------------------------------------------------------------------

function Zephyr:Dialog(cfg)
	cfg = cfg or {}
	local holder = ensureDialogHolder()
	holder.Visible = true

	local width = cfg.Width or 384
	local contentWidth = width - 52
	local contentHeight = 0
	if cfg.Content and cfg.Content ~= "" then
		contentHeight = Measure(cfg.Content, 12.5, contentWidth, Fonts.Regular).Y
	end

	local buttons = cfg.Buttons or { { Title = "OK" } }
	local buttonHeight = 36
	local buttonGap = 8
	local buttonsHeight = #buttons * buttonHeight + math.max(0, #buttons - 1) * buttonGap

	local iconHeight = 46
	local titleHeight = 22
	local height = 26 + iconHeight + 14 + titleHeight
		+ (contentHeight > 0 and (8 + contentHeight) or 0)
		+ 22 + buttonsHeight + 24

	local overlay = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		Active = true,
		BackgroundColor3 = Color("Overlay"),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 500,
		Parent = holder,
	})

	local group = New("CanvasGroup", {
		Name = "Dialog",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(width, height),
		BackgroundColor3 = Color("Panel"),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 501,
		GroupTransparency = 1,
		Parent = overlay,
	})
	Round(group, 16)
	Stroke(group, Color("Stroke"), 1, state.theme.StrokeTransparency)

	local scale = New("UIScale", { Scale = 0.94 }, group)

	local iconCircle = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 26),
		Size = UDim2.fromOffset(iconHeight, iconHeight),
		BackgroundColor3 = cfg.Accent or Color("Accent"),
		BackgroundTransparency = 0.85,
		BorderSizePixel = 0,
		Parent = group,
	})
	Round(iconCircle, iconHeight / 2)

	New("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = ResolveGlyph(cfg.Icon or "info") or ResolveGlyph("info"),
		Font = Fonts.Semibold,
		TextSize = 20,
		TextColor3 = cfg.Accent or Color("Accent"),
		Parent = iconCircle,
	})

	New("TextLabel", {
		Position = UDim2.fromOffset(26, 26 + iconHeight + 14),
		Size = UDim2.new(1, -52, 0, titleHeight),
		BackgroundTransparency = 1,
		Text = cfg.Title or "Confirm",
		Font = Fonts.Bold,
		TextSize = 16,
		TextColor3 = Color("Text"),
		Parent = group,
	})

	if contentHeight > 0 then
		New("TextLabel", {
			Position = UDim2.fromOffset(26, 26 + iconHeight + 14 + titleHeight + 8),
			Size = UDim2.new(1, -52, 0, contentHeight),
			BackgroundTransparency = 1,
			Text = cfg.Content,
			Font = Fonts.Regular,
			TextSize = 12.5,
			TextColor3 = Color("SubText"),
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			Parent = group,
		})
	end

	local buttonStart = height - 24 - buttonsHeight - 0
	local dialog = { root = group, overlay = overlay, closed = false }

	function dialog:Close()
		if self.closed then
			return
		end
		self.closed = true
		Tween(group, { GroupTransparency = 1, Size = UDim2.fromOffset(width - 12, height - 12) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		Tween(overlay, { BackgroundTransparency = 1 }, 0.2)
		task.delay(0.2, function()
			overlay:Destroy()
			local any = false
			for _, child in ipairs(holder:GetChildren()) do
				if child:IsA("Frame") then
					any = true
				end
			end
			if not any then
				holder.Visible = false
			end
		end)
	end

	for index, button in ipairs(buttons) do
		local primary = button.Variant == "Primary" or button.Primary or (button.Variant == nil and index == #buttons)
		local danger = button.Variant == "Danger" or button.Variant == "Destructive"
		local bg = primary and (button.Accent or Color("Accent")) or Color("Control")
		local textColor = primary and Color("AccentText") or Color("Text")
		if danger then
			bg = Color("Danger")
			textColor = Color3.new(1, 1, 1)
		end

		local btn = New("TextButton", {
			Position = UDim2.fromOffset(26, buttonStart + (index - 1) * (buttonHeight + buttonGap)),
			Size = UDim2.new(1, -52, 0, buttonHeight),
			BackgroundColor3 = bg,
			BorderSizePixel = 0,
			Text = button.Title or "OK",
			Font = Fonts.Semibold,
			TextSize = 13,
			TextColor3 = textColor,
			AutoButtonColor = false,
			Parent = group,
		})
		Round(btn, 8)

		btn.MouseEnter:Connect(function()
			Tween(btn, { BackgroundColor3 = bg:Lerp(Color3.new(1, 1, 1), primary and 0.12 or 0.06) }, 0.12)
		end)
		btn.MouseLeave:Connect(function()
			Tween(btn, { BackgroundColor3 = bg }, 0.12)
		end)
		btn.MouseButton1Click:Connect(function()
			if button.Callback then
				task.spawn(button.Callback)
			end
			if not button.KeepOpen then
				dialog:Close()
			end
		end)
	end

	if cfg.Dismissable ~= false then
		overlay.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local pos = input.Position
				local abs = group.AbsolutePosition
				local size = group.AbsoluteSize
				if pos.X < abs.X or pos.X > abs.X + size.X or pos.Y < abs.Y or pos.Y > abs.Y + size.Y then
					dialog:Close()
					if cfg.OnDismiss then
						task.spawn(cfg.OnDismiss)
					end
				end
			end
		end)
	end

	Tween(overlay, { BackgroundTransparency = state.theme.OverlayTransparency }, 0.2)
	Tween(group, { GroupTransparency = 0 }, 0.24, Enum.EasingStyle.Quart)
	Tween(scale, { Scale = 1 }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	return dialog
end

--------------------------------------------------------------------------------
-- tooltip
--------------------------------------------------------------------------------

local tooltip
local function ensureTooltip()
	if tooltip and tooltip.Parent then
		return tooltip
	end
	ensureRoot()
	tooltip = New("Frame", {
		Name = "Tooltip",
		BackgroundColor3 = Color("Panel"),
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(0, 26),
		AutomaticSize = Enum.AutomaticSize.X,
		Visible = false,
		ZIndex = 900,
		Parent = state.scaler,
	})
	Round(tooltip, 6)
	Stroke(tooltip, Color("Stroke"), 1, state.theme.StrokeTransparency)
	New("UIPadding", {
		PaddingLeft = UDim.new(0, 9),
		PaddingRight = UDim.new(0, 9),
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 5),
	}, tooltip)
	New("TextLabel", {
		Name = "Label",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Font = Fonts.Medium,
		TextSize = 11.5,
		TextColor3 = Color("Text"),
		Text = "",
		Parent = tooltip,
	})
	return tooltip
end

function Zephyr:ShowTooltip(text, x, y)
	local tip = ensureTooltip()
	local label = tip:FindFirstChild("Label")
	if label then
		label.Text = text
	end
	local scale = state.scaleValue or 1
	tip.Position = UDim2.fromOffset((x or 0) / scale + 14, (y or 0) / scale + 18)
	tip.Visible = true
end

function Zephyr:HideTooltip()
	if tooltip then
		tooltip.Visible = false
	end
end

--------------------------------------------------------------------------------
-- theme api
--------------------------------------------------------------------------------

function Zephyr:SetTheme(name)
	if not Themes[name] then
		name = "Dark"
	end
	state.themeName = name
	state.theme = Themes[name]
	if not state.accentOverride then
		state.accent = state.theme.Accent
	end
	for _, fn in ipairs(state.bindings) do
		pcall(fn)
	end
	if self.Notify then
		-- theme changes are applied through bindings; nothing else required
	end
end

function Zephyr:GetTheme()
	return state.themeName
end

function Zephyr:SetAccent(color)
	if typeof(color) == "string" then
		color = Hex(color)
	end
	state.accent = color
	state.accentOverride = true
	for _, fn in ipairs(state.bindings) do
		pcall(fn)
	end
end

function Zephyr:GetAccent()
	return state.accent
end

function Zephyr:GetThemes()
	local names = {}
	for name in pairs(Themes) do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function Zephyr:Destroy()
	local openList = {}
	for _, popup in ipairs(state.popups) do
		table.insert(openList, popup)
	end
	for _, popup in ipairs(openList) do
		pcall(function()
			popup:Close()
		end)
	end
	state.popups = {}

	local windows = {}
	for _, window in ipairs(state.windows) do
		table.insert(windows, window)
	end
	for _, window in ipairs(windows) do
		pcall(function()
			window:Destroy()
		end)
	end
	state.windows = {}

	if state.root then
		state.root:Destroy()
		state.root = nil
	end
	state.blurUsers = 0
	if state.blur then
		state.blur:Destroy()
		state.blur = nil
	end
	state.bindings = {}
end
--------------------------------------------------------------------------------
-- window
--------------------------------------------------------------------------------

local Window = {}
Window.__index = Window

local function sizeToVector(size, base)
	local x = (size.X.Scale * (base and base.X or 1280)) + size.X.Offset
	local y = (size.Y.Scale * (base and base.Y or 720)) + size.Y.Offset
	return Vector2.new(x, y)
end

function Zephyr:CreateWindow(cfg)
	cfg = cfg or {}
	ensureRoot()

	if cfg.Theme and Themes[cfg.Theme] then
		state.themeName = cfg.Theme
		state.theme = Themes[cfg.Theme]
		if not state.accentOverride then
			state.accent = state.theme.Accent
		end
	end
	if cfg.Accent then
		state.accent = cfg.Accent
		state.accentOverride = true
	end
	for _, fn in ipairs(state.bindings) do
		pcall(fn)
	end

	local self = setmetatable({}, Window)
	self.Config = cfg
	self.Tabs = {}
	self.Widgets = {}
	self.SearchEntries = {}
	self.SidebarWidth = cfg.SideBarWidth or 188
	self.MinWidth = cfg.MinSize and cfg.MinSize.X or 520
	self.MinHeight = cfg.MinSize and cfg.MinSize.Y or 360
	self.Minimized = false
	self.Destroyed = false
	self.Dragging = false

	local initialSize = sizeToVector(cfg.Size or UDim2.fromOffset(640, 460))
	self.Width = initialSize.X
	self.Height = initialSize.Y

	local vp = viewport()
	local scaleValue = state.scaleValue or 1
	local startX = cfg.Position and cfg.Position.X.Offset or math.floor((vp.X / scaleValue - self.Width) / 2)
	local startY = cfg.Position and cfg.Position.Y.Offset or math.floor((vp.Y / scaleValue - self.Height) / 2)
	if cfg.Position then
		startX = cfg.Position.X.Scale * (vp.X / scaleValue) + cfg.Position.X.Offset
		startY = cfg.Position.Y.Scale * (vp.Y / scaleValue) + cfg.Position.Y.Offset
	end

	local root = New("Frame", {
		Name = "ZephyrWindow",
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromOffset(startX, startY),
		Size = UDim2.fromOffset(self.Width, self.Height),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Parent = state.scaler,
	})
	self.Root = root
	self.Scale = New("UIScale", { Scale = 1 }, root)

	local shadow = New("ImageLabel", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 54, 1, 54),
		BackgroundTransparency = 1,
		Image = "rbxassetid://8992230677",
		ImageColor3 = Color("Shadow"),
		ImageTransparency = 0.6,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(50, 50, 50, 50),
		ZIndex = 0,
		Parent = root,
	})
	BindColor(shadow, "ImageColor3", "Shadow")

	local main = New("Frame", {
		Name = "Main",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color("Panel"),
		BackgroundTransparency = cfg.Transparent == false and 0 or 0.04,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 1,
		Parent = root,
	})
	self.Main = main
	Round(main, cfg.CornerRadius or 14)
	BindColor(main, "BackgroundColor3", "Panel")
	self.MainStroke = Stroke(main, Color("Stroke"), 1, state.theme.StrokeTransparency)
	Bind(function()
		self.MainStroke.Color = Color("Stroke")
		self.MainStroke.Transparency = state.theme.StrokeTransparency
	end)

	-- top bar ---------------------------------------------------------------

	local top = New("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1,
		ZIndex = 2,
		Parent = main,
	})
	self.TopBar = top
	top.Active = true

	local topLine = New("Frame", {
		Name = "TopLine",
		Position = UDim2.fromOffset(0, 47),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Color("Stroke"),
		BackgroundTransparency = 0.95,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = main,
	})
	Bind(function()
		topLine.BackgroundColor3 = Color("Stroke")
		topLine.BackgroundTransparency = math.min(0.98, state.theme.StrokeTransparency + 0.03)
	end)

	local iconHolder = New("Frame", {
		Name = "Icon",
		Position = UDim2.fromOffset(16, 14),
		Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1,
		Parent = top,
	})
	self.IconHolder = iconHolder

	local iconName = cfg.Icon or "wind"
	if tostring(iconName):find("rbxassetid://") or tostring(iconName):find("rbxasset") then
		New("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = iconName,
			ImageColor3 = Color("Accent"),
			ScaleType = Enum.ScaleType.Fit,
			Parent = iconHolder,
		})
	else
		New("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = ResolveGlyph(iconName) or ResolveGlyph("wind"),
			Font = Fonts.Semibold,
			TextSize = 17,
			TextColor3 = Color("Accent"),
			Parent = iconHolder,
		})
	end
	Bind(function()
		for _, child in ipairs(iconHolder:GetChildren()) do
			if child:IsA("ImageLabel") then
				child.ImageColor3 = Color("Accent")
			elseif child:IsA("TextLabel") then
				child.TextColor3 = Color("Accent")
			end
		end
	end)

	local title = New("TextLabel", {
		Name = "Title",
		Position = UDim2.fromOffset(45, cfg.SubTitle and 8 or 0),
		Size = UDim2.new(0, 230, cfg.SubTitle and 0 or 1, cfg.SubTitle and 18 or 0),
		BackgroundTransparency = 1,
		Text = cfg.Title or "Zephyr",
		Font = Fonts.Semibold,
		TextSize = 13,
		TextColor3 = Color("Text"),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = cfg.SubTitle and Enum.TextYAlignment.Center or Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = top,
	})
	self.TitleLabel = title
	BindColor(title, "TextColor3", "Text")

	if cfg.SubTitle then
		local subtitle = New("TextLabel", {
			Name = "SubTitle",
			Position = UDim2.fromOffset(45, 26),
			Size = UDim2.new(0, 230, 0, 14),
			BackgroundTransparency = 1,
			Text = cfg.SubTitle,
			Font = Fonts.Regular,
			TextSize = 10,
			TextColor3 = Color("Muted"),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = top,
		})
		BindColor(subtitle, "TextColor3", "Muted")
	end

	-- search ----------------------------------------------------------------

	local searchFrame = New("Frame", {
		Name = "Search",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -110, 0.5, 0),
		Size = UDim2.fromOffset(180, 28),
		BackgroundColor3 = Color("Control"),
		BackgroundTransparency = 0.35,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = top,
	})
	self.SearchFrame = searchFrame
	Round(searchFrame, 7)

	local searchIcon = New("TextLabel", {
		Position = UDim2.fromOffset(9, 0),
		Size = UDim2.new(0, 14, 1, 0),
		BackgroundTransparency = 1,
		Text = ResolveGlyph("search"),
		Font = Fonts.Regular,
		TextSize = 12,
		TextColor3 = Color("Muted"),
		Parent = searchFrame,
	})
	BindColor(searchIcon, "TextColor3", "Muted")

	local searchBox = New("TextBox", {
		Position = UDim2.fromOffset(30, 0),
		Size = UDim2.new(1, -38, 1, 0),
		BackgroundTransparency = 1,
		Font = Fonts.Regular,
		TextSize = 12,
		TextColor3 = Color("Text"),
		PlaceholderText = cfg.SearchPlaceholder or "搜索功能 / 设置",
		PlaceholderColor3 = Color("Muted"),
		Text = "",
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Parent = searchFrame,
	})
	self.SearchBox = searchBox
	BindColor(searchBox, "TextColor3", "Text")
	BindColor(searchBox, "PlaceholderColor3", "Muted")

	searchBox.Focused:Connect(function()
		Tween(searchFrame, { BackgroundTransparency = 0 }, 0.15)
		self.MainStroke.Color = Color("Accent")
		self.MainStroke.Transparency = 0.55
	end)
	searchBox.FocusLost:Connect(function()
		Tween(searchFrame, { BackgroundTransparency = 0.35 }, 0.15)
		self.MainStroke.Color = Color("Stroke")
		self.MainStroke.Transparency = state.theme.StrokeTransparency
	end)
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		self:_applyFilter(searchBox.Text)
	end)

	-- window buttons --------------------------------------------------------

	local function windowButton(icon, xOffset, hoverColor)
		local btn = New("TextButton", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, xOffset, 0, 12),
			Size = UDim2.fromOffset(26, 26),
			BackgroundColor3 = Color("Control"),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 4,
			Parent = top,
		})
		Round(btn, 7)
		local glyph = New("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = ResolveGlyph(icon),
			Font = Fonts.Regular,
			TextSize = 12,
			TextColor3 = Color("SubText"),
			Parent = btn,
		})
		BindColor(glyph, "TextColor3", "SubText")
		btn.MouseEnter:Connect(function()
			Tween(btn, { BackgroundColor3 = hoverColor or Color("Control"), BackgroundTransparency = 0.2 }, 0.12)
			if hoverColor == Color("Danger") then
				glyph.TextColor3 = Color3.new(1, 1, 1)
			else
				glyph.TextColor3 = Color("Text")
			end
		end)
		btn.MouseLeave:Connect(function()
			Tween(btn, { BackgroundTransparency = 1 }, 0.12)
			glyph.TextColor3 = Color("SubText")
		end)
		return btn, glyph
	end

	local minimizeBtn = windowButton("minimize", -74, nil)
	minimizeBtn.MouseButton1Click:Connect(function()
		self:Minimize(not self.Minimized)
	end)

	local closeBtn = windowButton("close", -42, Color("Danger"))
	closeBtn.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	-- body ------------------------------------------------------------------

	local body = New("Frame", {
		Name = "Body",
		Position = UDim2.fromOffset(0, 48),
		Size = UDim2.new(1, 0, 1, -48),
		BackgroundTransparency = 1,
		ZIndex = 2,
		Parent = main,
	})
	self.Body = body

	local sidebar = New("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, self.SidebarWidth, 1, 0),
		BackgroundColor3 = Color("Sidebar"),
		BackgroundTransparency = 0.35,
		BorderSizePixel = 0,
		Parent = body,
	})
	self.Sidebar = sidebar
	BindColor(sidebar, "BackgroundColor3", "Sidebar")

	local sidebarLine = New("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = Color("Stroke"),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Parent = sidebar,
	})
	Bind(function()
		sidebarLine.BackgroundColor3 = Color("Stroke")
		sidebarLine.BackgroundTransparency = state.theme.StrokeTransparency
	end)

	local tabsScroll = New("ScrollingFrame", {
		Name = "Tabs",
		Position = UDim2.fromOffset(0, 10),
		Size = UDim2.new(1, 0, 1, -68),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = sidebar,
	})
	self.TabsScroll = tabsScroll
	New("UIListLayout", {
		Padding = UDim.new(0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	}, tabsScroll)
	New("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
	}, tabsScroll)

	-- user card -------------------------------------------------------------

	local userCard = New("Frame", {
		Name = "User",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundColor3 = Color("Stroke"),
		BackgroundTransparency = 0.96,
		BorderSizePixel = 0,
		Parent = sidebar,
	})
	self.UserCard = userCard
	Round(userCard, 0)

	local avatar = New("ImageLabel", {
		Position = UDim2.fromOffset(14, 14),
		Size = UDim2.fromOffset(30, 30),
		BackgroundColor3 = Color("Control"),
		BorderSizePixel = 0,
		Image = "",
		Parent = userCard,
	})
	Round(avatar, 15)
	Stroke(avatar, Color("Stroke"), 1, 0.85)

	local userName = New("TextLabel", {
		Position = UDim2.fromOffset(52, 14),
		Size = UDim2.new(1, -64, 0, 16),
		BackgroundTransparency = 1,
		Text = (cfg.User and cfg.User.Name) or (LocalPlayer and LocalPlayer.DisplayName) or "Player",
		Font = Fonts.Semibold,
		TextSize = 12,
		TextColor3 = Color("Text"),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = userCard,
	})
	BindColor(userName, "TextColor3", "Text")

	local userStatus = New("TextLabel", {
		Position = UDim2.fromOffset(52, 30),
		Size = UDim2.new(1, -64, 0, 14),
		BackgroundTransparency = 1,
		Text = (cfg.User and cfg.User.Status) or "Online",
		Font = Fonts.Regular,
		TextSize = 10.5,
		TextColor3 = Color("Muted"),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = userCard,
	})
	BindColor(userStatus, "TextColor3", "Muted")

	if cfg.User == false then
		userCard.Visible = false
	else
		task.spawn(function()
			if not LocalPlayer then
				return
			end
			local ok, image = pcall(function()
				return Players:GetUserThumbnailAsync(
					LocalPlayer.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size100x100
				)
			end)
			if ok and image and avatar then
				avatar.Image = image
			end
		end)
	end

	-- content ---------------------------------------------------------------

	local content = New("Frame", {
		Name = "Content",
		Position = UDim2.fromOffset(self.SidebarWidth, 0),
		Size = UDim2.new(1, -self.SidebarWidth, 1, 0),
		BackgroundTransparency = 1,
		Parent = body,
	})
	self.Content = content

	local scroll = New("ScrollingFrame", {
		Name = "Pages",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color("SubText"),
		ScrollBarImageTransparency = 0.55,
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = true,
		ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
		Parent = content,
	})
	self.Scroll = scroll
	New("UIListLayout", {
		Padding = UDim.new(0, 14),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, scroll)
	New("UIPadding", {
		PaddingTop = UDim.new(0, 14),
		PaddingBottom = UDim.new(0, 22),
		PaddingLeft = UDim.new(0, 16),
		PaddingRight = UDim.new(0, 12),
	}, scroll)
	BindColor(scroll, "ScrollBarImageColor3", "SubText")

	local emptyState = New("TextLabel", {
		Name = "Empty",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.42),
		Size = UDim2.fromOffset(280, 44),
		BackgroundTransparency = 1,
		Text = "没有找到匹配项",
		Font = Fonts.Regular,
		TextSize = 12,
		TextColor3 = Color("Muted"),
		Visible = false,
		ZIndex = 3,
		Parent = content,
	})
	self.EmptyState = emptyState
	BindColor(emptyState, "TextColor3", "Muted")

	-- resize grip -----------------------------------------------------------

	local grip = New("TextButton", {
		Name = "ResizeGrip",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -4, 1, -4),
		Size = UDim2.fromOffset(18, 18),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 5,
		Parent = main,
	})

	for i = 1, 3 do
		local line = New("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -3 - (i - 1) * 5, 1, -3),
			Size = UDim2.fromOffset(1, 4 + (i - 1) * 4),
			BackgroundColor3 = Color("Muted"),
			BackgroundTransparency = 0.45,
			BorderSizePixel = 0,
			Rotation = 45,
			Parent = grip,
		})
		Bind(function()
			line.BackgroundColor3 = Color("Muted")
		end)
	end

	-- interactions ----------------------------------------------------------

	local function connectDrag(handle)
		handle.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			if UserInputService:GetFocusedTextBox() then
				return
			end
			local startPos = input.Position
			local origin = root.Position
			local moved = false
			local moveConn, endConn

			moveConn = UserInputService.InputChanged:Connect(function(changed)
				if changed.UserInputType ~= Enum.UserInputType.MouseMovement and changed.UserInputType ~= Enum.UserInputType.Touch then
					return
				end
				local delta = (changed.Position - startPos) / (state.scaleValue or 1)
				if math.abs(delta.X) > 2 or math.abs(delta.Y) > 2 then
					moved = true
				end
				local vp2 = viewport()
				local sx = vp2.X / (state.scaleValue or 1)
				local sy = vp2.Y / (state.scaleValue or 1)
				local x = math.clamp(origin.X.Offset + delta.X, -self.Width + 90, sx - 90)
				local y = math.clamp(origin.Y.Offset + delta.Y, 0, sy - 48)
				root.Position = UDim2.fromOffset(x, y)
			end)

			endConn = UserInputService.InputEnded:Connect(function(ended)
				if ended.UserInputType == input.UserInputType or ended.UserInputType == Enum.UserInputType.MouseButton1 then
					if moveConn then
						moveConn:Disconnect()
					end
					if endConn then
						endConn:Disconnect()
					end
				end
			end)

		end)
	end

	connectDrag(top)
	connectDrag(iconHolder)
	connectDrag(title)

	-- resize ----------------------------------------------------------------

	grip.InputBegan:Connect(function(input)
		if self.Minimized then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local startPos = input.Position
		local startSize = Vector2.new(self.Width, self.Height)
		local moveConn, endConn

		moveConn = UserInputService.InputChanged:Connect(function(changed)
			if changed.UserInputType ~= Enum.UserInputType.MouseMovement and changed.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local delta = (changed.Position - startPos) / (state.scaleValue or 1)
			local vp2 = viewport()
			local maxW = vp2.X / (state.scaleValue or 1) - 20
			local maxH = vp2.Y / (state.scaleValue or 1) - 20
			local w2 = math.clamp(startSize.X + delta.X, self.MinWidth, math.max(self.MinWidth, maxW - root.Position.X.Offset))
			local h2 = math.clamp(startSize.Y + delta.Y, self.MinHeight, math.max(self.MinHeight, maxH - root.Position.Y.Offset))
			self.Width = w2
			self.Height = h2
			root.Size = UDim2.fromOffset(w2, h2)
			self:_layout()
		end)

		endConn = UserInputService.InputEnded:Connect(function(ended)
			if ended.UserInputType == input.UserInputType or ended.UserInputType == Enum.UserInputType.MouseButton1 then
				if moveConn then
					moveConn:Disconnect()
				end
				if endConn then
					endConn:Disconnect()
				end
			end
		end)
	end)

	-- keybind toggle --------------------------------------------------------

	self.ToggleKey = cfg.ToggleKey
	if self.ToggleKey == nil then
		self.ToggleKey = Enum.KeyCode.RightShift
	end
	if self.ToggleKey then
		self.KeyConnection = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then
				return
			end
			if input.KeyCode == self.ToggleKey then
				self:Toggle()
			end
		end)
	end

	-- acrylic ---------------------------------------------------------------

	self.Acrylic = cfg.Acrylic ~= false
	if self.Acrylic then
		setBlur(true)
	end

	self:_layout()
	table.insert(state.windows, self)

	-- open animation
	self.Scale.Scale = 0.97
	self.Main.BackgroundTransparency = 1
	Tween(self.Scale, { Scale = 1 }, 0.28, Enum.EasingStyle.Quart)
	Tween(self.Main, {
		BackgroundTransparency = cfg.Transparent == false and 0 or 0.04,
	}, 0.25)

	if cfg.OnReady then
		task.spawn(cfg.OnReady, self)
	end

	return self
end

function Window:_layout()
	local compact = self.Width < 560
	local sideWidth = compact and 58 or self.SidebarWidth

	self.Sidebar.Size = UDim2.new(0, sideWidth, 1, 0)
	self.Content.Position = UDim2.fromOffset(sideWidth, 0)
	self.Content.Size = UDim2.new(1, -sideWidth, 1, 0)

	local searchVisible = self.Width >= 640
	self.SearchFrame.Visible = searchVisible
	if searchVisible then
		self.SearchFrame.Size = UDim2.fromOffset(math.clamp(self.Width * 0.24, 160, 210), 28)
	end

	local showUser = (not compact) and self.Config.User ~= false
	self.UserCard.Visible = showUser
	self.TabsScroll.Size = UDim2.new(1, 0, 1, showUser and -68 or -12)

	for _, tab in ipairs(self.Tabs) do
		tab:SetCompact(compact)
	end
end

function Window:_applyFilter(query)
	query = query or ""
	local lowered = string.lower(query)
	local counts = {}
	for _, tab in ipairs(self.Tabs) do
		counts[tab] = 0
	end

	for _, entry in ipairs(self.SearchEntries) do
		if entry.row and entry.row.Parent then
			local match = lowered == ""
			if not match then
				if string.find(string.lower(entry.title or ""), lowered, 1, true) then
					match = true
				elseif entry.desc and string.find(string.lower(entry.desc), lowered, 1, true) then
					match = true
				end
			end
			entry.row.Visible = match
			if match and lowered ~= "" then
				counts[entry.tab] = (counts[entry.tab] or 0) + 1
			end
		end
	end

	for _, tab in ipairs(self.Tabs) do
		tab:_updateSections()
		tab:_updateSearchState(lowered ~= "" and (counts[tab] or 0) == 0)
	end

	local current = self.CurrentTab
	local currentEmpty = current and lowered ~= "" and (counts[current] or 0) == 0
	if currentEmpty then
		for _, tab in ipairs(self.Tabs) do
			if (counts[tab] or 0) > 0 then
				self:SelectTab(tab)
				break
			end
		end
	end

	local active = self.CurrentTab
	self.EmptyState.Visible = lowered ~= "" and active ~= nil and (counts[active] or 0) == 0
	self.EmptyState.Text = "没有找到 \"" .. query .. "\" 的相关设置"
end

function Window:SelectTab(tab)
	local target
	if type(tab) == "number" then
		target = self.Tabs[tab]
	elseif type(tab) == "string" then
		for _, item in ipairs(self.Tabs) do
			if item.Title == tab then
				target = item
				break
			end
		end
	else
		target = tab
	end
	if not target then
		return
	end

	for _, item in ipairs(self.Tabs) do
		local active = item == target
		item.Active = active
		item.Page.Visible = active
		item:SetActive(active)
	end

	self.CurrentTab = target
	self.Scroll.CanvasPosition = Vector2.new(0, 0)
end

function Window:SetTitle(text)
	self.TitleLabel.Text = text
end

function Window:SetToggleKey(key)
	if self.KeyConnection then
		self.KeyConnection:Disconnect()
		self.KeyConnection = nil
	end
	if type(key) == "string" then
		key = Enum.KeyCode[key] or nil
	end
	self.ToggleKey = key
	if key then
		self.KeyConnection = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then
				return
			end
			if input.KeyCode == self.ToggleKey then
				self:Toggle()
			end
		end)
	end
end

function Window:GetTab(name)
	for _, tab in ipairs(self.Tabs) do
		if tab.Title == name then
			return tab
		end
	end
	return nil
end

function Window:Minimize(minimized)
	minimized = minimized ~= false and minimized or false
	if self.Minimized == minimized then
		return
	end
	self.Minimized = minimized
	if minimized then
		self:_closePopups()
		self.Body.Visible = true
		Tween(self.Root, { Size = UDim2.fromOffset(self.Width, 48) }, 0.24, Enum.EasingStyle.Quart)
		task.delay(0.25, function()
			if self.Minimized and self.Body then
				self.Body.Visible = false
			end
		end)
	else
		self.Body.Visible = true
		self.Root.Size = UDim2.fromOffset(self.Width, 48)
		Tween(self.Root, { Size = UDim2.fromOffset(self.Width, self.Height) }, 0.26, Enum.EasingStyle.Quart)
		self.Scale.Scale = 1
	end
end

function Window:Toggle(force)
	local visible = force
	if visible == nil then
		visible = not self.Root.Visible
	end
	self.Root.Visible = visible
	if visible then
		self.Scale.Scale = 0.98
		Tween(self.Scale, { Scale = 1 }, 0.2, Enum.EasingStyle.Quart)
	end
end

function Window:IsVisible()
	return self.Root and self.Root.Visible
end

function Window:_closePopups()
	for _, popup in ipairs(state.popups) do
		if popup.Close then
			popup:Close()
		end
	end
	state.popups = {}
end

function Window:Notify(cfg)
	return Zephyr:Notify(cfg)
end

function Window:Dialog(cfg)
	return Zephyr:Dialog(cfg)
end

function Window:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true
	self:_closePopups()

	if self.KeyConnection then
		self.KeyConnection:Disconnect()
		self.KeyConnection = nil
	end

	for index, item in ipairs(state.windows) do
		if item == self then
			table.remove(state.windows, index)
			break
		end
	end

	if self.Acrylic then
		setBlur(false)
		self.Acrylic = false
	end

	local root = self.Root
	if root and root.Parent then
		Tween(self.Main, { BackgroundTransparency = 1 }, 0.16)
		Tween(self.Scale, { Scale = 0.97 }, 0.16)
		task.delay(0.17, function()
			if root then
				root:Destroy()
			end
		end)
	end

	if self.Config.OnClose then
		task.spawn(self.Config.OnClose)
	end
end
--------------------------------------------------------------------------------
-- tab + section
--------------------------------------------------------------------------------

local Tab = {}
Tab.__index = Tab

local function hoverRow(row)
	Bind(function()
		row.BackgroundColor3 = Color("Hover")
	end)
	row.MouseEnter:Connect(function()
		if row.BackgroundTransparency > 0.99 or row.BackgroundTransparency == nil then
			Tween(row, { BackgroundTransparency = state.theme.HoverTransparency - 0.02 }, 0.14)
		end
	end)
	row.MouseLeave:Connect(function()
		Tween(row, { BackgroundTransparency = 1 }, 0.16)
	end)
end

local function buildInfo(row, cfg, rightInset, height, topAlign)
	local hasDesc = cfg.Desc and cfg.Desc ~= ""
	local width = -(rightInset + 20)
	local info = New("Frame", {
		Position = UDim2.fromOffset(11, 0),
		Size = UDim2.new(1, width, 1, 0),
		BackgroundTransparency = 1,
		Parent = row,
	})

	local title
	if hasDesc then
		title = New("TextLabel", {
			Position = UDim2.fromOffset(0, 9),
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = cfg.Title or "",
			Font = Fonts.Medium,
			TextSize = 12.5,
			TextColor3 = Color("Text"),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = info,
		})
		New("TextLabel", {
			Position = UDim2.fromOffset(0, 27),
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundTransparency = 1,
			Text = cfg.Desc,
			Font = Fonts.Regular,
			TextSize = 10.5,
			TextColor3 = Color("SubText"),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = info,
		})
	else
		title = New("TextLabel", {
			Position = topAlign and UDim2.fromOffset(0, 9) or nil,
			Size = topAlign and UDim2.new(1, 0, 0, 16) or UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = cfg.Title or "",
			Font = Fonts.Medium,
			TextSize = 12.5,
			TextColor3 = Color("Text"),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = info,
		})
	end

	BindColor(title, "TextColor3", "Text")
	for _, child in ipairs(info:GetChildren()) do
		if child:IsA("TextLabel") and child ~= title then
			BindColor(child, "TextColor3", "SubText")
		end
	end
	return info
end

local function makeWidget(tab, row, cfg)
	local widget = {
		Row = row,
		Title = cfg.Title or "",
		Desc = cfg.Desc,
		Tab = tab,
		Window = tab.Window,
		Flag = cfg.Flag or cfg.Title or "",
		Visible = true,
	}

	function widget:SetVisible(value)
		self.Visible = value ~= false
		self.Row.Visible = self.Visible
	end

	function widget:Destroy()
		if self.Row then
			self.Row:Destroy()
		end
		self.Destroyed = true
	end

	table.insert(tab.Widgets, widget)
	table.insert(tab.Window.Widgets, widget)
	return widget
end

local function trackEntry(tab, section, row, cfg)
	local entry = {
		row = row,
		title = cfg.Title,
		desc = cfg.Desc,
		section = section,
		tab = tab,
	}
	table.insert(tab.Entries, entry)
	table.insert(tab.Window.SearchEntries, entry)
	if section then
		table.insert(section.Items, entry)
	end
	return entry
end

-- button -----------------------------------------------------------------------

local function MakeButton(tab, parent, section, cfg)
	local height = (cfg.Desc and cfg.Desc ~= "") and 60 or 46
	local row = New("TextButton", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = Color("Hover"),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = parent,
	})
	Round(row, 8)
	hoverRow(row)

	buildInfo(row, cfg, 34, height)

	local arrow = New("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(18, 18),
		BackgroundTransparency = 1,
		Text = ResolveGlyph("chevron_right"),
		Font = Fonts.Regular,
		TextSize = 13,
		TextColor3 = Color("Muted"),
		Parent = row,
	})
	BindColor(arrow, "TextColor3", "Muted")

	row.MouseEnter:Connect(function()
		Tween(arrow, { Position = UDim2.new(1, -9, 0.5, 0) }, 0.16)
		arrow.TextColor3 = Color("Accent")
	end)
	row.MouseLeave:Connect(function()
		Tween(arrow, { Position = UDim2.new(1, -12, 0.5, 0) }, 0.16)
		arrow.TextColor3 = Color("Muted")
	end)

	local widget = makeWidget(tab, row, cfg)

	function widget:Fire()
		if cfg.Callback then
			task.spawn(cfg.Callback)
		end
	end

	row.MouseButton1Click:Connect(function()
		widget:Fire()
	end)

	trackEntry(tab, section, row, cfg)
	return widget
end

-- toggle -----------------------------------------------------------------------

local function MakeToggle(tab, parent, section, cfg)
	local height = (cfg.Desc and cfg.Desc ~= "") and 60 or 46
	local row = New("TextButton", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = Color("Hover"),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = parent,
	})
	Round(row, 8)
	hoverRow(row)

	buildInfo(row, cfg, 62, height)

	local pill = New("Frame", {
		Name = "Pill",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(38, 21),
		BackgroundColor3 = Color("Control"),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Parent = row,
	})
	Round(pill, 11)

	local knob = New("Frame", {
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.fromOffset(15, 15),
		BackgroundColor3 = Color("SubText"),
		BorderSizePixel = 0,
		Parent = pill,
	})
	Round(knob, 8)

	local value = cfg.Default
	if value == nil then
		value = cfg.Value
	end
	value = value and true or false

	local widget = makeWidget(tab, row, cfg)
	widget.Value = value

	local function paint(animated)
		local on = widget.Value
		local time = animated and 0.18 or 0
		if time == 0 then
			pill.BackgroundColor3 = on and Color("Accent") or Color("Control")
			knob.Position = UDim2.fromOffset(on and 20 or 3, 3)
			knob.BackgroundColor3 = on and Color3.new(1, 1, 1) or Color("SubText")
		else
			Tween(pill, { BackgroundColor3 = on and Color("Accent") or Color("Control") }, time)
			Tween(knob, {
				Position = UDim2.fromOffset(on and 20 or 3, 3),
				BackgroundColor3 = on and Color3.new(1, 1, 1) or Color("SubText"),
			}, time, Enum.EasingStyle.Quart)
		end
	end

	function widget:Set(newValue, silent)
		self.Value = newValue and true or false
		paint(true)
		if not silent and cfg.Callback then
			task.spawn(cfg.Callback, self.Value)
		end
		return self.Value
	end

	function widget:Get()
		return self.Value
	end

	function widget:Toggle()
		return self:Set(not self.Value)
	end

	row.MouseButton1Click:Connect(function()
		widget:Toggle()
	end)

	Bind(function()
		paint(false)
	end)

	paint(false)
	trackEntry(tab, section, row, cfg)
	return widget
end

-- slider -----------------------------------------------------------------------

local function MakeSlider(tab, parent, section, cfg)
	local height = (cfg.Desc and cfg.Desc ~= "") and 68 or 54
	local row = New("Frame", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = Color("Hover"),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent,
	})
	Round(row, 8)
	hoverRow(row)

	local valueCfg = type(cfg.Value) == "table" and cfg.Value or {}
	local min = cfg.Min or valueCfg.Min or 0
	local max = cfg.Max or valueCfg.Max or 100
	local default = cfg.Default
	if default == nil then
		default = valueCfg.Default
	end
	if default == nil then
		default = min
	end
	local step = cfg.Step or 1
	local suffix = cfg.Suffix or ""

	local info = buildInfo(row, cfg, 84, height, true)
	local suffixLabel = New("TextLabel", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, (cfg.Desc and 9) or 9),
		Size = UDim2.fromOffset(72, 16),
		BackgroundTransparency = 1,
		Text = "",
		Font = Fonts.Medium,
		TextSize = 11.5,
		TextColor3 = Color("SubText"),
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row,
	})
	BindColor(suffixLabel, "TextColor3", "SubText")

	local track = New("Frame", {
		Name = "Track",
		Active = true,
		Position = UDim2.fromOffset(10, (cfg.Desc and 46) or 32),
		Size = UDim2.new(1, -20, 0, 4),
		BackgroundColor3 = Color("Control"),
		BorderSizePixel = 0,
		Parent = row,
	})
	Round(track, 2)

	local fill = New("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color("Accent"),
		BorderSizePixel = 0,
		Parent = track,
	})
	Round(fill, 2)
	AccentGradient(fill, 0)

	local knob = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(13, 13),
		BackgroundColor3 = Color("Text"),
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = track,
	})
	Round(knob, 7)
	Stroke(knob, Color("Panel"), 2, 0)

	local widget = makeWidget(tab, row, cfg)
	widget.Value = default
	widget.Min = min
	widget.Max = max
	widget.Step = step

	local function roundTo(value)
		if not step or step <= 0 then
			return value
		end
		local snapped = min + math.floor((value - min) / step + 0.5) * step
		return math.clamp(snapped, min, max)
	end

	local function format(value)
		if step >= 1 then
			return tostring(math.floor(value + 0.5))
		end
		return string.format("%.2f", value)
	end

	local function paint(animated)
		local alpha = 0
		if max ~= min then
			alpha = (widget.Value - min) / (max - min)
		end
		alpha = math.clamp(alpha, 0, 1)
		local width = UDim.new(alpha, 0)
		if animated then
			Tween(fill, { Size = UDim2.new(alpha, 0, 1, 0) }, 0.12, Enum.EasingStyle.Quart)
			Tween(knob, { Position = UDim2.fromScale(alpha, 0.5) }, 0.12, Enum.EasingStyle.Quart)
		else
			fill.Size = UDim2.new(alpha, 0, 1, 0)
			knob.Position = UDim2.fromScale(alpha, 0.5)
		end
		suffixLabel.Text = format(widget.Value) .. suffix
	end

	function widget:Set(value, silent)
		self.Value = roundTo(tonumber(value) or min)
		paint(true)
		if not silent and cfg.Callback then
			task.spawn(cfg.Callback, self.Value)
		end
		return self.Value
	end

	function widget:Get()
		return self.Value
	end

	local dragging = false

	local function updateFromInput(input)
		local abs = track.AbsolutePosition
		local size = track.AbsoluteSize
		local alpha = (input.Position.X - abs.X) / math.max(size.X, 1)
		alpha = math.clamp(alpha, 0, 1)
		local value = min + (max - min) * alpha
		widget.Value = roundTo(value)
		paint(false)
	end

	local moveConn

	track.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		dragging = true
		updateFromInput(input)
		if moveConn then
			moveConn:Disconnect()
		end
		moveConn = UserInputService.InputChanged:Connect(function(changed)
			if not dragging then
				return
			end
			if changed.UserInputType == Enum.UserInputType.MouseMovement or changed.UserInputType == Enum.UserInputType.Touch then
				updateFromInput(changed)
			end
		end)
	end)

	local endConnection = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				dragging = false
				if cfg.Callback then
					task.spawn(cfg.Callback, widget.Value)
				end
			end
		end
	end)

	function widget:Destroy()
		if moveConn then
			moveConn:Disconnect()
			moveConn = nil
		end
		if endConnection then
			endConnection:Disconnect()
			endConnection = nil
		end
		self.Row:Destroy()
	end

	Bind(function()
		paint(false)
	end)

	paint(false)
	trackEntry(tab, section, row, cfg)
	return widget
end
--------------------------------------------------------------------------------
-- popup plumbing
--------------------------------------------------------------------------------

local function closePopup(popup)
	if popup and popup.Close then
		popup:Close()
	end
end

local function registerPopup(popup)
	for index, item in ipairs(state.popups) do
		if item == popup then
			table.remove(state.popups, index)
			break
		end
	end
	table.insert(state.popups, popup)
end

local function openPopup(control, width, height, build)
	if not state.scaler then
		return nil
	end

	local scaleValue = state.scaleValue or 1
	local vp = viewport()
	local abs = control.AbsolutePosition
	local absSize = control.AbsoluteSize

	local designX = abs.X / scaleValue
	local designY = abs.Y / scaleValue
	local designW = absSize.X / scaleValue
	local designH = absSize.Y / scaleValue
	local maxX = vp.X / scaleValue

	local popupWidth = math.max(width, designW)
	local x = math.clamp(designX, 10, math.max(10, maxX - popupWidth - 10))
	local y = designY + designH + 7
	if y + height > vp.Y / scaleValue - 12 then
		y = designY - height - 7
	end
	y = math.max(10, y)

	local popup = New("Frame", {
		Name = "Popup",
		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(popupWidth, height),
		BackgroundColor3 = Color("Panel"),
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 800,
		Parent = state.scaler,
	})
	Round(popup, 10)
	Stroke(popup, Color("Stroke"), 1, state.theme.StrokeTransparency)
	Bind(function()
		popup.BackgroundColor3 = Color("Panel")
	end)

	popup.BackgroundTransparency = 1
	Tween(popup, { BackgroundTransparency = 0.02 }, 0.15)

	local closed = false
	local object = { Root = popup }

	function object:Close()
		if closed then
			return
		end
		closed = true
		for index, item in ipairs(state.popups) do
			if item == self then
				table.remove(state.popups, index)
				break
			end
		end
		if popup.Parent then
			Tween(popup, { BackgroundTransparency = 1 }, 0.1)
			task.delay(0.11, function()
				popup:Destroy()
			end)
		end
	end

	local function inside(position)
		local px = popup.AbsolutePosition.X
		local py = popup.AbsolutePosition.Y
		local sx = popup.AbsoluteSize.X
		local sy = popup.AbsoluteSize.Y
		return position.X >= px and position.X <= px + sx and position.Y >= py and position.Y <= py + sy
	end

	local function insideControl(position)
		local px = control.AbsolutePosition.X
		local py = control.AbsolutePosition.Y
		local sx = control.AbsoluteSize.X
		local sy = control.AbsoluteSize.Y
		return position.X >= px and position.X <= px + sx and position.Y >= py and position.Y <= py + sy
	end

	object.Connection = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if not popup.Parent then
			object:Close()
			return
		end
		if not inside(input.Position) and not insideControl(input.Position) then
			object:Close()
		end
	end)

	build(popup, object)
	registerPopup(object)
	return object
end

local function styleItem(button, accentText)
	button.MouseEnter:Connect(function()
		Tween(button, { BackgroundColor3 = Color("Control"), BackgroundTransparency = 0.25 }, 0.1)
	end)
	button.MouseLeave:Connect(function()
		Tween(button, { BackgroundColor3 = Color("Control"), BackgroundTransparency = 1 }, 0.12)
	end)
end

--------------------------------------------------------------------------------
-- dropdown
--------------------------------------------------------------------------------

local function normalizeOptions(values)
	local options = {}
	for _, item in ipairs(values or {}) do
		if type(item) == "table" then
			local title = item.Title or item.Value or item[1]
			local value = item.Value
			if value == nil then
				value = item.Title or item[1]
			end
			table.insert(options, { title = tostring(title or ""), value = value })
		else
			table.insert(options, { title = tostring(item), value = item })
		end
	end
	return options
end

local function sameValue(a, b)
	if type(a) == "table" and type(b) == "table" then
		return false
	end
	return a == b
end

local function MakeDropdown(tab, parent, section, cfg)
	local height = (cfg.Desc and cfg.Desc ~= "") and 60 or 46
	local row = New("Frame", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = Color("Hover"),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent,
	})
	Round(row, 8)
	hoverRow(row)

	local controlWidth = cfg.Width or 190
	buildInfo(row, cfg, controlWidth + 22, height)

	local control = New("TextButton", {
		Name = "Control",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(controlWidth, 30),
		BackgroundColor3 = Color("Control"),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = row,
	})
	Round(control, 7)
	local controlStroke = Stroke(control, Color("Stroke"), 1, state.theme.StrokeTransparency)
	Bind(function()
		control.BackgroundColor3 = Color("Control")
		controlStroke.Color = Color("Stroke")
		controlStroke.Transparency = state.theme.StrokeTransparency
	end)

	local text = New("TextLabel", {
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -32, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Font = Fonts.Regular,
		TextSize = 11.5,
		TextColor3 = Color("Text"),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = control,
	})
	BindColor(text, "TextColor3", "Text")

	local chevron = New("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -9, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundTransparency = 1,
		Text = ResolveGlyph("chevron_down"),
		Font = Fonts.Regular,
		TextSize = 9,
		TextColor3 = Color("Muted"),
		Parent = control,
	})
	BindColor(chevron, "TextColor3", "Muted")

	local options = normalizeOptions(cfg.Values or cfg.Options or {})
	local multi = cfg.Multi or cfg.Multiselect or false
	local widget = makeWidget(tab, row, cfg)
	widget.Options = options
	widget.Multi = multi

	local selected
	if multi then
		selected = {}
		local defaults = cfg.Default or cfg.Value
		if type(defaults) == "table" then
			for _, option in ipairs(options) do
				for _, default in ipairs(defaults) do
					if option.value == default or option.title == default then
						table.insert(selected, option.value)
					end
				end
			end
		end
		widget.Value = selected
	else
		selected = cfg.Default
		if selected == nil then
			selected = cfg.Value
		end
		if selected == nil and cfg.Placeholder == nil and #options > 0 then
			selected = options[1].value
		end
		widget.Value = selected
	end

	local function optionTitle(value)
		for _, option in ipairs(options) do
			if option.value == value or option.title == value then
				return option.title
			end
		end
		return tostring(value)
	end

	local function selectedCount()
		local count = 0
		for _, option in ipairs(options) do
			for _, value in ipairs(selected) do
				if option.value == value then
					count = count + 1
				end
			end
		end
		return count
	end

	local popupRef

	local function refresh()
		if multi then
			local count = selectedCount()
			if count == 0 then
				text.Text = cfg.Placeholder or "选择..."
				text.TextColor3 = Color("Muted")
			elseif cfg.ShowTitles and count <= 2 then
				local names = {}
				for _, option in ipairs(options) do
					for _, value in ipairs(selected) do
						if option.value == value then
							table.insert(names, option.title)
						end
					end
				end
				text.Text = table.concat(names, ", ")
				text.TextColor3 = Color("Text")
			else
				text.Text = tostring(count) .. " 项已选择"
				text.TextColor3 = Color("Text")
			end
		else
			if selected == nil then
				text.Text = cfg.Placeholder or "选择..."
				text.TextColor3 = Color("Muted")
			else
				text.Text = optionTitle(selected)
				text.TextColor3 = Color("Text")
			end
		end
	end

	local function buildList(container, query)
		local lowered = string.lower(query or "")
		local offset = 0
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		for _, option in ipairs(options) do
			if lowered == "" or string.find(string.lower(option.title), lowered, 1, true) then
				local isSelected
				if multi then
					isSelected = false
					for _, value in ipairs(selected) do
						if sameValue(value, option.value) or value == option.title then
							isSelected = true
						end
					end
				else
					isSelected = sameValue(selected, option.value) or selected == option.title
				end

				local item = New("TextButton", {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundColor3 = Color("Control"),
					BackgroundTransparency = isSelected and 0.7 or 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					Parent = container,
				})
				Round(item, 6)
				styleItem(item)

				local itemText = New("TextLabel", {
					Position = UDim2.fromOffset(multi and 30 or 10, 0),
					Size = UDim2.new(1, multi and -58 or -38, 1, 0),
					BackgroundTransparency = 1,
					Text = option.title,
					Font = isSelected and Fonts.Medium or Fonts.Regular,
					TextSize = 11.5,
					TextColor3 = isSelected and Color("Accent") or Color("SubText"),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = item,
				})
				Bind(function()
					itemText.TextColor3 = isSelected and Color("Accent") or Color("SubText")
				end)

				if multi then
					local box = New("Frame", {
						Position = UDim2.fromOffset(10, 9),
						Size = UDim2.fromOffset(13, 13),
						BackgroundColor3 = isSelected and Color("Accent") or Color("Control"),
						BackgroundTransparency = isSelected and 0 or 0.2,
						BorderSizePixel = 0,
						Parent = item,
					})
					Round(box, 3)
					Stroke(box, Color("Stroke"), 1, isSelected and 1 or state.theme.StrokeTransparency)
					if isSelected then
						New("TextLabel", {
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							Text = ResolveGlyph("check"),
							Font = Fonts.Bold,
							TextSize = 9,
							TextColor3 = Color("AccentText"),
							Parent = box,
						})
					end
				else
					if isSelected then
						New("TextLabel", {
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -10, 0.5, 0),
							Size = UDim2.fromOffset(12, 12),
							BackgroundTransparency = 1,
							Text = ResolveGlyph("check"),
							Font = Fonts.Bold,
							TextSize = 10,
							TextColor3 = Color("Accent"),
							Parent = item,
						})
					end
				end

				item.MouseButton1Click:Connect(function()
					if multi then
						local found = false
						for index, value in ipairs(selected) do
							if sameValue(value, option.value) or value == option.title then
								table.remove(selected, index)
								found = true
								break
							end
						end
						if not found then
							table.insert(selected, option.value)
						end
						widget.Value = selected
						refresh()
						if popupRef then
							local scroll = popupRef.Root:FindFirstChild("List")
							if scroll then
								buildList(scroll, "")
							end
						end
						if cfg.Callback then
							task.spawn(cfg.Callback, selected)
						end
					else
						selected = option.value
						widget.Value = selected
						refresh()
						if popupRef then
							popupRef:Close()
						end
						if cfg.Callback then
							task.spawn(cfg.Callback, selected)
						end
					end
				end)

				offset = offset + 32
			end
		end
	end

	control.MouseButton1Click:Connect(function()
		if popupRef and popupRef.Root and popupRef.Root.Parent then
			popupRef:Close()
			return
		end
		local openList = {}
		for _, item in ipairs(state.popups) do
			table.insert(openList, item)
		end
		for _, item in ipairs(openList) do
			closePopup(item)
		end

		local showSearch = cfg.Search ~= false and #options > 6
		local listHeight = math.min(#options * 32 + 8, cfg.MaxHeight or 208)
		local total = listHeight + (showSearch and 38 or 8)

		popupRef = openPopup(control, controlWidth, total, function(popup, object)
			local top = 4
			if showSearch then
				local searchBox = New("TextBox", {
					Position = UDim2.fromOffset(8, 6),
					Size = UDim2.new(1, -16, 0, 28),
					BackgroundColor3 = Color("Control"),
					BackgroundTransparency = 0.3,
					BorderSizePixel = 0,
					Font = Fonts.Regular,
					TextSize = 11.5,
					TextColor3 = Color("Text"),
					PlaceholderText = "搜索...",
					PlaceholderColor3 = Color("Muted"),
					Text = "",
					TextXAlignment = Enum.TextXAlignment.Left,
					ClearTextOnFocus = false,
					Parent = popup,
				})
				Round(searchBox, 6)
				New("UIPadding", { PaddingLeft = UDim.new(0, 9) }, searchBox)
				top = 40
			end

			local list = New("ScrollingFrame", {
				Name = "List",
				Position = UDim2.fromOffset(4, top),
				Size = UDim2.new(1, -8, 1, -top - 4),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.fromOffset(0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = Color("SubText"),
				ScrollBarImageTransparency = 0.6,
				Parent = popup,
			})
			New("UIListLayout", { Padding = UDim.new(0, 2) }, list)
			buildList(list, "")

			if showSearch then
				local box = popup:FindFirstChildOfClass("TextBox")
				if box then
					box:GetPropertyChangedSignal("Text"):Connect(function()
						buildList(list, box.Text)
					end)
				end
			end
		end)

		if popupRef then
			chevron.Rotation = 180
			local conn
			conn = RunService.Heartbeat:Connect(function()
				if not popupRef or not popupRef.Root or not popupRef.Root.Parent then
					chevron.Rotation = 0
					conn:Disconnect()
				end
			end)
		end
	end)

	function widget:Get()
		if multi then
			return table.clone and table.clone(selected) or selected
		end
		return selected
	end

	function widget:Set(value, silent)
		if multi then
			selected = {}
			if type(value) == "table" then
				for _, item in ipairs(value) do
					table.insert(selected, item)
				end
			end
			widget.Value = selected
		else
			selected = value
			widget.Value = value
		end
		refresh()
		if not silent and cfg.Callback then
			task.spawn(cfg.Callback, widget:Get())
		end
	end

	function widget:Refresh(newValues)
		if newValues then
			options = normalizeOptions(newValues)
			widget.Options = options
		end
		refresh()
	end

	Bind(refresh)
	refresh()
	trackEntry(tab, section, row, cfg)
	return widget
end
--------------------------------------------------------------------------------
-- input
--------------------------------------------------------------------------------

local function MakeInput(tab, parent, section, cfg)
	local height = (cfg.Desc and cfg.Desc ~= "") and 60 or 46
	local row = New("Frame", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = Color("Hover"),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent,
	})
	Round(row, 8)
	hoverRow(row)

	local controlWidth = cfg.Width or 180
	buildInfo(row, cfg, controlWidth + 22, height)

	local control = New("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(controlWidth, 30),
		BackgroundColor3 = Color("Control"),
		BorderSizePixel = 0,
		Parent = row,
	})
	Round(control, 7)
	local controlStroke = Stroke(control, Color("Stroke"), 1, state.theme.StrokeTransparency)
	Bind(function()
		control.BackgroundColor3 = Color("Control")
		controlStroke.Color = Color("Stroke")
		controlStroke.Transparency = state.theme.StrokeTransparency
	end)

	local box = New("TextBox", {
		Name = "Box",
		Position = UDim2.fromOffset(9, 0),
		Size = UDim2.new(1, -18, 1, 0),
		BackgroundTransparency = 1,
		Font = Fonts.Regular,
		TextSize = 11.5,
		TextColor3 = Color("Text"),
		PlaceholderText = cfg.Placeholder or "",
		PlaceholderColor3 = Color("Muted"),
		Text = tostring(cfg.Default or cfg.Value or ""),
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Parent = control,
	})
	BindColor(box, "TextColor3", "Text")
	BindColor(box, "PlaceholderColor3", "Muted")

	local widget = makeWidget(tab, row, cfg)

	function widget:Get()
		return box.Text
	end

	function widget:Set(value, silent)
		box.Text = tostring(value or "")
		if not silent and cfg.Callback then
			task.spawn(cfg.Callback, box.Text, false)
		end
	end

	box.Focused:Connect(function()
		controlStroke.Color = Color("Accent")
		controlStroke.Transparency = 0.45
		Tween(control, { BackgroundTransparency = 0 }, 0.15)
	end)

	box.FocusLost:Connect(function(enterPressed)
		controlStroke.Color = Color("Stroke")
		controlStroke.Transparency = state.theme.StrokeTransparency
		if cfg.Callback then
			task.spawn(cfg.Callback, box.Text, enterPressed)
		end
	end)

	trackEntry(tab, section, row, cfg)
	return widget
end

--------------------------------------------------------------------------------
-- keybind
--------------------------------------------------------------------------------

local function keyLabel(value)
	if typeof(value) == "EnumItem" then
		return value.Name
	end
	if type(value) == "string" and value ~= "" then
		return value
	end
	return "无"
end

local function MakeKeybind(tab, parent, section, cfg)
	local height = (cfg.Desc and cfg.Desc ~= "") and 60 or 46
	local row = New("Frame", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = Color("Hover"),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent,
	})
	Round(row, 8)
	hoverRow(row)

	buildInfo(row, cfg, 132, height)

	local control = New("TextButton", {
		Name = "Control",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(110, 30),
		BackgroundColor3 = Color("Control"),
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = row,
	})
	Round(control, 7)
	Stroke(control, Color("Stroke"), 1, state.theme.StrokeTransparency)
	Bind(function()
		control.BackgroundColor3 = Color("Control")
	end)

	local label = New("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = keyLabel(cfg.Default or cfg.Value),
		Font = Fonts.Medium,
		TextSize = 11.5,
		TextColor3 = Color("SubText"),
		Parent = control,
	})
	BindColor(label, "TextColor3", "SubText")

	local widget = makeWidget(tab, row, cfg)
	widget.Value = cfg.Default or cfg.Value
	widget.Listening = false

	local connection

	function widget:Set(value, silent)
		self.Value = value
		label.Text = keyLabel(value)
		if not silent and cfg.Callback then
			task.spawn(cfg.Callback, value)
		end
	end

	function widget:Get()
		return self.Value
	end

	local function stopListening()
		widget.Listening = false
		label.Text = keyLabel(widget.Value)
		label.TextColor3 = Color("SubText")
		control.BackgroundColor3 = Color("Control")
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	local function startListening()
		widget.Listening = true
		label.Text = "按下按键..."
		label.TextColor3 = Color("Accent")
		control.BackgroundColor3 = Color("Control")

		connection = UserInputService.InputBegan:Connect(function(input, processed)
			if not widget.Listening then
				return
			end
			if input.KeyCode == Enum.KeyCode.Unknown then
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					widget:Set("Mouse1")
					stopListening()
				elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
					widget:Set("Mouse2")
					stopListening()
				end
				return
			end
			if input.KeyCode == Enum.KeyCode.Escape then
				stopListening()
				return
			end
			if processed then
				return
			end
			widget:Set(input.KeyCode)
			stopListening()
		end)
	end

	control.MouseButton1Click:Connect(function()
		if widget.Listening then
			stopListening()
		else
			startListening()
		end
	end)

	function widget:Destroy()
		if connection then
			connection:Disconnect()
			connection = nil
		end
		self.Row:Destroy()
	end

	trackEntry(tab, section, row, cfg)
	return widget
end

--------------------------------------------------------------------------------
-- colorpicker
--------------------------------------------------------------------------------

local function MakeColorpicker(tab, parent, section, cfg)
	local height = (cfg.Desc and cfg.Desc ~= "") and 60 or 46
	local row = New("Frame", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = Color("Hover"),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = parent,
	})
	Round(row, 8)
	hoverRow(row)

	buildInfo(row, cfg, 64, height)

	local initial = cfg.Default or cfg.Value or Color3.fromRGB(77, 141, 255)
	local h, s, v = initial:ToHSV()

	local swatch = New("TextButton", {
		Name = "Swatch",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(38, 30),
		BackgroundColor3 = initial,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Parent = row,
	})
	Round(swatch, 7)
	Stroke(swatch, Color("Stroke"), 1, 0.75)

	local widget = makeWidget(tab, row, cfg)
	widget.Value = initial
	local popupRef

	local function refreshSwatch()
		swatch.BackgroundColor3 = Color3.fromHSV(h, s, v)
	end

	local function fromHex(text)
		local cleaned = string.gsub(text or "", "#", "")
		cleaned = string.gsub(cleaned, "%s", "")
		if string.match(cleaned, "^%x%x%x%x%x%x$") then
			return Color3.fromHex(cleaned)
		end
		return nil
	end

	local popupSync

	local function apply(color, silent)
		h, s, v = color:ToHSV()
		widget.Value = color
		refreshSwatch()
		if popupSync and popupRef and popupRef.Root and popupRef.Root.Parent then
			popupSync()
		end
		if not silent and cfg.Callback then
			task.spawn(cfg.Callback, color)
		end
	end

	function widget:Get()
		return widget.Value
	end

	function widget:Set(color, silent)
		if typeof(color) == "string" then
			color = fromHex(color) or widget.Value
		end
		apply(color, silent)
	end

	swatch.MouseButton1Click:Connect(function()
		if popupRef and popupRef.Root and popupRef.Root.Parent then
			popupRef:Close()
			return
		end
		local openList = {}
		for _, item in ipairs(state.popups) do
			table.insert(openList, item)
		end
		for _, item in ipairs(openList) do
			closePopup(item)
		end

		local popupWidth = 202
		local popupHeight = 192

		popupRef = openPopup(swatch, popupWidth, popupHeight, function(popup)
			local sv = New("Frame", {
				Position = UDim2.fromOffset(12, 12),
				Size = UDim2.fromOffset(178, 110),
				BackgroundColor3 = Color3.fromHSV(h, 1, 1),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = popup,
			})
			Round(sv, 6)

			New("UIGradient", {
				Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
				Rotation = 0,
			}, sv)

			New("UIGradient", {
				Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0),
				}),
				Rotation = 90,
			}, sv)

			sv.Active = true
			local svKnob = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(s, 1 - v),
				Size = UDim2.fromOffset(11, 11),
				BackgroundColor3 = Color3.fromHSV(h, s, v),
				BorderSizePixel = 0,
				Active = false,
				ZIndex = 2,
				Parent = sv,
			})
			Round(svKnob, 6)
			Stroke(svKnob, Color3.new(1, 1, 1), 1.5, 0.1)

			local hueBar = New("Frame", {
				Position = UDim2.fromOffset(12, 132),
				Size = UDim2.fromOffset(178, 10),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Parent = popup,
			})
			Round(hueBar, 5)
			local hueGradient = New("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0.0, Color3.fromHSV(0, 1, 1)),
					ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
					ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
					ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
					ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1)),
					ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
					ColorSequenceKeypoint.new(1.0, Color3.fromHSV(1, 1, 1)),
				}),
			}, hueBar)

			hueBar.Active = true
			local hueKnob = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(h, 0.5),
				Size = UDim2.fromOffset(4, 14),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Active = false,
				ZIndex = 2,
				Parent = hueBar,
			})
			Round(hueKnob, 2)
			Stroke(hueKnob, Color3.new(0, 0, 0), 1, 0.65)

			local hexBox = New("TextBox", {
				Position = UDim2.fromOffset(12, 154),
				Size = UDim2.fromOffset(110, 26),
				BackgroundColor3 = Color("Control"),
				BorderSizePixel = 0,
				Font = Fonts.Regular,
				TextSize = 11.5,
				TextColor3 = Color("Text"),
				Text = string.format("#%02X%02X%02X", math.floor(widget.Value.R * 255 + 0.5), math.floor(widget.Value.G * 255 + 0.5), math.floor(widget.Value.B * 255 + 0.5)),
				TextXAlignment = Enum.TextXAlignment.Center,
				ClearTextOnFocus = false,
				Parent = popup,
			})
			Round(hexBox, 6)
			Stroke(hexBox, Color("Stroke"), 1, state.theme.StrokeTransparency)

			local preview = New("Frame", {
				Position = UDim2.fromOffset(132, 154),
				Size = UDim2.fromOffset(58, 26),
				BackgroundColor3 = widget.Value,
				BorderSizePixel = 0,
				Parent = popup,
			})
			Round(preview, 6)
			Stroke(preview, Color("Stroke"), 1, 0.75)

			local function syncHex(color)
				hexBox.Text = string.format(
					"#%02X%02X%02X",
					math.floor(color.R * 255 + 0.5),
					math.floor(color.G * 255 + 0.5),
					math.floor(color.B * 255 + 0.5)
				)
			end

			local function paint()
				local color = Color3.fromHSV(h, s, v)
				sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				svKnob.Position = UDim2.fromScale(s, 1 - v)
				svKnob.BackgroundColor3 = color
				hueKnob.Position = UDim2.fromScale(h, 0.5)
				preview.BackgroundColor3 = color
				swatch.BackgroundColor3 = color
				widget.Value = color
				syncHex(color)
			end

			local function dragOn(gui, handler)
				local moving = false
				local conn
				gui.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					moving = true
					handler(input.Position)
					if conn then
						conn:Disconnect()
					end
					conn = UserInputService.InputChanged:Connect(function(changed)
						if moving and (changed.UserInputType == Enum.UserInputType.MouseMovement or changed.UserInputType == Enum.UserInputType.Touch) then
							handler(changed.Position)
						end
					end)
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						if moving then
							moving = false
							if conn then
								conn:Disconnect()
								conn = nil
							end
							if cfg.Callback then
								task.spawn(cfg.Callback, widget.Value)
							end
						end
					end
				end)
			end

			dragOn(sv, function(position)
				local abs = sv.AbsolutePosition
				local size = sv.AbsoluteSize
				s = math.clamp((position.X - abs.X) / math.max(size.X, 1), 0, 1)
				v = 1 - math.clamp((position.Y - abs.Y) / math.max(size.Y, 1), 0, 1)
				paint()
			end)

			dragOn(hueBar, function(position)
				local abs = hueBar.AbsolutePosition
				local size = hueBar.AbsoluteSize
				h = math.clamp((position.X - abs.X) / math.max(size.X, 1), 0, 1)
				paint()
			end)

			hexBox.FocusLost:Connect(function()
				local color = fromHex(hexBox.Text)
				if color then
					h, s, v = color:ToHSV()
					paint()
					if cfg.Callback then
						task.spawn(cfg.Callback, color)
					end
				else
					syncHex(widget.Value)
				end
			end)

			popupSync = paint
		end)
	end)

	Bind(refreshSwatch)
	refreshSwatch()
	trackEntry(tab, section, row, cfg)
	return widget
end

--------------------------------------------------------------------------------
-- paragraph / divider / label
--------------------------------------------------------------------------------

local function MakeParagraph(tab, parent, section, cfg)
	local window = tab.Window
	local compact = window.Width < 560
	local side = compact and 58 or window.SidebarWidth
	local available = window.Width - side - 28 - 24
	local hasTitle = cfg.Title and cfg.Title ~= ""
	local descHeight = 0
	if cfg.Desc and cfg.Desc ~= "" then
		descHeight = Measure(cfg.Desc, 11.5, available, Fonts.Regular).Y
	end

	local height = 24 + (hasTitle and 20 or 0) + descHeight
	if cfg.Image and cfg.Image ~= "" then
		height = math.max(height, 84)
	end

	local card = New("Frame", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = Color("Control"),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Parent = parent,
	})
	Round(card, 9)
	Stroke(card, Color("Stroke"), 1, 0.95)
	Bind(function()
		card.BackgroundColor3 = Color("Control")
	end)

	local textX = 12
	if cfg.Image and cfg.Image ~= "" then
		local image = New("ImageLabel", {
			Position = UDim2.fromOffset(12, 12),
			Size = UDim2.fromOffset(60, 60),
			BackgroundColor3 = Color("Panel"),
			BorderSizePixel = 0,
			Image = cfg.Image,
			ScaleType = Enum.ScaleType.Crop,
			Parent = card,
		})
		Round(image, 8)
		textX = 84
	end

	local y = 12
	if hasTitle then
		local title = New("TextLabel", {
			Position = UDim2.fromOffset(textX, y),
			Size = UDim2.new(1, -textX - 12, 0, 18),
			BackgroundTransparency = 1,
			Text = cfg.Title,
			Font = Fonts.Semibold,
			TextSize = 12.5,
			TextColor3 = Color("Text"),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = card,
		})
		BindColor(title, "TextColor3", "Text")
		y = y + 20
	end

	if cfg.Desc and cfg.Desc ~= "" then
		local desc = New("TextLabel", {
			Position = UDim2.fromOffset(textX, y),
			Size = UDim2.new(1, -textX - 12, 0, math.max(descHeight, 14)),
			BackgroundTransparency = 1,
			Text = cfg.Desc,
			Font = Fonts.Regular,
			TextSize = 11.5,
			TextColor3 = Color("SubText"),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Parent = card,
		})
		BindColor(desc, "TextColor3", "SubText")
	end

	local widget = makeWidget(tab, card, cfg)
	trackEntry(tab, section, card, cfg)
	return widget
end

local function MakeDivider(tab, parent, section, cfg)
	local holder = New("Frame", {
		Size = UDim2.new(1, 0, 0, 9),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	local line = New("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Color("Stroke"),
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Parent = holder,
	})
	Bind(function()
		line.BackgroundColor3 = Color("Stroke")
		line.BackgroundTransparency = math.min(0.98, state.theme.StrokeTransparency + 0.04)
	end)

	local widget = makeWidget(tab, holder, cfg)
	table.insert(tab.Entries, { row = holder, title = "", desc = "", section = section, tab = tab, always = true })
	return widget
end

local function MakeLabel(tab, parent, section, cfg)
	local label = New("TextLabel", {
		Size = UDim2.new(1, 0, 0, cfg.Height or 20),
		BackgroundTransparency = 1,
		Text = cfg.Text or cfg.Title or "",
		Font = cfg.Bold and Fonts.Semibold or Fonts.Regular,
		TextSize = cfg.TextSize or 10.5,
		TextColor3 = Color("Muted"),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = cfg.Wrap or false,
		Parent = parent,
	})
	BindColor(label, "TextColor3", "Muted")

	local widget = makeWidget(tab, label, cfg)
	table.insert(tab.Entries, { row = label, title = "", desc = "", section = section, tab = tab, always = true })
	return widget
end
--------------------------------------------------------------------------------
-- widget dispatch
--------------------------------------------------------------------------------

local KindFactory = {
	Button = MakeButton,
	Toggle = MakeToggle,
	Slider = MakeSlider,
	Dropdown = MakeDropdown,
	Input = MakeInput,
	Keybind = MakeKeybind,
	Colorpicker = MakeColorpicker,
	Paragraph = MakeParagraph,
	Divider = MakeDivider,
	Label = MakeLabel,
}

local function CreateWidget(tab, parent, section, kind, cfg)
	local factory = KindFactory[kind]
	if not factory then
		return nil
	end
	local widget = factory(tab, parent, section, cfg or {})
	if widget then
		widget.Kind = kind
	end
	return widget
end

--------------------------------------------------------------------------------
-- section
--------------------------------------------------------------------------------

local Section = {}
Section.__index = Section

function Tab:Section(cfg)
	cfg = cfg or {}
	local container = New("Frame", {
		Name = "Section",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = #self.Sections + 1,
		Parent = self.Page,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, container)
	New("UIPadding", {
		PaddingBottom = UDim.new(0, cfg.Spacing or 0),
	}, container)

	local section = setmetatable({ Tab = self, Container = container, Items = {}, Title = cfg.Title }, Section)
	table.insert(self.Sections, section)

	if cfg.Title and cfg.Title ~= "" then
		local header = New("Frame", {
			Size = UDim2.new(1, 0, 0, 27),
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Parent = container,
		})

		local titleWidth = Measure(cfg.Title, 10.5, 400, Fonts.Semibold).X
		local label = New("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 1, 0.5, 0),
			Size = UDim2.fromOffset(titleWidth + 6, 16),
			BackgroundTransparency = 1,
			Text = cfg.Title,
			Font = Fonts.Semibold,
			TextSize = 10.5,
			TextColor3 = Color("SubText"),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = header,
		})
		BindColor(label, "TextColor3", "SubText")

		local line = New("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, titleWidth + 14, 0.5, 0),
			Size = UDim2.new(1, -(titleWidth + 14), 0, 1),
			BackgroundColor3 = Color("Stroke"),
			BackgroundTransparency = 0.93,
			BorderSizePixel = 0,
			Parent = header,
		})
		Bind(function()
			line.BackgroundColor3 = Color("Stroke")
		end)
	end

	return section
end

function Section:Button(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Button", cfg)
end

function Section:Toggle(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Toggle", cfg)
end

function Section:Slider(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Slider", cfg)
end

function Section:Dropdown(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Dropdown", cfg)
end

function Section:Input(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Input", cfg)
end

function Section:Keybind(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Keybind", cfg)
end

function Section:Colorpicker(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Colorpicker", cfg)
end

function Section:Paragraph(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Paragraph", cfg)
end

function Section:Divider(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Divider", cfg)
end

function Section:Label(cfg)
	return CreateWidget(self.Tab, self.Container, self, "Label", cfg)
end

--------------------------------------------------------------------------------
-- tab
--------------------------------------------------------------------------------

function Tab:SetActive(active)
	self.Active = active
	if not self.TabButton or not self.TabButton.Parent then
		return
	end

	local iconColorKey = active and "Accent" or "SubText"
	if self.IconGui then
		if self.IconGui:IsA("ImageLabel") then
			self.IconGui.ImageColor3 = Color(iconColorKey)
		else
			self.IconGui.TextColor3 = Color(iconColorKey)
		end
	end

	if active then
		self.TabButton.BackgroundColor3 = Color("Control")
		self.TabButton.BackgroundTransparency = 0
		self.Bar.Visible = true
		self.Bar.BackgroundColor3 = Color("Accent")
		self.NameLabel.TextColor3 = Color("Text")
		self.NameLabel.Font = Fonts.Semibold
	else
		self.TabButton.BackgroundTransparency = 1
		self.Bar.Visible = false
		self.NameLabel.TextColor3 = Color("SubText")
		self.NameLabel.Font = Fonts.Medium
	end

	local dim = self.Dimmed and 0.6 or 0
	self.NameLabel.TextTransparency = dim
	if self.IconGui then
		if self.IconGui:IsA("TextLabel") then
			self.IconGui.TextTransparency = dim
		elseif self.IconGui:IsA("ImageLabel") then
			self.IconGui.ImageTransparency = dim
		end
	end
end

function Tab:SetCompact(compact)
	self.Compact = compact
	if not self.TabButton or not self.TabButton.Parent then
		return
	end
	self.TabButton.Size = UDim2.new(1, 0, 0, compact and 38 or 36)
	self.NameLabel.Visible = not compact
	if self.IconGui then
		self.IconGui.Position = UDim2.fromOffset(compact and 10 or 13, 0)
		self.IconGui.Size = UDim2.new(0, compact and 22 or 18, 1, 0)
		if self.IconGui:IsA("TextLabel") then
			self.IconGui.TextSize = compact and 16 or 14
		end
	end
	if self.Bar then
		self.Bar.Position = UDim2.new(0, 0, 0.5, 0)
	end
end

function Tab:_updateSections()
	for _, section in ipairs(self.Sections) do
		local any = false
		for _, item in ipairs(section.Items) do
			if item.row and item.row.Parent and item.row.Visible then
				any = true
				break
			end
		end
		section.Container.Visible = any
	end
end

function Tab:_updateSearchState(empty)
	self.Dimmed = empty
	if not self.TabButton then
		return
	end
	self:SetActive(self.Active)
end

function Tab:Select()
	self.Window:SelectTab(self)
end

function Tab:SetTitle(title)
	self.Title = title
	if self.NameLabel then
		self.NameLabel.Text = title
	end
end

function Tab:Clear()
	for _, widget in ipairs(self.Widgets) do
		if widget.Row then
			widget.Row:Destroy()
		end
	end
	self.Widgets = {}
	self.Entries = {}
	for _, section in ipairs(self.Sections) do
		section.Items = {}
		if section.Container then
			section.Container:ClearAllChildren()
		end
	end
	local window = self.Window
	local kept = {}
	for _, entry in ipairs(window.SearchEntries) do
		if entry.tab ~= self then
			table.insert(kept, entry)
		end
	end
	window.SearchEntries = kept
end

function Tab:Destroy()
	if self.TabButton then
		self.TabButton:Destroy()
	end
	if self.Page then
		self.Page:Destroy()
	end
	for index, item in ipairs(self.Window.Tabs) do
		if item == self then
			table.remove(self.Window.Tabs, index)
			break
		end
	end
end

function Tab:Button(cfg)
	return CreateWidget(self, self.Page, nil, "Button", cfg)
end

function Tab:Toggle(cfg)
	return CreateWidget(self, self.Page, nil, "Toggle", cfg)
end

function Tab:Slider(cfg)
	return CreateWidget(self, self.Page, nil, "Slider", cfg)
end

function Tab:Dropdown(cfg)
	return CreateWidget(self, self.Page, nil, "Dropdown", cfg)
end

function Tab:Input(cfg)
	return CreateWidget(self, self.Page, nil, "Input", cfg)
end

function Tab:Keybind(cfg)
	return CreateWidget(self, self.Page, nil, "Keybind", cfg)
end

function Tab:Colorpicker(cfg)
	return CreateWidget(self, self.Page, nil, "Colorpicker", cfg)
end

function Tab:Paragraph(cfg)
	return CreateWidget(self, self.Page, nil, "Paragraph", cfg)
end

function Tab:Divider(cfg)
	return CreateWidget(self, self.Page, nil, "Divider", cfg)
end

function Tab:Label(cfg)
	return CreateWidget(self, self.Page, nil, "Label", cfg)
end

function Tab:Space(height)
	return New("Frame", {
		Size = UDim2.new(1, 0, 0, height or 8),
		BackgroundTransparency = 1,
		Parent = self.Page,
	})
end

--------------------------------------------------------------------------------
-- window: create tab
--------------------------------------------------------------------------------

function Window:Tab(cfg)
	cfg = cfg or {}
	local index = #self.Tabs + 1
	local tab = setmetatable({}, Tab)
	tab.Window = self
	tab.Title = cfg.Title or ("Tab " .. index)
	tab.IconName = cfg.Icon
	tab.Entries = {}
	tab.Widgets = {}
	tab.Sections = {}
	tab.Active = false
	tab.Compact = false

	local button = New("TextButton", {
		Name = "Tab_" .. tostring(index),
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = Color("Control"),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = index,
		Parent = self.TabsScroll,
	})
	Round(button, 8)
	tab.TabButton = button

	local bar = New("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(3, 16),
		BackgroundColor3 = Color("Accent"),
		BorderSizePixel = 0,
		Visible = false,
		Parent = button,
	})
	Round(bar, 2)
	tab.Bar = bar

	local iconName = cfg.Icon or "dot"
	local icon
	if tostring(iconName):find("rbxasset") then
		icon = New("ImageLabel", {
			Position = UDim2.fromOffset(13, 0),
			Size = UDim2.fromOffset(18, 36),
			BackgroundTransparency = 1,
			Image = iconName,
			ImageColor3 = Color("SubText"),
			ScaleType = Enum.ScaleType.Fit,
			Parent = button,
		})
	else
		icon = New("TextLabel", {
			Position = UDim2.fromOffset(13, 0),
			Size = UDim2.fromOffset(18, 36),
			BackgroundTransparency = 1,
			Text = ResolveGlyph(iconName) or ResolveGlyph("dot"),
			Font = Fonts.Regular,
			TextSize = 14,
			TextColor3 = Color("SubText"),
			Parent = button,
		})
	end
	tab.IconGui = icon

	local label = New("TextLabel", {
		Position = UDim2.fromOffset(36, 0),
		Size = UDim2.new(1, -46, 1, 0),
		BackgroundTransparency = 1,
		Text = tab.Title,
		Font = Fonts.Medium,
		TextSize = 12,
		TextColor3 = Color("SubText"),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = button,
	})
	tab.NameLabel = label

	local page = New("Frame", {
		Name = "Page_" .. tostring(index),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = false,
		LayoutOrder = index,
		Parent = self.Scroll,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, page)
	tab.Page = page

	button.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	button.MouseEnter:Connect(function()
		if not tab.Active then
			button.BackgroundColor3 = Color("Hover")
			button.BackgroundTransparency = state.theme.HoverTransparency - 0.02
			label.TextColor3 = Color("Text")
		end
		if tab.Compact then
			local mouse = UserInputService:GetMouseLocation()
			Zephyr:ShowTooltip(tab.Title, mouse.X, mouse.Y)
		end
	end)

	button.MouseLeave:Connect(function()
		if not tab.Active then
			button.BackgroundTransparency = 1
			label.TextColor3 = Color("SubText")
		end
		Zephyr:HideTooltip()
	end)

	table.insert(self.Tabs, tab)
	Bind(function()
		tab:SetActive(tab.Active)
		tab:SetCompact(tab.Compact)
	end)

	if index == 1 then
		self:SelectTab(tab)
	end

	self:_layout()
	if self.SearchBox.Text ~= "" then
		self:_applyFilter(self.SearchBox.Text)
	end

	return tab
end

--------------------------------------------------------------------------------
-- config
--------------------------------------------------------------------------------

local HttpService = service("HttpService")

local function serializeValue(value)
	local kind = typeof(value)
	if kind == "Color3" then
		return string.format(
			"#%02X%02X%02X",
			math.floor(value.R * 255 + 0.5),
			math.floor(value.G * 255 + 0.5),
			math.floor(value.B * 255 + 0.5)
		)
	end
	if kind == "EnumItem" then
		return value.Name
	end
	if type(value) == "table" then
		local out = {}
		for key, item in pairs(value) do
			out[key] = serializeValue(item)
		end
		return out
	end
	return value
end

function Window:GetConfig()
	local data = {}
	for _, widget in ipairs(self.Widgets) do
		if widget.Flag and widget.Flag ~= "" and widget.Get then
			local ok, value = pcall(function()
				return widget:Get()
			end)
			if ok then
				data[widget.Flag] = serializeValue(value)
			end
		end
	end
	return data
end

function Window:SaveConfig(name)
	local data = self:GetConfig()
	local fileName = "ZephyrUI/" .. tostring(name or self.Config.Folder or "default") .. ".json"

	local ok, encoded = pcall(function()
		return HttpService:JSONEncode(data)
	end)
	self.LastConfig = data
	if not ok then
		return data, false
	end

	local wrote = false
	if writefile then
		wrote = pcall(function()
			if makefolder and isfolder and not isfolder("ZephyrUI") then
				makefolder("ZephyrUI")
			end
			writefile(fileName, encoded)
		end)
	end
	return data, wrote
end

function Window:LoadConfig(name)
	local fileName = "ZephyrUI/" .. tostring(name or self.Config.Folder or "default") .. ".json"
	local data
	if readfile and isfile then
		local exists = false
		pcall(function()
			exists = isfile(fileName)
		end)
		if exists then
			pcall(function()
				local content = readfile(fileName)
				data = HttpService:JSONDecode(content)
			end)
		end
	end
	if not data then
		return nil
	end

	for _, widget in ipairs(self.Widgets) do
		local value = widget.Flag and data[widget.Flag]
		if value ~= nil and widget.Set then
			if widget.Kind == "Colorpicker" and type(value) == "string" then
				local ok, color = pcall(function()
					return Color3.fromHex(value)
				end)
				if ok then
					widget:Set(color, true)
				end
			elseif widget.Kind == "Keybind" and type(value) == "string" then
				local key = Enum.KeyCode[value]
				widget:Set(key or value, true)
			else
				pcall(function()
					widget:Set(value, true)
				end)
			end
		end
	end

	return data
end

--------------------------------------------------------------------------------
-- public surface
--------------------------------------------------------------------------------

Zephyr.Themes = Themes
Zephyr.Icons = Glyphs
Zephyr.Window = Window
Zephyr.Tab = Tab
Zephyr.Section = Section

function Zephyr:GetWindows()
	return state.windows
end

return Zephyr
