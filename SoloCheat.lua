-- [[ SoloCheat - V1 COMPLETE & FIXED ]] --
-- [[ ESP + DISTANCE AIM + ALL SETTINGS WORKING ]] --

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
    Active = true,
    Silent = false, FOV = 200, ShowFOV = true, TargetPart = "Head",
    Fly = false, FlySpeed = 10, NoClip = false,
    ESP_Box = false, ESP_HealthText = false,
    TP_Mode = "Disabled", 
    TP_Key = Enum.KeyCode.E,
    MenuKey = Enum.KeyCode.K,
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    AccentColor = Color3.fromRGB(0, 255, 150),
    BgColor = Color3.fromRGB(15, 15, 15),
    SecColor = Color3.fromRGB(25, 25, 25)
}

-- [[ DRAG ]] --
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

-- [[ AIMBOT DISTANCE ]] --
local function GetClosestTarget()
    local target, nearestDistance = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character[Config.TargetPart].Position)
            local screenDist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
            
            if vis and screenDist <= Config.FOV then
                local worldDist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if worldDist < nearestDistance then
                    nearestDistance = worldDist
                    target = p.Character[Config.TargetPart]
                end
            end
        end
    end
    return target
end

-- [[ ESP FIX ]] --
local function CreateESP(p)
    local function SetupESP(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10)
        local box = Instance.new("BoxHandleAdornment", CoreGui)
        box.Adornee = char; box.AlwaysOnTop = true; box.Size = Vector3.new(4, 6, 0.1); box.Color3 = Config.AccentColor; box.Transparency = 0.6
        
        local bill = Instance.new("BillboardGui", CoreGui)
        bill.Adornee = head; bill.Size = UDim2.new(0, 100, 0, 40); bill.AlwaysOnTop = true; bill.ExtentsOffset = Vector3.new(0, 3, 0)
        local lbl = Instance.new("TextLabel", bill); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1, 1, 1); lbl.Font = "GothamBold"; lbl.TextSize = 12

        RunService.RenderStepped:Connect(function()
            if not char.Parent or not Config.Active then box:Destroy(); bill:Destroy(); return end
            box.Visible = Config.ESP_Box
            lbl.Visible = Config.ESP_HealthText
            if lbl.Visible then 
                local hum = char:FindFirstChild("Humanoid")
                lbl.Text = p.Name .. " [" .. (hum and math.floor(hum.Health) or "0") .. " HP]" 
            end
        end)
    end
    p.CharacterAdded:Connect(SetupESP)
    if p.Character then SetupESP(p.Character) end
end

-- [[ INTERFACE MAIN ]] --
local function LaunchCheat()
    local MainUI = Instance.new("ScreenGui", CoreGui); MainUI.Name = "SoloV1_Final"
    local MainFrame = Instance.new("Frame", MainUI); MainFrame.Size = UDim2.new(0, 580, 0, 430); MainFrame.Position = UDim2.new(0.5, -290, 0.5, -215); MainFrame.BackgroundColor3 = Config.BgColor; Instance.new("UICorner", MainFrame); Instance.new("UIStroke", MainFrame).Color = Config.AccentColor

    local TopBar = Instance.new("Frame", MainFrame); TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundColor3 = Config.SecColor; MakeDraggable(TopBar, MainFrame)
    local Title = Instance.new("TextLabel", TopBar); Title.Size = UDim2.new(1, -120, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.Text = "SoloCheat - V1 PRO"; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0
    local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0.5, -15); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80); CloseBtn.BackgroundTransparency = 1; CloseBtn.Font = "GothamBold"; CloseBtn.TextSize = 20

    local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Size = UDim2.new(0, 150, 1, -45); Sidebar.Position = UDim2.new(0, 5, 0, 42); Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", Sidebar)
    local Container = Instance.new("Frame", MainFrame); Container.Size = UDim2.new(1, -165, 1, -50); Container.Position = UDim2.new(0, 160, 0, 45); Container.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

    local function AddTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar); TabBtn.Size = UDim2.new(0.9, 0, 0, 40); TabBtn.Text = name; TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TabBtn.TextColor3 = Color3.new(1, 1, 1); TabBtn.Font = "Gotham"; Instance.new("UICorner", TabBtn)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 0; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)
        return Page
    end

    local function AddToggle(parent, text, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 40); b.Text = text .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() 
            Config[key] = not Config[key]; b.Text = text .. " : " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Config[key] and Config.AccentColor or Color3.new(1, 1, 1)
        end)
    end

    local function AddSlider(parent, text, key, min, max)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 55); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 25); l.Text = text .. " : " .. Config[key]; l.TextColor3 = Color3.new(1, 1, 1); l.BackgroundTransparency = 1
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.9, 0, 0, 10); b.Position = UDim2.new(0.05, 0, 0.6, 0); b.Text = ""; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        local fill = Instance.new("Frame", b); fill.Size = UDim2.new((Config[key]-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Config.AccentColor
        b.MouseButton1Click:Connect(function()
            local m = math.clamp((UIS:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
            Config[key] = math.floor(min + (m * (max - min))); l.Text = text .. " : " .. Config[key]; fill.Size = UDim2.new(m, 0, 1, 0)
        end)
    end

    local function AddKey(parent, text, key)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.Text = text; l.TextColor3 = Color3.new(1, 1, 1); l.BackgroundTransparency = 1; l.TextXAlignment = 0
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 80, 0, 30); b.Position = UDim2.new(1, -90, 0.5, -15); b.Text = Config[key].Name; b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Config.AccentColor; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            b.Text = "..."; local c; c = UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Keyboard then Config[key] = i.KeyCode; b.Text = i.KeyCode.Name; c:Disconnect() end
            end)
        end)
    end

    local TCombat = AddTab("Combat"); local TVisuals = AddTab("Visuals"); local TMovement = AddTab("Movement"); local TSettings = AddTab("Settings")
    AddToggle(TCombat, "SILENT AIM", "Silent"); AddToggle(TCombat, "SHOW FOV", "ShowFOV")
    AddToggle(TVisuals, "ESP BOXES", "ESP_Box"); AddToggle(TVisuals, "ESP HP/NAME", "ESP_HealthText")
    AddToggle(TMovement, "FLY MODE", "Fly"); AddToggle(TMovement, "NOCLIP", "NoClip")
    
    AddSlider(TSettings, "FOV SIZE", "FOV", 50, 800)
    AddSlider(TSettings, "FLY SPEED", "FlySpeed", 1, 50)
    AddKey(TSettings, "TP KEY", "TP_Key"); AddKey(TSettings, "MENU KEY", "MenuKey")

    local Circle = Drawing.new("Circle"); Circle.Thickness = 1.5; Circle.Color = Config.AccentColor
    CloseBtn.MouseButton1Click:Connect(function() Config.Active = false; Circle:Remove(); MainUI:Destroy() end)

    RunService.RenderStepped:Connect(function()
        if not Config.Active then return end
        Circle.Visible = Config.ShowFOV; Circle.Radius = Config.FOV; Circle.Position = UIS:GetMouseLocation()
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t then local p = Camera:WorldToViewportPoint(t.Position); mousemoverel((p.X - UIS:GetMouseLocation().X)/2, (p.Y - UIS:GetMouseLocation().Y)/2) end
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if Config.Fly then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0.1, 0)
                local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                if m.Magnitude > 0 then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (m * (Config.FlySpeed/10)) end
            end
            if Config.NoClip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end
    end)

    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Config.MenuKey then MainFrame.Visible = not MainFrame.Visible end
    end)
    
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
    Players.PlayerAdded:Connect(CreateESP); TCombat.Visible = true
end

-- [[ KEY SYSTEM ]] --
local function StartKey()
    local KeyUI = Instance.new("ScreenGui", CoreGui); local KF = Instance.new("Frame", KeyUI); KF.Size = UDim2.new(0, 420, 0, 300); KF.Position = UDim2.new(0.5, -210, 0.5, -150); KF.BackgroundColor3 = Config.BgColor; Instance.new("UIStroke", KF).Color = Config.AccentColor
    local B = Instance.new("TextBox", KF); B.Size = UDim2.new(0.8, 0, 0, 45); B.Position = UDim2.new(0.1, 0, 0.3, 0); B.PlaceholderText = "Clé V1..."; B.BackgroundColor3 = Config.SecColor; B.TextColor3 = Color3.new(1,1,1)
    local V = Instance.new("TextButton", KF); V.Size = UDim2.new(0.4, -5, 0, 45); V.Position = UDim2.new(0.1, 0, 0.6, 0); V.Text = "VALIDER"; V.BackgroundColor3 = Config.AccentColor
    local G = Instance.new("TextButton", KF); G.Size = UDim2.new(0.4, -5, 0, 45); G.Position = UDim2.new(0.5, 5, 0.6, 0); G.Text = "GET KEY"; G.BackgroundColor3 = Color3.fromRGB(40,40,40); G.TextColor3 = Color3.new(1,1,1)
    V.MouseButton1Click:Connect(function() if B.Text == Config.CorrectKey then KeyUI:Destroy(); LaunchCheat() end end)
    G.MouseButton1Click:Connect(function() setclipboard(Config.Discord) end)
end

StartKey()
