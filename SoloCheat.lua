-- [[ SoloCheat - V1 PRO MAX COMPLET ]] --
-- [[ VERSION LONGUE & DÉBRIDÉE ]] --

repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration Globale
local Config = {
    AccentColor = Color3.fromRGB(255, 0, 80),
    BgColor = Color3.fromRGB(15, 15, 15),
    SecColor = Color3.fromRGB(25, 25, 25),
    
    Aimbot = false,
    FOV = 150,
    ShowFOV = true,
    Smoothness = 0.2,
    
    ESP_Box = false,
    ESP_Health = false,
    
    WalkSpeed = 16,
    JumpPower = 50,
    Fly = false,
    NoClip = false,
    Invisible = false,
    
    MenuKey = Enum.KeyCode.K,
    AimKey = Enum.KeyCode.V,
    SpeedKey = Enum.KeyCode.J
}

local Palette = {
    ["Rouge"] = Color3.fromRGB(255, 30, 30),
    ["Vert"] = Color3.fromRGB(30, 255, 30),
    ["Bleu"] = Color3.fromRGB(30, 150, 255),
    ["Jaune"] = Color3.fromRGB(255, 230, 30),
    ["Rose"] = Color3.fromRGB(255, 50, 200),
    ["Blanc"] = Color3.fromRGB(255, 255, 255)
}

-- ========================================== --
-- [[ SYSTÈME INVISIBLE (POUR LES AUTRES) ]]  --
-- ========================================== --
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("LowerTorso") then
                local root = LP.Character.LowerTorso:FindFirstChild("RootRigidJoint")
                if Config.Invisible then
                    -- Toi tu te vois mais transparent
                    for _, v in pairs(LP.Character:GetChildren()) do
                        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                            v.Transparency = 0.5
                        end
                    end
                    -- Aux autres, tu es sous la map
                    if root then root.C0 = CFrame.new(0, -1000, 0) end
                else
                    -- Reset normal
                    if root then root.C0 = CFrame.new(0, 0, 0) end
                    for _, v in pairs(LP.Character:GetChildren()) do
                        if v:IsA("BasePart") then v.Transparency = 0 end
                    end
                end
            end
        end)
    end
end)

-- ========================================== --
-- [[ FONCTIONS UTILITAIRES ]]                --
-- ========================================== --
local function GetClosestTarget()
    local target = nil
    local shortestDistance = Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = UIS:GetMouseLocation()
                local screenDist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if screenDist < shortestDistance then
                    shortestDistance = screenDist
                    target = p.Character
                end
            end
        end
    end
    return target
end

-- ========================================== --
-- [[ CRÉATION DE L'INTERFACE ]]              --
-- ========================================== --
local function Launch()
    if CoreGui:FindFirstChild("SoloV1_Master") then CoreGui.SoloV1_Master:Destroy() end

    local Screen = Instance.new("ScreenGui", CoreGui)
    Screen.Name = "SoloV1_Master"

    local Main = Instance.new("Frame", Screen)
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 560, 0, 440)
    Main.Position = UDim2.new(0.5, -280, 0.5, -220)
    Main.BackgroundColor3 = Config.BgColor
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Config.AccentColor
    Stroke.Thickness = 2

    -- Barre Latérale
    local Side = Instance.new("Frame", Main)
    Side.Size = UDim2.new(0, 150, 1, 0)
    Side.BackgroundColor3 = Config.SecColor
    Instance.new("UICorner", Side)

    local Logo = Instance.new("TextLabel", Side)
    Logo.Size = UDim2.new(1, 0, 0, 60)
    Logo.Text = "SOLO V1"
    Logo.Font = "GothamBold"
    Logo.TextSize = 20
    Logo.TextColor3 = Config.AccentColor
    Logo.BackgroundTransparency = 1

    local TabContainer = Instance.new("Frame", Side)
    TabContainer.Size = UDim2.new(1, 0, 1, -70)
    TabContainer.Position = UDim2.new(0, 0, 0, 70)
    TabContainer.BackgroundTransparency = 1
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.HorizontalAlignment = "Center"
    TabList.Padding = UDim.new(0, 5)

    -- Conteneur de Pages
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -170, 1, -20)
    PageContainer.Position = UDim2.new(0, 160, 0, 10)
    PageContainer.BackgroundTransparency = 1

    -- Fonction pour créer des onglets
    local function CreateTab(name, active)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = active
        Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 38)
        TabBtn.Text = name
        TabBtn.Font = "GothamBold"
        TabBtn.TextColor3 = Color3.new(1, 1, 1)
        TabBtn.BackgroundColor3 = active and Config.AccentColor or Color3.fromRGB(30, 30, 30)
        Instance.new("UICorner", TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Config.AccentColor
        end)
        return Page
    end

    -- Les Pages
    local P_Combat = CreateTab("COMBAT", true)
    local P_Visual = CreateTab("VISUELS", false)
    local P_Moves = CreateTab("MOVES", false)
    local P_Settings = CreateTab("SETTINGS", false)

    -- Composant Toggle
    local function AddToggle(parent, text, var)
        local TFrame = Instance.new("Frame", parent)
        TFrame.Size = UDim2.new(1, -10, 0, 45)
        TFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Instance.new("UICorner", TFrame)

        local Label = Instance.new("TextLabel", TFrame)
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.Text = text
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = "Gotham"
        Label.TextXAlignment = "Left"
        Label.BackgroundTransparency = 1

        local Btn = Instance.new("TextButton", TFrame)
        Btn.Size = UDim2.new(0, 45, 0, 22)
        Btn.Position = UDim2.new(1, -55, 0.5, -11)
        Btn.Text = ""
        Btn.BackgroundColor3 = Config[var] and Config.AccentColor or Color3.fromRGB(50, 50, 50)
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

        Btn.MouseButton1Click:Connect(function()
            Config[var] = not Config[var]
            Btn.BackgroundColor3 = Config[var] and Config.AccentColor or Color3.fromRGB(50, 50, 50)
        end)
    end

    -- Composant Slider
    local function AddSlider(parent, text, min, max, var)
        local SFrame = Instance.new("Frame", parent)
        SFrame.Size = UDim2.new(1, -10, 0, 60)
        SFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Instance.new("UICorner", SFrame)

        local Label = Instance.new("TextLabel", SFrame)
        Label.Size = UDim2.new(1, 0, 0, 30)
        Label.Position = UDim2.new(0, 12, 0, 5)
        Label.Text = text .. " : " .. Config[var]
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = "Gotham"
        Label.TextXAlignment = "Left"
        Label.BackgroundTransparency = 1

        local SliderBack = Instance.new("Frame", SFrame)
        SliderBack.Size = UDim2.new(0.9, 0, 0, 6)
        SliderBack.Position = UDim2.new(0.05, 0, 0, 45)
        SliderBack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Instance.new("UICorner", SliderBack)

        local Fill = Instance.new("Frame", SliderBack)
        Fill.Size = UDim2.new((Config[var] - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Config.AccentColor
        Instance.new("UICorner", Fill)

        SliderBack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    local mouseX = UIS:GetMouseLocation().X
                    local relativeX = math.clamp((mouseX - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * relativeX)
                    Config[var] = value
                    Label.Text = text .. " : " .. value
                    Fill.Size = UDim2.new(relativeX, 0, 1, 0)
                end)
                UIS.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                        connection:Disconnect()
                    end
                end)
            end
        end)
    end

    -- Onglet Combat
    AddToggle(P_Combat, "AIMBOT", "Aimbot")
    AddToggle(P_Combat, "AFFICHER CERCLE FOV", "ShowFOV")
    AddSlider(P_Combat, "RAYON FOV", 10, 1000, "FOV")
    AddSlider(P_Combat, "LISSAGE AIM", 0, 1, "Smoothness")

    -- Onglet Visuels
    AddToggle(P_Visual, "ESP BOX", "ESP_Box")
    AddToggle(P_Visual, "ESP SANTÉ", "ESP_Health")
    
    local PalLabel = Instance.new("TextLabel", P_Visual)
    PalLabel.Size = UDim2.new(1, 0, 0, 30)
    PalLabel.Text = "COULEUR DU CHEAT"
    PalLabel.TextColor3 = Color3.new(1, 1, 1)
    PalLabel.Font = "GothamBold"
    PalLabel.BackgroundTransparency = 1

    local PaletteFrame = Instance.new("Frame", P_Visual)
    PaletteFrame.Size = UDim2.new(1, -10, 0, 80)
    PaletteFrame.BackgroundTransparency = 1
    local UIGrid = Instance.new("UIGridLayout", PaletteFrame)
    UIGrid.CellSize = UDim2.new(0, 45, 0, 45)
    UIGrid.Padding = UDim2.new(0, 10, 0, 10)

    for name, color in pairs(Palette) do
        local CBtn = Instance.new("TextButton", PaletteFrame)
        CBtn.BackgroundColor3 = color
        CBtn.Text = ""
        Instance.new("UICorner", CBtn)
        CBtn.MouseButton1Click:Connect(function()
            Config.AccentColor = color
            Stroke.Color = color
            for _, b in pairs(TabContainer:GetChildren()) do
                if b:IsA("TextButton") and b.BackgroundColor3 ~= Color3.fromRGB(30, 30, 30) then
                    b.BackgroundColor3 = color
                end
            end
        end)
    end

    -- Onglet Moves
    AddSlider(P_Moves, "VITESSE (MAX 1000)", 16, 1000, "WalkSpeed")
    AddSlider(P_Moves, "SAUT (MAX 1000)", 50, 1000, "JumpPower")
    AddToggle(P_Moves, "VOLER (FLY)", "Fly")
    AddToggle(P_Moves, "PASSER MURS (NOCLIP)", "NoClip")
    AddToggle(P_Moves, "INVISIBLE (GHOST)", "Invisible")

    -- Onglet Settings (Binds)
    local function AddBind(parent, text, var)
        local BFrame = Instance.new("Frame", parent)
        BFrame.Size = UDim2.new(1, -10, 0, 45)
        BFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Instance.new("UICorner", BFrame)

        local L = Instance.new("TextLabel", BFrame)
        L.Size = UDim2.new(1, 0, 1, 0)
        L.Text = text .. " : " .. Config[var].Name
        L.TextColor3 = Color3.new(1, 1, 1)
        L.BackgroundTransparency = 1
        
        BFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                L.Text = "Appuyez sur une touche..."
                local c; c = UIS.InputBegan:Connect(function(key)
                    if key.KeyCode ~= Enum.KeyCode.Unknown then
                        Config[var] = key.KeyCode
                        L.Text = text .. " : " .. key.KeyCode.Name
                        c:Disconnect()
                    end
                end)
            end
        end)
    end
    AddBind(P_Settings, "TOUCHE MENU", "MenuKey")
    AddBind(P_Settings, "TOUCHE AIMBOT", "AimKey")
    AddBind(P_Settings, "TOUCHE SPEED", "SpeedKey")

    -- BOUCLE DE RENDU ET LOGIQUE
    local Circle = Drawing.new("Circle")
    Circle.Thickness = 2
    Circle.Filled = false

    RunService.RenderStepped:Connect(function()
        Circle.Visible = Config.ShowFOV
        Circle.Radius = Config.FOV
        Circle.Position = UIS:GetMouseLocation()
        Circle.Color = Config.AccentColor

        if Config.Aimbot then
            local t = GetClosestTarget()
            if t and (UIS:IsMouseButtonPressed(1) or UIS:IsMouseButtonPressed(2)) then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.HumanoidRootPart.Position), Config.Smoothness)
            end
        end

        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = Config.WalkSpeed
            LP.Character.Humanoid.JumpPower = Config.JumpPower
            if Config.Fly then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 5, 0) end
            if Config.NoClip then
                for _, v in pairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end)

    -- DRAG SYSTEM
    local drag, dragS, startP
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true dragS = i.Position startP = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragS
        Main.Position = UDim2.new(startP.X.Scale, startP.X.Offset + delta.X, startP.Y.Scale, startP.Y.Offset + delta.Y)
    end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
end

Launch()
