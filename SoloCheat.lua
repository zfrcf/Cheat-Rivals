-- [[ SoloCheat - V1 PRO ]] --
-- [[ EDITION : RIVALS ULTIMATE | ZERO COMPRESSION ABSOLUE | ECON SKINCHANGER ]] --

repeat
    task.wait()
until game:IsLoaded()

-- ========================================== --
-- [[ 1. SÉCURITÉ : VÉRIFICATION RIVALS ]]    --
-- ========================================== --
local TARGET_ID = 117398147513099
local RIVALS_PLACE_IDS = {
    17625359962,
    18641753753,
    18641743141,
    18641747754,
    6043017242
}

local isRivals = false

if game.GameId == TARGET_ID then
    isRivals = true
elseif game.PlaceId == TARGET_ID then
    isRivals = true
else
    for _, id in pairs(RIVALS_PLACE_IDS) do
        if game.PlaceId == id then
            isRivals = true
            break
        end
    end
end

if not isRivals then
    warn("[SoloCheat] Jeu non supporté ! Ce script est exclusivement réservé à Rivals.")
    warn("-> Ton PlaceId actuel : " .. tostring(game.PlaceId))
    warn("-> Ton GameId actuel : " .. tostring(game.GameId))
    return 
end

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
    KeyFileName = "SoloCheat_Key.txt",
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    AccentColor = Color3.fromRGB(255, 0, 80),
    BgColor = Color3.fromRGB(15, 15, 15),
    SecColor = Color3.fromRGB(25, 25, 25),
    
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
    if isfile then
        if isfile(ConfigFileName) then
            if readfile then
                local success, result = pcall(function()
                    return HttpService:JSONDecode(readfile(ConfigFileName))
                end)
                
                if success then
                    if type(result) == "table" then
                        ConfigData = result
                        if not ConfigData.Profiles then 
                            ConfigData.Profiles = {} 
                        end
                    end
                end
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
    if not data then 
        return 
    end
    
    for k, v in pairs(data) do
        if k == "TP_Key" then
            Config[k] = Enum.KeyCode[v] or Config[k]
        elseif k == "MenuKey" then
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
            if Config[key] == true then
                btn.BackgroundColor3 = Config.AccentColor
            else
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
        end
    end
    
    for key, btn in pairs(UIElements.Hotkeys) do
        if Config[key] ~= nil then
            btn.Text = Config[key].Name
        end
    end
end

LoadConfigsFromFile()

if ConfigData.LastConfig then
    if ConfigData.Profiles[ConfigData.LastConfig] then
        ApplyConfigProfile(ConfigData.LastConfig)
    end
end

-- ========================================== --
-- [[ 5. FONCTIONS UTILITAIRES ]]             --
-- ========================================== --
local function MakeDraggable(frame, parent)
    if not parent then
        parent = frame
    end
    
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
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newXScale = startPos.X.Scale
                local newXOffset = startPos.X.Offset + delta.X
                local newYScale = startPos.Y.Scale
                local newYOffset = startPos.Y.Offset + delta.Y
                
                parent.Position = UDim2.new(newXScale, newXOffset, newYScale, newYOffset)
            end
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
    
    if not myCharacter then
        return nil
    end
    
    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    
    if not myRoot then 
        return nil 
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if p.Character then
                local enemyPart = p.Character:FindFirstChild(Config.TargetPart)
                local hum = p.Character:FindFirstChild("Humanoid")
                
                if enemyPart then
                    if hum then
                        if hum.Health > 0 then
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
        local mainGui = CoreGui:FindFirstChild("SoloV1_Main")
        
        if not mainGui then 
            FOVCircle.Visible = false 
            return 
        end
        
        FOVCircle.Visible = Config.ShowFOV
        FOVCircle.Radius = Config.FOV
        FOVCircle.Position = UIS:GetMouseLocation()

        local char = LocalPlayer.Character
        
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hum then
                if hrp then
                    if hum.Health > 0 then
                        
                        hum.WalkSpeed = Config.WalkSpeedValue

                        if Config.Fly then
                            hrp.Velocity = Vector3.new(0, 0.1, 0)
                            local dir = Vector3.new()
                            
                            if UIS:IsKeyDown(Enum.KeyCode.W) then 
                                dir = dir + Camera.CFrame.LookVector 
                            end
                            
                            if UIS:IsKeyDown(Enum.KeyCode.S) then 
                                dir = dir - Camera.CFrame.LookVector 
                            end
                            
                            if dir.Magnitude > 0 then 
                                hrp.CFrame = hrp.CFrame + (dir * Config.FlySpeed) 
                            end
                        end

                        if Config.NoClip then
                            local descendants = char:GetDescendants()
                            for _, v in pairs(descendants) do 
                                if v:IsA("BasePart") then 
                                    v.CanCollide = false 
                                end 
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
                            if target then
                                if target.Parent then
                                    local targetHum = target.Parent:FindFirstChild("Humanoid")
                                    if targetHum then
                                        if targetHum.Health > 0 then
                                            local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
                                            if targetPlayer then
                                                if targetPlayer ~= LocalPlayer then
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
                                end
                            end
                        end

                        if Config.Silent then
                            if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                                local t = GetClosestTargetByDistance()
                                if t then
                                    if mousemoverel then
                                        local pos = Camera:WorldToViewportPoint(t.Position)
                                        local mouseLoc = UIS:GetMouseLocation()
                                        mousemoverel(pos.X - mouseLoc.X, pos.Y - mouseLoc.Y)
                                    elseif getgenv().mousemoverel then
                                        local m = getgenv().mousemoverel
                                        local pos = Camera:WorldToViewportPoint(t.Position)
                                        local mouseLoc = UIS:GetMouseLocation()
                                        m(pos.X - mouseLoc.X, pos.Y - mouseLoc.Y)
                                    end
                                end
                            end
                        end

                        if Config.TPKill then
                            local tObj = GetClosestTargetByDistance()
                            if tObj then
                                if tObj.Parent then
                                    local targetRoot = tObj.Parent:FindFirstChild("HumanoidRootPart")
                                    if targetRoot then
                                        local offsetCFrame = CFrame.new(0, Config.KillOffset, 2)
                                        hrp.CFrame = targetRoot.CFrame * offsetCFrame
                                        
                                        local lookAtCFrame = CFrame.new(Camera.CFrame.Position, tObj.Position)
                                        Camera.CFrame = lookAtCFrame
                                        
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
            
            if not head then
                return
            end
            
            if not humanoid then 
                return 
            end

            local box = Instance.new("BoxHandleAdornment")
            box.Name = "SoloCheat_Box"
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = Vector3.new(4, 6, 1)
            box.Color3 = Config.AccentColor
            box.Transparency = 0.7
            box.Adornee = character
            box.Parent = character
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "SoloCheat_Bill"
            billboard.Size = UDim2.new(0, 150, 0, 60)
            billboard.AlwaysOnTop = true
            billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
            billboard.Adornee = head
            billboard.Parent = head
            
            local label = Instance.new("TextLabel")
            label.Name = "NameLabel"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 13
            label.TextStrokeTransparency = 0
            label.Parent = billboard

            local connection
            connection = RunService.Heartbeat:Connect(function()
                local guiCheck = CoreGui:FindFirstChild("SoloV1_Main")
                
                if not guiCheck then 
                    box.Visible = false
                    billboard.Enabled = false
                    connection:Disconnect()
                    return 
                end

                if character then
                    if humanoid then
                        if humanoid.Health > 0 then
                            box.Visible = Config.ESP_Box
                            billboard.Enabled = Config.ESP_HealthText
                            
                            if billboard.Enabled then
                                local healthFloor = math.floor(humanoid.Health)
                                label.Text = player.Name .. "\nHP: " .. tostring(healthFloor)
                                
                                local hue = (humanoid.Health / 100) * 0.35
                                label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                            end
                        else
                            box.Visible = false
                            billboard.Enabled = false
                        end
                    else
                        box.Visible = false
                        billboard.Enabled = false
                    end
                else
                    box.Visible = false
                    billboard.Enabled = false
                end
            end)
        end)
    end

    local allPlayers = Players:GetPlayers()
    for _, p in pairs(allPlayers) do 
        if p ~= LocalPlayer then 
            CreatePlayerESP(p) 
        end 
    end
    
    Players.PlayerAdded:Connect(CreatePlayerESP)
end

-- ========================================== --
-- [[ 7. INTERFACE UTILISATEUR (UI) ]]        --
-- ========================================== --
local function InitCheat()
    local existingGui = CoreGui:FindFirstChild("SoloV1_Main")
    if existingGui then 
        existingGui:Destroy() 
    end

    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "SoloV1_Main"
    MainUI.Parent = CoreGui
    
    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Size = UDim2.new(0, 560, 0, 450)
    Frame.Position = UDim2.new(0.5, -280, 0.5, -225)
    Frame.BackgroundColor3 = Config.BgColor
    Frame.ClipsDescendants = true
    Frame.Parent = MainUI
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.Parent = Frame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Config.AccentColor
    Stroke.Thickness = 1.5
    Stroke.Parent = Frame
    
    MakeDraggable(Frame)

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Config.SecColor
    TopBar.Parent = Frame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.Parent = TopBar
    
    MakeDraggable(TopBar, Frame)
    
    local Title = Instance.new("TextLabel")
    Title.Name = "TitleLabel"
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "  SoloCheat - V1 PRO (RIVALS)"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseButton"
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar
    
    CloseBtn.MouseButton1Click:Connect(function() 
        MainUI:Destroy() 
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.Parent = Frame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.Parent = Sidebar
    
    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding = UDim.new(0, 5)
    SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Parent = Sidebar

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -150, 1, -50)
    Container.Position = UDim2.new(0, 145, 0, 45)
    Container.BackgroundTransparency = 1
    Container.Parent = Frame

    local function CreateTab(name, layoutOrder)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundColor3 = Config.SecColor
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.LayoutOrder = layoutOrder
        TabBtn.Parent = Sidebar
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.Parent = TabBtn
        
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.CanvasSize = UDim2.new(0, 0, 3, 0)
        Page.Parent = Container
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            local containerChildren = Container:GetChildren()
            for _, v in pairs(containerChildren) do 
                if v:IsA("ScrollingFrame") then 
                    v.Visible = false 
                end
            end
            
            local sidebarChildren = Sidebar:GetChildren()
            for _, b in pairs(sidebarChildren) do 
                if b:IsA("TextButton") then 
                    b.TextColor3 = Color3.fromRGB(150, 150, 150) 
                end 
            end
            
            Page.Visible = true
            TabBtn.TextColor3 = Config.AccentColor
        end)
        
        return Page, TabBtn
    end

    local function AddToggle(parent, text, configKey, layoutOrder)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
        ToggleFrame.BackgroundColor3 = Config.SecColor
        ToggleFrame.LayoutOrder = layoutOrder
        ToggleFrame.Parent = parent
        
        local Corner = Instance.new("UICorner")
        Corner.Parent = ToggleFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 35, 0, 18)
        Btn.Position = UDim2.new(1, -45, 0.5, -9)
        Btn.Text = ""
        
        if Config[configKey] then
            Btn.BackgroundColor3 = Config.AccentColor
        else
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        
        Btn.Parent = ToggleFrame
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(1, 0)
        BtnCorner.Parent = Btn
        
        Btn.MouseButton1Click:Connect(function() 
            Config[configKey] = not Config[configKey]
            
            if Config[configKey] then
                Btn.BackgroundColor3 = Config.AccentColor
            else
                Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
        end)
        
        UIElements.Toggles[configKey] = Btn
    end

    local function AddHotkey(parent, text, configKey, layoutOrder)
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Size = UDim2.new(1, -10, 0, 40)
        KeyFrame.BackgroundColor3 = Config.SecColor
        KeyFrame.LayoutOrder = layoutOrder
        KeyFrame.Parent = parent
        
        local Corner = Instance.new("UICorner")
        Corner.Parent = KeyFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -100, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = KeyFrame
        
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 80, 0, 25)
        Btn.Position = UDim2.new(1, -90, 0.5, -12.5)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Btn.Text = Config[configKey].Name
        Btn.TextColor3 = Config.AccentColor
        Btn.Font = Enum.Font.GothamBold
        Btn.Parent = KeyFrame
        
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
    SpeedBtn.Size = UDim2.new(1, -10, 0, 40)
    SpeedBtn.BackgroundColor3 = Config.SecColor
    SpeedBtn.Text = "TOGGLE SPEED (45)"
    SpeedBtn.TextColor3 = Color3.new(1, 1, 1)
    SpeedBtn.Font = Enum.Font.Gotham
    SpeedBtn.LayoutOrder = 1
    SpeedBtn.Parent = TabMovement
    
    local SpeedCorner = Instance.new("UICorner")
    SpeedCorner.Parent = SpeedBtn
    
    SpeedBtn.MouseButton1Click:Connect(function() 
        if Config.WalkSpeedValue == 16 then
            Config.WalkSpeedValue = 45
        else
            Config.WalkSpeedValue = 16
        end
    end)

    AddToggle(TabMovement, "FLY MODE (CFRAME)", "Fly", 2)
    AddToggle(TabMovement, "NOCLIP (ANTI-WALL)", "NoClip", 3)
    AddToggle(TabMovement, "ANTI-RAGDOLL", "AntiRagdoll", 4)

    -- ONGLET SKINCHANGER (EconRCO)
    local SkinLabel = Instance.new("TextLabel")
    SkinLabel.Size = UDim2.new(1, -10, 0, 50)
    SkinLabel.BackgroundTransparency = 1
    SkinLabel.Text = "RIVALS SKINCHANGER SYSTEM (ECON)"
    SkinLabel.TextColor3 = Color3.new(1, 1, 1)
    SkinLabel.Font = Enum.Font.GothamBold
    SkinLabel.TextWrapped = true
    SkinLabel.LayoutOrder = 1
    SkinLabel.Parent = TabSkin

    local RunSkinBtn = Instance.new("TextButton")
    RunSkinBtn.Size = UDim2.new(1, -10, 0, 45)
    RunSkinBtn.BackgroundColor3 = Config.AccentColor
    RunSkinBtn.Text = "ACTIVER LE SKINCHANGER"
    RunSkinBtn.TextColor3 = Color3.new(1, 1, 1)
    RunSkinBtn.Font = Enum.Font.GothamBold
    RunSkinBtn.LayoutOrder = 2
    RunSkinBtn.Parent = TabSkin
    
    local RunSkinCorner = Instance.new("UICorner")
    RunSkinCorner.Parent = RunSkinBtn

    RunSkinBtn.MouseButton1Click:Connect(function()
        RunSkinBtn.Text = "CHARGEMENT..."
        
        local success, err = pcall(function()
            local url = "https://raw.githubusercontent.com/EconRCO/Econ/refs/heads/main/Init"
            local code = game:HttpGet(url)
            local func = loadstring(code)
            func()
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
    ConfigTitle.Size = UDim2.new(1, -10, 0, 20)
    ConfigTitle.BackgroundTransparency = 1
    ConfigTitle.Text = "CONFIG MANAGER"
    ConfigTitle.TextColor3 = Config.AccentColor
    ConfigTitle.Font = Enum.Font.GothamBold
    ConfigTitle.LayoutOrder = 1
    ConfigTitle.Parent = TabSettings

    local ConfigContainer = Instance.new("Frame")
    ConfigContainer.Size = UDim2.new(1, -10, 0, 90)
    ConfigContainer.BackgroundColor3 = Config.SecColor
    ConfigContainer.LayoutOrder = 2
    ConfigContainer.ClipsDescendants = true
    ConfigContainer.Parent = TabSettings
    
    local ConfigCorner = Instance.new("UICorner")
    ConfigCorner.Parent = ConfigContainer
    
    local ConfigBox = Instance.new("TextBox")
    ConfigBox.Size = UDim2.new(0.6, -5, 0, 30)
    ConfigBox.Position = UDim2.new(0, 10, 0, 10)
    ConfigBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ConfigBox.TextColor3 = Color3.new(1, 1, 1)
    ConfigBox.PlaceholderText = "Nom de la config..."
    
    if ConfigData.LastConfig ~= "Default" then
        ConfigBox.Text = ConfigData.LastConfig
    else
        ConfigBox.Text = ""
    end
    
    ConfigBox.Font = Enum.Font.Gotham
    ConfigBox.Parent = ConfigContainer
    
    local ConfigBoxCorner = Instance.new("UICorner")
    ConfigBoxCorner.Parent = ConfigBox

    local SaveConfigBtn = Instance.new("TextButton")
    SaveConfigBtn.Size = UDim2.new(0.4, -25, 0, 30)
    SaveConfigBtn.Position = UDim2.new(0.6, 15, 0, 10)
    SaveConfigBtn.BackgroundColor3 = Config.AccentColor
    SaveConfigBtn.Text = "SAUVEGARDER"
    SaveConfigBtn.TextColor3 = Color3.new(1, 1, 1)
    SaveConfigBtn.Font = Enum.Font.GothamBold
    SaveConfigBtn.Parent = ConfigContainer
    
    local SaveConfigCorner = Instance.new("UICorner")
    SaveConfigCorner.Parent = SaveConfigBtn

    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(1, -20, 0, 30)
    DropdownBtn.Position = UDim2.new(0, 10, 0, 50)
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownBtn.Text = "CONFIG : " .. ConfigData.LastConfig .. " ▼"
    DropdownBtn.TextColor3 = Color3.new(1, 1, 1)
    DropdownBtn.Font = Enum.Font.GothamBold
    DropdownBtn.Parent = ConfigContainer
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.Parent = DropdownBtn

    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Size = UDim2.new(1, -20, 0, 80)
    DropdownList.Position = UDim2.new(0, 10, 0, 85)
    DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownList.Visible = false
    DropdownList.ScrollBarThickness = 2
    DropdownList.Parent = ConfigContainer
    
    local DropdownListLayout = Instance.new("UIListLayout")
    DropdownListLayout.Padding = UDim.new(0, 2)
    DropdownListLayout.Parent = DropdownList

    local function PopulateDropdown()
        local listChildren = DropdownList:GetChildren()
        for _, v in pairs(listChildren) do
            if v:IsA("TextButton") then 
                v:Destroy() 
            end
        end
        
        local ySize = 0
        
        for profileName, _ in pairs(ConfigData.Profiles) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(1, 0, 0, 25)
            itemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            itemBtn.Text = profileName
            itemBtn.TextColor3 = Color3.new(1, 1, 1)
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.Parent = DropdownList
            
            itemBtn.MouseButton1Click:Connect(function()
                ApplyConfigProfile(profileName)
                RefreshUI()
                ConfigBox.Text = profileName
                DropdownBtn.Text = "CONFIG : " .. profileName .. " ▼"
                DropdownList.Visible = false
                
                local tweenInfo = TweenInfo.new(0.2)
                local goal = {Size = UDim2.new(1, -10, 0, 90)}
                TweenService:Create(ConfigContainer, tweenInfo, goal):Play()
            end)
            
            ySize = ySize + 27
        end
        
        DropdownList.CanvasSize = UDim2.new(0, 0, 0, ySize)
    end

    SaveConfigBtn.MouseButton1Click:Connect(function()
        local name = ConfigBox.Text
        if name then
            if name ~= "" then
                SaveCurrentToProfile(name)
                PopulateDropdown()
                DropdownBtn.Text = "CONFIG : " .. name .. " ▼"
                SaveConfigBtn.Text = "OK!"
                task.wait(1)
                SaveConfigBtn.Text = "SAUVEGARDER"
            end
        end
    end)

    DropdownBtn.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
        
        if DropdownList.Visible then
            PopulateDropdown()
            local tweenInfo = TweenInfo.new(0.2)
            local goal = {Size = UDim2.new(1, -10, 0, 175)}
            TweenService:Create(ConfigContainer, tweenInfo, goal):Play()
        else
            local tweenInfo = TweenInfo.new(0.2)
            local goal = {Size = UDim2.new(1, -10, 0, 90)}
            TweenService:Create(ConfigContainer, tweenInfo, goal):Play()
        end
    end)

    local BindsTitle = Instance.new("TextLabel")
    BindsTitle.Size = UDim2.new(1, -10, 0, 20)
    BindsTitle.BackgroundTransparency = 1
    BindsTitle.Text = "RACCOURCIS"
    BindsTitle.TextColor3 = Config.AccentColor
    BindsTitle.Font = Enum.Font.GothamBold
    BindsTitle.LayoutOrder = 3
    BindsTitle.Parent = TabSettings

    AddHotkey(TabSettings, "MENU BIND", "MenuKey", 4)
    AddHotkey(TabSettings, "TELEPORT BIND", "TP_Key", 5)

    local DiscFrame = Instance.new("Frame")
    DiscFrame.Size = UDim2.new(1, -10, 0, 40)
    DiscFrame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscFrame.LayoutOrder = 6
    DiscFrame.Parent = TabSettings
    
    local DiscCorner = Instance.new("UICorner")
    DiscCorner.Parent = DiscFrame
    
    local DiscBtn = Instance.new("TextButton")
    DiscBtn.Size = UDim2.new(1, 0, 1, 0)
    DiscBtn.BackgroundTransparency = 1
    DiscBtn.Text = "COPY DISCORD LINK"
    DiscBtn.TextColor3 = Color3.new(1, 1, 1)
    DiscBtn.Font = Enum.Font.GothamBold
    DiscBtn.Parent = DiscFrame
    
    DiscBtn.MouseButton1Click:Connect(function() 
        setclipboard(Config.Discord)
        DiscBtn.Text = "COPIED!"
        task.wait(1)
        DiscBtn.Text = "COPY DISCORD LINK" 
    end)

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then 
            return 
        end
        
        if input.KeyCode == Config.TP_Key then
            if LocalPlayer.Character then 
                local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then 
                    local hitCFrame = Mouse.Hit
                    local offsetCFrame = CFrame.new(0, 3, 0)
                    rootPart.CFrame = hitCFrame * offsetCFrame 
                end
            end
        end
        
        if input.KeyCode == Config.MenuKey then
            local mainGuiCheck = CoreGui:FindFirstChild("SoloV1_Main")
            if mainGuiCheck then 
                Frame.Visible = not Frame.Visible 
            end
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
    if isfile then
        if isfile(Config.KeyFileName) then
            if readfile then
                local savedKey = readfile(Config.KeyFileName)
                if savedKey == Config.CorrectKey then 
                    InitCheat() 
                    return 
                end
            end
        end
    end

    local existingKeyGui = CoreGui:FindFirstChild("SoloV1_Key")
    if existingKeyGui then 
        existingKeyGui:Destroy() 
    end
    
    local KeyUI = Instance.new("ScreenGui")
    KeyUI.Name = "SoloV1_Key"
    KeyUI.Parent = CoreGui
    
    local KFrame = Instance.new("Frame")
    KFrame.Size = UDim2.new(0, 450, 0, 300)
    KFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    KFrame.BackgroundColor3 = Config.BgColor
    KFrame.ClipsDescendants = true
    KFrame.Parent = KeyUI
    
    local KCorner = Instance.new("UICorner")
    KCorner.Parent = KFrame
    
    local KStroke = Instance.new("UIStroke")
    KStroke.Color = Config.AccentColor
    KStroke.Thickness = 1.5
    KStroke.Parent = KFrame
    
    MakeDraggable(KFrame)

    local KTitle = Instance.new("TextLabel")
    KTitle.Size = UDim2.new(1, 0, 0, 60)
    KTitle.BackgroundTransparency = 1
    KTitle.Text = "SoloCheat"
    KTitle.TextColor3 = Config.AccentColor
    KTitle.Font = Enum.Font.GothamBold
    KTitle.TextSize = 25
    KTitle.Parent = KFrame

    local KBox = Instance.new("TextBox")
    KBox.Size = UDim2.new(0.8, 0, 0, 45)
    KBox.Position = UDim2.new(0.1, 0, 0.35, 0)
    KBox.BackgroundColor3 = Config.SecColor
    KBox.TextColor3 = Color3.new(1, 1, 1)
    KBox.PlaceholderText = "Collez la clé ici..."
    KBox.Text = ""
    KBox.Font = Enum.Font.Gotham
    KBox.Parent = KFrame
    
    local KBoxCorner = Instance.new("UICorner")
    KBoxCorner.Parent = KBox

    local ValidBtn = Instance.new("TextButton")
    ValidBtn.Size = UDim2.new(0.4, -5, 0, 40)
    ValidBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    ValidBtn.BackgroundColor3 = Config.AccentColor
    ValidBtn.Text = "VALIDER V1"
    ValidBtn.TextColor3 = Color3.new(1, 1, 1)
    ValidBtn.Font = Enum.Font.GothamBold
    ValidBtn.Parent = KFrame
    
    local ValidCorner = Instance.new("UICorner")
    ValidCorner.Parent = ValidBtn

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0.4, -5, 0, 40)
    GetKeyBtn.Position = UDim2.new(0.5, 5, 0.65, 0)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    GetKeyBtn.Text = "[ Get Key ]"
    GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Parent = KFrame
    
    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.Parent = GetKeyBtn

    ValidBtn.MouseButton1Click:Connect(function()
        local inputText = KBox.Text
        if inputText == Config.CorrectKey then
            if writefile then 
                writefile(Config.KeyFileName, inputText) 
            end
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
