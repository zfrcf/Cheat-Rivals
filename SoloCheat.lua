-- [[ SoloCheat - V1 OMNIPOTENT // ELITE TARGETING & MOVEMENT ]] --
-- [[ TEAM CHECK | ANTI-CORPSE | DISTANCE BASED | JUMP BOOST ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]] --
local CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0"
local DiscordLink = "https://discord.gg/VDNw9dXnJe"
local FileName = "SoloCheat_Key.txt"

local Config = {
    Active = false,
    Silent = false,
    Triggerbot = false,
    ESP_Box = false,
    ESP_HealthText = false,
    Fly = false,
    FlySpeed = 5,
    NoClip = false,
    JumpBoost = false, -- NOUVEAU
    JumpPower = 100, -- Puissance du boost
    MenuKey = "K",
    AccentColor = Color3.fromRGB(0, 255, 150),
    TargetPart = "Head"
}

-- [[ UI HELPERS ]] --
local function MakeDraggable(frame, parent)
    parent = parent or frame
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = parent.Position
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

-- [[ LOGIQUE DE CIBLAGE ]] --
local function GetClosestLivingEnemy()
    local target, nearestDistance = nil, math.huge
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local enemyPart = p.Character[Config.TargetPart]
            local isEnemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            local isAlive = hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead
            if isEnemy and isAlive then
                local dist = (enemyPart.Position - myRoot.Position).Magnitude
                local _, visible = Camera:WorldToViewportPoint(enemyPart.Position)
                if visible and dist < nearestDistance then nearestDistance = dist; target = enemyPart end
            end
        end
    end
    return target
end

-- [[ ESP SYSTEM ]] --
local function CreatePlayerESP(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        local head = char:WaitForChild("Head"); local hum = char:WaitForChild("Humanoid")
        local box = Instance.new("BoxHandleAdornment", char); box.Adornee = char; box.AlwaysOnTop = true; box.Size = Vector3.new(4,6,1); box.Color3 = Config.AccentColor; box.Transparency = 0.7; box.ZIndex = 10
        local bill = Instance.new("BillboardGui", head); bill.Size = UDim2.new(0, 150, 0, 60); bill.AlwaysOnTop = true; bill.ExtentsOffset = Vector3.new(0, 3.5, 0)
        local label = Instance.new("TextLabel", bill); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Font = "GothamBold"; label.TextSize = 13; label.TextStrokeTransparency = 0
        local conn; conn = RunService.Heartbeat:Connect(function()
            if not char or not char.Parent or not Config.Active then box:Destroy(); bill:Destroy(); conn:Disconnect(); return end
            local isEnemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            local isAlive = hum and hum.Health > 0
            box.Visible = Config.ESP_Box and isEnemy and isAlive; label.Visible = Config.ESP_HealthText and isEnemy and isAlive
            if label.Visible then label.Text = p.Name .. "\nHP: " .. math.floor(hum.Health); label.TextColor3 = Color3.fromHSV(hum.Health/100 * 0.35, 1, 1) end
        end)
    end)
end

-- [[ INTERFACE MAIN ]] --
local function MainCheat()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloCheat_Master"
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 540, 0, 420); Main.Position = UDim2.new(0.5, -270, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(12,12,12); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Config.AccentColor
    local TopBar = Instance.new("Frame", Main); TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", TopBar)
    local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -35, 0, 0); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.Font = "Code"; CloseBtn.TextSize = 22
    MakeDraggable(TopBar, Main); CloseBtn.MouseButton1Click:Connect(function() Config.Active = false; UI:Destroy() end)
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 45); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -50); Container.Position = UDim2.new(0, 160, 0, 45); Container.BackgroundTransparency = 1

    local function Tab(name)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name:upper(); b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); p.ScrollBarThickness = 0
        b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; p.Visible = true end); return p
    end
    local function Toggle(p, t, k)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Font = "Code"; Instance.new("UICorner", b)
        local function u() b.Text = t.." : "..(Config[k] and "ON" or "OFF"); b.TextColor3 = Config[k] and Config.AccentColor or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[k] = not Config[k]; u() end); u()
    end

    local T1 = Tab("Combat"); local T2 = Tab("Visuals"); local T3 = Tab("Misc"); local T4 = Tab("Settings")
    Toggle(T1, "SILENT AIM (ELITE)", "Silent"); Toggle(T1, "TRIGGERBOT", "Triggerbot")
    Toggle(T2, "ESP BOXES", "ESP_Box"); Toggle(T2, "ESP NAME & HP", "ESP_HealthText")
    Toggle(T3, "FLY MODE", "Fly"); Toggle(T3, "NOCLIP", "NoClip"); Toggle(T3, "SLIDE JUMP BOOST", "JumpBoost")
    
    local FlySpdBtn = Instance.new("TextButton", T4); FlySpdBtn.Size = UDim2.new(1,-10,0,40); FlySpdBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); FlySpdBtn.Font = "Code"; FlySpdBtn.Text = "FLY SPEED : x"..(Config.FlySpeed); Instance.new("UICorner", FlySpdBtn)
    FlySpdBtn.MouseButton1Click:Connect(function() Config.FlySpeed = (Config.FlySpeed >= 50 and 5 or Config.FlySpeed + 10); FlySpdBtn.Text = "FLY SPEED : x"..Config.FlySpeed end)

    -- [[ MAIN LOOP ]] --
    RunService.RenderStepped:Connect(function()
        if not Config.Active then return end
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestLivingEnemy()
            if t and mousemoverel then
                local pos = Camera:WorldToViewportPoint(t.Position); mousemoverel(pos.X - UIS:GetMouseLocation().X, pos.Y - UIS:GetMouseLocation().Y)
            end
        end
        if Config.Triggerbot and Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") then
            local p = Players:GetPlayerFromCharacter(Mouse.Target.Parent)
            if p and (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral") and Mouse.Target.Parent.Humanoid.Health > 0 then mouse1click() end
        end
        if Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart; hrp.Velocity = Vector3.new(0, 0.1, 0)
            local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
            if m.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (m * Config.FlySpeed) end
        end
    end)

    -- JUMP BOOST LOGIC
    UIS.JumpRequest:Connect(function()
        if Config.Active and Config.JumpBoost and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = hrp.Velocity + (LocalPlayer.Character.Humanoid.MoveDirection * Config.JumpPower) + Vector3.new(0, 20, 0)
            end
        end
    end)

    RunService.Stepped:Connect(function() if Config.Active and Config.NoClip and LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
    UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.E and LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit * CFrame.new(0,3,0) elseif i.KeyCode.Name == "K" then Main.Visible = not Main.Visible end end)
    T1.Visible = true
end

-- [[ KEY SYSTEM ]] --
local function KeySystem()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloKeySystem"
    local Frame = Instance.new("Frame", UI); Frame.Size = UDim2.new(0, 420, 0, 280); Frame.Position = UDim2.new(0.5, -210, 0.5, -140); Frame.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UICorner", Frame); Instance.new("UIStroke", Frame).Color = Config.AccentColor; MakeDraggable(Frame)
    local Box = Instance.new("TextBox", Frame); Box.Size = UDim2.new(0.9, 0, 0, 45); Box.Position = UDim2.new(0.05, 0, 0.35, 0); Box.BackgroundColor3 = Color3.fromRGB(25,25,25); Box.TextColor3 = Color3.new(1,1,1); Box.PlaceholderText = "Paste Key..."; Box.Text = ""; Box.Font = "Code"; Box.TextScaled = true; Instance.new("UICorner", Box)
    local ValidBtn = Instance.new("TextButton", Frame); ValidBtn.Size = UDim2.new(0.9, 0, 0, 45); ValidBtn.Position = UDim2.new(0.05, 0, 0.6, 0); ValidBtn.BackgroundColor3 = Config.AccentColor; ValidBtn.Text = "VALIDATE"; ValidBtn.Font = "GothamBold"; Instance.new("UICorner", ValidBtn)
    local function Launch()
        Config.Active = true; UI:Destroy(); MainCheat()
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePlayerESP(p) end end; Players.PlayerAdded:Connect(CreatePlayerESP)
    end
    if (isfile and isfile(FileName) and readfile(FileName) == CorrectKey) then Launch() return end
    ValidBtn.MouseButton1Click:Connect(function() if Box.Text == CorrectKey then if writefile then writefile(FileName, Box.Text) end Launch() else ValidBtn.Text = "WRONG"; task.wait(1); ValidBtn.Text = "VALIDATE" end end)
end

KeySystem()
