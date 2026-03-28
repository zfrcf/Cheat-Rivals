-- [[ SoloCheat - V1 TOTAL CONTROL ]] --
-- [[ STABLE + SLIDERS + KEYBINDS + KILL SWITCH ]] --

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [[ CONFIGURATION ]] --
local Config = {
    Active = true, -- Variable pour tout stopper
    Silent = false, FOV = 200, ShowFOV = true, TargetPart = "Head",
    Fly = false, FlySpeed = 2, NoClip = false,
    ESP_Box = false, ESP_HealthText = false,
    TP_Mode = "Disabled", 
    TP_Key = Enum.KeyCode.E,
    MenuKey = Enum.KeyCode.K,
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    AccentColor = Color3.fromRGB(0, 255, 150),
    BgColor = Color3.fromRGB(15, 15, 15),
    SecColor = Color3.fromRGB(25, 25, 25)
}

local function MakeDraggable(topbar, object)
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function GetClosestTarget()
    if not Config.Active then return nil end
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, vis = Camera:WorldToViewportPoint(p.Character[Config.TargetPart].Position)
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < nearest then nearest = dist; target = p.Character[Config.TargetPart] end
                end
            end
        end
    end
    return target
end

-- [[ INTERFACE ]] --
local function LaunchCheat()
    local MainUI = Instance.new("ScreenGui", CoreGui); MainUI.Name = "SoloV1_Final"
    local MainFrame = Instance.new("Frame", MainUI); MainFrame.Size = UDim2.new(0, 580, 0, 430); MainFrame.Position = UDim2.new(0.5, -290, 0.5, -215); MainFrame.BackgroundColor3 = Config.BgColor; MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame); Instance.new("UIStroke", MainFrame).Color = Config.AccentColor

    local TopBar = Instance.new("Frame", MainFrame); TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundColor3 = Config.SecColor; TopBar.BorderSizePixel = 0
    Instance.new("UICorner", TopBar); MakeDraggable(TopBar, MainFrame)

    local Title = Instance.new("TextLabel", TopBar); Title.Size = UDim2.new(1, -120, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.Text = "SoloCheat - V1 PRO"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0
    
    local MiniHint = Instance.new("TextLabel", TopBar); MiniHint.Size = UDim2.new(0, 60, 1, 0); MiniHint.Position = UDim2.new(1, -100, 0, 0); MiniHint.Text = "[ "..Config.MenuKey.Name.." ]"; MiniHint.TextColor3 = Config.AccentColor; MiniHint.Font = "GothamBold"; MiniHint.BackgroundTransparency = 1

    -- BOUTON FERMER (X)
    local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0.5, -15); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80); CloseBtn.Font = "GothamBold"; CloseBtn.BackgroundTransparency = 1; CloseBtn.TextSize = 20

    local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Size = UDim2.new(0, 150, 1, -45); Sidebar.Position = UDim2.new(0, 5, 0, 42); Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", Sidebar)
    local SideLayout = Instance.new("UIListLayout", Sidebar); SideLayout.Padding = UDim.new(0, 5); SideLayout.HorizontalAlignment = "Center"
    local Container = Instance.new("Frame", MainFrame); Container.Size = UDim2.new(1, -165, 1, -50); Container.Position = UDim2.new(0, 160, 0, 45); Container.BackgroundTransparency = 1

    local function AddTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar); TabBtn.Size = UDim2.new(0.9, 0, 0, 40); TabBtn.Text = name; TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TabBtn.TextColor3 = Color3.new(1, 1, 1); TabBtn.Font = "Gotham"; Instance.new("UICorner", TabBtn)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, b in pairs(Sidebar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.new(1, 1, 1) end end
            Page.Visible = true; TabBtn.TextColor3 = Config.AccentColor
        end)
        return Page
    end

    local function AddToggle(parent, text, cfg, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 40); b.Text = text .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() 
            cfg[key] = not cfg[key]; b.Text = text .. " : " .. (cfg[key] and "ON" or "OFF"); b.TextColor3 = cfg[key] and Config.AccentColor or Color3.new(1, 1, 1)
        end)
    end

    local function AddSlider(parent, text, cfg, key, min, max)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 55); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 25); l.Text = text .. " : " .. cfg[key]; l.TextColor3 = Color3.new(1, 1, 1); l.BackgroundTransparency = 1; l.Font = "Gotham"
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.9, 0, 0, 10); b.Position = UDim2.new(0.05, 0, 0.6, 0); b.Text = ""; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); Instance.new("UICorner", b)
        local fill = Instance.new("Frame", b); fill.Size = UDim2.new((cfg[key]-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Config.AccentColor; Instance.new("UICorner", fill)
        b.MouseButton1Click:Connect(function()
            local move = math.clamp((UIS:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
            cfg[key] = math.floor(min + (move * (max - min))); l.Text = text .. " : " .. cfg[key]; fill.Size = UDim2.new(move, 0, 1, 0)
        end)
    end

    local function AddKey(parent, text, cfg, key)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.Text = text; l.TextColor3 = Color3.new(1, 1, 1); l.BackgroundTransparency = 1; l.Font = "Gotham"; l.TextXAlignment = 0
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 80, 0, 30); b.Position = UDim2.new(1, -90, 0.5, -15); b.Text = cfg[key].Name; b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Config.AccentColor; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            b.Text = "..."; local c; c = UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    cfg[key] = i.KeyCode; b.Text = i.KeyCode.Name
                    if key == "MenuKey" then MiniHint.Text = "[ "..i.KeyCode.Name.." ]" end
                    c:Disconnect()
                end
            end)
        end)
    end

    local TCombat = AddTab("Combat"); local TVisuals = AddTab("Visuals"); local TMovement = AddTab("Movement"); local TSettings = AddTab("Settings")
    AddToggle(TCombat, "SILENT AIM", Config, "Silent"); AddToggle(TCombat, "SHOW FOV", Config, "ShowFOV")
    AddToggle(TVisuals, "ESP BOXES", Config, "ESP_Box"); AddToggle(TVisuals, "ESP HP/NAME", Config, "ESP_HealthText")
    AddToggle(TMovement, "FLY MODE", Config, "Fly"); AddToggle(TMovement, "NOCLIP", Config, "NoClip")
    AddSlider(TSettings, "FOV SIZE", Config, "FOV", 50, 800); AddSlider(TSettings, "FLY SPEED", Config, "FlySpeed", 1, 25)
    
    local TPBtn = Instance.new("TextButton", TSettings); TPBtn.Size = UDim2.new(1, -10, 0, 45); TPBtn.Text = "TP MODE : " .. Config.TP_Mode:upper(); TPBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TPBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", TPBtn)
    TPBtn.MouseButton1Click:Connect(function()
        if Config.TP_Mode == "Disabled" then Config.TP_Mode = "Mouse"
        elseif Config.TP_Mode == "Mouse" then Config.TP_Mode = "Look"
        else Config.TP_Mode = "Disabled" end
        TPBtn.Text = "TP MODE : " .. Config.TP_Mode:upper()
    end)
    AddKey(TSettings, "TP KEY", Config, "TP_Key"); AddKey(TSettings, "MENU KEY", Config, "MenuKey")

    -- [[ LOGIQUE DE FIN ]] --
    local Circle = Drawing.new("Circle"); Circle.Thickness = 1.5; Circle.Color = Config.AccentColor
    CloseBtn.MouseButton1Click:Connect(function()
        Config.Active = false; Config.Fly = false; Config.NoClip = false; Config.ESP_Box = false; Config.ESP_HealthText = false
        Circle:Remove(); MainUI:Destroy()
    end)

    -- [[ BOUCLE MOTEUR ]] --
    RunService.RenderStepped:Connect(function()
        if not Config.Active then return end
        Circle.Visible = Config.ShowFOV; Circle.Radius = Config.FOV; Circle.Position = UIS:GetMouseLocation()
        
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t and mousemoverel then
                local p = Camera:WorldToViewportPoint(t.Position); mousemoverel(p.X - UIS:GetMouseLocation().X, p.Y - UIS:GetMouseLocation().Y)
            end
        end

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if Config.Fly then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0.1, 0)
                local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                if m.Magnitude > 0 then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (m * (Config.FlySpeed/5)) end
            end
            if Config.NoClip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end
    end)

    UIS.InputBegan:Connect(function(i, g)
        if not Config.Active then return end
        if not g and i.KeyCode == Config.TP_Key and Config.TP_Mode ~= "Disabled" then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if Config.TP_Mode == "Mouse" then hrp.CFrame = Mouse.Hit * CFrame.new(0, 3, 0)
            else hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 25) end
        end
        if i.KeyCode == Config.MenuKey then MainFrame.Visible = not MainFrame.Visible end
    end)
    TCombat.Visible = true
end

local function StartKey()
    local KeyUI = Instance.new("ScreenGui", CoreGui); local KFrame = Instance.new("Frame", KeyUI); KFrame.Size = UDim2.new(0, 420, 0, 280); KFrame.Position = UDim2.new(0.5, -210, 0.5, -140); KFrame.BackgroundColor3 = Config.BgColor; Instance.new("UICorner", KFrame); Instance.new("UIStroke", KFrame).Color = Config.AccentColor
    local T = Instance.new("TextLabel", KFrame); T.Size = UDim2.new(1, 0, 0, 70); T.Text = "SoloCheat"; T.TextColor3 = Config.AccentColor; T.Font = "GothamBold"; T.TextSize = 35; T.BackgroundTransparency = 1
    local B = Instance.new("TextBox", KFrame); B.Size = UDim2.new(0.8, 0, 0, 45); B.Position = UDim2.new(0.1, 0, 0.35, 0); B.BackgroundColor3 = Config.SecColor; B.TextColor3 = Color3.new(1, 1, 1); B.PlaceholderText = "Clé V1..."; Instance.new("UICorner", B)
    local V = Instance.new("TextButton", KFrame); V.Size = UDim2.new(0.4, -5, 0, 45); V.Position = UDim2.new(0.1, 0, 0.65, 0); V.BackgroundColor3 = Config.AccentColor; V.Text = "VALIDER"; V.Font = "GothamBold"; Instance.new("UICorner", V)
    V.MouseButton1Click:Connect(function() if B.Text == Config.CorrectKey then KeyUI:Destroy(); LaunchCheat() end end)
    MakeDraggable(KFrame, KFrame)
end

StartKey()
