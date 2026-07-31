# TryxUiLib

UI Library modulaire pour Roblox, style dark/modern.

## Structure

```
TryxUiLib/
├── Theme.lua      → couleurs, polices, tailles, tweens
├── Utils.lua      → fonctions partagées (corner, stroke, drag, scroll...)
├── Elements.lua   → tous les éléments UI (Toggle, Slider, Dropdown, Button...)
├── Main.lua       → moteur principal (fenêtre, tabs, pages, loading, notif)
└── Example.lua    → exemple d'utilisation complet
```

## Usage rapide

```lua
local BASE = "https://raw.githubusercontent.com/VOTRE_USER/TryxUiLib/main/"
local TryxUiLib = loadstring(game:HttpGet(BASE .. "Main.lua"))()

local window = TryxUiLib.new({
    Title   = "Mon Script",
    Credits = "by moi",
    Tabs    = {
        {
            Name  = "Combat",
            Build = function(page, E)
                E.Toggle(page, {
                    Label    = "Silent Aim",
                    Callback = function(state)
                        print("Silent Aim:", state)
                    end,
                })
                E.Slider(page, {
                    Label    = "FOV",
                    Min      = 10,
                    Max      = 500,
                    Default  = 150,
                    Callback = function(val, lbl)
                        lbl.Text = "FOV: " .. math.round(val)
                    end,
                })
            end,
        },
    },
})

window:Show()
```

## Éléments disponibles

### `E.Toggle(page, config)`
| Clé | Type | Description |
|---|---|---|
| `Label` | string | Texte affiché |
| `Callback` | function(bool) | Appelée au clic |
| `Bindable` | bool | Active le keybind (défaut: true) |
| `BindAction` | function | Action du bind (défaut: toggle lui-même) |

### `E.Slider(page, config)`
| Clé | Type | Description |
|---|---|---|
| `Label` | string | Texte affiché |
| `Min` | number | Valeur minimale |
| `Max` | number | Valeur maximale |
| `Default` | number | Valeur initiale |
| `Callback` | function(val, label) | Appelée au glissement |

### `E.Dropdown(page, config)`
| Clé | Type | Description |
|---|---|---|
| `Label` | string | Texte affiché |
| `Options` | table | Liste des options |
| `Default` | string | Option par défaut |
| `Callback` | function(opt) | Appelée à la sélection |

### `E.PlayerDropdown(page, config)`
| Clé | Type | Description |
|---|---|---|
| `Label` | string | Texte affiché |
| `OnSelect` | function(player) | Joueur sélectionné |
| `OnAuto` | function() | Mode auto sélectionné |
| `GetRole` | function(player) → string | Optionnel: retourne le rôle |
| `GetRoleColor` | function(player) → Color3 | Optionnel: couleur du rôle |

### `E.Button(page, config)`
| Clé | Type | Description |
|---|---|---|
| `Text` | string | Texte du bouton |
| `Color` | Color3 | Couleur de fond |
| `Width` | number | Largeur (défaut: 115) |
| `Height` | number | Hauteur (défaut: 32) |
| `XOffset` | number | Décalage horizontal |
| `Callback` | function() | Appelée au clic |

### `E.Spacer(page, height)`
Ajoute un espace vide entre éléments.

### `E.Label(page, config)`
| Clé | Type | Description |
|---|---|---|
| `Text` | string | Texte affiché |
| `Color` | Color3 | Couleur du texte |
| `Size` | number | Taille de police |

## Méthodes de la fenêtre

```lua
window:Show()
window:Hide()
window:Toggle()
window:Destroy()

window:LoadingScreen({ Title, Sub, OnDone })
window:Notification({ Message, AvatarId })
window:ScreenButton({ Name, Text, Callback })
```

## Modifier le thème

Tout passe par `Theme.lua`. Change une couleur → ça s'applique partout automatiquement.

```lua
-- Exemple: changer la couleur accent
Theme.Colors.Accent       = Color3.fromRGB(255, 100, 0)
Theme.Colors.Stroke       = Color3.fromRGB(255, 100, 0)
Theme.Colors.ToggleActive = Color3.fromRGB(255, 100, 0)
```

## Ajouter un nouvel élément

1. Ouvre `Elements.lua`
2. Ajoute une fonction `Elements.MonElement(parent, config)`
3. Elle reçoit automatiquement `Theme`, `Utils` et peut créer n'importe quel `Instance`
4. Retourne une table avec les refs utiles

```lua
function Elements.MonElement(parent, config)
    local frame = Instance.new("Frame")
    -- ... ta logique ...
    frame.Parent = parent
    return { Frame = frame }
end
```

## GitHub

Remplace `VOTRE_USER` par ton username GitHub dans tous les fichiers.
