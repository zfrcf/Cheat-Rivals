-- [[ SoloCheat - V1 OMNIPOTENT // FINAL ELITE EDITION ]] --
-- [[ DRAGGABLE | CLOSE BUTTON | JSON SAVE | KEYBINDS | NOCLIP ]] --

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION PAR DÉFAUT ]] --
local Config = {
    Active = true,
    AuthKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    ConfigFile = "SoloCheat_Settings.json",
    Silent = false, FOV = 200, ShowFOV = true, TargetPart = "Head", Loadout = "Legit",
    ESP_Box = false, ESP_HealthText = false,
    Invisible = false, Fly = false, FlySpeed = 60, NoClip = false,
    TP_Key = "E", MenuKey = "K",
    AccentColor = {0, 255, 65},
    AllyColor = {0, 150, 255}
}

-- [[ SYSTÈME DE SAUVEGARDE ]] --
local function SaveSettings()
    if writefile then
        local success, data = pcall(function() return HttpService:JSONEncode(Config) end)
        if success then writefile(Config.ConfigFile, data) end
    end
end

local function LoadSettings()
    if isfile and isfile(Config.ConfigFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(Config.ConfigFile)) end)
        if success then for i, v in pairs(data) do Config[i] = v end end
    end
end

LoadSettings()

-- [[ FONCTION DRAG (DÉPLACEMENT DE L'INTERFACE) ]] --
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ LOGIQUE DE COMBAT ]] --
local function GetClosestTarget()
    local target = nil
    local nearestDistance = Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            if (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral") and hum and hum.Health > 0 then
                local part = p.Character[Config.TargetPart]
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < nearestDistance then nearestDistance = dist; target = part end
                end
            end
        end
    end
    return target
end

-- [[ INTERFACE PRINCIPALE ]] --
local function LaunchCheat()
    local MainUI = Instance.new("ScreenGui", CoreGui); MainUI.Name = "SoloCheat_V1"
    local MainFrame = Instance.new("Frame", MainUI); MainFrame.Size = UDim2.new(0, 600, 0, 450); MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225); MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8); MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local Glow = Instance.new("UIStroke", MainFrame); Glow.Color = Color3.fromRGB(Config.AccentColor[1], Config.AccentColor[2], Config.AccentColor[3]); Glow.Thickness = 2

    -- TopBar (Pour Drag et Fermer)
    local TopBar = Instance.new("Frame", MainFrame); TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); TopBar.BorderSizePixel = 0
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
    MakeDraggable(TopBar, MainFrame)

    local Title = Instance.new("TextLabel", TopBar); Title.Size = UDim2.new(1, -50, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.Text = "SOLOCHIET // SYSTEM_V1"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "Code"; Title.TextSize = 16; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0
    
    local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0.5, -15); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1, 0.2, 0.2); CloseBtn.Font = "Code"; CloseBtn.TextSize = 20; CloseBtn.BackgroundTransparency = 1

    -- Navigation
    local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Size = UDim2.new(0, 140, 1, -60); Sidebar.Position = UDim2.new(0, 10, 0, 50); Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", MainFrame); Container.Size = UDim2.new(1, -170, 1, -60); Container.Position = UDim2.new(0, 160, 0, 50); Container.BackgroundTransparency = 1

    local function CreateTab(name)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = "["..name:upper().."]"; b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.TextColor3 = Color3.new(0.7,0.7,0.7); b.Font = "Code"; b.TextSize = 14; Instance.new("UICorner", b)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            p.Visible = true
        end)
        return p
    end

    local TCombat = CreateTab("Combat"); local TVisuals = CreateTab("Visuals"); local TMovement = CreateTab("Movement"); local TKeybinds = CreateTab("Keybinds"); local TSettings = CreateTab("Settings")

    -- [[ UI HELPERS ]] --
    local function AddToggle(parent, text, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 38); b.Text = text .. " : " .. (Config[key] and "ON" or "OFF"); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Config[key] and Color3.new(0,1,0) or Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config[key] = not Config[key]; b.Text = text .. " : " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Config[key] and Color3.new(0,1,0) or Color3.new(1,1,1)
            SaveSettings()
        end)
    end

    local function AddKeybind(parent, text, key)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 38); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.Text = "> " .. text; l.TextColor3 = Color3.new(1,1,1); l.Font = "Code"; l.TextXAlignment = 0; l.BackgroundTransparency = 1
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 90, 0, 28); b.Position = UDim2.new(1, -95, 0.5, -14); b.Text = "[" .. Config[key] .. "]"; b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.TextColor3 = Color3.new(0,1,0); b.Font = "Code"; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            b.Text = "..."; local c; c = UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    Config[key] = i.KeyCode.Name; b.Text = "[" .. i.KeyCode.Name .. "]"; SaveSettings(); c:Disconnect()
                end
            end)
        end)
    end

    local function AddDropdown(parent, text, key, options)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 38); b.Text = text .. " : " .. Config[key]; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(0, 1, 0); b.Font = "Code"; Instance.new("UICorner", b)
        local open = false; local optFrame = Instance.new("Frame", parent); optFrame.Size = UDim2.new(1, -10, 0, #options * 30); optFrame.Visible = false; optFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", optFrame); Instance.new("UIListLayout", optFrame)
        for _, opt in pairs(options) do
            local o = Instance.new("TextButton", optFrame); o.Size = UDim2.new(1, 0, 0, 30); o.Text = opt; o.Font = "Code"; o.TextColor3 = Color3.new(1, 1, 1); o.BackgroundTransparency = 1
            o.MouseButton1Click:Connect(function() Config[key] = opt; b.Text = text .. " : " .. opt; optFrame.Visible = false; open = false; SaveSettings() end)
        end
        b.MouseButton1Click:Connect(function() open = not open; optFrame.Visible = open end)
    end

    -- Setup des onglets
    AddToggle(TCombat, "SILENT_AIM", "Silent"); AddToggle(TCombat, "SHOW_FOV", "ShowFOV")
    AddToggle(TVisuals, "ESP_BOX", "ESP_Box"); AddToggle(TVisuals, "ESP_HEALTH", "ESP_HealthText")
    AddToggle(TMovement, "FLY_ACTIVE", "Fly"); AddToggle(TMovement, "NOCLIP_ACTIVE", "NoClip")
    AddKeybind(TKeybinds, "GHOST_BLINK", "TP_Key"); AddKeybind(TKeybinds, "MENU_TOGGLE", "MenuKey")
    AddDropdown(TSettings, "LOADOUT", "Loadout", {"Legit", "Semi-Rage", "Full-Rage"})

    -- [[ BOUCLE DE RENDU ]] --
    local Circle = Drawing.new("Circle"); Circle.Thickness = 1; Circle.Color = Color3.fromRGB(0, 255, 65); Circle.Transparency = 0.7
    
    local MainLoop; MainLoop = RunService.RenderStepped:Connect(function()
        if not Config.Active then Circle:Remove(); MainLoop:Disconnect(); return end
        Circle.Visible = Config.ShowFOV; Circle.Radius = Config.FOV; Circle.Position = UIS:GetMouseLocation()
        
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t then mousemoverel((Camera:WorldToViewportPoint(t.Position).X - UIS:GetMouseLocation().X)/2, (Camera:WorldToViewportPoint(t.Position).Y - UIS:GetMouseLocation().Y)/2) end
        end

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if Config.Fly then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0.1, 0)
                local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                if m.Magnitude > 0 then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (m * (Config.FlySpeed/10)) end
            end
            if Config.NoClip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end
    end)

    -- Fermeture
    CloseBtn.MouseButton1Click:Connect(function()
        Config.Active = false
        MainUI:Destroy()
    end)

    -- Keybind Listener
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode.Name == Config.MenuKey then MainFrame.Visible = not MainFrame.Visible end
        if i.KeyCode.Name == Config.TP_Key then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 35) end
        end
    end)

    TCombat.Visible = true
end

LaunchCheat()
