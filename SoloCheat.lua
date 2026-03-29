-- [[ SoloCheat - V1 OMNIPOTENT // AIMBOT EDITION ]] --
-- [[ HARD LOCK AIM | COMPLETE ESP | GHOST MODE | JSON ]] --

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]] --
local Config = {
    Active = true,
    ConfigFile = "SoloCheat_Aimbot.json",
    
    -- Combat (Aimbot)
    Aimbot = false,
    FOV = 150,
    ShowFOV = true,
    Smoothing = 0.25, -- Plus c'est bas, plus c'est rapide (0.1 = instantané)
    TargetPart = "Head",
    
    -- Visuals
    ESP_Box = false,
    ESP_Health = false,
    
    -- Movement
    Fly = false,
    FlySpeed = 70,
    NoClip = false,
    Invisible = false,
    
    -- Keybinds
    TP_Key = "E",
    MenuKey = "K",
    CurrentLoadout = "Legit"
}

-- [[ PRESETS ]] --
local Presets = {
    ["Legit"] = {Aimbot = true, FOV = 80, Smoothing = 0.5, ESP_Box = true, ESP_Health = true, Fly = false, NoClip = false, Invisible = false},
    ["Semi-Rage"] = {Aimbot = true, FOV = 300, Smoothing = 0.2, ESP_Box = true, ESP_Health = true, Fly = true, NoClip = false, Invisible = false},
    ["Full-Rage"] = {Aimbot = true, FOV = 800, Smoothing = 0.05, ESP_Box = true, ESP_Health = true, Fly = true, NoClip = true, Invisible = true}
}

-- [[ SAUVEGARDE JSON ]] --
local function Save() if writefile then writefile(Config.ConfigFile, HttpService:JSONEncode(Config)) end end
local function Load()
    if isfile and isfile(Config.ConfigFile) then
        local s, d = pcall(function() return HttpService:JSONDecode(readfile(Config.ConfigFile)) end)
        if s then for i, v in pairs(d) do Config[i] = v end end
    end
end
Load()

-- [[ MOTEUR AIMBOT (CAMERA LOCK) ]] --
local function GetClosestTarget()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            local isEnemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            
            if hum and hum.Health > 0 and isEnemy then
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

-- [[ SYSTEME ESP ]] --
local function CreateESP(p)
    local function Setup()
        local char = p.Character or p.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart", 10)
        local head = char:WaitForChild("Head", 10)
        if not root or not head then return end

        local Box = Instance.new("BoxHandleAdornment", CoreGui)
        Box.Adornee = root; Box.AlwaysOnTop = true; Box.Size = Vector3.new(4, 6, 0.1); Box.Transparency = 0.6; Box.Color3 = Color3.fromRGB(0, 255, 65)

        local Bill = Instance.new("BillboardGui", CoreGui)
        Bill.Adornee = head; Bill.Size = UDim2.new(0, 80, 0, 10); Bill.AlwaysOnTop = true; Bill.ExtentsOffset = Vector3.new(0, 3, 0)
        local BarBG = Instance.new("Frame", Bill); BarBG.Size = UDim2.new(1,0,1,0); BarBG.BackgroundColor3 = Color3.new(0,0,0); BarBG.BorderSizePixel = 0
        local Bar = Instance.new("Frame", BarBG); Bar.Size = UDim2.new(1,0,1,0); Bar.BackgroundColor3 = Color3.new(0,1,0); Bar.BorderSizePixel = 0

        local loop; loop = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not Config.Active then Box:Destroy(); Bill:Destroy(); loop:Disconnect(); return end
            local enemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            Box.Visible = Config.ESP_Box and enemy
            Bill.Enabled = Config.ESP_Health and enemy
            local hum = char:FindFirstChild("Humanoid")
            if hum then 
                Bar.Size = UDim2.new(math.clamp(hum.Health/hum.MaxHealth, 0, 1), 0, 1, 0) 
                Bar.BackgroundColor3 = Color3.fromHSV((hum.Health/hum.MaxHealth) * 0.3, 1, 1)
            end
        end)
    end
    p.CharacterAdded:Connect(Setup); if p.Character then Setup() end
end

-- [[ INTERFACE ]] --
local function Launch()
    local UI = Instance.new("ScreenGui", CoreGui)
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 580, 0, 420); Main.Position = UDim2.new(0.5, -290, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(15,15,15); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 65)

    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1,0,0,40); Top.BackgroundColor3 = Color3.fromRGB(25,25,25); Top.BorderSizePixel = 0
    Instance.new("UICorner", Top)
    local drag, dragS, startP; Top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dragS = i.Position; startP = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dragS; Main.Position = UDim2.new(startP.X.Scale, startP.X.Offset+d.X, startP.Y.Scale, startP.Y.Offset+d.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

    local Close = Instance.new("TextButton", Top); Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.TextSize = 20
    Close.MouseButton1Click:Connect(function() Config.Active = false; UI:Destroy() end)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, -60); Sidebar.Position = UDim2.new(0, 10, 0, 50); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -60); Container.Position = UDim2.new(0, 160, 0, 50); Container.BackgroundTransparency = 1

    local function Tab(n)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; p.Visible = true end)
        return p
    end

    local T1 = Tab("Combat"); local T2 = Tab("Visuals"); local T3 = Tab("Movement"); local T4 = Tab("Keybinds"); local T5 = Tab("Settings")

    local function Toggle(p, t, k)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(1,-10,0,35); b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.Font = "Code"; Instance.new("UICorner", b)
        local function upd() b.Text = t.." : "..(Config[k] and "ON" or "OFF"); b.TextColor3 = Config[k] and Color3.new(0,1,0) or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[k] = not Config[k]; upd(); Save() end); upd()
    end

    Toggle(T1, "AIMBOT (LOCK)", "Aimbot"); Toggle(T1, "SHOW FOV", "ShowFOV")
    Toggle(T2, "ESP BOX", "ESP_Box"); Toggle(T2, "ESP HEALTH", "ESP_Health")
    Toggle(T3, "FLY", "Fly"); Toggle(T3, "NOCLIP", "NoClip"); Toggle(T3, "INVISIBLE", "Invisible")

    local LoadBtn = Instance.new("TextButton", T5); LoadBtn.Size = UDim2.new(1,-10,0,40); LoadBtn.Text = "LOADOUT : "..Config.CurrentLoadout; LoadBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); LoadBtn.TextColor3 = Color3.new(1,1,1); LoadBtn.Font = "Code"; Instance.new("UICorner", LoadBtn)
    LoadBtn.MouseButton1Click:Connect(function()
        local l = {"Legit", "Semi-Rage", "Full-Rage"}
        local i = table.find(l, Config.CurrentLoadout) or 1
        Config.CurrentLoadout = l[i+1] or l[1]
        for k, v in pairs(Presets[Config.CurrentLoadout]) do Config[k] = v end
        LoadBtn.Text = "LOADOUT : "..Config.CurrentLoadout; Save()
    end)

    -- [[ BOUCLE RENDU ]] --
    local FOV_D = Drawing.new("Circle"); FOV_D.Thickness = 1; FOV_D.Color = Color3.new(0,1,0); FOV_D.Transparency = 0.8
    RunService.RenderStepped:Connect(function()
        if not Config.Active then FOV_D:Remove(); return end
        FOV_D.Visible = Config.ShowFOV; FOV_D.Radius = Config.FOV; FOV_D.Position = UIS:GetMouseLocation()
        
        -- AIMBOT LOGIC
        if Config.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), Config.Smoothing)
            end
        end

        -- Character States
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if Config.Fly then
                    hrp.Velocity = Vector3.new(0, 2, 0)
                    local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                    if m.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (m * (Config.FlySpeed/12)) end
                end
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        if Config.NoClip then v.CanCollide = false end
                        if Config.Invisible and v.Name ~= "HumanoidRootPart" then v.Transparency = 1 elseif not Config.Invisible and v.Transparency == 1 then v.Transparency = 0 end
                    elseif v:IsA("Decal") then v.Transparency = Config.Invisible and 1 or 0 end
                end
            end
        end
    end)

    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode.Name == Config.MenuKey then Main.Visible = not Main.Visible end
        if i.KeyCode.Name == Config.TP_Key then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 45) end
        end
    end)

    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
    Players.PlayerAdded:Connect(CreateESP); T1.Visible = true
end

Launch()
