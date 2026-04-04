-- [[ SoloCheat - V1 PRO ]] --
-- [[ EDITION : ULTIMATE V2 | SLIDER UPDATE | MOBILE & PC ]] --

repeat task.wait() until game:IsLoaded()

-- ========================================== --
-- [[ 1. SERVICES & CONFIGURATION ]]          --
-- ========================================== --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

local Config = {
    Key = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    AccentColor = Color3.fromRGB(255, 0, 80),
    SecondaryColor = Color3.fromRGB(25, 25, 25),
    BgColor = Color3.fromRGB(15, 15, 15),
    
    -- Features
    SilentAim = false,
    TriggerBot = false,
    TPKill = false,
    FOV = 150,
    ShowFOV = false,
    
    ESP_Box = false,
    ESP_Name = false,
    
    WalkSpeed = 16,
    Fly = false,
    NoClip = false,
    AntiRagdoll = true
}

-- ========================================== --
-- [[ 2. FONCTIONS MATHÉMATIQUES & LOGIQUE ]] --
-- ========================================== --

local function MakeDraggable(obj, dragZone)
    local dragging, dragStart, startPos
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

local function GetClosest()
    local target, dist = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < dist then
                        dist = mag
                        target = p.Character.HumanoidRootPart
                    end
                end
            end
        end
    end
    return target
end

-- ========================================== --
-- [[ 3. CONSTRUCTION DE L'INTERFACE ]]       --
-- ========================================== --

local function LaunchCheat()
    if CoreGui:FindFirstChild("SoloV1_Master") then CoreGui.SoloV1_Master:Destroy() end

    local Screen = Instance.new("ScreenGui", CoreGui)
    Screen.Name = "SoloV1_Master"
    Screen.ResetOnSpawn = false

    -- Floating Open Button
    local OpenBtn = Instance.new("TextButton", Screen)
    OpenBtn.Size = UDim2.new(0, 45, 0, 45)
    OpenBtn.Position = UDim2.new(0, 5, 0.5, -22)
    OpenBtn.BackgroundColor3 = Config.AccentColor
    OpenBtn.Text = "S"
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextColor3 = Color3.new(1,1,1)
    OpenBtn.Visible = false
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    local OpenStroke = Instance.new("UIStroke", OpenBtn)
    OpenStroke.Thickness = 2
    OpenStroke.Color = Color3.new(1,1,1)

    -- Main Frame
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 520, 0, 380)
    Main.Position = UDim2.new(0.5, -260, 0.5, -190)
    Main.BackgroundColor3 = Config.BgColor
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Config.AccentColor
    MainStroke.Thickness = 2

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Config.SecondaryColor
    Instance.new("UICorner", Sidebar)

    local Title = Instance.new("TextLabel", Sidebar)
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Text = "SOLO V1 PRO"
    Title.TextColor3 = Config.AccentColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1

    -- Header Buttons
    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 50, 50)
    Close.BackgroundTransparency = 1
    Close.Font = Enum.Font.GothamBold
    
    local Mini = Instance.new("TextButton", Main)
    Mini.Size = UDim2.new(0, 30, 0, 30)
    Mini.Position = UDim2.new(1, -65, 0, 5)
    Mini.Text = "-"
    Mini.TextColor3 = Color3.new(1,1,1)
    Mini.BackgroundTransparency = 1
    Mini.TextSize = 25
    Mini.Font = Enum.Font.GothamBold

    -- Tabs Container
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -155, 1, -20)
    Container.Position = UDim2.new(0, 145, 0, 10)
    Container.BackgroundTransparency = 1

    local Tabs = {}
    local function CreateTab(name, active)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = active
        Page.ScrollBarThickness = 2
        Page.CanvasSize = UDim2.new(0,0,1.5,0)
        
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 10)
        
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 38)
        TabBtn.Position = UDim2.new(0.05, 0, 0, 70 + (#Sidebar:GetChildren() * 45))
        TabBtn.Text = name
        TabBtn.BackgroundColor3 = active and Config.AccentColor or Color3.fromRGB(30,30,30)
        TabBtn.TextColor3 = Color3.new(1,1,1)
        TabBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do p.Visible = false end
            for _, b in pairs(Sidebar:GetChildren()) do 
                if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(30,30,30) end
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Config.AccentColor
        end)
        return Page
    end

    local PageCombat = CreateTab("COMBAT", true)
    local PageVisuals = CreateTab("VISUALS", false)
    local PageMovement = CreateTab("MOVES", false)
    local PageMisc = CreateTab("SKINS", false)

    -- UI ELEMENTS BUILDER
    local function AddToggle(parent, text, var)
        local TFrame = Instance.new("Frame", parent)
        TFrame.Size = UDim2.new(1, -10, 0, 45)
        TFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Instance.new("UICorner", TFrame)
        
        local Lbl = Instance.new("TextLabel", TFrame)
        Lbl.Size = UDim2.new(1, -60, 1, 0)
        Lbl.Position = UDim2.new(0, 12, 0, 0)
        Lbl.Text = text
        Lbl.TextColor3 = Color3.new(1,1,1)
        Lbl.BackgroundTransparency = 1
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Font = Enum.Font.Gotham
        Lbl.TextSize = 14

        local Btn = Instance.new("TextButton", TFrame)
        Btn.Size = UDim2.new(0, 45, 0, 22)
        Btn.Position = UDim2.new(1, -55, 0.5, -11)
        Btn.BackgroundColor3 = Config[var] and Config.AccentColor or Color3.fromRGB(50,50,50)
        Btn.Text = ""
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)

        Btn.MouseButton1Click:Connect(function()
            Config[var] = not Config[var]
            local goal = Config[var] and Config.AccentColor or Color3.fromRGB(50,50,50)
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = goal}):Play()
        end)
    end

    -- SLIDER FONCTION (NEW)
    local function AddSlider(parent, text, min, max, var)
        local SFrame = Instance.new("Frame", parent)
        SFrame.Size = UDim2.new(1, -10, 0, 65)
        SFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Instance.new("UICorner", SFrame)

        local Lbl = Instance.new("TextLabel", SFrame)
        Lbl.Size = UDim2.new(1, 0, 0, 30)
        Lbl.Position = UDim2.new(0, 12, 0, 5)
        Lbl.Text = text .. " : " .. Config[var]
        Lbl.TextColor3 = Color3.new(1,1,1)
        Lbl.BackgroundTransparency = 1
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Font = Enum.Font.Gotham
        Lbl.TextSize = 14

        local SliderBack = Instance.new("Frame", SFrame)
        SliderBack.Size = UDim2.new(0.9, 0, 0, 6)
        SliderBack.Position = UDim2.new(0.05, 0, 0, 45)
        SliderBack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Instance.new("UICorner", SliderBack)

        local SliderFill = Instance.new("Frame", SliderBack)
        SliderFill.Size = UDim2.new((Config[var] - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Config.AccentColor
        Instance.new("UICorner", SliderFill)

        local Knob = Instance.new("Frame", SliderFill)
        Knob.Size = UDim2.new(0, 14, 0, 14)
        Knob.Position = UDim2.new(1, -7, 0.5, -7)
        Knob.BackgroundColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)

        local function UpdateSlider(input)
            local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(min + (max - min) * pos)
            Config[var] = value
            Lbl.Text = text .. " : " .. value
        end

        local sliding = false
        SFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                UpdateSlider(input)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlider(input)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)
    end

    -- POPULATE TABS
    AddToggle(PageCombat, "SILENT AIM (MOUSE2)", "SilentAim")
    AddToggle(PageCombat, "TRIGGER BOT", "TriggerBot")
    AddToggle(PageCombat, "TELEPORT KILL", "TPKill")
    AddToggle(PageCombat, "SHOW FOV CIRCLE", "ShowFOV")
    AddSlider(PageCombat, "FOV RADIUS", 30, 600, "FOV")

    AddToggle(PageVisuals, "ESP BOXES", "ESP_Box")
    AddToggle(PageVisuals, "ESP NAMES", "ESP_Name")

    AddToggle(PageMovement, "NOCLIP", "NoClip")
    AddToggle(PageMovement, "FLY MODE", "Fly")
    AddToggle(PageMovement, "ANTI RAGDOLL", "AntiRagdoll")
    
    local SpeedBtn = Instance.new("TextButton", PageMovement)
    SpeedBtn.Size = UDim2.new(1, -10, 0, 45)
    SpeedBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    SpeedBtn.Text = "WALKSPEED : 16 (CLIC TO TOGGLE)"
    SpeedBtn.TextColor3 = Color3.new(1,1,1)
    SpeedBtn.Font = Enum.Font.Gotham
    Instance.new("UICorner", SpeedBtn)
    SpeedBtn.MouseButton1Click:Connect(function()
        Config.WalkSpeed = (Config.WalkSpeed == 16 and 45 or 16)
        SpeedBtn.Text = "WALKSPEED : " .. Config.WalkSpeed
    end)

    local SkinBtn = Instance.new("TextButton", PageMisc)
    SkinBtn.Size = UDim2.new(1, -10, 0, 50)
    SkinBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 100)
    SkinBtn.Text = "LOAD ECON SKINCHANGER"
    SkinBtn.TextColor3 = Color3.new(1,1,1)
    SkinBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", SkinBtn)
    SkinBtn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EconRCO/Econ/refs/heads/main/Init"))()
    end)

    -- MAIN LOOP
    MakeDraggable(Main, Sidebar)
    Close.MouseButton1Click:Connect(function() Screen:Destroy() end)
    Mini.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
    OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

    local Circle = Drawing.new("Circle")
    Circle.Thickness = 1.5
    Circle.Color = Config.AccentColor
    Circle.Filled = false
    Circle.Transparency = 1

    RunService.Heartbeat:Connect(function()
        if not Screen.Parent then Circle:Remove() return end
        
        Circle.Visible = Config.ShowFOV
        Circle.Radius = Config.FOV
        Circle.Position = UIS:GetMouseLocation()

        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            local hum = LP.Character.Humanoid
            hum.WalkSpeed = Config.WalkSpeed
            
            if Config.Fly and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 3, 0)
            end
            if Config.NoClip then
                for _, v in pairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
            if Config.SilentAim and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local t = GetClosest()
                if t and mousemoverel then
                    local p = Camera:WorldToViewportPoint(t.Position)
                    local m = UIS:GetMouseLocation()
                    mousemoverel((p.X - m.X)*0.65, (p.Y - m.Y)*0.65)
                end
            end
        end
    end)

    -- ESP SYSTEM
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local b = p.Character:FindFirstChild("SoloBox")
                if Config.ESP_Box then
                    if not b then
                        b = Instance.new("BoxHandleAdornment", p.Character)
                        b.Name = "SoloBox"
                        b.AlwaysOnTop = true
                        b.Size = Vector3.new(4, 5.5, 1)
                        b.Color3 = Config.AccentColor
                        b.Transparency = 0.6
                        b.Adornee = p.Character
                    end
                    b.Visible = true
                elseif b then b.Visible = false end
            end
        end
    end)
end

-- ========================================== --
-- [[ 4. KEY SYSTEM INITIALIZER ]]            --
-- ========================================== --

local function InitKey()
    local KeyUI = Instance.new("ScreenGui", CoreGui)
    KeyUI.Name = "SoloKeyV1"
    
    local KF = Instance.new("Frame", KeyUI)
    KF.Size = UDim2.new(0, 380, 0, 220)
    KF.Position = UDim2.new(0.5, -190, 0.5, -110)
    KF.BackgroundColor3 = Config.BgColor
    Instance.new("UICorner", KF)
    local KS = Instance.new("UIStroke", KF)
    KS.Color = Config.AccentColor
    KS.Thickness = 2
    MakeDraggable(KF)

    local T = Instance.new("TextLabel", KF)
    T.Size = UDim2.new(1, 0, 0, 60)
    T.Text = "SOLO CHEAT - KEY SYSTEM"
    T.TextColor3 = Config.AccentColor
    T.Font = Enum.Font.GothamBold
    T.BackgroundTransparency = 1
    T.TextSize = 18

    local Box = Instance.new("TextBox", KF)
    Box.Size = UDim2.new(0.85, 0, 0, 45)
    Box.Position = UDim2.new(0.075, 0, 0.35, 0)
    Box.PlaceholderText = "Enter Key..."
    Box.BackgroundColor3 = Config.SecondaryColor
    Box.TextColor3 = Color3.new(1,1,1)
    Box.Font = Enum.Font.Gotham
    Instance.new("UICorner", Box)

    local V = Instance.new("TextButton", KF)
    V.Size = UDim2.new(0.4, 0, 0, 40)
    V.Position = UDim2.new(0.075, 0, 0.65, 0)
    V.BackgroundColor3 = Config.AccentColor
    V.Text = "VERIFY"
    V.TextColor3 = Color3.new(1,1,1)
    V.Font = Enum.Font.GothamBold
    Instance.new("UICorner", V)

    local G = Instance.new("TextButton", KF)
    G.Size = UDim2.new(0.4, 0, 0, 40)
    G.Position = UDim2.new(0.525, 0, 0.65, 0)
    G.BackgroundColor3 = Color3.fromRGB(40,40,40)
    G.Text = "GET KEY"
    G.TextColor3 = Color3.new(1,1,1)
    G.Font = Enum.Font.GothamBold
    Instance.new("UICorner", G)

    V.MouseButton1Click:Connect(function()
        if Box.Text == Config.Key then
            KeyUI:Destroy()
            LaunchCheat()
        else
            V.Text = "INVALID KEY"
            task.wait(1)
            V.Text = "VERIFY"
        end
    end)

    G.MouseButton1Click:Connect(function()
        setclipboard(Config.Discord)
        G.Text = "LINK COPIED"
        task.wait(1)
        G.Text = "GET KEY"
    end)
end

InitKey()
