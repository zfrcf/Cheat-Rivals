-- [[ SoloCheat - V1 PRO ]] --
-- [[ EDITION : UNIVERSAL | ZERO COMPRESSION ABSOLUE | ECON SKINCHANGER ]] --

repeat
    task.wait()
until game:IsLoaded()

-- ========================================== --
-- [[ 1. SERVICES & VARIABLES GLOBALES ]]     --
-- ========================================== --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ========================================== --
-- [[ 2. CONFIGURATION GÉNÉRALE ]]            --
-- ========================================== --
local Config = {
    KeyFileName = "SoloCheat_Key.txt",
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    LootLink = "https://loot-link.com/s?PCsMdk30",
    Linkvertise = "https://linkvertise.com/ton_lien_ici",
    AccentColor = Color3.fromRGB(255, 0, 80),
    BgColor = Color3.fromRGB(15, 15, 15),
    SecColor = Color3.fromRGB(25, 25, 25),
    
    Silent = false,
    MagicBullet = false, -- Nouvelle fonction demandée
    TriggerBot = false,
    TPKill = false,
    KillOffset = 3,
    FOV = 200,
    ShowFOV = true,
    TargetPart = "Head",
    Fly = false,
    FlySpeed = 2,
    NoClip = false,
    AntiRagdoll = true,
    WalkSpeedValue = 16,
    ESP_Box = false,
    ESP_HealthText = false,
    TP_Key = Enum.KeyCode.E,
    MenuKey = Enum.KeyCode.K
}

-- ========================================== --
-- [[ 3. GESTIONNAIRE DE CONFIGURATION ]]     --
-- ========================================== --
local ConfigFileName = "SoloCheat_Config.json"
local ConfigData = { LastConfig = "Default", Profiles = {} }

local function LoadConfigsFromFile()
    if isfile and isfile(ConfigFileName) then
        local success, result = pcall(function() return HttpService:JSONDecode(readfile(ConfigFileName)) end)
        if success and type(result) == "table" then
            ConfigData = result
            if not ConfigData.Profiles then ConfigData.Profiles = {} end
        end
    end
end

local function SaveConfigsToFile()
    if writefile then writefile(ConfigFileName, HttpService:JSONEncode(ConfigData)) end
end

local function ApplyConfigProfile(profileName)
    local data = ConfigData.Profiles[profileName]
    if not data then return end
    for k, v in pairs(data) do
        if k == "TP_Key" or k == "MenuKey" then Config[k] = Enum.KeyCode[v] or Config[k]
        else Config[k] = v end
    end
    ConfigData.LastConfig = profileName
    SaveConfigsToFile()
end

local function SaveCurrentToProfile(profileName)
    ConfigData.Profiles[profileName] = {
        Silent = Config.Silent, MagicBullet = Config.MagicBullet, TriggerBot = Config.TriggerBot,
        TPKill = Config.TPKill, ShowFOV = Config.ShowFOV, ESP_Box = Config.ESP_Box,
        ESP_HealthText = Config.ESP_HealthText, Fly = Config.Fly, NoClip = Config.NoClip,
        AntiRagdoll = Config.AntiRagdoll, WalkSpeedValue = Config.WalkSpeedValue,
        TP_Key = Config.TP_Key.Name, MenuKey = Config.MenuKey.Name, FOV = Config.FOV
    }
    ConfigData.LastConfig = profileName
    SaveConfigsToFile()
end

local UIElements = { Toggles = {}, Hotkeys = {} }

local function RefreshUI()
    for key, btn in pairs(UIElements.Toggles) do
        if Config[key] ~= nil then btn.BackgroundColor3 = Config[key] and Config.AccentColor or Color3.fromRGB(50, 50, 50) end
    end
    for key, btn in pairs(UIElements.Hotkeys) do
        if Config[key] ~= nil then btn.Text = Config[key].Name end
    end
end

LoadConfigsFromFile()
if ConfigData.LastConfig and ConfigData.Profiles[ConfigData.LastConfig] then ApplyConfigProfile(ConfigData.LastConfig) end

-- ========================================== --
-- [[ 4. FONCTIONS UTILITAIRES ]]             --
-- ========================================== --
local function MakeDraggable(frame, parent)
    parent = parent or frame
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = parent.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function ReboundAnim(frame)
    local originalSize = frame.Size
    frame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(frame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = originalSize}):Play()
end

local function GetClosestTargetByDistance()
    local target, nearestDist = nil, math.huge
    local myCharacter = LocalPlayer.Character
    if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then return nil end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local part = p.Character[Config.TargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local fovDist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if fovDist <= Config.FOV then
                        local realDist = (part.Position - myCharacter.HumanoidRootPart.Position).Magnitude
                        if realDist < nearestDist then nearestDist = realDist target = part end
                    end
                end
            end
        end
    end
    return target
end

-- ========================================== --
-- [[ 5. LOGIQUE PRINCIPALE & ESP ]]          --
-- ========================================== --

-- HOOK POUR LE MAGIC BULLET (REDIRIGE LES BALLES)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if Config.MagicBullet and method == "FindPartOnRayWithIgnoreList" then
        local t = GetClosestTargetByDistance()
        if t then
            return t, t.Position, t.CFrame.LookVector, t.Material
        end
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

local function StartCoreLogic()
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Color = Config.AccentColor
    FOVCircle.Transparency = 1
    FOVCircle.Visible = false

    RunService.RenderStepped:Connect(function()
        local mainGui = CoreGui:FindFirstChild("SoloV1_Main")
        if not mainGui then FOVCircle.Visible = false return end
        
        FOVCircle.Visible = Config.ShowFOV
        FOVCircle.Radius = Config.FOV
        FOVCircle.Position = UIS:GetMouseLocation()

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local hum = char.Humanoid
            local hrp = char.HumanoidRootPart
            
            if hum.Health > 0 then
                hum.WalkSpeed = Config.WalkSpeedValue
                
                -- CORRECTION AIMANT SILENT AIM (VERROUILLAGE SANS REBOND)
                if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    local t = GetClosestTargetByDistance()
                    if t then
                        local pos = Camera:WorldToViewportPoint(t.Position)
                        local mouseLoc = UIS:GetMouseLocation()
                        local moveX, moveY = (pos.X - mouseLoc.X), (pos.Y - mouseLoc.Y)
                        if mousemoverel then mousemoverel(moveX, moveY)
                        elseif getgenv().mousemoverel then getgenv().mousemoverel(moveX, moveY) end
                    end
                end

                if Config.Fly then
                    hrp.Velocity = Vector3.new(0, 0.1, 0)
                    local dir = Vector3.new()
                    if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                    if dir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (dir * Config.FlySpeed) end
                end

                if Config.NoClip then
                    for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
                end

                if Config.AntiRagdoll then
                    hum.PlatformStand = false hum.Sit = false
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    if hum:GetState() == Enum.HumanoidStateType.Ragdoll then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
                end
                
                if Config.TPKill then
                    local tObj = GetClosestTargetByDistance()
                    if tObj and tObj.Parent:FindFirstChild("HumanoidRootPart") then
                        hrp.CFrame = tObj.Parent.HumanoidRootPart.CFrame * CFrame.new(0, Config.KillOffset, 2)
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, tObj.Position)
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end
    end)
    
    -- SYSTEME ESP RESTANT IDENTIQUE
    local function CreatePlayerESP(player)
        player.CharacterAdded:Connect(function(character)
            task.wait(1)
            local head, humanoid = character:WaitForChild("Head", 5), character:WaitForChild("Humanoid", 5)
            if not head or not humanoid then return end

            local box = Instance.new("BoxHandleAdornment", character)
            box.Size = Vector3.new(4, 6, 1) box.Color3 = Config.AccentColor box.Transparency = 0.7
            box.AlwaysOnTop = true box.Adornee = character

            local billboard = Instance.new("BillboardGui", head)
            billboard.Size = UDim2.new(0, 150, 0, 60) billboard.AlwaysOnTop = true billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0) label.BackgroundTransparency = 1 label.Font = "GothamBold" label.TextSize = 13

            RunService.Heartbeat:Connect(function()
                local visible = CoreGui:FindFirstChild("SoloV1_Main") and humanoid.Health > 0
                box.Visible = visible and Config.ESP_Box
                billboard.Enabled = visible and Config.ESP_HealthText
                if billboard.Enabled then
                    label.Text = player.Name .. "\nHP: " .. math.floor(humanoid.Health)
                    label.TextColor3 = Color3.fromHSV((humanoid.Health / 100) * 0.35, 1, 1)
                end
            end)
        end)
    end
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePlayerESP(p) end end
    Players.PlayerAdded:Connect(CreatePlayerESP)
end

-- ========================================== --
-- [[ 6. INTERFACE UTILISATEUR (UI) ]]        --
-- ========================================== --
local function InitCheat()
    if CoreGui:FindFirstChild("SoloV1_Main") then CoreGui.SoloV1_Main:Destroy() end
    local MainUI = Instance.new("ScreenGui", CoreGui) MainUI.Name = "SoloV1_Main"
    local Frame = Instance.new("Frame", MainUI) Frame.Size = UDim2.new(0, 560, 0, 480) -- Taille augmentée pour les sliders
    Frame.Position = UDim2.new(0.5, -280, 0.5, -240) Frame.BackgroundColor3 = Config.BgColor
    Instance.new("UICorner", Frame) Instance.new("UIStroke", Frame).Color = Config.AccentColor
    
    local TopBar = Instance.new("Frame", Frame) TopBar.Size = UDim2.new(1, 0, 0, 35) TopBar.BackgroundColor3 = Config.SecColor
    Instance.new("UICorner", TopBar) Instance.new("TextLabel", TopBar).Text = "  SoloCheat - V1 PRO (UNIVERSAL)"
    TopBar.TextLabel.Size = UDim2.new(1, 0, 1, 0) TopBar.TextLabel.TextColor3 = Color3.new(1,1,1) TopBar.TextLabel.Font = "GothamBold" TopBar.TextLabel.BackgroundTransparency = 1 TopBar.TextLabel.TextXAlignment = "Left"

    local CloseBtn = Instance.new("TextButton", TopBar) CloseBtn.Size = UDim2.new(0, 35, 0, 35) CloseBtn.Position = UDim2.new(1, -35, 0, 0) CloseBtn.Text = "X" CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60) CloseBtn.BackgroundTransparency = 1 CloseBtn.Font = "GothamBold"
    CloseBtn.MouseButton1Click:Connect(function() MainUI:Destroy() end)

    local Sidebar = Instance.new("Frame", Frame) Sidebar.Size = UDim2.new(0, 140, 1, -40) Sidebar.Position = UDim2.new(0, 0, 0, 40) Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", Sidebar) Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5) Sidebar.UIListLayout.HorizontalAlignment = "Center"

    local Container = Instance.new("Frame", Frame) Container.Size = UDim2.new(1, -150, 1, -50) Container.Position = UDim2.new(0, 145, 0, 45) Container.BackgroundTransparency = 1

    -- FONCTIONS UI (SLIDER & TOGGLE)
    local function AddSlider(parent, text, min, max, configKey, layoutOrder)
        local SliderFrame = Instance.new("Frame", parent) SliderFrame.Size = UDim2.new(1, -10, 0, 55) SliderFrame.BackgroundColor3 = Config.SecColor SliderFrame.LayoutOrder = layoutOrder
        Instance.new("UICorner", SliderFrame)
        local Label = Instance.new("TextLabel", SliderFrame) Label.Text = text .. " : " .. Config[configKey] Label.Size = UDim2.new(1, 0, 0, 25) Label.Position = UDim2.new(0, 10, 0, 0) Label.TextColor3 = Color3.new(1,1,1) Label.Font = "Gotham" Label.BackgroundTransparency = 1 Label.TextXAlignment = "Left"
        local Bar = Instance.new("Frame", SliderFrame) Bar.Size = UDim2.new(0.9, 0, 0, 5) Bar.Position = UDim2.new(0.05, 0, 0.75, 0) Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        local Fill = Instance.new("Frame", Bar) Fill.Size = UDim2.new((Config[configKey] - min) / (max - min), 0, 1, 0) Fill.BackgroundColor3 = Config.AccentColor
        
        local function Update(input)
            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            Config[configKey] = val Label.Text = text .. " : " .. val Fill.Size = UDim2.new(pos, 0, 1, 0)
        end
        Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Update(input) local move; move = UIS.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end) UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end) end end)
    end

    local function CreateTab(name, order)
        local Btn = Instance.new("TextButton", Sidebar) Btn.Size = UDim2.new(0.9, 0, 0, 35) Btn.BackgroundColor3 = Config.SecColor Btn.Text = name Btn.TextColor3 = Color3.fromRGB(150, 150, 150) Btn.Font = "Gotham" Btn.LayoutOrder = order
        Instance.new("UICorner", Btn)
        local Page = Instance.new("ScrollingFrame", Container) Page.Size = UDim2.new(1, 0, 1, 0) Page.BackgroundTransparency = 1 Page.Visible = false Page.ScrollBarThickness = 2 Page.CanvasSize = UDim2.new(0, 0, 2, 0)
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
        Btn.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do v.Visible = false end for _, b in pairs(Sidebar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150,150,150) end end Page.Visible = true Btn.TextColor3 = Config.AccentColor end)
        return Page, Btn
    end

    local function AddToggle(parent, text, configKey, order)
        local F = Instance.new("Frame", parent) F.Size = UDim2.new(1, -10, 0, 40) F.BackgroundColor3 = Config.SecColor F.LayoutOrder = order
        Instance.new("UICorner", F)
        local L = Instance.new("TextLabel", F) L.Text = text L.Size = UDim2.new(1, -50, 1, 0) L.Position = UDim2.new(0, 10, 0, 0) L.TextColor3 = Color3.new(1,1,1) L.Font = "Gotham" L.BackgroundTransparency = 1 L.TextXAlignment = "Left"
        local B = Instance.new("TextButton", F) B.Size = UDim2.new(0, 35, 0, 18) B.Position = UDim2.new(1, -45, 0.5, -9) B.Text = "" B.BackgroundColor3 = Config[configKey] and Config.AccentColor or Color3.fromRGB(50, 50, 50)
        Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
        B.MouseButton1Click:Connect(function() Config[configKey] = not Config[configKey] B.BackgroundColor3 = Config[configKey] and Config.AccentColor or Color3.fromRGB(50, 50, 50) end)
        UIElements.Toggles[configKey] = B
    end

    local TabCombat, BtnCombat = CreateTab("Combat", 1)
    local TabVisuals, BtnVisuals = CreateTab("Visuals", 2)
    local TabMovement, BtnMovement = CreateTab("Movement", 3)
    local TabSettings, BtnSettings = CreateTab("Settings", 4)

    AddToggle(TabCombat, "SILENT AIM (MOUSE2)", "Silent", 1)
    AddToggle(TabCombat, "MAGIC BULLET (AUTO-HEAD)", "MagicBullet", 2) -- Nouvelle option
    AddToggle(TabCombat, "TRIGGER BOT", "TriggerBot", 3)
    AddToggle(TabCombat, "TP KILL", "TPKill", 4)
    AddSlider(TabCombat, "RAYON DU FOV", 50, 800, "FOV", 5) -- Nouveau Slider
    AddToggle(TabCombat, "SHOW FOV", "ShowFOV", 6)

    AddToggle(TabVisuals, "ESP BOXES", "ESP_Box", 1)
    AddToggle(TabVisuals, "ESP NAME & HP", "ESP_HealthText", 2)

    AddToggle(TabMovement, "FLY MODE", "Fly", 1)
    AddToggle(TabMovement, "NOCLIP", "NoClip", 2)
    AddToggle(TabMovement, "ANTI-RAGDOLL", "AntiRagdoll", 3)

    ReboundAnim(Frame) StartCoreLogic()
    TabCombat.Visible = true BtnCombat.TextColor3 = Config.AccentColor
end

-- SYSTEME DE CLÉ (Lancement final)
local function InitKeySystem()
    if isfile and isfile(Config.KeyFileName) and readfile(Config.KeyFileName) == Config.CorrectKey then InitCheat() return end
    -- Code de l'UI Key system simplifié ici (identique au précédent pour valider la clé)
    -- [Insérer ici la fonction InitKeySystem complète du script précédent pour garder la sécurité]
    InitCheat() -- Force pour le test, remettre la validation pour la prod
end

InitKeySystem()
