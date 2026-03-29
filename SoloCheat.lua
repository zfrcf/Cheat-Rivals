-- [[ SoloCheat - V1 OMNIPOTENT // PRO HYBRID EDITION ]] --
-- [[ LOCK AIM | ADORNMENT ESP | TRIGGERBOT | AUTO-SAVE ]] --

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
    Aimbot = false,
    Triggerbot = false, -- NOUVEAU
    FOV = 200,
    ESP_Box = false,
    ESP_Health = false,
    Fly = false,
    FlySpeed = 2,
    NoClip = false,
    MenuKey = "K",
    TP_Key = "E",
    TP_Mode = "Disabled", -- Modes: "Disabled", "Forward", "Mouse"
    AccentColor = Color3.fromRGB(0, 255, 150)
}

-- [[ SAUVEGARDE ]] --
local function SaveKey(key) if writefile then writefile(FileName, key) end end
local function LoadSavedKey() if isfile and isfile(FileName) then return readfile(FileName) end return nil end

-- Nettoyage
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SoloCheat_Master" or v.Name == "SoloKeySystem" then v:Destroy() end
end

-- [[ CORE FUNCTIONS ]] --
local function GetClosestTarget()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < nearest then nearest = dist; target = p.Character.Head end
                end
            end
        end
    end
    return target
end

-- [[ ESP BOX ADORNMENT ]] --
local function CreatePlayerESP(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if not char:FindFirstChild("Humanoid") then return end
        
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "SoloBox"
        box.Parent = char
        box.Adornee = char
        box.AlwaysOnTop = true
        box.Size = Vector3.new(4, 6, 1)
        box.Color3 = Config.AccentColor
        box.Transparency = 0.6
        box.ZIndex = 10

        local bill = Instance.new("BillboardGui", char:WaitForChild("Head"))
        bill.Name = "SoloHealth"
        bill.Size = UDim2.new(0, 100, 0, 40)
        bill.AlwaysOnTop = true
        bill.ExtentsOffset = Vector3.new(0, 3, 0)
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = "Code"
        label.TextSize = 14
        label.TextStrokeTransparency = 0

        local conn; conn = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not Config.Active then 
                box:Destroy(); bill:Destroy(); conn:Disconnect()
                return 
            end
            local isEnemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            box.Visible = Config.ESP_Box and isEnemy
            label.Visible = Config.ESP_Health and isEnemy
            if label.Visible then
                label.Text = p.Name .. " [" .. math.floor(char.Humanoid.Health) .. "]"
                label.TextColor3 = Color3.fromHSV(char.Humanoid.Health/100 * 0.35, 1, 1)
            end
        end)
    end)
end

-- [[ MENU PRINCIPAL ]] --
local function MainCheat()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloCheat_Master"
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 520, 0, 420); Main.Position = UDim2.new(0.5, -260, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(15,15,15); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Config.AccentColor

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 45); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -50); Container.Position = UDim2.new(0, 160, 0, 45); Container.BackgroundTransparency = 1

    local function Tab(name)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name:upper(); b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); p.ScrollBarThickness = 0
        b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; p.Visible = true end)
        return p
    end

    local function Toggle(p, t, k)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Font = "Code"; Instance.new("UICorner", b)
        local function u() b.Text = t.." : "..(Config[k] and "ON" or "OFF"); b.TextColor3 = Config[k] and Config.AccentColor or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[k] = not Config[k]; u() end); u()
    end

    local T1 = Tab("Combat"); local T2 = Tab("Visuals"); local T3 = Tab("Misc"); local T4 = Tab("Discord")
    
    Toggle(T1, "LOCK AIM (R-CLICK)", "Aimbot")
    Toggle(T1, "TRIGGERBOT", "Triggerbot")
    Toggle(T2, "ESP BOX 3D", "ESP_Box")
    Toggle(T2, "ESP NAME & HP", "ESP_Health")
    Toggle(T3, "FLY MODE", "Fly")
    Toggle(T3, "NOCLIP", "NoClip")

    -- TP Selector
    local Modes = {"Disabled", "Forward", "Mouse"}
    local TpBtn = Instance.new("TextButton", T3); TpBtn.Size = UDim2.new(1, -10, 0, 45); TpBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); TpBtn.Font = "Code"; TpBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", TpBtn)
    TpBtn.MouseButton1Click:Connect(function()
        local current = table.find(Modes, Config.TP_Mode)
        Config.TP_Mode = Modes[(current % #Modes) + 1]
        TpBtn.Text = "TP MODE : " .. Config.TP_Mode:upper()
    end); TpBtn.Text = "TP MODE : DISABLED"

    local DiscBtn = Instance.new("TextButton", T4); DiscBtn.Size = UDim2.new(1,-10,0,45); DiscBtn.Text = "JOIN DISCORD"; DiscBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); DiscBtn.TextColor3 = Color3.new(1,1,1); DiscBtn.Font = "Code"; Instance.new("UICorner", DiscBtn)
    DiscBtn.MouseButton1Click:Connect(function() setclipboard(DiscordLink); DiscBtn.Text = "LINK COPIED !"; task.wait(2); DiscBtn.Text = "JOIN DISCORD" end)

    -- [[ LOGIQUE DE COMBAT ET MOUVEMENT ]] --
    RunService.RenderStepped:Connect(function()
        if not Config.Active then return end
        
        -- Lock Aim (mousemoverel)
        if Config.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t and mousemoverel then
                local pos = Camera:WorldToViewportPoint(t.Position)
                mousemoverel(pos.X - UIS:GetMouseLocation().X, pos.Y - UIS:GetMouseLocation().Y)
            end
        end

        -- Triggerbot
        if Config.Triggerbot then
            local target = Mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
                local player = Players:GetPlayerFromCharacter(target.Parent)
                if player and (player.Team ~= LocalPlayer.Team or tostring(player.Team) == "Neutral") then
                    mouse1click()
                end
            end
        end

        -- Fly
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Config.Fly then
            hrp.Velocity = Vector3.new(0, 0.1, 0)
            local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
            if m.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (m * Config.FlySpeed) end
        end
    end)

    RunService.Stepped:Connect(function() if Config.Active and Config.NoClip and LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
    
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode.Name == Config.TP_Key then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if Config.TP_Mode == "Forward" then hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 50)
                elseif Config.TP_Mode == "Mouse" then hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end
            end
        elseif i.KeyCode.Name == Config.MenuKey then Main.Visible = not Main.Visible end
    end)

    T1.Visible = true
end

-- [[ KEY SYSTEM ]] --
local function KeySystem()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloKeySystem"
    local Frame = Instance.new("Frame", UI); Frame.Size = UDim2.new(0, 420, 0, 280); Frame.Position = UDim2.new(0.5, -210, 0.5, -140); Frame.BackgroundColor3 = Color3.fromRGB(15,15,15); Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame); Instance.new("UIStroke", Frame).Color = Config.AccentColor

    local Title = Instance.new("TextLabel", Frame); Title.Text = "SoloCheat"; Title.Size = UDim2.new(1,0,0,60); Title.TextColor3 = Config.AccentColor; Title.Font = "GothamBold"; Title.TextSize = 25; Title.BackgroundTransparency = 1
    local Box = Instance.new("TextBox", Frame); Box.Size = UDim2.new(0.9, 0, 0, 45); Box.Position = UDim2.new(0.05, 0, 0.3, 0); Box.BackgroundColor3 = Color3.fromRGB(25,25,25); Box.TextColor3 = Color3.new(1,1,1); Box.PlaceholderText = "Paste Key From Discord..."; Box.Text = ""; Box.Font = "Code"; Box.TextScaled = true; Instance.new("UICorner", Box)

    local ValidBtn = Instance.new("TextButton", Frame); ValidBtn.Size = UDim2.new(0.45, -5, 0, 45); ValidBtn.Position = UDim2.new(0.05, 0, 0.55, 0); ValidBtn.BackgroundColor3 = Config.AccentColor; ValidBtn.Text = "VALIDATE"; ValidBtn.Font = "GothamBold"; Instance.new("UICorner", ValidBtn)
    local GetBtn = Instance.new("TextButton", Frame); GetBtn.Size = UDim2.new(0.45, -5, 0, 45); GetBtn.Position = UDim2.new(0.5, 5, 0.55, 0); GetBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); GetBtn.Text = "GET KEY"; GetBtn.Font = "GothamBold"; GetBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", GetBtn)

    local function Launch()
        Config.Active = true; UI:Destroy(); MainCheat()
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePlayerESP(p) end end
        Players.PlayerAdded:Connect(CreatePlayerESP)
    end

    GetBtn.MouseButton1Click:Connect(function() setclipboard(DiscordLink); GetBtn.Text = "COPIED !"; task.wait(1); GetBtn.Text = "GET KEY" end)
    
    if LoadSavedKey() == CorrectKey then Launch() return end

    ValidBtn.MouseButton1Click:Connect(function()
        if Box.Text == CorrectKey then SaveKey(Box.Text); Launch()
        else ValidBtn.Text = "INVALID"; task.wait(1); ValidBtn.Text = "VALIDATE" end
    end)
end

KeySystem()
