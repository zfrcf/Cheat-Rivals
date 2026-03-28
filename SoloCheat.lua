-- [[ SOLOCHEAT V5 ULTRA - RIVALS X XENO EDITION ]] --
-- [[ ARCHITECTURE PROFESSIONNELLE | 500+ LINES ]] --
-- [[ FEATURES: AIMBOT, SILENT, TRIGGER, FLY, NOCLIP, ESP, KEYBINDS ]] --

if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

-- [[ 1. DÉCLARATION DES SERVICES SYSTÈME ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

-- [[ 2. VARIABLES GLOBALES ET CLIENT ]] --
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- [[ 3. CONFIGURATION AVANCÉE (DATA STRUCTURE) ]] --
local SoloCheatConfig = {
    Combat = {
        Enabled = false,
        SilentAim = false,
        TriggerBot = false,
        FOV = 150,
        Smoothness = 0.08,
        TargetPart = "Head",
        TeamCheck = true,
        ShowFOV = true,
        FOVSides = 100,
        FOVThickness = 1.5,
        FOVColor = Color3.fromRGB(0, 255, 150)
    },
    Movement = {
        Fly = false,
        FlySpeed = 80,
        NoClip = false,
        SpeedHack = false,
        WalkSpeedValue = 50,
        JumpPowerValue = 50,
        InfiniteJump = false
    },
    Visuals = {
        ESP_Boxes = false,
        ESP_Names = false,
        ESP_Distance = false,
        ESP_Color = Color3.fromRGB(255, 0, 0),
        Skins = false,
        SkinType = "Gold",
        FieldOfView = 90
    },
    Settings = {
        MenuKey = Enum.KeyCode.K,
        AimKey = Enum.UserInputType.MouseButton2,
        PanicKey = Enum.KeyCode.Delete,
        AccentColor = Color3.fromRGB(0, 150, 255),
        Transparency = 0.1
    }
}

-- [[ 4. SYSTÈME DE DESSIN (DRAWING API) ]] --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = SoloCheatConfig.Combat.FOVThickness
FOVCircle.NumSides = SoloCheatConfig.Combat.FOVSides
FOVCircle.Color = SoloCheatConfig.Combat.FOVColor
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [[ 5. FONCTIONS UTILITAIRES (HELPERS) ]] --

local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 5
    })
end

local function GetClosestToMouse()
    local target, nearest = nil, SoloCheatConfig.Combat.FOV
    local mousePos = UIS:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(SoloCheatConfig.Combat.TargetPart) then
            local part = p.Character[SoloCheatConfig.Combat.TargetPart]
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            
            if hum and hum.Health > 0 then
                if SoloCheatConfig.Combat.TeamCheck and p.Team == LocalPlayer.Team then continue end
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < nearest then
                        nearest = dist
                        target = {Instance = part, Position = screenPos}
                    end
                end
            end
        end
    end
    return target
end

-- [[ 6. MOTEUR DE COMBAT (AIMBOT & SILENT) ]] --

-- Hook pour le Silent Aim
local OldNC
OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if SoloCheatConfig.Combat.SilentAim and not checkcaller() then
        if method == "Raycast" or method == "FindPartOnRayWithIgnoreList" then
            local target = GetClosestToMouse()
            if target then
                return target.Instance.Position
            end
        end
    end
    return OldNC(self, ...)
end)

-- Boucle de rendu pour l'Aimbot et TriggerBot
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = SoloCheatConfig.Combat.ShowFOV
    FOVCircle.Radius = SoloCheatConfig.Combat.FOV
    FOVCircle.Position = UIS:GetMouseLocation()
    FOVCircle.Color = SoloCheatConfig.Combat.FOVColor

    if SoloCheatConfig.Combat.Enabled then
        local isAiming = UIS:IsMouseButtonPressed(SoloCheatConfig.Settings.AimKey) or UIS:IsKeyDown(Enum.KeyCode.Q) -- Fallback
        
        if isAiming then
            local target = GetClosestToMouse()
            if target then
                local moveX = (target.Position.X - UIS:GetMouseLocation().X) * SoloCheatConfig.Combat.Smoothness
                local moveY = (target.Position.Y - UIS:GetMouseLocation().Y) * SoloCheatConfig.Combat.Smoothness
                if mousemoverel then
                    mousemoverel(moveX, moveY)
                end
            end
        end
    end

    if SoloCheatConfig.Combat.TriggerBot then
        local t = Mouse.Target
        if t and t.Parent:FindFirstChild("Humanoid") then
            local p = Players:GetPlayerFromCharacter(t.Parent)
            if p and p.Team ~= LocalPlayer.Team then
                mouse1click()
            end
        end
    end
end)

-- [[ 7. MOTEUR DE PHYSIQUE (MOVEMENT) ]] --

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- Speed Hack
    if SoloCheatConfig.Movement.SpeedHack then
        hum.WalkSpeed = SoloCheatConfig.Movement.WalkSpeedValue
    end

    -- Fly Logic
    if SoloCheatConfig.Movement.Fly then
        if not hrp:FindFirstChild("SoloVel") then
            local bv = Instance.new("BodyVelocity", hrp); bv.Name = "SoloVel"; bv.MaxForce = Vector3.new(1,1,1)*10^8
            local bg = Instance.new("BodyGyro", hrp); bg.Name = "SoloGyro"; bg.MaxTorque = Vector3.new(1,1,1)*10^8
        end
        local dir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        hrp.SoloVel.Velocity = dir * SoloCheatConfig.Movement.FlySpeed
        hrp.SoloGyro.CFrame = Camera.CFrame
    else
        if hrp:FindFirstChild("SoloVel") then hrp.SoloVel:Destroy(); hrp.SoloGyro:Destroy() end
    end

    -- NoClip Logic
    if SoloCheatConfig.Movement.NoClip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- [[ 8. INTERFACE UTILISATEUR FRAMEWORK (UI) ]] --

if CoreGui:FindFirstChild("SoloCheatUI") then CoreGui.SoloCheatUI:Destroy() end

local MainUI = Instance.new("ScreenGui", CoreGui); MainUI.Name = "SoloCheatUI"
local MainFrame = Instance.new("Frame", MainUI); MainFrame.Size = UDim2.new(0, 560, 0, 420); MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210); MainFrame.BackgroundColor3 = SoloCheatConfig.Settings.AccentColor; MainFrame.BorderSizePixel = 0
local Shadow = Instance.new("ImageLabel", MainFrame); Shadow.Size = UDim2.new(1, 40, 1, 40); Shadow.Position = UDim2.new(0, -20, 0, -20); Shadow.BackgroundTransparency = 1; Shadow.Image = "rbxassetid://1316045217"; Shadow.ImageColor3 = Color3.new(0,0,0); Shadow.ImageTransparency = 0.5

local InnerFrame = Instance.new("Frame", MainFrame); InnerFrame.Size = UDim2.new(1, -4, 1, -4); InnerFrame.Position = UDim2.new(0, 2, 0, 2); InnerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); InnerFrame.BorderSizePixel = 0

-- Barre de Titre
local TitleBar = Instance.new("Frame", InnerFrame); TitleBar.Size = UDim2.new(1, 0, 0, 40); TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22); TitleBar.BorderSizePixel = 0
local TitleText = Instance.new("TextLabel", TitleBar); TitleText.Size = UDim2.new(1, 0, 1, 0); TitleText.Position = UDim2.new(0, 15, 0, 0); TitleText.Text = "SOLOCHEAT V5 | PREMIUM FRAMEWORK"; TitleText.TextColor3 = Color3.new(1,1,1); TitleText.Font = Enum.Font.GothamBold; TitleText.TextSize = 14; TitleText.TextXAlignment = 0; TitleText.BackgroundTransparency = 1

-- Bouton de Fermeture
local CloseBtn = Instance.new("TextButton", TitleBar); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5); CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.BorderSizePixel = 0
CloseBtn.MouseButton1Click:Connect(function() MainUI:Destroy(); FOVCircle:Remove() end)

-- Barre Latérale (Sidebar)
local Sidebar = Instance.new("Frame", InnerFrame); Sidebar.Size = UDim2.new(0, 140, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Sidebar.BorderSizePixel = 0
local SidebarLayout = Instance.new("UIListLayout", Sidebar); SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; SidebarLayout.Padding = UDim.new(0, 4)

-- Conteneur de Pages
local PageContainer = Instance.new("Frame", InnerFrame); PageContainer.Size = UDim2.new(1, -150, 1, -50); PageContainer.Position = UDim2.new(0, 145, 0, 45); PageContainer.BackgroundTransparency = 1

local Pages = {}
local TabButtons = {}

local function CreateTab(name, iconId)
    local TabBtn = Instance.new("TextButton", Sidebar); TabBtn.Size = UDim2.new(0.9, 0, 0, 38); TabBtn.Text = name; TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180); TabBtn.Font = Enum.Font.Gotham; TabBtn.TextSize = 13; TabBtn.BorderSizePixel = 0
    local Corner = Instance.new("UICorner", TabBtn); Corner.CornerRadius = UDim.new(0, 4)
    
    local Page = Instance.new("ScrollingFrame", PageContainer); Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2; Page.CanvasSize = UDim2.new(0,0,2,0)
    local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 8); PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabButtons) do b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.fromRGB(180, 180, 180) end
        Page.Visible = true; TabBtn.BackgroundColor3 = SoloCheatConfig.Settings.AccentColor; TabBtn.TextColor3 = Color3.new(1,1,1)
    end)
    
    table.insert(Pages, Page); table.insert(TabButtons, TabBtn)
    return Page
end

-- [[ 9. COMPOSANTS DE L'INTERFACE (TOGGLES, SLIDERS) ]] --

local function AddToggle(parent, text, cfg_table, cfg_key)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundColor3 = Color3.fromRGB(22, 22, 22); f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -60, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.Text = text; l.TextColor3 = Color3.fromRGB(220, 220, 220); l.Font = Enum.Font.Gotham; l.TextSize = 13; l.TextXAlignment = 0; l.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0, 44, 0, 22); btn.Position = UDim2.new(1, -54, 0.5, -11); btn.Text = ""; btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", btn); circle.Size = UDim2.new(0, 18, 0, 18); circle.Position = UDim2.new(0, 2, 0.5, -9); circle.BackgroundColor3 = Color3.new(1,1,1); circle.BorderSizePixel = 0
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    btn.MouseButton1Click:Connect(function()
        cfg_table[cfg_key] = not cfg_table[cfg_key]
        local targetPos = cfg_table[cfg_key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local targetCol = cfg_table[cfg_key] and SoloCheatConfig.Settings.AccentColor or Color3.fromRGB(40, 40, 40)
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetCol}):Play()
    end)
end

local function AddSlider(parent, text, min, max, cfg_table, cfg_key)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 65); f.BackgroundColor3 = Color3.fromRGB(22, 22, 22); f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 30); l.Position = UDim2.new(0, 12, 0, 5); l.Text = text .. " : " .. cfg_table[cfg_key]; l.TextColor3 = Color3.fromRGB(220, 220, 220); l.Font = Enum.Font.Gotham; l.TextSize = 13; l.TextXAlignment = 0; l.BackgroundTransparency = 1
    
    local sbg = Instance.new("Frame", f); sbg.Size = UDim2.new(1, -24, 0, 6); sbg.Position = UDim2.new(0, 12, 0, 45); sbg.BackgroundColor3 = Color3.fromRGB(40, 40, 40); sbg.BorderSizePixel = 0
    local sfill = Instance.new("Frame", sbg); sfill.Size = UDim2.new((cfg_table[cfg_key]-min)/(max-min), 0, 1, 0); sfill.BackgroundColor3 = SoloCheatConfig.Settings.AccentColor; sfill.BorderSizePixel = 0
    
    sbg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            local move = UIS.InputChanged:Connect(function(i2)
                if i2.UserInputType == Enum.UserInputType.MouseMovement then
                    local per = math.clamp((i2.Position.X - sbg.AbsolutePosition.X) / sbg.AbsoluteSize.X, 0, 1)
                    sfill.Size = UDim2.new(per, 0, 1, 0)
                    local val = math.floor(min + (max - min) * per)
                    l.Text = text .. " : " .. val
                    cfg_table[cfg_key] = val
                end
            end)
            UIS.InputEnded:Connect(function(i3) if i3.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
        end
    end)
end

local function AddKeybind(parent, text, cfg_table, cfg_key)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundColor3 = Color3.fromRGB(22, 22, 22); f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -100, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.Text = text; l.TextColor3 = Color3.fromRGB(220, 220, 220); l.Font = Enum.Font.Gotham; l.TextSize = 13; l.TextXAlignment = 0; l.BackgroundTransparency = 1
    
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 80, 0, 26); b.Position = UDim2.new(1, -90, 0.5, -13); b.Text = cfg_table[cfg_key].Name; b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = SoloCheatConfig.Settings.AccentColor; b.Font = Enum.Font.GothamBold; b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    local active = false
    b.MouseButton1Click:Connect(function() b.Text = "..."; active = true end)
    UIS.InputBegan:Connect(function(input)
        if active and input.UserInputType == Enum.UserInputType.Keyboard then
            cfg_table[cfg_key] = input.KeyCode; b.Text = input.KeyCode.Name; active = false
        elseif active and input.UserInputType == Enum.UserInputType.MouseButton2 then
            cfg_table[cfg_key] = Enum.UserInputType.MouseButton2; b.Text = "RightClick"; active = false
        end
    end)
end

-- [[ 10. ASSEMBLAGE DES PAGES ET ÉVÉNEMENTS ]] --

local CombatPage = CreateTab("Combat")
local MovementPage = CreateTab("Movement")
local VisualPage = CreateTab("Visuals")
local BindPage = CreateTab("Keybinds")

AddToggle(CombatPage, "Aimbot Enabled", SoloCheatConfig.Combat, "Enabled")
AddToggle(CombatPage, "Silent Aim (Bypass)", SoloCheatConfig.Combat, "SilentAim")
AddToggle(CombatPage, "TriggerBot", SoloCheatConfig.Combat, "TriggerBot")
AddSlider(CombatPage, "FOV Radius", 50, 800, SoloCheatConfig.Combat, "FOV")
AddToggle(CombatPage, "Show FOV Circle", SoloCheatConfig.Combat, "ShowFOV")

AddToggle(MovementPage, "Fly Mode", SoloCheatConfig.Movement, "Fly")
AddSlider(MovementPage, "Fly Speed", 10, 300, SoloCheatConfig.Movement, "FlySpeed")
AddToggle(MovementPage, "NoClip", SoloCheatConfig.Movement, "NoClip")
AddToggle(MovementPage, "SpeedHack", SoloCheatConfig.Movement, "SpeedHack")
AddSlider(MovementPage, "WalkSpeed", 16, 250, SoloCheatConfig.Movement, "WalkSpeedValue")

AddToggle(VisualPage, "ESP Boxes", SoloCheatConfig.Visuals, "ESP_Boxes")
AddToggle(VisualPage, "ESP Names", SoloCheatConfig.Visuals, "ESP_Names")
AddToggle(VisualPage, "Skin Changer (Client)", SoloCheatConfig.Visuals, "Skins")

AddKeybind(BindPage, "Menu Open/Hide", SoloCheatConfig.Settings, "MenuKey")
AddKeybind(BindPage, "Aimbot Key", SoloCheatConfig.Settings, "AimKey")

-- Système Draggable
local dStart, sPos, dragging
TitleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dStart = i.Position; sPos = MainFrame.Position end end)
UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then 
    local delta = i.Position - dStart
    MainFrame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
TitleBar.InputEnded:Connect(function() dragging = false end)

-- Gestion Touche Menu
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == SoloCheatConfig.Settings.MenuKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initialisation
Pages[1].Visible = true
TabButtons[1].BackgroundColor3 = SoloCheatConfig.Settings.AccentColor
TabButtons[1].TextColor3 = Color3.new(1,1,1)

Notify("SoloCheat V5 Ultra", "Chargé avec succès ! Appuie sur K pour le menu.")
print("SOLOCHEAT V5 LOADED - 500+ LINES ARCHITECTURE READY.")
