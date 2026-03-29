-- [[ SoloCheat - V1 OMNIPOTENT // THE DEFINITIVE EDITION ]] --
-- [[ ALL FEATURES RESTORED | STABLE ESP | LEGACY AIM | JSON ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION INITIALE ]] --
local Config = {
    Active = true,
    ConfigFile = "SoloCheat_Master.json",
    -- Combat
    Silent = false, FOV = 150, ShowFOV = true, TargetPart = "Head",
    -- Visuals
    ESP_Box = false, ESP_Health = false,
    -- Movement & Physics
    Fly = false, FlySpeed = 60, NoClip = false, Invisible = false,
    -- Keybinds
    TP_Key = "E", MenuKey = "K",
    -- Loadout
    CurrentLoadout = "Legit"
}

local Presets = {
    ["Legit"] = {Silent = true, FOV = 100, ESP_Box = true, ESP_Health = true, Fly = false, NoClip = false, Invisible = false},
    ["Semi-Rage"] = {Silent = true, FOV = 300, ESP_Box = true, ESP_Health = true, Fly = true, FlySpeed = 80, NoClip = false, Invisible = false},
    ["Full-Rage"] = {Silent = true, FOV = 800, ESP_Box = true, ESP_Health = true, Fly = true, FlySpeed = 150, NoClip = true, Invisible = true}
}

-- [[ SYSTÈME DE SAUVEGARDE ]] --
local function Save()
    if writefile then writefile(Config.ConfigFile, HttpService:JSONEncode(Config)) end
end

local function Load()
    if isfile and isfile(Config.ConfigFile) then
        local s, d = pcall(function() return HttpService:JSONDecode(readfile(Config.ConfigFile)) end)
        if s then for i, v in pairs(d) do Config[i] = v end end
    end
end
Load()

-- [[ SILENT AIM LEGACY (ANCIENNE VERSION) ]] --
local function GetClosest()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral") then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character[Config.TargetPart].Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < nearest then nearest = dist; target = p.Character[Config.TargetPart] end
                end
            end
        end
    end
    return target
end

-- [[ ESP STABLE (BOX + HEALTH) ]] --
local function ApplyESP(p)
    local function Create()
        local char = p.Character or p.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if not root then return end

        local Box = Instance.new("BoxHandleAdornment", CoreGui)
        Box.Name = p.Name.."_B"; Box.Adornee = root; Box.AlwaysOnTop = true; Box.Size = Vector3.new(4, 6, 0.1); Box.Transparency = 0.5; Box.Color3 = Color3.fromRGB(0, 255, 65)

        local Bill = Instance.new("BillboardGui", CoreGui)
        Bill.Name = p.Name.."_H"; Bill.Adornee = char:WaitForChild("Head"); Bill.Size = UDim2.new(0, 80, 0, 10); Bill.AlwaysOnTop = true; Bill.ExtentsOffset = Vector3.new(0, 3, 0)
        
        local Back = Instance.new("Frame", Bill); Back.Size = UDim2.new(1, 0, 1, 0); Back.BackgroundColor3 = Color3.new(0,0,0); Back.BorderSizePixel = 0
        local Bar = Instance.new("Frame", Back); Bar.Size = UDim2.new(1, 0, 1, 0); Bar.BackgroundColor3 = Color3.new(0,1,0); Bar.BorderSizePixel = 0
        local Txt = Instance.new("TextLabel", Bill); Txt.Size = UDim2.new(1, 0, 1, 0); Txt.Position = UDim2.new(0,0,-1.5,0); Txt.BackgroundTransparency = 1; Txt.TextColor3 = Color3.new(1,1,1); Txt.Font = "Code"; Txt.TextSize = 11

        local loop; loop = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not Config.Active then Box:Destroy(); Bill:Destroy(); loop:Disconnect(); return end
            local enemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            Box.Visible = Config.ESP_Box and enemy
            Bill.Enabled = Config.ESP_Health and enemy
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                Bar.Size = UDim2.new(hp, 0, 1, 0)
                Bar.BackgroundColor3 = Color3.fromHSV(hp * 0.3, 1, 1)
                Txt.Text = p.Name .. " [" .. math.floor(hum.Health) .. "]"
            end
        end)
    end
    p.CharacterAdded:Connect(Create); if p.Character then Create() end
end

-- [[ INTERFACE ]] --
local function Launch()
    local UI = Instance.new("ScreenGui", CoreGui)
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 580, 0, 420); Main.Position = UDim2.new(0.5, -290, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(12,12,12); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 65)

    -- Bar Déplaçable
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 35); Top.BackgroundColor3 = Color3.fromRGB(20,20,20); Top.BorderSizePixel = 0
    Instance.new("UICorner", Top); local drag, start, startP
    Top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; start = i.Position; startP = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then 
        local d = i.Position - start; Main.Position = UDim2.new(startP.X.Scale, startP.X.Offset + d.X, startP.Y.Scale, startP.Y.Offset + d.Y) 
    end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

    local Close = Instance.new("TextButton", Top); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 2); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.TextSize = 20
    Close.MouseButton1Click:Connect(function() Config.Active = false; UI:Destroy() end)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 45); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -50); Container.Position = UDim2.new(0, 160, 0, 45); Container.BackgroundTransparency = 1

    local function Tab(name)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; p.Visible = true end)
        return p
    end

    local TComb = Tab("Combat"); local TVis = Tab("Visuals"); local TMov = Tab("Movement"); local TKeys = Tab("Keybinds"); local TSet = Tab("Settings")

    local function Toggle(parent, txt, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local function upd() b.Text = txt .. " : " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Config[key] and Color3.new(0,1,0) or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; upd(); Save() end); upd()
    end

    local function Bind(parent, txt, key)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 35); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.Text = txt; l.TextColor3 = Color3.new(1,1,1); l.Font = "Code"; l.BackgroundTransparency = 1; l.TextXAlignment = 0
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 80, 0, 25); b.Position = UDim2.new(1, -85, 0.5, -12); b.Text = "["..Config[key].."]"; b.Font = "Code"; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(0,1,0); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() b.Text = "..."; local c; c = UIS.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Keyboard then Config[key] = i.KeyCode.Name; b.Text = "["..i.KeyCode.Name.."]"; Save(); c:Disconnect() end end) end)
    end

    -- Setup Onglets
    Toggle(TComb, "SILENT AIM", "Silent"); Toggle(TComb, "SHOW FOV", "ShowFOV")
    Toggle(TVis, "ESP BOX", "ESP_Box"); Toggle(TVis, "ESP HEALTH", "ESP_Health")
    Toggle(TMov, "FLY", "Fly"); Toggle(TMov, "NOCLIP", "NoClip"); Toggle(TMov, "INVISIBLE", "Invisible")
    Bind(TKeys, "MENU TOGGLE", "MenuKey"); Bind(TKeys, "BLINK TP", "TP_Key")

    local LoadoutBtn = Instance.new("TextButton", TSet); LoadoutBtn.Size = UDim2.new(1, -10, 0, 40); LoadoutBtn.Text = "LOADOUT : " .. Config.CurrentLoadout; LoadoutBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); LoadoutBtn.TextColor3 = Color3.new(0,1,1); LoadoutBtn.Font = "Code"
    LoadoutBtn.MouseButton1Click:Connect(function()
        local l = {"Legit", "Semi-Rage", "Full-Rage"}
        local i = table.find(l, Config.CurrentLoadout) or 1
        Config.CurrentLoadout = l[i+1] or l[1]
        for k, v in pairs(Presets[Config.CurrentLoadout]) do Config[k] = v end
        LoadoutBtn.Text = "LOADOUT : " .. Config.CurrentLoadout; Save()
    end)

    -- [[ BOUCLE DE RENDU FINALE ]] --
    local FOV = Drawing.new("Circle"); FOV.Thickness = 1; FOV.Color = Color3.new(0,1,0); FOV.Transparency = 0.7
    RunService.RenderStepped:Connect(function()
        if not Config.Active then FOV:Remove(); return end
        FOV.Visible = Config.ShowFOV; FOV.Radius = Config.FOV; FOV.Position = UIS:GetMouseLocation()
        
        -- Silent Aim V0
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosest()
            if t then mousemoverel((Camera:WorldToViewportPoint(t.Position).X - UIS:GetMouseLocation().X)/1.8, (Camera:WorldToViewportPoint(t.Position).Y - UIS:GetMouseLocation().Y)/1.8) end
        end

        -- Movement & Character Loop
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if Config.Fly then
                    hrp.Velocity = Vector3.new(0, 2, 0)
                    local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                    if m.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (m * (Config.FlySpeed/10)) end
                end
                -- NoClip & Invisible (Forcé à chaque image)
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        if Config.NoClip then v.CanCollide = false end
                        if Config.Invisible and v.Name ~= "HumanoidRootPart" then v.Transparency = 1 
                        elseif not Config.Invisible and v.Transparency == 1 then v.Transparency = 0 end
                    elseif v:IsA("Decal") then
                        if Config.Invisible then v.Transparency = 1 elseif not Config.Invisible and v.Transparency == 1 then v.Transparency = 0 end
                    end
                end
            end
        end
    end)

    -- Input Listener (TP & Menu)
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode.Name == Config.MenuKey then Main.Visible = not Main.Visible end
        if i.KeyCode.Name == Config.TP_Key then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 45) end
        end
    end)

    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ApplyESP(p) end end
    Players.PlayerAdded:Connect(ApplyESP); TComb.Visible = true
end

Launch()
