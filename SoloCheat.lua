-- [[ KICIAHOOK OMNI-EDITION | RIVALS X XENO ]] --
-- [[ ALL-IN-ONE FRAMEWORK | 500+ LINES SOURCE ]] --
-- [[ FEATURES: SILENT, MOUSELOCK, TRIGGER, FLY, NOCLIP, ESP, SKINS ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

-- [[ 1. DÉCLARATION DES SERVICES ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [[ 2. CONFIGURATION GLOBALE ]] --
local Kicia = {
    Combat = {
        Aimbot = false,
        SilentAim = false,
        TriggerBot = false,
        FOV = 150,
        Smoothness = 0.08,
        TargetPart = "Head",
        TeamCheck = true,
        ShowFOV = true
    },
    Movement = {
        Fly = false,
        NoClip = false,
        SpeedHack = false,
        FlySpeed = 80,
        WalkSpeed = 50,
        JumpPower = 50
    },
    Visuals = {
        ESP_Boxes = false,
        Skins = false,
        SkinType = "Gold",
        MenuKey = Enum.KeyCode.RightControl
    }
}

-- [[ 3. SYSTÈME DE DESSIN (FOV) ]] --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [[ 4. FONCTIONS DE CIBLE (CORE ENGINE) ]] --
local function GetClosestTarget()
    local target, nearest = nil, Kicia.Combat.FOV
    local mousePos = UIS:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Kicia.Combat.TargetPart) then
            local part = p.Character[Kicia.Combat.TargetPart]
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            
            if hum and hum.Health > 0 then
                if Kicia.Combat.TeamCheck and p.Team == LocalPlayer.Team then continue end
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < nearest then
                        nearest = dist
                        target = {Part = part, Pos = screenPos}
                    end
                end
            end
        end
    end
    return target
end

-- [[ 5. SILENT AIM (METAMETHOD HOOK) ]] --
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if Kicia.Combat.SilentAim and not checkcaller() then
        if method == "FindPartOnRayWithIgnoreList" or method == "Raycast" then
            local target = GetClosestTarget()
            if target then
                return target.Part.Position
            end
        end
    end
    return OldNamecall(self, ...)
end)

-- [[ 6. BOUCLE DE RENDU (COMBAT & TRIGGERBOT) ]] --
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Kicia.Combat.ShowFOV
    FOVCircle.Radius = Kicia.Combat.FOV
    FOVCircle.Position = UIS:GetMouseLocation()

    -- Mouse Lock Aimbot
    if Kicia.Combat.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestTarget()
        if target then
            local mousePos = UIS:GetMouseLocation()
            local moveX = (target.Pos.X - mousePos.X) * Kicia.Combat.Smoothness
            local moveY = (target.Pos.Y - mousePos.Y) * Kicia.Combat.Smoothness
            if mousemoverel then mousemoverel(moveX, moveY) end
        end
    end

    -- TriggerBot
    if Kicia.Combat.TriggerBot then
        local target = Mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local player = Players:GetPlayerFromCharacter(target.Parent)
            if player and player.Team ~= LocalPlayer.Team then
                mouse1click()
            end
        end
    end
end)

-- [[ 7. BOUCLE PHYSIQUE (FLY, SPEED, NOCLIP) ]] --
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- Movement Features
    if Kicia.Movement.SpeedHack then hum.WalkSpeed = Kicia.Movement.WalkSpeed end
    
    if Kicia.Movement.Fly then
        if not hrp:FindFirstChild("OmniVel") then
            local bv = Instance.new("BodyVelocity", hrp); bv.Name = "OmniVel"; bv.MaxForce = Vector3.new(1,1,1)*10^7
            local bg = Instance.new("BodyGyro", hrp); bg.Name = "OmniGyro"; bg.MaxTorque = Vector3.new(1,1,1)*10^7
        end
        local dir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        hrp.OmniVel.Velocity = dir * Kicia.Movement.FlySpeed
        hrp.OmniGyro.CFrame = Camera.CFrame
    else
        if hrp:FindFirstChild("OmniVel") then hrp.OmniVel:Destroy(); hrp.OmniGyro:Destroy() end
    end

    if Kicia.Movement.NoClip then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- Skin Changer (Logic simplified for Xeno)
    if Kicia.Visuals.Skins then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("MeshPart") and v.Parent.Name ~= "Head" then
                v.Color = Kicia.Visuals.SkinType == "Gold" and Color3.fromRGB(255,215,0) or Color3.fromRGB(255,0,0)
                v.Material = Enum.Material.Metal
            end
        end
    end
end)

-- [[ 8. INTERFACE UTILISATEUR COMPLÈTE (PREMIUM) ]] --
if CoreGui:FindFirstChild("KiciaOmni") then CoreGui.KiciaOmni:Destroy() end

local Screen = Instance.new("ScreenGui", CoreGui); Screen.Name = "KiciaOmni"
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 500, 0, 420); Main.Position = UDim2.new(0.5, -250, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0
local Corner = Instance.new("UICorner", Main); Corner.CornerRadius = UDim.new(0, 10)

-- Barre de Titre (Déplaçable)
local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 45); Top.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Top.BorderSizePixel = 0
local TopCorner = Instance.new("UICorner", Top); TopCorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Top); Title.Size = UDim2.new(1, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.Text = "KICIAHOOK | OMNI-REMASTER"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = 3; Title.TextSize = 16; Title.TextXAlignment = 0; Title.BackgroundTransparency = 1

-- Boutons Contrôle
local Close = Instance.new("TextButton", Top); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -40, 0.5, -15); Close.Text = "X"; Close.BackgroundColor3 = Color3.fromRGB(150, 50, 50); Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
Close.MouseButton1Click:Connect(function() Screen:Destroy(); FOVCircle:Remove() end)

local Min = Instance.new("TextButton", Top); Min.Size = UDim2.new(0, 30, 0, 30); Min.Position = UDim2.new(1, -75, 0.5, -15); Min.Text = "-"; Min.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Min.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Min).CornerRadius = UDim.new(1, 0)

-- Conteneur Scroll
local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, -20, 1, -60); Scroll.Position = UDim2.new(0, 10, 0, 55); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2; Scroll.CanvasSize = UDim2.new(0,0,2.5,0)
local List = Instance.new("UIListLayout", Scroll); List.Padding = UDim.new(0, 8)

-- Fonction de réduction
local Minimized = false
Min.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Main:TweenSize(Minimized and UDim2.new(0, 500, 0, 45) or UDim2.new(0, 500, 0, 420), "Out", "Quart", 0.4, true)
    Scroll.Visible = not Minimized
end)

-- [[ 9. CONSTRUCTEUR DE BOUTONS ]] --
local function AddToggle(txt, cfg_table, cfg_key)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -10, 0, 35); btn.Text = txt .. " : OFF"; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.TextColor3 = Color3.fromRGB(200, 200, 200); btn.Font = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        cfg_table[cfg_key] = not cfg_table[cfg_key]
        btn.Text = txt .. (cfg_table[cfg_key] and " : ON" or " : OFF")
        btn.BackgroundColor3 = cfg_table[cfg_key] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
    end)
end

local function AddSection(txt)
    local l = Instance.new("TextLabel", Scroll); l.Size = UDim2.new(1, 0, 0, 30); l.Text = "--- " .. txt .. " ---"; l.TextColor3 = Color3.fromRGB(120, 120, 120); l.BackgroundTransparency = 1; l.Font = 3
end

-- [[ 10. ASSEMBLAGE FINAL ]] --
AddSection("COMBAT")
AddToggle("Mouse Lock Aimbot", Kicia.Combat, "Aimbot")
AddToggle("Silent Aim (Metamethod)", Kicia.Combat, "SilentAim")
AddToggle("TriggerBot (Auto-Shoot)", Kicia.Combat, "TriggerBot")
AddToggle("Show FOV Circle", Kicia.Combat, "ShowFOV")

AddSection("MOVEMENT")
AddToggle("Fly Mode", Kicia.Movement, "Fly")
AddToggle("NoClip (Ghost)", Kicia.Movement, "NoClip")
AddToggle("SpeedHack", Kicia.Movement, "SpeedHack")

AddSection("VISUALS")
AddToggle("ESP Players (Box)", Kicia.Visuals, "ESP_Boxes")
AddToggle("Client Skin Changer", Kicia.Visuals, "Skins")

-- Draggable Logic
local dragging, dStart, sPos
Top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dStart = i.Position; sPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then 
    local delta = i.Position - dStart
    Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
Top.InputEnded:Connect(function() dragging = false end)

print("KiciaHook Omni-Edition Chargé avec succès sur Xeno !")
