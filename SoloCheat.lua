-- [[ SoloCheat - V1 OMNIPOTENT // ANTI-RAGE EDITION ]] --
-- [[ RE-VERIFIED SILENT AIM | FIXED ESP | DRAGGABLE | JSON ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ INITIALISATION DES VARIABLES ]] --
local Config = {
    Active = true,
    ConfigFile = "SoloCheat_V1.json",
    
    -- Combat
    Silent = false, FOV = 150, ShowFOV = true, TargetPart = "Head",
    CurrentLoadout = "Legit",
    
    -- Visuals
    ESP_Box = false, ESP_Health = false,
    
    -- Movement
    Fly = false, FlySpeed = 60, NoClip = false, Invisible = false,
    
    -- Keybinds
    TP_Key = "E", MenuKey = "K",
    AccentColor = {0, 255, 65}
}

-- [[ PRESETS DE TRICHE (LOADOUTS) ]] --
local Presets = {
    ["Legit"] = {Silent = true, FOV = 100, ESP_Box = true, ESP_Health = true, Fly = false, NoClip = false},
    ["Semi-Rage"] = {Silent = true, FOV = 300, ESP_Box = true, ESP_Health = true, Fly = true, FlySpeed = 80, NoClip = false},
    ["Full-Rage"] = {Silent = true, FOV = 800, ESP_Box = true, ESP_Health = true, Fly = true, FlySpeed = 150, NoClip = true}
}

-- [[ GESTION DE LA CONFIGURATION ]] --
local function SaveConfig()
    if writefile then writefile(Config.ConfigFile, HttpService:JSONEncode(Config)) end
end

local function LoadConfig()
    if isfile and isfile(Config.ConfigFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(Config.ConfigFile)) end)
        if success then for i, v in pairs(data) do Config[i] = v end end
    end
end
LoadConfig()

-- [[ MOTEUR DE VISÉE (SILENT AIM LEGACY) ]] --
local function GetTarget()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            local isEnemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            
            if isEnemy and hum and hum.Health > 0 then
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

-- [[ SYSTÈME ESP (FIXE) ]] --
local function ApplyESP(p)
    local function Create()
        local char = p.Character or p.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 10)
        if not hrp then return end

        -- Box ESP
        local box = Instance.new("BoxHandleAdornment", CoreGui)
        box.Name = p.Name .. "_Box"; box.Adornee = hrp; box.AlwaysOnTop = true; box.Size = Vector3.new(4, 6, 0.1); box.Transparency = 0.5
        box.Color3 = Color3.fromRGB(Config.AccentColor[1], Config.AccentColor[2], Config.AccentColor[3])
        
        -- Billboard (Santé)
        local bill = Instance.new("BillboardGui", CoreGui)
        bill.Name = p.Name .. "_Bill"; bill.Adornee = char:WaitForChild("Head"); bill.Size = UDim2.new(0, 80, 0, 10); bill.ExtentsOffset = Vector3.new(0, 3, 0); bill.AlwaysOnTop = true
        
        local back = Instance.new("Frame", bill); back.Size = UDim2.new(1, 0, 1, 0); back.BackgroundColor3 = Color3.new(0,0,0); back.BorderSizePixel = 0
        local bar = Instance.new("Frame", back); bar.Size = UDim2.new(1, 0, 1, 0); bar.BorderSizePixel = 0
        local txt = Instance.new("TextLabel", bill); txt.Size = UDim2.new(1, 0, 1, 0); txt.Position = UDim2.new(0,0,-1.5,0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.new(1,1,1); txt.Font = "Code"; txt.TextSize = 12

        local conn; conn = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not Config.Active then box:Destroy(); bill:Destroy(); conn:Disconnect(); return end
            
            local isAlly = (p.Team == LocalPlayer.Team and p.Team ~= nil)
            box.Visible = Config.ESP_Box and not isAlly
            bill.Enabled = Config.ESP_Health and not isAlly
            
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                bar.Size = UDim2.new(hp, 0, 1, 0)
                bar.BackgroundColor3 = Color3.fromHSV(hp * 0.3, 1, 1)
                txt.Text = p.Name .. " [" .. math.floor(hum.Health) .. "]"
            end
        end)
    end
    p.CharacterAdded:Connect(Create); if p.Character then Create() end
end

-- [[ INTERFACE ET FONCTIONNALITÉS ]] --
local function Launch()
    local UI = Instance.new("ScreenGui", CoreGui)
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 580, 0, 420); Main.Position = UDim2.new(0.5, -290, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main); local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 255, 65); Stroke.Thickness = 2

    -- TopBar Draggable
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 40); Top.BackgroundColor3 = Color3.fromRGB(20,20,20); Top.BorderSizePixel = 0
    Instance.new("UICorner", Top); local drag, start, startP
    Top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; start = i.Position; startP = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then 
        local delta = i.Position - start; Main.Position = UDim2.new(startP.X.Scale, startP.X.Offset + delta.X, startP.Y.Scale, startP.Y.Offset + delta.Y) 
    end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

    local Close = Instance.new("TextButton", Top); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0.5, -15); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.TextSize = 20
    Close.MouseButton1Click:Connect(function() Config.Active = false; UI:Destroy() end)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 45); Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -50); Container.Position = UDim2.new(0, 160, 0, 45); Container.BackgroundTransparency = 1

    local function Tab(name)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; p.Visible = true end)
        return p
    end

    local TComb = Tab("COMBAT"); local TVis = Tab("VISUALS"); local TMov = Tab("MOVEMENT"); local TKeys = Tab("KEYBINDS"); local TSet = Tab("SETTINGS")

    local function Toggle(parent, txt, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local function upd() b.Text = txt .. " : " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Config[key] and Color3.new(0,1,0) or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; upd(); SaveConfig() end); upd()
    end

    Toggle(TComb, "SILENT AIM", "Silent"); Toggle(TComb, "SHOW FOV", "ShowFOV")
    Toggle(TVis, "ESP BOX", "ESP_Box"); Toggle(TVis, "ESP HEALTH", "ESP_Health")
    Toggle(TMov, "FLY", "Fly"); Toggle(TMov, "NOCLIP", "NoClip"); Toggle(TMov, "INVISIBLE", "Invisible")

    -- LOADOUTS DU CHEAT (SETTINGS)
    local LoadoutBtn = Instance.new("TextButton", TSet); LoadoutBtn.Size = UDim2.new(1, -10, 0, 40); LoadoutBtn.Text = "CHEAT PROFILE : " .. Config.CurrentLoadout; LoadoutBtn.BackgroundColor3 = Color3.fromRGB(35,35,35); LoadoutBtn.TextColor3 = Color3.new(0,1,1); LoadoutBtn.Font = "Code"
    LoadoutBtn.MouseButton1Click:Connect(function()
        local list = {"Legit", "Semi-Rage", "Full-Rage"}
        local cur = table.find(list, Config.CurrentLoadout) or 1
        Config.CurrentLoadout = list[cur + 1] or list[1]
        for k, v in pairs(Presets[Config.CurrentLoadout]) do Config[k] = v end
        LoadoutBtn.Text = "CHEAT PROFILE : " .. Config.CurrentLoadout; SaveConfig()
    end)

    -- [[ BOUCLE DE RENDU FINALE ]] --
    local FOV = Drawing.new("Circle"); FOV.Thickness = 1; FOV.Color = Color3.new(0,1,0); FOV.Transparency = 0.7
    RunService.RenderStepped:Connect(function()
        if not Config.Active then FOV:Remove(); return end
        FOV.Visible = Config.ShowFOV; FOV.Radius = Config.FOV; FOV.Position = UIS:GetMouseLocation()
        
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetTarget()
            if t then mousemoverel((Camera:WorldToViewportPoint(t.Position).X - UIS:GetMouseLocation().X)/2.2, (Camera:WorldToViewportPoint(t.Position).Y - UIS:GetMouseLocation().Y)/2.2) end
        end

        local char = LocalPlayer.Character
        if char then
            if Config.Fly then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then 
                    hrp.Velocity = Vector3.new(0, 1.5, 0)
                    local move = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                    if move.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (move * (Config.FlySpeed/10)) end
                end
            end
            if Config.NoClip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            if Config.Invisible then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end end end
        end
    end)

    -- Keybinds Menu & TP
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode.Name == Config.MenuKey then Main.Visible = not Main.Visible end
        if i.KeyCode.Name == Config.TP_Key then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 35) end
        end
    end)

    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ApplyESP(p) end end
    Players.PlayerAdded:Connect(ApplyESP); TComb.Visible = true
end

Launch()
