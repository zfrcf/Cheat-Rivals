-- [[ SOLOCHEAT V4 PREMIUM - RIVALS X XENO ]] --
-- [[ FULL SOURCE CODE | 500+ LINES ARCHITECTURE ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

-- [[ 1. SERVICES ET CONSTANTES ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 2. CONFIGURATION ET THÈME ]] --
local Config = {
    Visuals = {
        Accent = Color3.fromRGB(0, 255, 150),
        Background = Color3.fromRGB(12, 12, 12),
        Secondary = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(240, 240, 240),
        MenuKey = Enum.KeyCode.K -- TOUCHE K AJOUTÉE
    },
    Combat = {
        Aimbot = false,
        FOV = 150,
        Smoothness = 0.05,
        TargetPart = "Head",
        ShowFOV = true,
        TeamCheck = true
    },
    Movement = {
        FlyEnabled = false,
        FlySpeed = 80,
        SpeedHack = false,
        WalkSpeedValue = 40,
        NoClip = false
    }
}

-- [[ 3. SYSTÈMES DE DESSIN ]] --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = Config.Combat.FOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Config.Visuals.Accent

-- [[ 4. NETTOYAGE ]] --
if CoreGui:FindFirstChild("SoloCheatPremium") then CoreGui.SoloCheatPremium:Destroy() end

local function MakeDraggable(topbar, frame)
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- [[ 5. LOGIQUE AIMBOT & MOUVEMENT ]] --
local function GetClosestPlayer()
    local target, dist = nil, Config.Combat.FOV
    local mousePos = UIS:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.Combat.TargetPart) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if Config.Combat.TeamCheck and p.Team == LocalPlayer.Team then continue end
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character[Config.Combat.TargetPart].Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if mag < dist then dist = mag; target = p.Character[Config.Combat.TargetPart] end
                end
            end
        end
    end
    return target
end

local function UpdateMovement()
    RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")

        if Config.Movement.SpeedHack and hum then hum.WalkSpeed = Config.Movement.WalkSpeedValue end

        if Config.Movement.FlyEnabled then
            if not hrp:FindFirstChild("SoloCheatFly") then
                local bv = Instance.new("BodyVelocity", hrp); bv.Name = "SoloCheatFly"; bv.MaxForce = Vector3.new(1,1,1)*10^7
                local bg = Instance.new("BodyGyro", hrp); bg.Name = "SoloCheatGyro"; bg.MaxTorque = Vector3.new(1,1,1)*10^7
            end
            local vel = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then vel = vel + Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then vel = vel - Camera.CFrame.RightVector end
            hrp.SoloCheatFly.Velocity = vel * Config.Movement.FlySpeed
            hrp.SoloCheatGyro.CFrame = Camera.CFrame
        elseif hrp:FindFirstChild("SoloCheatFly") then
            hrp.SoloCheatFly:Destroy(); hrp.SoloCheatGyro:Destroy()
        end
        
        if Config.Movement.NoClip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)
end

-- [[ 6. INTERFACE UI ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "SoloCheatPremium"
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 550, 0, 400); Main.Position = UDim2.new(0.5, -275, 0.5, -200); Main.BackgroundColor3 = Config.Visuals.Background; Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local TopBar = Instance.new("Frame", Main); TopBar.Size = UDim2.new(1, 0, 0, 45); TopBar.BackgroundColor3 = Config.Visuals.Secondary; TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
MakeDraggable(TopBar, Main)

-- GESTION TOUCHE K
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Config.Visuals.MenuKey then
        Main.Visible = not Main.Visible
    end
end)

local Title = Instance.new("TextLabel", TopBar); Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.Text = "SOLOCHEAT | [K] TO HIDE"; Title.TextColor3 = Config.Visuals.TextColor; Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, -45); Sidebar.Position = UDim2.new(0, 0, 0, 45); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Sidebar.BorderSizePixel = 0
local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -140, 1, -55); Container.Position = UDim2.new(0, 135, 0, 50); Container.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Sidebar); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIList.Padding = UDim.new(0, 5)

local Tabs = {}
local TabBtns = {}

local function NewTab(name)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Config.Visuals.Secondary; b.TextColor3 = Color3.fromRGB(150, 150, 150); b.Font = Enum.Font.Gotham; b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.Visible = false end
        for _, v in pairs(TabBtns) do v.TextColor3 = Color3.fromRGB(150, 150, 150) end
        p.Visible = true; b.TextColor3 = Config.Visuals.Accent
    end)
    table.insert(Tabs, p); table.insert(TabBtns, b)
    return p
end

-- [ FONCTIONS ADDITIONS ] --
local function AddToggle(parent, text, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 40); f.BackgroundColor3 = Config.Visuals.Secondary; f.BorderSizePixel = 0; Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -50, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.Text = text; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.BackgroundTransparency = 1; l.Font = Enum.Font.Gotham; l.TextXAlignment = 0
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 40, 0, 20); b.Position = UDim2.new(1, -50, 0.5, -10); b.Text = ""; b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s
        TweenService:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = s and Config.Visuals.Accent or Color3.fromRGB(40, 40, 40)}):Play()
        callback(s)
    end)
end

local function AddSlider(parent, text, min, max, def, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 60); f.BackgroundColor3 = Config.Visuals.Secondary; f.BorderSizePixel = 0; Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 25); l.Position = UDim2.new(0, 10, 0, 5); l.Text = text .. " : " .. def; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.BackgroundTransparency = 1; l.Font = Enum.Font.Gotham; l.TextXAlignment = 0
    local sbg = Instance.new("Frame", f); sbg.Size = UDim2.new(1, -30, 0, 6); sbg.Position = UDim2.new(0, 15, 0, 40); sbg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local sfill = Instance.new("Frame", sbg); sfill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); sfill.BackgroundColor3 = Config.Visuals.Accent
    sbg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            local move = UIS.InputChanged:Connect(function(i2)
                if i2.UserInputType == Enum.UserInputType.MouseMovement then
                    local per = math.clamp((i2.Position.X - sbg.AbsolutePosition.X) / sbg.AbsoluteSize.X, 0, 1)
                    sfill.Size = UDim2.new(per, 0, 1, 0); local val = math.floor(min + (max - min) * per); l.Text = text .. " : " .. val; callback(val)
                end
            end)
            UIS.InputEnded:Connect(function(i3) if i3.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
        end
    end)
end

-- [[ 7. ASSEMBLAGE ]] --
local MainTab = NewTab("Combat")
local MoveTab = NewTab("Movement")

AddToggle(MainTab, "Enable Aimbot", function(v) Config.Combat.Aimbot = v end)
AddToggle(MainTab, "Show FOV", function(v) Config.Combat.ShowFOV = v end)
AddSlider(MainTab, "FOV Size", 50, 800, 150, function(v) Config.Combat.FOV = v end)

AddToggle(MoveTab, "Fly (W/S/A/D)", function(v) Config.Movement.FlyEnabled = v end)
AddToggle(MoveTab, "NoClip", function(v) Config.Movement.NoClip = v end)
AddToggle(MoveTab, "SpeedHack", function(v) Config.Movement.SpeedHack = v end)
AddSlider(MoveTab, "Speed Value", 16, 200, 40, function(v) Config.Movement.WalkSpeedValue = v end)

UpdateMovement()
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Config.Combat.ShowFOV; FOVCircle.Radius = Config.Combat.FOV; FOVCircle.Position = UIS:GetMouseLocation()
    if Config.Combat.Aimbot then
        local t = GetClosestPlayer()
        if t then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), Config.Combat.Smoothness) end
    end
end)

Tabs[1].Visible = true; TabBtns[1].TextColor3 = Config.Visuals.Accent
print("SoloCheat V4 Loaded! Press K to Hide.")
