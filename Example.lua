local BASE = "https://raw.githubusercontent.com/moon-82O/TryxUiLib/refs/heads/main/Main.lua"

local TryxUiLib = loadstring(game:HttpGet(BASE .. "Main.lua"))()

local Settings = {
    speedEnabled  = false,
    walkSpeed     = 16,
    flyEnabled    = false,
    flySpeed      = 50,
    aimbotEnabled = false,
    fov           = 150,
    chamEnabled   = false,
    targetPart    = "Head",
    noclip        = false,
}

local window = TryxUiLib.new({
    Title   = "TryxUiLib",
    Credits = "by TryxUiLib",
    Tabs    = {
        {
            Name  = "Movement",
            Build = function(page, E)
                E.Toggle(page, {
                    Label    = "Speed Hack",
                    Callback = function(state)
                        Settings.speedEnabled = state
                        if not state then
                            local hum = game.Players.LocalPlayer.Character and
                                        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if hum then hum.WalkSpeed = 16 end
                        end
                    end,
                })

                E.Slider(page, {
                    Label    = "Walk Speed",
                    Min      = 16,
                    Max      = 120,
                    Default  = 16,
                    Callback = function(val, lbl)
                        Settings.walkSpeed = math.round(val)
                        lbl.Text = "Walk Speed: " .. tostring(Settings.walkSpeed)
                    end,
                })

                E.Spacer(page, 4)

                E.Toggle(page, {
                    Label    = "Fly Hack",
                    Callback = function(state)
                        Settings.flyEnabled = state
                    end,
                })

                E.Slider(page, {
                    Label    = "Fly Speed",
                    Min      = 10,
                    Max      = 150,
                    Default  = 50,
                    Callback = function(val, lbl)
                        Settings.flySpeed = math.round(val)
                        lbl.Text = "Fly Speed: " .. tostring(Settings.flySpeed)
                    end,
                })

                E.Spacer(page, 4)

                E.Toggle(page, {
                    Label    = "Noclip",
                    Callback = function(state)
                        Settings.noclip = state
                    end,
                })
            end,
        },

        {
            Name  = "Combat",
            Build = function(page, E)
                E.Toggle(page, {
                    Label    = "Aimbot",
                    Callback = function(state)
                        Settings.aimbotEnabled = state
                    end,
                })

                E.Slider(page, {
                    Label    = "FOV",
                    Min      = 10,
                    Max      = 600,
                    Default  = 150,
                    Callback = function(val, lbl)
                        Settings.fov = math.round(val)
                        lbl.Text = "FOV: " .. tostring(Settings.fov)
                    end,
                })

                E.Spacer(page, 4)

                E.Dropdown(page, {
                    Label    = "Aim Part",
                    Options  = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
                    Default  = "Head",
                    Callback = function(opt)
                        Settings.targetPart = opt
                    end,
                })
            end,
        },

        {
            Name  = "Visuals",
            Build = function(page, E)
                E.Toggle(page, {
                    Label    = "Chams",
                    Callback = function(state)
                        Settings.chamEnabled = state
                    end,
                })

                E.Dropdown(page, {
                    Label    = "Tracer Origin",
                    Options  = { "Bottom", "Center" },
                    Default  = "Bottom",
                    Callback = function(opt)
                        print("Tracer origin:", opt)
                    end,
                })
            end,
        },

        {
            Name  = "Misc",
            Build = function(page, E)
                E.PlayerDropdown(page, {
                    Label    = "Select Target",
                    OnSelect = function(player)
                        print("Target selected:", player.Name)
                    end,
                    OnAuto   = function()
                        print("Auto target enabled")
                    end,
                })

                E.Spacer(page, 4)

                E.Button(page, {
                    Text     = "Kill Target",
                    Color    = Color3.fromRGB(90, 90, 255),
                    Callback = function()
                        print("Kill target clicked")
                    end,
                })

                E.Button(page, {
                    Text     = "Kill All",
                    Color    = Color3.fromRGB(180, 50, 180),
                    XOffset  = 125,
                    Callback = function()
                        print("Kill all clicked")
                    end,
                })
            end,
        },
    },
})

task.spawn(function()
    window:LoadingScreen({
        Title  = "TryxUiLib",
        Sub    = "loading resources...",
        OnDone = function()
            window:Show()
            task.spawn(function()
                window:Notification({
                    Message  = "TryxUiLib loaded successfully!",
                })
            end)
        end,
    })
end)
