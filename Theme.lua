local Theme = {}

Theme.Colors = {
    Background     = Color3.fromRGB(15, 15, 19),
    TopBar         = Color3.fromRGB(22, 22, 29),
    TabBar         = Color3.fromRGB(11, 11, 15),
    ElementBg      = Color3.fromRGB(26, 26, 33),
    ToggleBg       = Color3.fromRGB(45, 45, 52),
    ToggleActive   = Color3.fromRGB(90, 90, 255),
    SliderTrack    = Color3.fromRGB(35, 35, 42),
    SliderFill     = Color3.fromRGB(255, 255, 255),
    Accent         = Color3.fromRGB(90, 90, 255),
    TextPrimary    = Color3.fromRGB(255, 255, 255),
    TextSecondary  = Color3.fromRGB(220, 220, 225),
    TextMuted      = Color3.fromRGB(150, 150, 160),
    TextTab        = Color3.fromRGB(150, 150, 160),
    TextTabActive  = Color3.fromRGB(90, 90, 255),
    TextBind       = Color3.fromRGB(100, 100, 110),
    TextBindActive = Color3.fromRGB(130, 160, 240),
    TextBindPending = Color3.fromRGB(240, 190, 50),
    DropdownList   = Color3.fromRGB(18, 18, 23),
    DropdownItem   = Color3.fromRGB(24, 24, 30),
    ButtonPrimary  = Color3.fromRGB(90, 90, 255),
    ButtonSecondary = Color3.fromRGB(180, 50, 180),
    Stroke         = Color3.fromRGB(90, 90, 255),
    Credits        = Color3.fromRGB(110, 110, 130),
    Indicator      = Color3.fromRGB(150, 150, 160),
    IndicatorActive = Color3.fromRGB(255, 255, 255),
}

Theme.Fonts = {
    Bold    = Enum.Font.GothamBold,
    Medium  = Enum.Font.GothamMedium,
    Regular = Enum.Font.Gotham,
}

Theme.Sizes = {
    CornerMain    = UDim.new(0, 10),
    CornerSmall   = UDim.new(0, 6),
    CornerRound   = UDim.new(1, 0),
    StrokeMain    = 1.5,
    StrokeAccent  = 1.5,
    TitleSize     = 16,
    TabSize       = 12,
    ElementSize   = 13,
    SubSize       = 12,
    BindSize      = 10,
    WindowW       = 420,
    WindowH       = 310,
    TopBarH       = 50,
    TabBarW       = 110,
    TabH          = 42,
    ToggleW       = 46,
    ToggleH       = 24,
    IndicatorSize = 18,
    SliderH       = 6,
    KnobSize      = 12,
    ElementH      = 35,
    SliderTotalH  = 52,
    DropdownH     = 40,
    DropdownListH = 110,
}

Theme.Tween = {
    Toggle   = TweenInfo.new(0.2, Enum.EasingStyle.Quad),
    Collapse = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Fade     = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}

return Theme
