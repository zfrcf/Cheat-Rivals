-- [[ SoloCheat - V1 OMNIPOTENT // THE ABSOLUTE FINAL ]] --
-- [[ 100% UNBUGGED | LEGACY CORE | ALL FEATURES RESTORED ]] --

repeat task.wait() until game:IsLoaded()

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION INTEGRALE ]] --
local Config = {
    Active = true,
    Visible = true,
    ConfigFile = "SoloCheat_Final_Master.json",
    
    -- Combat
    Silent = false,
    FOV = 150,
    ShowFOV = true,
    TargetPart = "Head",
    
    -- Visuals
    ESP_Box = false,
    ESP_Health = false,
    ESP_Names = false,
    
    -- Movement / Physics
    Fly = false,
    FlySpeed = 60,
    NoClip = false,
    Invisible = false,
    
    -- Keybinds
    TP_Key = "E",
    MenuKey = "K",
    
    -- Loadout Preset
    CurrentLoadout = "Legit"
}

-- [[ PRESETS DE TRICHE (PROFILS) ]] --
local Presets = {
    ["Legit"] = {Silent = true, FOV = 100, ESP_Box = true, ESP_Health = true, Fly = false, NoClip = false, Invisible = false},
    ["Semi-Rage"] = {Silent = true, FOV = 350, ESP_Box = true, ESP_Health = true, Fly = true, FlySpeed = 80, NoClip = false, Invisible = false},
    ["Full-Rage"] = {Silent = true, FOV = 800, ESP_Box = true, ESP_Health = true, Fly = true, FlySpeed = 150, NoClip = true, Invisible = true}
}

-- [[ GESTION DE LA SAUVEGARDE ]] --
local function SaveSettings()
    if writefile then
        local success, encoded = pcall(function() return HttpService:JSONEncode(Config) end)
        if success then writefile(Config.ConfigFile, encoded) end
    end
end

local function LoadSettings()
    if isfile and isfile(Config.ConfigFile) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(Config.ConfigFile)) end)
        if success then for i, v in pairs(decoded) do Config[i] = v end end
    end
end
LoadSettings()

-- [[ MOTEUR SILENT AIM (LEGACY VERSION - LA MEILLEURE) ]] --
local function GetClosestPlayer()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            local isEnemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            
            if hum and hum.Health > 0 and isEnemy then
                local head = p.Character[Config.TargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local mousePos = UIS:GetMouseLocation()
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    
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

-- [[ SYSTEME ESP (STABLE & REPETABLE) ]] --
local function CreateESP(player)
    local function SetupESP()
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart", 15)
        local head = char:WaitForChild("Head", 15)
        if not root or not head then return end

        -- Box Adorment
        local Box = Instance.new("BoxHandleAdornment", CoreGui)
        Box.Name = player.Name.."_ESP_Box"
        Box.AlwaysOnTop = true
        Box.ZIndex = 10
        Box.Size = Vector3.new(4, 6, 0.1)
        Box.Transparency = 0.5
        Box.Color3 = Color3.fromRGB(0, 255, 65)
        Box.Adornee = root

        -- Billboard UI (Santé & Nom)
        local Bill = Instance.new("BillboardGui", CoreGui)
        Bill.Name = player.Name.."_ESP_UI"
        Bill.AlwaysOnTop = true
        Bill.Size = UDim2.new(0, 100, 0, 40)
        Bill.Adornee = head
        Bill.ExtentsOffset = Vector3.new(0, 3, 0)
        
        local HealthBarBG = Instance.new("Frame", Bill)
        HealthBarBG.Size = UDim2.new(1, 0, 0, 8)
        HealthBarBG.Position = UDim2.new(0, 0, 0, 0)
        HealthBarBG.BackgroundColor3 = Color3.new(0, 0, 0)
        HealthBarBG.BorderSizePixel = 0
        
        local HealthBar = Instance.new("Frame", HealthBarBG)
        HealthBar.Size = UDim2.new(1, 0, 1, 0)
        HealthBar.BackgroundColor3 = Color3.new(0, 1, 0)
        HealthBar.BorderSizePixel = 0
        
        local NameLabel = Instance.new("TextLabel", Bill)
        NameLabel.Size = UDim2.new(1, 0, 0, 20)
        NameLabel.Position = UDim2.new(0, 0, 0, -25)
        NameLabel.BackgroundTransparency = 1
        NameLabel.TextColor3 = Color3.new(1, 1, 1)
        NameLabel.Font = Enum.Font.Code
        NameLabel.TextSize = 14
        NameLabel.TextStrokeTransparency = 0

        -- Mise à jour ESP
        local conn; conn = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not Config.Active then
                Box:Destroy(); Bill:Destroy(); conn:Disconnect(); return
            end
            
            local isAlly = (player.Team == LocalPlayer.Team and player.Team ~= nil)
            Box.Visible = Config.ESP_Box and not isAlly
            Bill.Enabled = (Config.ESP_Health or Config.ESP_Names) and not isAlly
            
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                HealthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                HealthBar.BackgroundColor3 = Color3.fromHSV(healthPercent * 0.3, 1, 1)
                HealthBar.Visible = Config.ESP_Health
                
                NameLabel.Text = player.Name .. " [" .. math.floor(hum.Health) .. "]"
                NameLabel.Visible = Config.ESP_Names
            end
        end)
    end
    player.CharacterAdded:Connect(SetupESP)
    if player.Character then SetupESP() end
end

-- [[ INTERFACE UTILISATEUR (GUI) ]] --
local function BuildUI()
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "SoloCheat_Omnipotent"
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Color3.fromRGB(0, 255, 65); MainStroke.Thickness = 2

    -- Top Bar (Deplacement + Croix)
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.BorderSizePixel = 0
    Instance.new("UICorner", TopBar)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "SOLO CHEAT // V1 MASTER CONTROL"; Title.Font = "Code"; Title.TextColor3 = Color3.new(1,1,1); Title.Size = UDim2.new(1,-100,1,0); Title.Position = UDim2.new(0,15,0,0); Title.TextXAlignment = 0; Title.BackgroundTransparency = 1; Title.TextSize = 18

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -40, 0.5, -17); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,0,0); CloseBtn.Font = "Code"; CloseBtn.TextSize = 25; CloseBtn.BackgroundTransparency = 1
    CloseBtn.MouseButton1Click:Connect(function() Config.Active = false; ScreenGui:Destroy() end)

    -- Drag System
    local drag, dragInput, startPos, startInputPos
    TopBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; startInputPos = input.Position; startPos = MainFrame.Position end end)
    UIS.InputChanged:Connect(function(input) if drag and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - startInputPos; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

    -- Tabs System
    local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Size = UDim2.new(0, 140, 1, -60); Sidebar.Position = UDim2.new(0, 10, 0, 50); Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", MainFrame); Container.Size = UDim2.new(1, -170, 1, -60); Container.Position = UDim2.new(0, 160, 0, 50); Container.BackgroundTransparency = 1

    local function CreateTab(name)
        local btn = Instance.new("TextButton", Sidebar); btn.Size = UDim2.new(1, 0, 0, 35); btn.Text = name:upper(); btn.BackgroundColor3 = Color3.fromRGB(30,30,30); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "Code"; Instance.new("UICorner", btn)
        local page = Instance.new("ScrollingFrame", Container); page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1; page.ScrollBarThickness = 2; Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; page.Visible = true end)
        return page
    end

    local TabComb = CreateTab("Combat"); local TabVis = CreateTab("Visuals"); local TabMov = CreateTab("Movement"); local TabKeys = CreateTab("Keybinds"); local TabSet = CreateTab("Settings")

    -- UI Helpers
    local function AddToggle(parent, txt, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 38); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Font = "Code"; b.TextSize = 14; Instance.new("UICorner", b)
        local function upd() b.Text = txt .. " : " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Config[key] and Color3.new(0,1,0) or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; upd(); SaveSettings() end); upd()
    end

    local function AddBind(parent, txt, key)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1,-10,0,38); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6,0,1,0); l.Text = txt; l.TextColor3 = Color3.new(1,1,1); l.Font = "Code"; l.TextXAlignment = 0; l.BackgroundTransparency = 1
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0,90,0,28); b.Position = UDim2.new(1,-95,0.5,-14); b.Text = "["..Config[key].."]"; b.Font = "Code"; b.BackgroundColor3 = Color3.fromRGB(45,45,45); b.TextColor3 = Color3.new(0,1,0); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() b.Text = "..."; local c; c = UIS.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Keyboard then Config[key] = i.KeyCode.Name; b.Text = "["..i.KeyCode.Name.."]"; SaveSettings(); c:Disconnect() end end) end)
    end

    -- Combat & Visuals
    AddToggle(TabComb, "SILENT AIM", "Silent"); AddToggle(TabComb, "SHOW FOV CIRCLE", "ShowFOV")
    AddToggle(TabVis, "ESP BOXES", "ESP_Box"); AddToggle(TabVis, "ESP HEALTHBAR", "ESP_Health"); AddToggle(TabVis, "ESP NAMES", "ESP_Names")
    
    -- Movement & Physics
    AddToggle(TabMov, "FLY ENABLED", "Fly"); AddToggle(TabMov, "NOCLIP (WALL)", "NoClip"); AddToggle(TabMov, "GHOST INVISIBLE", "Invisible")
    
    -- Keybinds
    AddBind(TabKeys, "OPEN/CLOSE MENU", "MenuKey"); AddBind(TabKeys, "BLINK TP (FRONT)", "TP_Key")

    -- Settings (Presets)
    local LoadoutBtn = Instance.new("TextButton", TabSet); LoadoutBtn.Size = UDim2.new(1, -10, 0, 45); LoadoutBtn.Text = "ACTIVE PROFILE : " .. Config.CurrentLoadout; LoadoutBtn.BackgroundColor3 = Color3.fromRGB(0, 50, 0); LoadoutBtn.TextColor3 = Color3.new(1,1,1); LoadoutBtn.Font = "Code"; Instance.new("UICorner", LoadoutBtn)
    LoadoutBtn.MouseButton1Click:Connect(function()
        local order = {"Legit", "Semi-Rage", "Full-Rage"}
        local currentIdx = table.find(order, Config.CurrentLoadout) or 1
        Config.CurrentLoadout = order[currentIdx + 1] or order[1]
        for k, v in pairs(Presets[Config.CurrentLoadout]) do Config[k] = v end
        LoadoutBtn.Text = "ACTIVE PROFILE : " .. Config.CurrentLoadout; SaveSettings()
    end)

    -- [[ BOUCLE DE RENDU ET LOGIQUE BRUTE ]] --
    local FOV_Drawing = Drawing.new("Circle")
    FOV_Drawing.Thickness = 1; FOV_Drawing.Color = Color3.fromRGB(0, 255, 65); FOV_Drawing.Transparency = 0.8; FOV_Drawing.Filled = false

    RunService.RenderStepped:Connect(function()
        if not Config.Active then FOV_Drawing:Remove(); return end
        
        -- FOV Update
        FOV_Drawing.Visible = Config.ShowFOV
        FOV_Drawing.Radius = Config.FOV
        FOV_Drawing.Position = UIS:GetMouseLocation()
        
        -- Silent Aim Legacy (Direct Mouse Move)
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestPlayer()
            if t then
                local screenPos = Camera:WorldToViewportPoint(t.Position)
                local mousePos = UIS:GetMouseLocation()
                mousemoverel((screenPos.X - mousePos.X) / 1.8, (screenPos.Y - mousePos.Y) / 1.8)
            end
        end

        -- Player State (Fly, Noclip, Invis)
        local character = LocalPlayer.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Fly
                if Config.Fly then
                    hrp.Velocity = Vector3.new(0, 2, 0)
                    local dir = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                    if dir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (dir * (Config.FlySpeed/12)) end
                end
                
                -- Perma-Loop Noclip & Invis (Force check every frame)
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if Config.NoClip then part.CanCollide = false end
                        if Config.Invisible and part.Name ~= "HumanoidRootPart" then 
                            part.Transparency = 1 
                        elseif not Config.Invisible and part.Transparency == 1 then
                            part.Transparency = 0
                        end
                    elseif part:IsA("Decal") then
                        part.Transparency = Config.Invisible and 1 or 0
                    end
                end
            end
        end
    end)

    -- [[ KEYBOARD LISTENERS ]] --
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode.Name == Config.MenuKey then
            MainFrame.Visible = not MainFrame.Visible
        end
        if input.KeyCode.Name == Config.TP_Key then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 45)
            end
        end
    end)

    -- Initialisation ESP pour les joueurs existants
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
    Players.PlayerAdded:Connect(CreateESP)
    
    TabComb.Visible = true
end

LaunchCheat = BuildUI
LaunchCheat()
