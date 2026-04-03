-- [[ SoloCheat - V1 PRO ]] --
-- [[ EDITION : RIVALS ULTIMATE | ZERO COMPRESSION | ECON SKINCHANGER ]] --

repeat task.wait() until game:IsLoaded()

-- ========================================== --
-- [[ 1. SÉCURITÉ : VÉRIFICATION RIVALS ]]    --
-- ========================================== --
-- ========================================== --
-- [[ 2. SERVICES & VARIABLES GLOBALES ]]     --
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
-- [[ 3. CONFIGURATION GÉNÉRALE ]]            --
-- ========================================== --
local Config = {
    -- Fichier Key et Thème
    KeyFileName = "SoloCheat_Key.txt",
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    AccentColor = Color3.fromRGB(255, 0, 80),
    BgColor = Color3.fromRGB(15, 15, 15),
    SecColor = Color3.fromRGB(25, 25, 25),
    
    -- Variables Actives
    Silent = false,
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
-- [[ 4. GESTIONNAIRE DE CONFIGURATION ]]     --
-- ========================================== --
local ConfigFileName = "SoloCheat_Config.json"
local ConfigData = {
    LastConfig = "Default",
    Profiles = {}
}

local function LoadConfigsFromFile()
    if isfile and isfile(ConfigFileName) and readfile then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigFileName))
        end)
        if success and type(result) == "table" then
            ConfigData = result
            if not ConfigData.Profiles then 
                ConfigData.Profiles = {} 
            end
        end
    end
end

local function SaveConfigsToFile()
    if writefile then
        local json = HttpService:JSONEncode(ConfigData)
        writefile(ConfigFileName, json)
    end
end

local function ApplyConfigProfile(profileName)
    local data = ConfigData.Profiles[profileName]
    if not data then return end
    
    for k, v in pairs(data) do
        if k == "TP_Key" or k == "MenuKey" then
            Config[k] = Enum.KeyCode[v] or Config[k]
        else
            Config[k] = v
        end
    end
    ConfigData.LastConfig = profileName
    SaveConfigsToFile()
end

local function SaveCurrentToProfile(profileName)
    ConfigData.Profiles[profileName] = {
        Silent = Config.Silent,
        TriggerBot = Config.TriggerBot,
        TPKill = Config.TPKill,
        ShowFOV = Config.ShowFOV,
        ESP_Box = Config.ESP_Box,
        ESP_HealthText = Config.ESP_HealthText,
        Fly = Config.Fly,
        NoClip = Config.NoClip,
        AntiRagdoll = Config.AntiRagdoll,
        WalkSpeedValue = Config.WalkSpeedValue,
        TP_Key = Config.TP_Key.Name,
        MenuKey = Config.MenuKey.Name
    }
    ConfigData.LastConfig = profileName
    SaveConfigsToFile()
end

local UIElements = {
    Toggles = {},
    Hotkeys = {}
}

local function RefreshUI()
    for key, btn in pairs(UIElements.Toggles) do
        if Config[key] ~= nil then
            btn.BackgroundColor3 = Config[key] and Config.AccentColor or Color3.fromRGB(50, 50, 50)
        end
    end
    for key, btn in pairs(UIElements.Hotkeys) do
        if Config[key] ~= nil then
            btn.Text = Config[key].Name
        end
    end
end

LoadConfigsFromFile()
if ConfigData.LastConfig and ConfigData.Profiles[ConfigData.LastConfig] then
    ApplyConfigProfile(ConfigData.LastConfig)
end

-- ========================================== --
-- [[ 5. FONCTIONS UTILITAIRES ]]             --
-- ========================================== --
local function MakeDraggable(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function ReboundAnim(frame)
    local originalSize = frame.Size
    frame.Size = UDim2.new(0, 0, 0, 0)
    
    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
    local tween = TweenService:Create(frame, tweenInfo, {Size = originalSize})
    tween:Play()
end

local function GetClosestTargetByDistance()
    local target = nil
    local nearestDist = math.huge
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    
    if not myRoot then return nil end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local enemyPart = p.Character:FindFirstChild(Config.TargetPart)
            local hum = p.Character:FindFirstChild("Humanoid")
            
            if enemyPart and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(enemyPart.Position)
                
                if onScreen then
                    local mousePos = UIS:GetMouseLocation()
                    local fovDist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    
                    if fovDist <= Config.FOV then
                        local realDist = (enemyPart.Position - myRoot.Position).Magnitude
                        if realDist < nearestDist then
                            nearestDist = realDist
                            target = enemyPart
                        end
                    end
                end
            end
        end
    end
    return target
end

-- ========================================== --
-- [[ 6. LOGIQUE PRINCIPALE & ESP ]]          --
-- ========================================== --
local function StartCoreLogic()
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Color = Config.AccentColor
    FOVCircle.Transparency = 1
    FOVCircle.Visible = false

    RunService.RenderStepped:Connect(function()
        if not CoreGui:FindFirstChild("SoloV1_Main") then 
            FOVCircle.Visible = false 
            return 
        end
        
        FOVCircle.Visible = Config.ShowFOV
        FOVCircle.Radius = Config.FOV
        FOVCircle.Position = UIS:GetMouseLocation()

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if char and hum and hrp and hum.Health > 0 then
            
            hum.WalkSpeed = Config.WalkSpeedValue

            if Config.Fly then
                hrp.Velocity = Vector3.new(0, 0.1, 0)
                local dir = Vector3.new()
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if dir.Magnitude > 0 then 
                    hrp.CFrame = hrp.CFrame + (dir * Config.FlySpeed) 
                end
            end

            if Config.NoClip then
                for _, v in pairs(char:GetDescendants()) do 
                    if v:IsA("BasePart") then v.CanCollide = false end 
                end
            end

            if Config.AntiRagdoll then
                hum.PlatformStand = false
                hum.Sit = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                if hum:GetState() == Enum.HumanoidStateType.Ragdoll then 
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
                end
            end

            if Config.TriggerBot then
                local target = Mouse.Target
                if target and target.Parent then
                    local targetHum = target.Parent:FindFirstChild("Humanoid")
                    if targetHum and targetHum.Health > 0 then
                        local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
                        if targetPlayer and targetPlayer ~= LocalPlayer then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then 
                                tool:Activate() 
                            elseif mouse1click then 
                                mouse1click() 
                            end
                        end
                    end
                end
            end

            if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local t = GetClosestTargetByDistance()
                if t and (mousemoverel or getgenv().mousemoverel) then
                    local m = mousemoverel or getgenv().mousemoverel
                    local pos = Camera:WorldToViewportPoint(t.Position)
                    m(pos.X - UIS:GetMouseLocation().X, pos.Y - UIS:GetMouseLocation().Y)
                end
            end

            if Config.TPKill then
                local tObj = GetClosestTargetByDistance()
                if tObj and tObj.Parent and tObj.Parent:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = tObj.Parent.HumanoidRootPart
                    hrp.CFrame = targetRoot.CFrame * CFrame.new(0, Config.KillOffset, 2)
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, tObj.Position)
                    
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then 
                        tool:Activate() 
                    elseif mouse1click then 
                        mouse1click() 
                    end
                end
            end
        end
    end)

    local function CreatePlayerESP(player)
        player.CharacterAdded:Connect(function(character)
            task.wait(1)
            local head = character:WaitForChild("Head", 5)
            local humanoid = character:WaitForChild("Humanoid", 5)
            if not head or not humanoid then return end

            local box = Instance.new("BoxHandleAdornment")
            box.Name = "SoloCheat_Box"
            box.Adornee = character
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = Vector3.new(4, 6, 1)
            box.Color3 = Config.AccentColor
            box.Transparency = 0.7
            box.Parent = character
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "SoloCheat_Bill"
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 150, 0, 60)
            billboard.AlwaysOnTop = true
            billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
            billboard.Parent = head
            
            local label = Instance.new("TextLabel")
            label.Name = "NameLabel"
            label.Parent = billboard
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 13
            label.TextStrokeTransparency = 0

            local connection
            connection = RunService.Heartbeat:Connect(function()
                if not CoreGui:FindFirstChild("SoloV1_Main") then 
                    box.Visible = false
                    billboard.Enabled = false
                    connection:Disconnect()
                    return 
                end

                if character and humanoid and humanoid.Health > 0 then
                    box.Visible = Config.ESP_Box
                    billboard.Enabled = Config.ESP_HealthText
                    if billboard.Enabled then
                        label.Text = player.Name .. "\nHP: " .. math.floor(humanoid.Health)
                        label.TextColor3 = Color3.fromHSV(humanoid.Health/100 * 0.35, 1, 1)
                    end
                else
                    box.Visible = false
                    billboard.Enabled = false
                end
            end)
        end)
    end

    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer then CreatePlayerESP(p) end 
    end
    Players.PlayerAdded:Connect(CreatePlayerESP)
end

-- ========================================== --
-- [[ 7. INTERFACE UTILISATEUR (UI) ]]        --
-- ========================================== --
local function InitCheat()
    if CoreGui:FindFirstChild("SoloV1_Main") then CoreGui.SoloV1_Main:Destroy() end

    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "SoloV1_Main"
    MainUI.Parent = CoreGui
    
    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Parent = MainUI
    Frame.Size = UDim2.new(0, 560, 0, 450)
    Frame.Position = UDim2.new(0.5, -280, 0.5, -225)
    Frame.BackgroundColor3 = Config.BgColor
    Frame.ClipsDescendants = true
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.Parent = Frame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Frame
    Stroke.Color = Config.AccentColor
    Stroke.Thickness = 1.5
    MakeDraggable(Frame)

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = Frame
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Config.SecColor
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.Parent = TopBar
    MakeDraggable(TopBar, Frame)
    
    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "  SoloCheat - V1 PRO (RIVALS)"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.MouseButton1Click:Connect(function() MainUI:Destroy() end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Frame
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.Parent = Sidebar
    
    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Parent = Sidebar
    SideLayout.Padding = UDim.new(0, 5)
    SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = Frame
    Container.Size = UDim2.new(1, -150, 1, -50)
    Container.Position = UDim2.new(0, 145, 0, 45)
    Container.BackgroundTransparency = 1

    local function CreateTab(name, layoutOrder)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundColor3 = Config.SecColor
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.LayoutOrder = layoutOrder
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.Parent = TabBtn
        
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Container
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.CanvasSize = UDim2.new(0, 0, 3, 0)
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do 
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, b in pairs(Sidebar:GetChildren()) do 
                if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end 
            end
            Page.Visible = true
            TabBtn.TextColor3 = Config.AccentColor
        end)
        
        return Page, TabBtn
    end

    local function AddToggle(parent, text, configKey, layoutOrder)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Parent = parent
        ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
        ToggleFrame.BackgroundColor3 = Config.SecColor
        ToggleFrame.LayoutOrder = layoutOrder
        
        local Corner = Instance.new("UICorner")
        Corner.Parent = ToggleFrame
        
        local Label = Instance.new("TextLabel")
        Label.Parent = ToggleFrame
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local Btn = Instance.new("TextButton")
        Btn.Parent = ToggleFrame
        Btn.Size = UDim2.new(0, 35, 0, 18)
        Btn.Position = UDim2.new(1, -45, 0.5, -9)
        Btn.Text = ""
        Btn.BackgroundColor3 = Config[configKey] and Config.AccentColor or Color3.fromRGB(50, 50, 50)
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.Parent = Btn
        BtnCorner.CornerRadius = UDim.new(1, 0)
        
        Btn.MouseButton1Click:Connect(function() 
            Config[configKey] = not Config[configKey]
            Btn.BackgroundColor3 = Config[configKey] and Config.AccentColor or Color3.fromRGB(50, 50, 50) 
        end)
        
        UIElements.Toggles[configKey] = Btn
    end

    local function AddHotkey(parent, text, configKey, layoutOrder)
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Parent = parent
        KeyFrame.Size = UDim2.new(1, -10, 0, 40)
        KeyFrame.BackgroundColor3 = Config.SecColor
        KeyFrame.LayoutOrder = layoutOrder
        
        local Corner = Instance.new("UICorner")
        Corner.Parent = KeyFrame
        
        local Label = Instance.new("TextLabel")
        Label.Parent = KeyFrame
        Label.Size = UDim2.new(1, -100, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local Btn = Instance.new("TextButton")
        Btn.Parent = KeyFrame
        Btn.Size = UDim2.new(0, 80, 0, 25)
        Btn.Position = UDim2.new(1, -90, 0.5, -12.5)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Btn.Text = Config[configKey].Name
        Btn.TextColor3 = Config.AccentColor
        Btn.Font = Enum.Font.GothamBold
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.Parent = Btn
        
        Btn.MouseButton1Click:Connect(function()
            Btn.Text = "..."
            local connection
            connection = UIS.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then 
                    Config[configKey] = input.KeyCode
                    Btn.Text = input.KeyCode.Name
                    connection:Disconnect() 
                end
            end)
        end)
        
        UIElements.Hotkeys[configKey] = Btn
    end

    -- Création des Pages
    local TabCombat, BtnCombat = CreateTab("Combat", 1)
    local TabVisuals, BtnVisuals = CreateTab("Visuals", 2)
    local TabMovement, BtnMovement = CreateTab("Movement", 3)
    local TabSkin, BtnSkin = CreateTab("SkinChanger", 4)
    local TabSettings, BtnSettings = CreateTab("Settings", 5)

    -- ONGLET COMBAT
    AddToggle(TabCombat, "TRIGGER BOT (AUTO-FIRE)", "TriggerBot", 1)
    AddToggle(TabCombat, "SILENT AIM (MOUSE2)", "Silent", 2)
    AddToggle(TabCombat, "TP KILL (AUTO-EXECUTE)", "TPKill", 3)
    AddToggle(TabCombat, "SHOW FOV CIRCLE", "ShowFOV", 4)

    -- ONGLET VISUALS
    AddToggle(TabVisuals, "ESP BOXES", "ESP_Box", 1)
    AddToggle(TabVisuals, "ESP NAME & HP", "ESP_HealthText", 2)

    -- ONGLET MOVEMENT
    local SpeedBtn = Instance.new("TextButton")
    SpeedBtn.Parent = TabMovement
    SpeedBtn.Size = UDim2.new(1, -10, 0, 40)
    SpeedBtn.BackgroundColor3 = Config.SecColor
    SpeedBtn.Text = "TOGGLE SPEED (45)"
    SpeedBtn.TextColor3 = Color3.new(1, 1, 1)
    SpeedBtn.Font = Enum.Font.Gotham
    SpeedBtn.LayoutOrder = 1
    
    local SpeedCorner = Instance.new("UICorner")
    SpeedCorner.Parent = SpeedBtn
    
    SpeedBtn.MouseButton1Click:Connect(function() 
        Config.WalkSpeedValue = (Config.WalkSpeedValue == 16) and 45 or 16 
    end)

    AddToggle(TabMovement, "FLY MODE (CFRAME)", "Fly", 2)
    AddToggle(TabMovement, "NOCLIP (ANTI-WALL)", "NoClip", 3)
    AddToggle(TabMovement, "ANTI-RAGDOLL", "AntiRagdoll", 4)

    -- ONGLET SKINCHANGER (EconRCO)
    local SkinLabel = Instance.new("TextLabel")
    SkinLabel.Parent = TabSkin
    SkinLabel.Size = UDim2.new(1, -10, 0, 50)
    SkinLabel.BackgroundTransparency = 1
    SkinLabel.Text = "RIVALS SKINCHANGER SYSTEM (ECON)"
    SkinLabel.TextColor3 = Color3.new(1, 1, 1)
    SkinLabel.Font = Enum.Font.GothamBold
    SkinLabel.TextWrapped = true

    local RunSkinBtn = Instance.new("TextButton")
    RunSkinBtn.Parent = TabSkin
    RunSkinBtn.Size = UDim2.new(1, -10, 0, 45)
    RunSkinBtn.BackgroundColor3 = Config.AccentColor
    RunSkinBtn.Text = "ACTIVER LE SKINCHANGER"
    RunSkinBtn.TextColor3 = Color3.new(1, 1, 1)
    RunSkinBtn.Font = Enum.Font.GothamBold
    
    local RunSkinCorner = Instance.new("UICorner")
    RunSkinCorner.Parent = RunSkinBtn

    RunSkinBtn.MouseButton1Click:Connect(function()
        RunSkinBtn.Text = "CHARGEMENT..."
        local success, err = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EconRCO/Econ/refs/heads/main/Init'))()
        end)
        
        if success then 
            RunSkinBtn.Text = "SKINS ACTIFS ✅" 
            RunSkinBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        else 
            RunSkinBtn.Text = "ERREUR ❌" 
            warn(err) 
        end
    end)

    -- ONGLET SETTINGS
    local ConfigTitle = Instance.new("TextLabel")
    ConfigTitle.Parent = TabSettings
    ConfigTitle.Size = UDim2.new(1, -10, 0, 20)
    ConfigTitle.BackgroundTransparency = 1
    ConfigTitle.Text = "CONFIG MANAGER"
    ConfigTitle.TextColor3 = Config.AccentColor
    ConfigTitle.Font = Enum.Font.GothamBold
    ConfigTitle.LayoutOrder = 1

    local ConfigContainer = Instance.new("Frame")
    ConfigContainer.Parent = TabSettings
    ConfigContainer.Size = UDim2.new(1, -10, 0, 90)
    ConfigContainer.BackgroundColor3 = Config.SecColor
    ConfigContainer.LayoutOrder = 2
    ConfigContainer.ClipsDescendants = true
    
    local ConfigCorner = Instance.new("UICorner")
    ConfigCorner.Parent = ConfigContainer
    
    local ConfigBox = Instance.new("TextBox")
    ConfigBox.Parent = ConfigContainer
    ConfigBox.Size = UDim2.new(0.6, -5, 0, 30)
    ConfigBox.Position = UDim2.new(0, 10, 0, 10)
    ConfigBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ConfigBox.TextColor3 = Color3.new(1, 1, 1)
    ConfigBox.PlaceholderText = "Nom de la config..."
    ConfigBox.Text = ConfigData.LastConfig ~= "Default" and ConfigData.LastConfig or ""
    ConfigBox.Font = Enum.Font.Gotham
    
    local ConfigBoxCorner = Instance.new("UICorner")
    ConfigBoxCorner.Parent = ConfigBox

    local SaveConfigBtn = Instance.new("TextButton")
    SaveConfigBtn.Parent = ConfigContainer
    SaveConfigBtn.Size = UDim2.new(0.4, -25, 0, 30)
    SaveConfigBtn.Position = UDim2.new(0.6, 15, 0, 10)
    SaveConfigBtn.BackgroundColor3 = Config.AccentColor
    SaveConfigBtn.Text = "SAUVEGARDER"
    SaveConfigBtn.TextColor3 = Color3.new(1, 1, 1)
    SaveConfigBtn.Font = Enum.Font.GothamBold
    
    local SaveConfigCorner = Instance.new("UICorner")
    SaveConfigCorner.Parent = SaveConfigBtn

    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Parent = ConfigContainer
    DropdownBtn.Size = UDim2.new(1, -20, 0, 30)
    DropdownBtn.Position = UDim2.new(0, 10, 0, 50)
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownBtn.Text = "CONFIG : " .. ConfigData.LastConfig .. " ▼"
    DropdownBtn.TextColor3 = Color3.new(1, 1, 1)
    DropdownBtn.Font = Enum.Font.GothamBold
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.Parent = DropdownBtn

    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Parent = ConfigContainer
    DropdownList.Size = UDim2.new(1, -20, 0, 80)
    DropdownList.Position = UDim2.new(0, 10, 0, 85)
    DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownList.Visible = false
    DropdownList.ScrollBarThickness = 2
    
    local DropdownListLayout = Instance.new("UIListLayout")
    DropdownListLayout.Parent = DropdownList
    DropdownListLayout.Padding = UDim.new(0, 2)

    local function PopulateDropdown()
        for _, v in pairs(DropdownList:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        local ySize = 0
        for profileName, _ in pairs(ConfigData.Profiles) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Parent = DropdownList
            itemBtn.Size = UDim2.new(1, 0, 0, 25)
            itemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            itemBtn.Text = profileName
            itemBtn.TextColor3 = Color3.new(1, 1, 1)
            itemBtn.Font = Enum.Font.Gotham
            
            itemBtn.MouseButton1Click:Connect(function()
                ApplyConfigProfile(profileName)
                RefreshUI()
                ConfigBox.Text = profileName
                DropdownBtn.Text = "CONFIG : " .. profileName .. " ▼"
                DropdownList.Visible = false
                
                TweenService:Create(ConfigContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 90)}):Play()
            end)
            ySize = ySize + 27
        end
        DropdownList.CanvasSize = UDim2.new(0, 0, 0, ySize)
    end

    SaveConfigBtn.MouseButton1Click:Connect(function()
        local name = ConfigBox.Text
        if name and name ~= "" then
            SaveCurrentToProfile(name)
            PopulateDropdown()
            DropdownBtn.Text = "CONFIG : " .. name .. " ▼"
            SaveConfigBtn.Text = "OK!"
            task.wait(1)
            SaveConfigBtn.Text = "SAUVEGARDER"
        end
    end)

    DropdownBtn.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
        if DropdownList.Visible then
            PopulateDropdown()
            TweenService:Create(ConfigContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 175)}):Play()
        else
            TweenService:Create(ConfigContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 90)}):Play()
        end
    end)

    local BindsTitle = Instance.new("TextLabel")
    BindsTitle.Parent = TabSettings
    BindsTitle.Size = UDim2.new(1, -10, 0, 20)
    BindsTitle.BackgroundTransparency = 1
    BindsTitle.Text = "RACCOURCIS"
    BindsTitle.TextColor3 = Config.AccentColor
    BindsTitle.Font = Enum.Font.GothamBold
    BindsTitle.LayoutOrder = 3

    AddHotkey(TabSettings, "MENU BIND", "MenuKey", 4)
    AddHotkey(TabSettings, "TELEPORT BIND", "TP_Key", 5)

    local DiscFrame = Instance.new("Frame")
    DiscFrame.Parent = TabSettings
    DiscFrame.Size = UDim2.new(1, -10, 0, 40)
    DiscFrame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscFrame.LayoutOrder = 6
    
    local DiscCorner = Instance.new("UICorner")
    DiscCorner.Parent = DiscFrame
    
    local DiscBtn = Instance.new("TextButton")
    DiscBtn.Parent = DiscFrame
    DiscBtn.Size = UDim2.new(1, 0, 1, 0)
    DiscBtn.BackgroundTransparency = 1
    DiscBtn.Text = "COPY DISCORD LINK"
    DiscBtn.TextColor3 = Color3.new(1, 1, 1)
    DiscBtn.Font = Enum.Font.GothamBold
    
    DiscBtn.MouseButton1Click:Connect(function() 
        setclipboard(Config.Discord)
        DiscBtn.Text = "COPIED!"
        task.wait(1)
        DiscBtn.Text = "COPY DISCORD LINK" 
    end)

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Config.TP_Key and LocalPlayer.Character then 
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then rootPart.CFrame = Mouse.Hit * CFrame.new(0, 3, 0) end
        end
        if input.KeyCode == Config.MenuKey and CoreGui:FindFirstChild("SoloV1_Main") then 
            Frame.Visible = not Frame.Visible 
        end
    end)

    ReboundAnim(Frame)
    StartCoreLogic()
    
    TabCombat.Visible = true
    BtnCombat.TextColor3 = Config.AccentColor
end

-- ========================================== --
-- [[ 8. SYSTEME DE CLE & SAUVEGARDE ]]       --
-- ========================================== --
local function InitKeySystem()
    if isfile and isfile(Config.KeyFileName) then
        if readfile(Config.KeyFileName) == Config.CorrectKey then 
            InitCheat() 
            return 
        end
    end

    if CoreGui:FindFirstChild("SoloV1_Key") then CoreGui.SoloV1_Key:Destroy() end
    
    local KeyUI = Instance.new("ScreenGui")
    KeyUI.Name = "SoloV1_Key"
    KeyUI.Parent = CoreGui
    
    local KFrame = Instance.new("Frame")
    KFrame.Parent = KeyUI
    KFrame.Size = UDim2.new(0, 450, 0, 300)
    KFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    KFrame.BackgroundColor3 = Config.BgColor
    KFrame.ClipsDescendants = true
    
    local KCorner = Instance.new("UICorner")
    KCorner.Parent = KFrame
    
    local KStroke = Instance.new("UIStroke")
    KStroke.Parent = KFrame
    KStroke.Color = Config.AccentColor
    KStroke.Thickness = 1.5
    MakeDraggable(KFrame)

    local KTitle = Instance.new("TextLabel")
    KTitle.Parent = KFrame
    KTitle.Size = UDim2.new(1, 0, 0, 60)
    KTitle.BackgroundTransparency = 1
    KTitle.Text = "SoloCheat"
    KTitle.TextColor3 = Config.AccentColor
    KTitle.Font = Enum.Font.GothamBold
    KTitle.TextSize = 25

    local KBox = Instance.new("TextBox")
    KBox.Parent = KFrame
    KBox.Size = UDim2.new(0.8, 0, 0, 45)
    KBox.Position = UDim2.new(0.1, 0, 0.35, 0)
    KBox.BackgroundColor3 = Config.SecColor
    KBox.TextColor3 = Color3.new(1, 1, 1)
    KBox.PlaceholderText = "Collez la clé ici..."
    KBox.Text = ""
    KBox.Font = Enum.Font.Gotham
    
    local KBoxCorner = Instance.new("UICorner")
    KBoxCorner.Parent = KBox

    local ValidBtn = Instance.new("TextButton")
    ValidBtn.Parent = KFrame
    ValidBtn.Size = UDim2.new(0.4, -5, 0, 40)
    ValidBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    ValidBtn.BackgroundColor3 = Config.AccentColor
    ValidBtn.Text = "VALIDER V1"
    ValidBtn.TextColor3 = Color3.new(1, 1, 1)
    ValidBtn.Font = Enum.Font.GothamBold
    
    local ValidCorner = Instance.new("UICorner")
    ValidCorner.Parent = ValidBtn

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Parent = KFrame
    GetKeyBtn.Size = UDim2.new(0.4, -5, 0, 40)
    GetKeyBtn.Position = UDim2.new(0.5, 5, 0.65, 0)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    GetKeyBtn.Text = "[ Get Key ]"
    GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
    GetKeyBtn.Font = Enum.Font.GothamBold
    
    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.Parent = GetKeyBtn

    ValidBtn.MouseButton1Click:Connect(function()
        if KBox.Text == Config.CorrectKey then
            if writefile then writefile(Config.KeyFileName, KBox.Text) end
            KeyUI:Destroy()
            InitCheat()
        else
            ValidBtn.Text = "CLÉ FAUSSE"
            task.wait(1)
            ValidBtn.Text = "VALIDER V1"
        end
    end)
    
    GetKeyBtn.MouseButton1Click:Connect(function() 
        setclipboard(Config.Discord)
        GetKeyBtn.Text = "LIEN COPIÉ !"
        task.wait(1)
        GetKeyBtn.Text = "[ Get Key ]" 
    end)

    ReboundAnim(KFrame)
end

-- ========================================== --
-- [[ 9. DEMARRAGE DU SCRIPT ]]               --
-- ========================================== --
InitKeySystem()
