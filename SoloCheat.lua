-- [[ SoloCheat - V1 RIVALS EDITION ]] --
-- [[ SILENT AIM FIXED + GHOST INVISIBILITY ]] --

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]] --
local Config = {
    Active = true,
    Silent = false, FOV = 200, ShowFOV = true, TargetPart = "Head",
    Fly = false, FlySpeed = 10, NoClip = false,
    ESP_Box = false, ESP_HealthText = false,
    Invisible = false, -- NOUVEAU
    TP_Key = Enum.KeyCode.E,
    MenuKey = Enum.KeyCode.K,
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    AccentColor = Color3.fromRGB(0, 255, 65),
    BgColor = Color3.fromRGB(5, 5, 5),
    SecColor = Color3.fromRGB(15, 15, 15),
    Rounded = UDim.new(0, 12)
}

-- [[ REPARATION SILENT AIM (FIXED LOGIC) ]] --
local function GetClosestTarget()
    local target, nearestDistance = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            -- Vérification équipe et vie (Ignore cadavres)
            if p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral" then 
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local pos, vis = Camera:WorldToViewportPoint(p.Character[Config.TargetPart].Position)
                    local screenDist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    
                    if vis and screenDist <= Config.FOV then
                        local worldDist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if worldDist < nearestDistance then 
                            nearestDistance = worldDist; target = p.Character[Config.TargetPart] 
                        end
                    end
                end
            end
        end
    end
    return target
end

-- [[ LOGIQUE INVISIBILITÉ (INTEGRÉE) ]] --
local function ApplyInvisibility()
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                -- Si actif: invisible (1), sinon: visible (0)
                v.Transparency = Config.Invisible and 1 or 0
                -- On garde l'HumanoidRootPart toujours invisible
                if v.Name == "HumanoidRootPart" then v.Transparency = 1 end
            end
        end
    end
end

-- [[ INTERFACE CYBER-HACKER ]] --
local function LaunchCheat()
    local MainUI = Instance.new("ScreenGui", CoreGui)
    local MainFrame = Instance.new("Frame", MainUI); MainFrame.Size = UDim2.new(0, 580, 0, 430); MainFrame.Position = UDim2.new(0.5, -290, 0.5, -215); MainFrame.BackgroundColor3 = Config.BgColor; Instance.new("UICorner", MainFrame).CornerRadius = Config.Rounded
    local Glow = Instance.new("UIStroke", MainFrame); Glow.Color = Config.AccentColor; Glow.Thickness = 2

    local TopBar = Instance.new("Frame", MainFrame); TopBar.Size = UDim2.new(1, 0, 0, 45); TopBar.BackgroundColor3 = Config.SecColor; Instance.new("UICorner", TopBar).CornerRadius = Config.Rounded
    local Title = Instance.new("TextLabel", TopBar); Title.Size = UDim2.new(1, 0, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0); Title.Text = "SOLOCHIET // RIVALS_V1"; Title.TextColor3 = Config.AccentColor; Title.Font = "Code"; Title.TextSize = 18; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

    local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Size = UDim2.new(0, 150, 1, -60); Sidebar.Position = UDim2.new(0, 10, 0, 55); Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)
    local Container = Instance.new("Frame", MainFrame); Container.Size = UDim2.new(1, -180, 1, -65); Container.Position = UDim2.new(0, 170, 0, 55); Container.BackgroundTransparency = 1

    local function AddTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar); TabBtn.Size = UDim2.new(1, 0, 0, 40); TabBtn.Text = "[ " .. name:upper() .. " ]"; TabBtn.BackgroundColor3 = Config.SecColor; TabBtn.TextColor3 = Color3.new(0.6, 0.6, 0.6); TabBtn.Font = "Code"; Instance.new("UICorner", TabBtn)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)
        return Page
    end

    local function AddToggle(parent, text, key, callback)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 45); b.Text = "> " .. text .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(15, 15, 15); b.TextColor3 = Color3.new(1, 1, 1); b.Font = "Code"
        Instance.new("UICorner", b); local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(40, 40, 40)
        b.MouseButton1Click:Connect(function() 
            Config[key] = not Config[key]
            b.Text = "> " .. text .. " : " .. (Config[key] and "ON" or "OFF")
            b.TextColor3 = Config[key] and Config.AccentColor or Color3.new(1, 1, 1)
            s.Color = Config[key] and Config.AccentColor or Color3.fromRGB(40, 40, 40)
            if callback then callback() end
        end)
    end

    -- ONGLET VISIBILITY (NOUVEAU)
    local TCombat = AddTab("Combat")
    local TVisual = AddTab("Visuals")
    local TVisibility = AddTab("Visibility") -- L'onglet demandé
    local TSettings = AddTab("Settings")

    AddToggle(TCombat, "AIM_SILENT", "Silent")
    AddToggle(TVisual, "ESP_BOX", "ESP_Box")
    
    -- Bouton Invisibilité intégré ici
    AddToggle(TVisibility, "GHOST_MODE", "Invisible", function()
        ApplyInvisibility()
    end)

    -- Boucle Silent Aim & Fly
    RunService.RenderStepped:Connect(function()
        if not Config.Active then return end
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t then 
                local p = Camera:WorldToViewportPoint(t.Position)
                mousemoverel((p.X - UIS:GetMouseLocation().X)/2, (p.Y - UIS:GetMouseLocation().Y)/2) 
            end
        end
        -- Maintien de l'invisibilité si le personnage reset
        if Config.Invisible then ApplyInvisibility() end
    end)

    TCombat.Visible = true
end

-- [[ LANCEMENT SYSTÈME ]] --
local function StartKey()
    local KeyUI = Instance.new("ScreenGui", CoreGui)
    local KF = Instance.new("Frame", KeyUI); KF.Size = UDim2.new(0, 420, 0, 260); KF.Position = UDim2.new(0.5, -210, 0.5, -130); KF.BackgroundColor3 = Config.BgColor; Instance.new("UICorner", KF)
    local B = Instance.new("TextBox", KF); B.Size = UDim2.new(0.8, 0, 0, 45); B.Position = UDim2.new(0.1, 0, 0.35, 0); B.PlaceholderText = "TOKEN_RIVALS..."; B.TextColor3 = Color3.new(1,1,1); B.Font = "Code"
    local V = Instance.new("TextButton", KF); V.Size = UDim2.new(0.4, -5, 0, 45); V.Position = UDim2.new(0.1, 0, 0.65, 0); V.Text = "[ RUN.EXE ]"; V.BackgroundColor3 = Color3.fromRGB(20, 40, 20); V.TextColor3 = Config.AccentColor; V.Font = "Code"
    V.MouseButton1Click:Connect(function() if B.Text == Config.CorrectKey then KeyUI:Destroy(); LaunchCheat() end end)
    Instance.new("UIStroke", KF).Color = Config.AccentColor
end

StartKey()
