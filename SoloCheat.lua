-- [[ SoloCheat - V1 OMNIPOTENT // WALL-IGNORE EDITION ]] --
-- [[ HARD LOCK AIM | NO WALL CHECK | FIXED MODULES ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Nettoyage complet
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SoloCheat_Omni_Final" then v:Destroy() end
end

local Config = {
    Active = true,
    Aimbot = false,
    FOV = 2000, -- Couvre tout l'écran
    TargetPart = "Head",
    -- Visuals
    ESP_Box = false,
    ESP_Health = false,
    -- Movement
    Fly = false,
    FlySpeed = 50,
    NoClip = false,
    -- Keys
    MenuKey = "K",
    TP_Key = "E"
}

-- [[ AIMBOT BRUT (IGNORE LES MURS) ]] --
local function GetClosestTarget()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            -- On vérifie juste si l'ennemi est vivant et dans une équipe différente
            if hum and hum.Health > 0 and (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral") then
                local head = p.Character[Config.TargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                -- L'aimbot fonctionne dès que le joueur est "en théorie" sur ton écran
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < nearest then
                        nearest = dist
                        target = head
                    end
                end
            end
        end
    end
    return target
end

-- [[ ESP HIGHLIGHT (A TRAVERS LES MURS) ]] --
local function ApplyESP(p)
    local function Create()
        local char = p.Character or p.CharacterAdded:Wait()
        local high = char:FindFirstChild("SoloHighlight") or Instance.new("Highlight", char)
        high.Name = "SoloHighlight"
        high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- TRÈS IMPORTANT : VOIR À TRAVERS LES MURS
        high.FillColor = Color3.fromRGB(0, 255, 65)
        high.OutlineColor = Color3.new(1, 1, 1)

        local loop; loop = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not Config.Active then 
                high:Destroy(); loop:Disconnect(); return 
            end
            local enemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            high.Enabled = Config.ESP_Box and enemy
        end)
    end
    p.CharacterAdded:Connect(Create); if p.Character then Create() end
end

-- [[ GESTION DU NOCLIP (BOUCLE PHYSIQUE) ]] --
RunService.Stepped:Connect(function()
    if Config.Active and Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- [[ INTERFACE ]] --
local function LaunchUI()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloCheat_Omni_Final"
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 580, 0, 420); Main.Position = UDim2.new(0.5, -290, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(15,15,15); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 65)

    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1,0,0,35); Top.BackgroundColor3 = Color3.fromRGB(25,25,25); Top.BorderSizePixel = 0; Instance.new("UICorner", Top)
    local Close = Instance.new("TextButton", Top); Close.Size = UDim2.new(0,35,0,35); Close.Position = UDim2.new(1,-35,0,0); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.TextSize = 20
    Close.MouseButton1Click:Connect(function() Config.Active = false; UI:Destroy() end)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 45); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -50); Container.Position = UDim2.new(0, 160, 0, 45); Container.BackgroundTransparency = 1

    local function Tab(n)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = n:upper(); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); p.ScrollBarThickness = 2
        b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; p.Visible = true end)
        return p
    end

    local function Toggle(p, t, k)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.Font = "Code"; Instance.new("UICorner", b)
        local function u() b.Text = t.." : "..(Config[k] and "ON" or "OFF"); b.TextColor3 = Config[k] and Color3.new(0,1,0) or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[k] = not Config[k]; u() end); u()
    end

    local T1 = Tab("Combat"); local T2 = Tab("Visuals"); local T3 = Tab("Movement"); local T4 = Tab("Keybinds")
    Toggle(T1, "AIMBOT (WALL-IGNORE)", "Aimbot"); Toggle(T2, "ESP BOX (HIGHLIGHT)", "ESP_Box")
    Toggle(T3, "FLY MODE", "Fly"); Toggle(T3, "NOCLIP", "NoClip")

    -- [[ BOUCLE DE RENDU FINALE ]] --
    local RightHolding = false
    UIS.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then RightHolding = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then RightHolding = false end end)

    RunService.RenderStepped:Connect(function()
        if not Config.Active then return end

        -- AIMBOT LOCK
        if Config.Aimbot and RightHolding then
            local t = GetClosestTarget()
            if t then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
            end
        end

        -- FLY
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Config.Fly then
            hrp.Velocity = Vector3.new(0, 1.5, 0)
            local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
            if m.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (m * (Config.FlySpeed/15)) end
        end
    end)

    T1.Visible = true
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ApplyESP(p) end end
Players.PlayerAdded:Connect(ApplyESP)
LaunchUI()
