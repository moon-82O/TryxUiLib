local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")

local Theme    = loadstring(game:HttpGet("https://raw.githubusercontent.com/moon-82O/TryxUiLib/refs/heads/main/Theme.lua"))()
local Utils    = loadstring(game:HttpGet("https://raw.githubusercontent.com/moon-82O/TryxUiLib/refs/heads/main/Utils.lua"))()
local Elements = loadstring(game:HttpGet("https://raw.githubusercontent.com/moon-82O/TryxUiLib/refs/heads/main/Elements.lua"))()

local TryxUiLib = {}
TryxUiLib.__index = TryxUiLib

function TryxUiLib.new(config)
    local self = setmetatable({}, TryxUiLib)

    local title    = config.Title   or "TryxUiLib"
    local credits  = config.Credits or ""
    local tabs     = config.Tabs    or {}
    local W        = Theme.Sizes.WindowW
    local H        = Theme.Sizes.WindowH
    local topH     = Theme.Sizes.TopBarH
    local tabW     = Theme.Sizes.TabBarW

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TryxUiLib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local ok = pcall(function() ScreenGui.Parent = CoreGui end)
    if not ok then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, W, 0, H)
    MainFrame.Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2)
    MainFrame.BackgroundColor3 = Theme.Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    Utils.applyCorner(MainFrame, Theme.Sizes.CornerMain)
    Utils.applyStroke(MainFrame, Theme.Colors.Stroke, Theme.Sizes.StrokeMain)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, topH)
    TopBar.BackgroundColor3 = Theme.Colors.TopBar
    TopBar.BorderSizePixel = 0
    TopBar.Active = true
    TopBar.Parent = MainFrame
    Utils.applyCorner(TopBar, Theme.Sizes.CornerMain)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 250, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Colors.TextPrimary
    TitleLabel.Font = Theme.Fonts.Bold
    TitleLabel.TextSize = Theme.Sizes.TitleSize
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local CollapseBtn = Instance.new("TextButton")
    CollapseBtn.Size = UDim2.new(0, topH, 0, topH)
    CollapseBtn.Position = UDim2.new(1, -topH, 0, 0)
    CollapseBtn.BackgroundTransparency = 1
    CollapseBtn.Text = "-"
    CollapseBtn.TextColor3 = Theme.Colors.TextPrimary
    CollapseBtn.Font = Theme.Fonts.Bold
    CollapseBtn.TextSize = 18
    CollapseBtn.Parent = TopBar

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, tabW, 1, -topH)
    TabContainer.Position = UDim2.new(0, 0, 0, topH)
    TabContainer.BackgroundColor3 = Theme.Colors.TabBar
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    Utils.applyCorner(TabContainer, Theme.Sizes.CornerMain)

    if credits ~= "" then
        local CreditsLabel = Instance.new("TextLabel")
        CreditsLabel.Size = UDim2.new(1, 0, 0, 20)
        CreditsLabel.Position = UDim2.new(0, 15, 1, -25)
        CreditsLabel.BackgroundTransparency = 1
        CreditsLabel.Text = credits
        CreditsLabel.TextColor3 = Theme.Colors.Credits
        CreditsLabel.Font = Theme.Fonts.Medium
        CreditsLabel.TextSize = 11
        CreditsLabel.TextXAlignment = Enum.TextXAlignment.Left
        CreditsLabel.Parent = TabContainer
    end

    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -tabW, 1, -topH)
    PageContainer.Position = UDim2.new(0, tabW, 0, topH)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local collapsed = false
    CollapseBtn.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        if collapsed then
            MainFrame:TweenSize(UDim2.new(0, W, 0, topH), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            CollapseBtn.Text = "+"
        else
            MainFrame:TweenSize(UDim2.new(0, W, 0, H), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            CollapseBtn.Text = "-"
        end
    end)

    Utils.makeDraggable(TopBar, MainFrame)

    local tabButtons = {}
    local pages = {}
    local activeTab = nil
    local activePage = nil

    local function routeTab(tabBtn, page)
        for _, btn in ipairs(tabButtons) do
            btn.TextColor3 = Theme.Colors.TextTab
        end
        for _, pg in ipairs(pages) do
            pg.Visible = false
        end
        tabBtn.TextColor3 = Theme.Colors.TextTabActive
        page.Visible = true
        activeTab = tabBtn
        activePage = page
    end

    local function makeScrollPage()
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.Colors.Accent
        page.CanvasSize = UDim2.new(0, 0, 0, 1200)
        page.Visible = false
        page.ClipsDescendants = true
        page.Parent = PageContainer
        Utils.applyListLayout(page, 10)
        Utils.applyPadding(page, 15, 15)
        Utils.enableDragScroll(page)
        return page
    end

    for i, tabConfig in ipairs(tabs) do
        local tabName = tabConfig.Name or ("Tab" .. i)
        local yOffset = 10 + (i - 1) * Theme.Sizes.TabH

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, Theme.Sizes.TabH)
        tabBtn.Position = UDim2.new(0, 0, 0, yOffset)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Theme.Colors.TextTab
        tabBtn.Font = Theme.Fonts.Bold
        tabBtn.TextSize = Theme.Sizes.TabSize
        tabBtn.Parent = TabContainer

        local page = makeScrollPage()

        table.insert(tabButtons, tabBtn)
        table.insert(pages, page)

        tabBtn.MouseButton1Click:Connect(function()
            routeTab(tabBtn, page)
        end)

        if tabConfig.Build then
            tabConfig.Build(page, Elements)
        end

        if i == 1 then
            routeTab(tabBtn, page)
        end
    end

    self.ScreenGui   = ScreenGui
    self.MainFrame   = MainFrame
    self.Pages       = pages
    self.TabButtons  = tabButtons

    return self
end

function TryxUiLib:Show()
    self.MainFrame.Visible = true
end

function TryxUiLib:Hide()
    self.MainFrame.Visible = false
end

function TryxUiLib:Toggle()
    self.MainFrame.Visible = not self.MainFrame.Visible
end

function TryxUiLib:Destroy()
    self.ScreenGui:Destroy()
end

function TryxUiLib:LoadingScreen(config)
    local title   = config.Title    or "TryxUiLib"
    local sub     = config.Sub      or "loading..."
    local onDone  = config.OnDone   or function() end
    local ScreenGui = self.ScreenGui

    local LoadFrame = Instance.new("Frame")
    LoadFrame.Size = UDim2.new(0, 260, 0, 95)
    LoadFrame.Position = UDim2.new(0.5, -130, 0.5, -47)
    LoadFrame.BackgroundColor3 = Theme.Colors.Background
    LoadFrame.BorderSizePixel = 0
    LoadFrame.ZIndex = 500
    LoadFrame.BackgroundTransparency = 1
    LoadFrame.Parent = ScreenGui
    Utils.applyCorner(LoadFrame, Theme.Sizes.CornerSmall)

    local loadStroke = Utils.applyStroke(LoadFrame, Theme.Colors.TextPrimary, 1)
    loadStroke.Transparency = 1

    local loadTitle = Instance.new("TextLabel")
    loadTitle.Size = UDim2.new(1, 0, 0, 30)
    loadTitle.Position = UDim2.new(0, 0, 0, 18)
    loadTitle.BackgroundTransparency = 1
    loadTitle.Text = title
    loadTitle.TextColor3 = Theme.Colors.TextPrimary
    loadTitle.Font = Enum.Font.SourceSansBold
    loadTitle.TextSize = 20
    loadTitle.TextTransparency = 1
    loadTitle.Parent = LoadFrame

    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(1, 0, 0, 15)
    subText.Position = UDim2.new(0, 0, 0, 43)
    subText.BackgroundTransparency = 1
    subText.Text = sub
    subText.TextColor3 = Theme.Colors.TextMuted
    subText.Font = Enum.Font.SourceSans
    subText.TextSize = 13
    subText.TextTransparency = 1
    subText.Parent = LoadFrame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -40, 0, 3)
    track.Position = UDim2.new(0, 20, 1, -18)
    track.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    track.BorderSizePixel = 0
    track.BackgroundTransparency = 1
    track.Parent = LoadFrame
    Utils.applyCorner(track, Theme.Sizes.CornerRound)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Colors.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    Utils.applyCorner(fill, Theme.Sizes.CornerRound)

    TweenService:Create(LoadFrame, Theme.Tween.Fade, { BackgroundTransparency = 0.15 }):Play()
    TweenService:Create(loadStroke, Theme.Tween.Fade, { Transparency = 0.5 }):Play()
    TweenService:Create(loadTitle, Theme.Tween.Fade, { TextTransparency = 0 }):Play()
    TweenService:Create(subText, Theme.Tween.Fade, { TextTransparency = 0 }):Play()
    TweenService:Create(track, Theme.Tween.Fade, { BackgroundTransparency = 0 }):Play()
    task.wait(0.4)

    TweenService:Create(fill, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 1, 0) }):Play()
    task.wait(1.8)

    local fadeOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(LoadFrame, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(loadStroke, fadeOut, { Transparency = 1 }):Play()
    TweenService:Create(loadTitle, fadeOut, { TextTransparency = 1 }):Play()
    TweenService:Create(subText, fadeOut, { TextTransparency = 1 }):Play()
    TweenService:Create(track, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(fill, fadeOut, { BackgroundTransparency = 1 }):Play()
    task.wait(0.3)

    LoadFrame:Destroy()
    onDone()
end

function TryxUiLib:Notification(config)
    local message    = config.Message  or ""
    local avatarId   = config.AvatarId or nil
    local ScreenGui  = self.ScreenGui

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 390, 0, 90)
    NotifFrame.Position = UDim2.new(0.5, -195, 1, 30)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.ZIndex = 900
    NotifFrame.Parent = ScreenGui
    Utils.applyCorner(NotifFrame, Theme.Sizes.CornerSmall)
    Utils.applyStroke(NotifFrame, Theme.Colors.TextPrimary, 1)

    if avatarId then
        local avatarImg = Instance.new("ImageLabel")
        avatarImg.Size = UDim2.new(0, 70, 0, 70)
        avatarImg.Position = UDim2.new(0, 12, 0.5, -35)
        avatarImg.BackgroundTransparency = 1
        avatarImg.ZIndex = 950
        avatarImg.Parent = NotifFrame
        Utils.applyCorner(avatarImg, Theme.Sizes.CornerRound)
        pcall(function()
            local content = game:GetService("Players"):GetUserThumbnailAsync(
                avatarId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
            avatarImg.Image = content
        end)
    end

    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -100, 1, -14)
    notifText.Position = UDim2.new(0, avatarId and 92 or 12, 0, 7)
    notifText.BackgroundTransparency = 1
    notifText.Text = ""
    notifText.TextColor3 = Theme.Colors.TextPrimary
    notifText.Font = Enum.Font.SourceSansBold
    notifText.TextSize = 14
    notifText.TextWrapped = true
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.TextYAlignment = Enum.TextYAlignment.Center
    notifText.ZIndex = 950
    notifText.Parent = NotifFrame

    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -195, 1, -120)
    }):Play()

    task.wait(0.6)
    for i = 1, #message do
        notifText.Text = string.sub(message, 1, i)
        task.wait(0.035)
    end

    task.wait(4.5)
    TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -195, 1, 30)
    }):Play()
    task.wait(0.4)
    NotifFrame:Destroy()
end

function TryxUiLib:ScreenButton(config)
    local name      = config.Name     or "Btn"
    local text      = config.Text     or "Button"
    local callback  = config.Callback or function() end
    local ScreenGui = self.ScreenGui

    if not self._screenBtnFrame then
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 130, 0, 200)
        f.Position = UDim2.new(1, -150, 0.6, 0)
        f.BackgroundTransparency = 1
        f.ZIndex = 1000
        f.Parent = ScreenGui
        Utils.applyListLayout(f, 8)
        self._screenBtnFrame = f
    end

    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(22, 22, 29)
    b.Text = text
    b.TextColor3 = Theme.Colors.TextPrimary
    b.Font = Theme.Fonts.Bold
    b.TextSize = 11
    b.Visible = false
    b.ZIndex = 1001
    b.Parent = self._screenBtnFrame
    Utils.applyCorner(b, Theme.Sizes.CornerSmall)
    Utils.applyStroke(b, Theme.Colors.Accent, Theme.Sizes.StrokeMain)

    b.MouseButton1Click:Connect(callback)

    return {
        Button = b,
        Show = function() b.Visible = true end,
        Hide = function() b.Visible = false end,
    }
end

return TryxUiLib
