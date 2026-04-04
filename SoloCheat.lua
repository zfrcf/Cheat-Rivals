-- [[ SoloCheat - V1 PRO ]] --
-- [[ EDITION : ULTIMATE | MOBILE & PC | KEY SYSTEM | UNLOCKED ]] --

-- ========================================== --
-- [[ 1. INITIALISATION & SECURITÉ ]]         --
-- ========================================== --

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- Configuration Globale
local Config = {
    Key = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    AccentColor = Color3.fromRGB(255, 0, 80),
    SecondaryColor = Color3.fromRGB(25, 25, 25),
    BgColor = Color3.fromRGB(15, 15, 15),
    
    -- États des fonctions
    SilentAim = false,
    TriggerBot = false,
    TPKill = false,
    FOV = 150,
    ShowFOV = false,
    
    ESP_Box = false,
    ESP_Name = false,
    
    WalkSpeed = 16,
    Fly = false,
    FlySpeed = 2,
    NoClip = false,
    AntiRagdoll = true,
    
    MenuBind = Enum.KeyCode.RightControl
}

-- ========================================== --
-- [[ 2. FONCTIONS UTILITAIRES ]]             --
-- ========================================== --

local function MakeDraggable(obj, dragZone)
    local dragging, dragInput, dragStart, startPos
    dragZone = dragZone or obj

    dragZone.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function GetClosestPlayer()
    local target = nil
    local dist = Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
            if p.Character.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local magnitude = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if magnitude < dist then
                        dist = magnitude
                        target = p.Character.HumanoidRootPart
                    end
                end
            end
        end
    end
    return target
end

-- ========================================== --
-- [[ 3. L'INTERFACE PRINCIPALE (MENU) ]]     --
-- ========================================== --

local function LaunchCheat()
    if CoreGui:FindFirstChild("SoloV1_Master") then CoreGui.SoloV1_Master:Destroy() end

    local Screen = Instance.new("ScreenGui", CoreGui)
    Screen.Name = "SoloV1_Master"
    Screen.ResetOnSpawn = false

    -- Bouton de réouverture (Mobile)
    local OpenBtn = Instance.new("TextButton", Screen)
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
    OpenBtn.BackgroundColor3 = Config.AccentColor
    OpenBtn.Text = "S"
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextColor3 = Color3.new(1,1,1)
    OpenBtn.Visible = false
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Config.BgColor
    Main.BorderSizePixel = 0
    local MainCorner = Instance.new("UICorner", Main)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Config.AccentColor
    MainStroke.Thickness = 2

    -- Barre de navigation (Sidebar)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Config.SecondaryColor
    Instance.new("UICorner", Sidebar)

    local Title = Instance.new("TextLabel", Sidebar)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "SOLO V1"
    Title.TextColor3 = Config.AccentColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.BackgroundTransparency = 1

    -- Boutons Top (Fermer / Réduire)
    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.Text = "X"
    Close.TextColor3 = Color3.new(1,0,0)
    Close.BackgroundTransparency = 1
    
    local Mini = Instance.new("TextButton", Main)
    Mini.Size = UDim2.new(0, 30, 0, 30)
    Mini.Position = UDim2.new(1, -65, 0, 5)
    Mini.Text = "-"
    Mini.TextColor3 = Color3.new(1,1,1)
    Mini.BackgroundTransparency = 1
    Mini.TextSize = 25

    -- Système d'Onglets
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -140, 1, -10)
    Container.Position = UDim2.new(0, 135, 0, 5)
    Container.BackgroundTransparency = 1

    local Tabs = {}
    local function CreateTab(name, active)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = active
        Page.ScrollBarThickness = 0
        
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 10)
        
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.Position = UDim2.new(0.05, 0, 0, 60 + (#Sidebar:GetChildren() * 40))
        TabBtn.Text = name
        TabBtn.BackgroundColor3 = active and Config.AccentColor or Color3.fromRGB(35,35,35)
        TabBtn.TextColor3 = Color3.new(1,1,1)
        TabBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do p.Visible = false end
            for _, b in pairs(Sidebar:GetChildren()) do 
                if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(35,35,35) end
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Config.AccentColor
        end)

        return Page
    end

    local PageCombat = CreateTab("COMBAT", true)
    local PageVisuals = CreateTab("VISUALS", false)
    local PageMovement = CreateTab("MOVES", false)
    local PageSettings = CreateTab("SKINS", false)

    -- Elements UI Builder
    local function AddToggle(parent, text, var)
        local Frame = Instance.new("Frame", parent)
        Frame.Size = UDim2.new(1, -10, 0, 40)
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Instance.new("UICorner", Frame)
        
        local Lbl = Instance.new("TextLabel", Frame)
        Lbl.Size = UDim2.new(1, -50, 1, 0)
        Lbl.Position = UDim2.new(0, 10, 0, 0)
        Lbl.Text = text
        Lbl.TextColor3 = Color3.new(1,1,1)
        Lbl.BackgroundTransparency = 1
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Font = Enum.Font.Gotham

        local Tog = Instance.new("TextButton", Frame)
        Tog.Size = UDim2.new(0, 40, 0, 20)
        Tog.Position = UDim2.new(1, -50, 0.5, -10)
        Tog.BackgroundColor3 = Config[var] and Config.AccentColor or Color3.fromRGB(60,60,60)
        Tog.Text = ""
        Instance.new("UICorner", Tog).CornerRadius = UDim.new(1,0)

        Tog.MouseButton1Click:Connect(function()
            Config[var] = not Config[var]
            Tog.BackgroundColor3 = Config[var] and Config.AccentColor or Color3.fromRGB(60,60,60)
        end)
    end

    -- REMPLISSAGE DES PAGES
    AddToggle(PageCombat, "SILENT AIM (MOUSE 2)", "SilentAim")
    AddToggle(PageCombat, "TRIGGER BOT", "TriggerBot")
    AddToggle(PageCombat, "TP KILL", "TPKill")
    AddToggle(PageCombat, "SHOW FOV", "ShowFOV")

    AddToggle(PageVisuals, "ESP BOXES", "ESP_Box")
    AddToggle(PageVisuals, "ESP NAMES", "ESP_Name")

    AddToggle(PageMovement, "NOCLIP", "NoClip")
    AddToggle(PageMovement, "FLY MODE", "Fly")
    AddToggle(PageMovement, "ANTI RAGDOLL", "AntiRagdoll")

    local SpeedBtn = Instance.new("TextButton", PageMovement)
    SpeedBtn.Size = UDim2.new(1, -10, 0, 40)
    SpeedBtn.Text = "SET SPEED TO 45"
    SpeedBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    SpeedBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", SpeedBtn)
    SpeedBtn.MouseButton1Click:Connect(function() 
        Config.WalkSpeed = Config.WalkSpeed == 16 and 45 or 16 
        SpeedBtn.Text = "SPEED : " .. Config.WalkSpeed
    end)

    local SkinBtn = Instance.new("TextButton", PageSettings)
    SkinBtn.Size = UDim2.new(1, -10, 0, 50)
    SkinBtn.Text = "ACTIVER SKINCHANGER (ECON)"
    SkinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    SkinBtn.TextColor3 = Color3.new(1,1,1)
    SkinBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", SkinBtn)
    SkinBtn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EconRCO/Econ/refs/heads/main/Init"))()
    end)

    -- LOGIQUE DE FONCTIONNEMENT
    MakeDraggable(Main, Sidebar)

    Close.MouseButton1Click:Connect(function() Screen:Destroy() end)
    Mini.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
    OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

    -- FOV Circle
    local Circle = Drawing.new("Circle")
    Circle.Thickness = 1
    Circle.Color = Config.AccentColor
    Circle.Transparency = 1
    Circle.Filled = false

    -- Boucle Heartbeat
    RunService.Heartbeat:Connect(function()
        if not Screen.Parent then Circle:Remove() return end
        
        Circle.Visible = Config.ShowFOV
        Circle.Radius = Config.FOV
        Circle.Position = UIS:GetMouseLocation()

        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = Config.WalkSpeed
            
            if Config.Fly and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0)
            end

            if Config.NoClip then
                for _, v in pairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end

            if Config.SilentAim and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local t = GetClosestPlayer()
                if t and mousemoverel then
                    local p = Camera:WorldToViewportPoint(t.Position)
                    local m = UIS:GetMouseLocation()
                    mousemoverel((p.X - m.X)*0.7, (p.Y - m.Y)*0.7)
                end
            end
        end
    end)

    -- Système ESP
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local box = p.Character:FindFirstChild("SoloBox")
                if Config.ESP_Box then
                    if not box then
                        box = Instance.new("BoxHandleAdornment", p.Character)
                        box.Name = "SoloBox"
                        box.AlwaysOnTop = true
                        box.Size = Vector3.new(4, 5, 1)
                        box.ZIndex = 5
                        box.Transparency = 0.5
                        box.Color3 = Config.AccentColor
                        box.Adornee = p.Character
                    end
                    box.Visible = true
                elseif box then
                    box.Visible = false
                end
            end
        end
    end)
end

-- ========================================== --
-- [[ 4. SYSTÈME DE CLÉ (START) ]]            --
-- ========================================== --

local function InitKey()
    local KeyUI = Instance.new("ScreenGui", CoreGui)
    KeyUI.Name = "SoloKeySystem"
    
    local KF = Instance.new("Frame", KeyUI)
    KF.Size = UDim2.new(0, 350, 0, 200)
    KF.Position = UDim2.new(0.5, -175, 0.5, -100)
    KF.BackgroundColor3 = Config.BgColor
    local KC = Instance.new("UICorner", KF)
    local KS = Instance.new("UIStroke", KF)
    KS.Color = Config.AccentColor
    KS.Thickness = 2
    MakeDraggable(KF)

    local T = Instance.new("TextLabel", KF)
    T.Size = UDim2.new(1, 0, 0, 50)
    T.Text = "SOLO CHEAT V1 - KEY"
    T.TextColor3 = Config.AccentColor
    T.Font = Enum.Font.GothamBold
    T.BackgroundTransparency = 1

    local Box = Instance.new("TextBox", KF)
    Box.Size = UDim2.new(0.8, 0, 0, 40)
    Box.Position = UDim2.new(0.1, 0, 0.35, 0)
    Box.PlaceholderText = "Paste Key Here..."
    Box.BackgroundColor3 = Config.SecondaryColor
    Box.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Box)

    local Verify = Instance.new("TextButton", KF)
    Verify.Size = UDim2.new(0.4, 0, 0, 40)
    Verify.Position = UDim2.new(0.1, 0, 0.65, 0)
    Verify.BackgroundColor3 = Config.AccentColor
    Verify.Text = "VERIFY"
    Verify.TextColor3 = Color3.new(1,1,1)
    Verify.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Verify)

    local GetK = Instance.new("TextButton", KF)
    GetK.Size = UDim2.new(0.4, 0, 0, 40)
    GetK.Position = UDim2.new(0.5, 5, 0.65, 0)
    GetK.BackgroundColor3 = Color3.fromRGB(40,40,40)
    GetK.Text = "GET KEY"
    GetK.TextColor3 = Color3.new(1,1,1)
    GetK.Font = Enum.Font.GothamBold
    Instance.new("UICorner", GetK)

    Verify.MouseButton1Click:Connect(function()
        if Box.Text == Config.Key then
            KeyUI:Destroy()
            LaunchCheat()
        else
            Verify.Text = "WRONG KEY"
            task.wait(1)
            Verify.Text = "VERIFY"
        end
    end)

    GetK.MouseButton1Click:Connect(function()
        setclipboard(Config.Discord)
        GetK.Text = "LINK COPIED"
        task.wait(1)
        GetK.Text = "GET KEY"
    end)
end

-- Lancement de la séquence
InitKey()
