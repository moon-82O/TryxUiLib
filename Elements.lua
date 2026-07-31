local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/VOTRE_USER/TryxUiLib/main/Theme.lua"))()
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/VOTRE_USER/TryxUiLib/main/Utils.lua"))()

local Elements = {}

local BindState = {
    Target = nil,
    Registry = {},
}

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if BindState.Target then
        local key = (input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode) or input.UserInputType
        local name = string.upper(key.Name)
        for k, v in pairs(BindState.Registry) do
            if v == BindState.Target.Action then
                BindState.Registry[k] = nil
            end
        end
        BindState.Registry[key] = BindState.Target.Action
        BindState.Target.Label.Text = "[" .. name .. "]"
        BindState.Target.Label.TextColor3 = Theme.Colors.TextBindActive
        BindState.Target = nil
        return
    end
    local key = (input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode) or input.UserInputType
    if BindState.Registry[key] then
        BindState.Registry[key]()
    end
end)

function Elements.Toggle(parent, config)
    local labelText = config.Label or "Toggle"
    local callback  = config.Callback or function() end
    local bindable  = config.Bindable ~= false
    local bindAction = config.BindAction or nil

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 270, 0, Theme.Sizes.ElementH)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, Theme.Sizes.ToggleW, 0, Theme.Sizes.ToggleH)
    btn.Position = UDim2.new(0, 0, 0.5, -Theme.Sizes.ToggleH / 2)
    btn.BackgroundColor3 = Theme.Colors.ToggleBg
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = frame
    Utils.applyCorner(btn, Theme.Sizes.CornerRound)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, Theme.Sizes.IndicatorSize, 0, Theme.Sizes.IndicatorSize)
    indicator.Position = UDim2.new(0, 3, 0.5, -Theme.Sizes.IndicatorSize / 2)
    indicator.BackgroundColor3 = Theme.Colors.Indicator
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    Utils.applyCorner(indicator, Theme.Sizes.CornerRound)

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -120, 1, 0)
    textLabel.Position = UDim2.new(0, 56, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = labelText
    textLabel.TextColor3 = Theme.Colors.TextSecondary
    textLabel.Font = Theme.Fonts.Medium
    textLabel.TextSize = Theme.Sizes.ElementSize
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame

    local bindLabel = Instance.new("TextLabel")
    bindLabel.Size = UDim2.new(0, 50, 1, 0)
    bindLabel.Position = UDim2.new(1, -55, 0, 0)
    bindLabel.BackgroundTransparency = 1
    bindLabel.Text = "[NONE]"
    bindLabel.TextColor3 = Theme.Colors.TextBind
    bindLabel.Font = Theme.Fonts.Bold
    bindLabel.TextSize = Theme.Sizes.BindSize
    bindLabel.TextXAlignment = Enum.TextXAlignment.Right
    bindLabel.Parent = frame

    local toggleState = false

    local function trigger()
        toggleState = not toggleState
        local targetPos   = toggleState and UDim2.new(0, 25, 0.5, -Theme.Sizes.IndicatorSize / 2) or UDim2.new(0, 3, 0.5, -Theme.Sizes.IndicatorSize / 2)
        local targetColor = toggleState and Theme.Colors.ToggleActive or Theme.Colors.ToggleBg
        local targetInd   = toggleState and Theme.Colors.IndicatorActive or Theme.Colors.Indicator
        TweenService:Create(indicator, Theme.Tween.Toggle, { Position = targetPos, BackgroundColor3 = targetInd }):Play()
        TweenService:Create(btn, Theme.Tween.Toggle, { BackgroundColor3 = targetColor }):Play()
        callback(toggleState)
    end

    btn.MouseButton1Click:Connect(trigger)

    if bindable then
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton3 then
                local action = bindAction or trigger
                BindState.Target = { Label = bindLabel, Action = action }
                bindLabel.Text = "[...]"
                bindLabel.TextColor3 = Theme.Colors.TextBindPending
            end
        end)
    end

    return {
        Frame = frame,
        SetState = function(state)
            if state ~= toggleState then
                trigger()
            end
        end,
        GetState = function()
            return toggleState
        end,
    }
end

function Elements.Slider(parent, config)
    local labelText = config.Label    or "Slider"
    local min       = config.Min      or 0
    local max       = config.Max      or 100
    local default   = config.Default  or min
    local callback  = config.Callback or function() end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 270, 0, Theme.Sizes.SliderTotalH)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText .. ": " .. tostring(default)
    lbl.TextColor3 = Theme.Colors.TextMuted
    lbl.Font = Theme.Fonts.Medium
    lbl.TextSize = Theme.Sizes.SubSize
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, -10, 0, Theme.Sizes.SliderH)
    bar.Position = UDim2.new(0, 0, 0, 28)
    bar.BackgroundColor3 = Theme.Colors.SliderTrack
    bar.BorderSizePixel = 0
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.Parent = container
    Utils.applyCorner(bar, Theme.Sizes.CornerRound)

    local initPct = (default - min) / (max - min)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(initPct, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Colors.SliderFill
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Utils.applyCorner(fill, Theme.Sizes.CornerRound)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, Theme.Sizes.KnobSize, 0, Theme.Sizes.KnobSize)
    knob.Position = UDim2.new(initPct, -Theme.Sizes.KnobSize / 2, 0.5, -Theme.Sizes.KnobSize / 2)
    knob.BackgroundColor3 = Theme.Colors.SliderFill
    knob.BorderSizePixel = 0
    knob.Parent = bar
    Utils.applyCorner(knob, Theme.Sizes.CornerRound)

    local active = false

    local function processScale(input)
        local pct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -Theme.Sizes.KnobSize / 2, 0.5, -Theme.Sizes.KnobSize / 2)
        local value = min + (pct * (max - min))
        callback(value, lbl)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            active = true
            processScale(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if active and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            processScale(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            active = false
        end
    end)

    return { Frame = container }
end

function Elements.Dropdown(parent, config)
    local labelText = config.Label    or "Dropdown"
    local options   = config.Options  or {}
    local default   = config.Default  or (options[1] or "")
    local callback  = config.Callback or function() end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 270, 0, Theme.Sizes.DropdownH)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 20
    frame.Parent = parent

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, -10, 1, 0)
    mainBtn.BackgroundColor3 = Theme.Colors.ElementBg
    mainBtn.Text = labelText .. ": " .. tostring(default)
    mainBtn.TextColor3 = Theme.Colors.TextPrimary
    mainBtn.Font = Theme.Fonts.Medium
    mainBtn.TextSize = Theme.Sizes.ElementSize
    mainBtn.ZIndex = 21
    mainBtn.Parent = frame
    Utils.applyCorner(mainBtn, Theme.Sizes.CornerSmall)

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, 0, 0, Theme.Sizes.DropdownListH)
    listFrame.Position = UDim2.new(0, 0, 1, 4)
    listFrame.BackgroundColor3 = Theme.Colors.DropdownList
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 2
    listFrame.Visible = false
    listFrame.ZIndex = 22
    listFrame.Parent = mainBtn
    Utils.enableDragScroll(listFrame)

    local listLayout = Utils.applyListLayout(listFrame, 2)

    local function populate()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, opt in ipairs(options) do
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 26)
            pBtn.BackgroundColor3 = Theme.Colors.DropdownItem
            pBtn.Text = tostring(opt)
            pBtn.TextColor3 = Theme.Colors.TextMuted
            pBtn.Font = Theme.Fonts.Regular
            pBtn.TextSize = Theme.Sizes.SubSize
            pBtn.ZIndex = 23
            pBtn.Parent = listFrame
            pBtn.MouseButton1Click:Connect(function()
                mainBtn.Text = labelText .. ": " .. tostring(opt)
                listFrame.Visible = false
                callback(opt)
            end)
        end
        listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end

    mainBtn.MouseButton1Click:Connect(function()
        listFrame.Visible = not listFrame.Visible
        if listFrame.Visible then populate() end
    end)

    return { Frame = frame }
end

function Elements.PlayerDropdown(parent, config)
    local labelText    = config.Label      or "Select Target"
    local onSelect     = config.OnSelect   or function() end
    local onAutoSelect = config.OnAuto     or function() end
    local getRoleColor = config.GetRoleColor or function() return Color3.new(1, 1, 1) end
    local getRole      = config.GetRole     or function() return "?" end
    local localPlayer  = game:GetService("Players").LocalPlayer

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 270, 0, Theme.Sizes.DropdownH)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 10
    frame.Parent = parent

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, -10, 1, 0)
    mainBtn.BackgroundColor3 = Theme.Colors.ElementBg
    mainBtn.Text = labelText .. ": None"
    mainBtn.TextColor3 = Theme.Colors.TextPrimary
    mainBtn.Font = Theme.Fonts.Medium
    mainBtn.TextSize = Theme.Sizes.ElementSize
    mainBtn.ZIndex = 11
    mainBtn.Parent = frame
    Utils.applyCorner(mainBtn, Theme.Sizes.CornerSmall)

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -10, 0, 120)
    listFrame.Position = UDim2.new(0, 0, 1, 4)
    listFrame.BackgroundColor3 = Theme.Colors.DropdownList
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 2
    listFrame.Visible = false
    listFrame.ZIndex = 12
    listFrame.Parent = mainBtn
    Utils.enableDragScroll(listFrame)

    local listLayout = Utils.applyListLayout(listFrame, 2)

    local function refreshList()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local autoBtn = Instance.new("TextButton")
        autoBtn.Size = UDim2.new(1, 0, 0, 24)
        autoBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        autoBtn.Text = "Auto (Closest Target)"
        autoBtn.TextColor3 = Theme.Colors.TextPrimary
        autoBtn.Font = Theme.Fonts.Regular
        autoBtn.TextSize = 11
        autoBtn.ZIndex = 13
        autoBtn.Parent = listFrame
        autoBtn.MouseButton1Click:Connect(function()
            mainBtn.Text = labelText .. ": Auto"
            listFrame.Visible = false
            onAutoSelect()
        end)

        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= localPlayer then
                local role = getRole(p)
                local pBtn = Instance.new("TextButton")
                pBtn.Size = UDim2.new(1, 0, 0, 24)
                pBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
                pBtn.Text = string.format("%s: %s", p.Name, role)
                pBtn.TextColor3 = getRoleColor(p)
                pBtn.Font = Theme.Fonts.Regular
                pBtn.TextSize = 11
                pBtn.ZIndex = 13
                pBtn.Parent = listFrame
                pBtn.MouseButton1Click:Connect(function()
                    mainBtn.Text = labelText .. ": " .. p.Name
                    listFrame.Visible = false
                    onSelect(p)
                end)
            end
        end

        listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end

    mainBtn.MouseButton1Click:Connect(function()
        listFrame.Visible = not listFrame.Visible
        if listFrame.Visible then refreshList() end
    end)

    return { Frame = frame }
end

function Elements.Button(parent, config)
    local text      = config.Text     or "Button"
    local color     = config.Color    or Theme.Colors.ButtonPrimary
    local w         = config.Width    or 115
    local h         = config.Height   or 32
    local xOffset   = config.XOffset  or 0
    local callback  = config.Callback or function() end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, w, 0, h)
    btn.Position = UDim2.new(0, xOffset, 0, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Theme.Colors.TextPrimary
    btn.Font = Theme.Fonts.Bold
    btn.TextSize = 11
    btn.Parent = parent
    Utils.applyCorner(btn, UDim.new(0, 5))

    btn.MouseButton1Click:Connect(callback)

    return { Button = btn }
end

function Elements.Spacer(parent, height)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, height or 8)
    f.BackgroundTransparency = 1
    f.Parent = parent
    return f
end

function Elements.Label(parent, config)
    local text  = config.Text  or ""
    local color = config.Color or Theme.Colors.TextMuted
    local size  = config.Size  or Theme.Sizes.SubSize
    local font  = config.Font  or Theme.Fonts.Medium

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.Font = font
    lbl.TextSize = size
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent

    return { Label = lbl }
end

return Elements
