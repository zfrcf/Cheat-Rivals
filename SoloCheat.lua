-- [[ SoloCheat - V1 OMNIPOTENT // MAX FOV EDITION ]] --
-- [[ INVISIBLE MAX FOV | HARD LOCK | ALL TABS RESTORED ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Nettoyage des anciennes sessions
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SoloCheat_Final" or v.Name == "SoloCheat_Max" then v:Destroy() end
end

local Config = {
    Active = true,
    Aimbot = false,
    FOV = 2000,          -- FOV AU MAXIMUM (Couvre tout l'écran)
    ShowFOV = false,     -- INVISIBLE PAR DÉFAUT
    TargetPart = "Head",
    -- Visuals
    ESP_Box = false,
    ESP_Health = false,
    -- Movement
    Fly = false,
    FlySpeed = 75,
    NoClip = false,
    Invisible = false,
    -- Keys
    MenuKey = "K",
    TP_Key = "E"
}

-- [[ RECHERCHE DE CIBLE (SCANNER TOTAL) ]] --
local function GetTarget()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            local isEnemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            if hum and hum.Health > 0 and isEnemy then
                local part = p.Character[Config.TargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                -- On vérifie juste si c'est à l'écran car le FOV est au max
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < nearest then
                        nearest = dist
                        target = part
                    end
                end
            end
        end
    end
    return target
end

-- [[ INTERFACE AVEC TOUS LES ONGLETS ]] --
local function Launch()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloCheat_Max"
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 580, 0, 420); Main.Position = UDim2.new(0.5, -290, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(15,15,15); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 65)

    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1,0,0,35); Top.BackgroundColor3 = Color3.fromRGB(25,25,25); Top.BorderSizePixel = 0; Instance.new("UICorner", Top)
    local Title = Instance.new("TextLabel", Top); Title.Text = "SOLO CHEAT // OMNIPOTENT MAX"; Title.Font = "Code"; Title.TextColor3 = Color3.new(1,1,1); Title.Size = UDim2.new(1,0,1,0); Title.BackgroundTransparency = 1

    -- Drag System
    local drag, start, startP; Top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; start = i.Position; startP = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position-start; Main.Position = UDim2.new(startP.X.Scale, startP.X.Offset+d.X, startP.Y.Scale, startP.Y.Offset+d.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 45); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -50); Container.Position = UDim2.new(0, 160, 0, 45); Container.BackgroundTransparency = 1

    local function Tab(name)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name:upper(); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); p.ScrollBarThickness = 2
        b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; p.Visible = true end)
        return p
    end

    local T1 = Tab("Combat"); local T2 = Tab("Visuals"); local T3 = Tab("Movement"); local T4 = Tab("Keybinds"); local T5 = Tab("Settings")

    local function Toggle(p, t, k)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.Font = "Code"; Instance.new("UICorner", b)
        local function u() b.Text = t.." : "..(Config[k] and "ON" or "OFF"); b.TextColor3 = Config[k] and Color3.new(0,1,0) or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[k] = not Config[k]; u() end); u()
    end

    -- Remplissage des onglets
    Toggle(T1, "AIMBOT (RIGHT CLICK)", "Aimbot"); Toggle(T1, "SHOW FOV CIRCLE", "ShowFOV")
    Toggle(T2, "ESP BOX", "ESP_Box"); Toggle(T2, "ESP HEALTH", "ESP_Health")
    Toggle(T3, "FLY MODE", "Fly"); Toggle(T3, "NOCLIP", "NoClip"); Toggle(T3, "GHOST INVISIBLE", "Invisible")
    
    local ProfileBtn = Instance.new("TextButton", T5); ProfileBtn.Size = UDim2.new(1, -10, 0, 40); ProfileBtn.Text = "LOADOUT : LEGIT"; ProfileBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); ProfileBtn.TextColor3 = Color3.new(1,1,1); ProfileBtn.Font = "Code"; Instance.new("UICorner", ProfileBtn)

    -- [[ BOUCLE DE RENDU ]] --
    local FOV_D = Drawing.new("Circle"); FOV_D.Thickness = 1; FOV_D.Color = Color3.new(0,1,0); FOV_D.Transparency = 0.5
    local Holding = false

    UIS.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then Holding = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then Holding = false end end)

    RunService.RenderStepped:Connect(function()
        if not Config.Active then FOV_D:Remove(); return end
        
        -- FOV invisible mais actif
        FOV_D.Visible = Config.ShowFOV
        FOV_D.Radius = Config.FOV
        FOV_D.Position = UIS:GetMouseLocation()
        
        -- AIMBOT LOCK (DIRECT SUR LA TÊTE)
        if Config.Aimbot and Holding then
            local t = GetTarget()
            if t then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
            end
        end

        -- GESTION PERSO (Invis, Noclip, Fly)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if Config.Fly then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0)
                local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                if m.Magnitude > 0 then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (m * (Config.FlySpeed/12)) end
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    if Config.NoClip then v.CanCollide = false end
                    if Config.Invisible and v.Name ~= "HumanoidRootPart" then v.Transparency = 1 
                    elseif not Config.Invisible and v.Transparency == 1 then v.Transparency = 0 end
                elseif v:IsA("Decal") then v.Transparency = Config.Invisible and 1 or 0 end
            end
        end
    end)

    T1.Visible = true
end

Launch()
