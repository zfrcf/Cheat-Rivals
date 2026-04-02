-- [[ SoloCheat - V1 PRO ]] --
-- [[ EDITION : RIVALS ULTIMATE | ZERO COMPRESSION | HAUTE PRECISION ]] --

repeat task.wait() until game:IsLoaded()

-- ========================================== --
-- [[ 1. SÉCURITÉ : VÉRIFICATION RIVALS ]]    --
-- ========================================== --
local RIVALS_GAME_ID = 6043017242
local RIVALS_PLACE_IDS = {17625359962, 18641753753, 18641743141, 18641747754}
local isRivals = false

if game.GameId == RIVALS_GAME_ID then
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
    warn("[SoloCheat] Jeu non supporté. Ce script est exclusivement réservé à Rivals.")
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

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ========================================== --
-- [[ 3. CONFIGURATION GÉNÉRALE ]]            --
-- ========================================== --
local Config = {
    -- Fichier et Sécurité
    FileName = "SoloCheat_Key.txt",
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    
    -- Combat
    Silent = false,
    TriggerBot = false,
    TPKill = false,
    KillOffset = 3,
    FOV = 200,
    ShowFOV = true,
    TargetPart = "Head",
    
    -- Mouvement
    Fly = false,
    FlySpeed = 2,
    NoClip = false,
    AntiRagdoll = true,
    WalkSpeedValue = 16,
    
    -- Visuels (ESP)
    ESP_Box = false,
    ESP_HealthText = false,
    
    -- Touches Raccourcis
    TP_Key = Enum.KeyCode.E,
    MenuKey = Enum.KeyCode.K,
    
    -- Thème UI
    AccentColor = Color3.fromRGB(255, 0, 80), -- Rouge/Rose Rivals
    BgColor = Color3.fromRGB(15, 15, 15),
    SecColor = Color3.fromRGB(25, 25, 25)
}

-- ========================================== --
-- [[ 4. FONCTIONS UTILITAIRES ]]             --
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
-- [[ 5. LOGIQUE PRINCIPALE & ESP ]]          --
-- ========================================== --
local function StartCoreLogic()
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Color = Config.AccentColor
    FOVCircle.Transparency = 1
    FOVCircle.Visible = false

    -- Boucle Principale
    RunService.RenderStepped:Connect(function()
        if not CoreGui:FindFirstChild("SoloV1_Main") then 
            FOVCircle.Visible = false 
            return 
        end
        
        -- Gestion du FOV Circle
        FOVCircle.Visible = Config.ShowFOV
        FOVCircle.Radius = Config.FOV
        FOVCircle.Position = UIS:GetMouseLocation()

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if char and hum and hrp and hum.Health > 0 then
            
            -- Vitesse (Forcée en boucle pour bypass les resets du jeu)
            hum.WalkSpeed = Config.WalkSpeedValue

            -- Mode Vol (Fly)
            if Config.Fly then
                hrp.Velocity = Vector3.new(0, 0.1, 0) -- Anti chute
                local dir = Vector3.new()
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if dir.Magnitude > 0 then 
                    hrp.CFrame = hrp.CFrame + (dir * Config.FlySpeed) 
                end
            end

            -- NoClip (Passe muraille)
            if Config.NoClip then
                for _, v in pairs(char:GetDescendants()) do 
                    if v:IsA("BasePart") then 
                        v.CanCollide = false 
                    end 
                end
            end

            -- Anti-Ragdoll (Rivals)
            if Config.AntiRagdoll then
                hum.PlatformStand = false
                hum.Sit = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                if hum:GetState() == Enum.HumanoidStateType.Ragdoll then 
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
                end
            end

            -- Trigger Bot (Tir Automatique)
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
                                mouse1click() -- Fallback universel pour les exécuteurs
                            end
                        end
                    end
                end
            end

            -- Silent Aim (Aim Assist invisible)
            if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local t = GetClosestTargetByDistance()
                if t and (mousemoverel or getgenv().mousemoverel) then
                    local m = mousemoverel or getgenv().mousemoverel
                    local pos = Camera:WorldToViewportPoint(t.Position)
                    m(pos.X - UIS:GetMouseLocation().X, pos.Y - UIS:GetMouseLocation().Y)
                end
            end

            -- TP Kill (Téléportation et exécution)
            if Config.TPKill then
                local tObj = GetClosestTargetByDistance()
                if tObj and tObj.Parent and tObj.Parent:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = tObj.Parent.HumanoidRootPart
                    hrp.CFrame = targetRoot.CFrame * CFrame.new(0, Config.KillOffset, 2)
                    
                    -- Orientation de la caméra vers la cible
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

    -- Système ESP Complet
    local function CreatePlayerESP(player)
        player.CharacterAdded:Connect(function(character)
            task.wait(1) -- Attend le chargement du personnage
            local head = character:WaitForChild("Head", 5)
            local humanoid = character:WaitForChild("Humanoid", 5)
            
            if not head or not humanoid then return end

            -- ESP Box
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "SoloCheat_Box"
            box.Adornee = character
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = Vector3.new(4, 6, 1)
            box.Color3 = Config.AccentColor
            box.Transparency = 0.7
            box.Parent = character
            
            -- ESP Text (Nom + HP)
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

            -- Mise à jour ESP
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

    -- Initialiser l'ESP pour les joueurs déjà présents
    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer then 
            CreatePlayerESP(p) 
        end 
    end
    -- Ajouter l'ESP pour les nouveaux joueurs
    Players.PlayerAdded:Connect(CreatePlayerESP)
end

-- ========================================== --
-- [[ 6. INTERFACE UTILISATEUR (UI) ]]        --
-- ========================================== --
local function InitCheat()
    if CoreGui:FindFirstChild("SoloV1_Main") then 
        CoreGui.SoloV1_Main:Destroy() 
    end

    -- Création du GUI Principal
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "SoloV1_Main"
    MainUI.Parent = CoreGui
    
    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Parent = MainUI
    Frame.Size = UDim2.new(0, 560, 0, 420)
    Frame.Position = UDim2.new(0.5, -280, 0.5, -210)
    Frame.BackgroundColor3 = Config.BgColor
    Frame.ClipsDescendants = true
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.Parent = Frame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Frame
    Stroke.Color = Config.AccentColor
    Stroke.Thickness = 1.5
    
    MakeDraggable(Frame)

    -- Barre Supérieure
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
    
    CloseBtn.MouseButton1Click:Connect(function() 
        MainUI:Destroy() 
    end)

    -- Barre de navigation (Sidebar)
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

    -- Conteneur des pages
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = Frame
    Container.Size = UDim2.new(1, -150, 1, -50)
    Container.Position = UDim2.new(0, 145, 0, 45)
    Container.BackgroundTransparency = 1

    -- Générateur de Tableaux
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
        Page.ScrollBarThickness = 0
        Page.CanvasSize = UDim2.new(0, 0, 2, 0)
        
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

    -- Générateur d'Options (Toggle)
    local function AddToggle(parent, text, configTable, configKey, layoutOrder)
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
        Btn.BackgroundColor3 = configTable[configKey] and Config.AccentColor or Color3.fromRGB(50, 50, 50)
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.Parent = Btn
        BtnCorner.CornerRadius = UDim.new(1, 0)
        
        Btn.MouseButton1Click:Connect(function() 
            configTable[configKey] = not configTable[configKey]
            Btn.BackgroundColor3 = configTable[configKey] and Config.AccentColor or Color3.fromRGB(50, 50, 50) 
        end)
    end

    -- Générateur de Raccourcis (Hotkey)
    local function AddHotkey(parent, text, configTable, configKey, layoutOrder)
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
        Btn.Text = configTable[configKey].Name
        Btn.TextColor3 = Config.AccentColor
        Btn.Font = Enum.Font.GothamBold
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.Parent = Btn
        
        Btn.MouseButton1Click:Connect(function()
            Btn.Text = "..."
            local connection
            connection = UIS.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then 
                    configTable[configKey] = input.KeyCode
                    Btn.Text = input.KeyCode.Name
                    connection:Disconnect() 
                end
            end)
        end)
    end

    -- Création des Pages
    local TabCombat, BtnCombat = CreateTab("Combat", 1)
    local TabVisuals, BtnVisuals = CreateTab("Visuals", 2)
    local TabMovement, BtnMovement = CreateTab("Movement", 3)
    local TabSettings, BtnSettings = CreateTab("Settings", 4)

    -- Remplissage de l'onglet Combat
    AddToggle(TabCombat, "TRIGGER BOT (AUTO-FIRE)", Config, "TriggerBot", 1)
    AddToggle(TabCombat, "SILENT AIM (MOUSE2)", Config, "Silent", 2)
    AddToggle(TabCombat, "TP KILL (AUTO-EXECUTE)", Config, "TPKill", 3)
    AddToggle(TabCombat, "SHOW FOV CIRCLE", Config, "ShowFOV", 4)

    -- Remplissage de l'onglet Visuels
    AddToggle(TabVisuals, "ESP BOXES", Config, "ESP_Box", 1)
    AddToggle(TabVisuals, "ESP NAME & HP", Config, "ESP_HealthText", 2)

    -- Remplissage de l'onglet Mouvement
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

    AddToggle(TabMovement, "FLY MODE (CFRAME)", Config, "Fly", 2)
    AddToggle(TabMovement, "NOCLIP (ANTI-WALL)", Config, "NoClip", 3)
    AddToggle(TabMovement, "ANTI-RAGDOLL", Config, "AntiRagdoll", 4)

    -- Remplissage de l'onglet Paramètres
    AddHotkey(TabSettings, "MENU BIND", Config, "MenuKey", 1)
    AddHotkey(TabSettings, "TELEPORT BIND", Config, "TP_Key", 2)

    local DiscFrame = Instance.new("Frame")
    DiscFrame.Parent = TabSettings
    DiscFrame.Size = UDim2.new(1, -10, 0, 40)
    DiscFrame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscFrame.LayoutOrder = 3
    
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

    -- Inputs Généraux (Menu et TP Hit)
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- TP au clic
        if input.KeyCode == Config.TP_Key and LocalPlayer.Character then 
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = Mouse.Hit * CFrame.new(0, 3, 0) 
            end
        end
        
        -- Afficher/Cacher le menu
        if input.KeyCode == Config.MenuKey and CoreGui:FindFirstChild("SoloV1_Main") then 
            Frame.Visible = not Frame.Visible 
        end
    end)

    -- Animation de lancement
    ReboundAnim(Frame)
    StartCoreLogic()
    
    -- Activer le premier onglet par défaut
    TabCombat.Visible = true
    BtnCombat.TextColor3 = Config.AccentColor
end

-- ========================================== --
-- [[ 7. SYSTEME DE CLE & SAUVEGARDE ]]       --
-- ========================================== --
local function InitKeySystem()
    -- Vérification automatique de la clé sauvegardée
    if isfile and isfile(Config.FileName) then
        if readfile(Config.FileName) == Config.CorrectKey then 
            InitCheat() 
            return 
        end
    end

    -- UI du Key System
    if CoreGui:FindFirstChild("SoloV1_Key") then 
        CoreGui.SoloV1_Key:Destroy() 
    end
    
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

    -- Logique des boutons
    ValidBtn.MouseButton1Click:Connect(function()
        if KBox.Text == Config.CorrectKey then
            if writefile then 
                writefile(Config.FileName, KBox.Text) 
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
-- [[ 8. DEMARRAGE DU SCRIPT ]]               --
-- ========================================== --
InitKeySystem()
