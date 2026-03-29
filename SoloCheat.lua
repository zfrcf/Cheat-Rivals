-- [[ SoloCheat - V1 OMNIPOTENT // FINAL PREMIUM ]] --
-- [[ KEY SYSTEM | DISCORD | AIMLOCK | ESP | FLY | TP ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]] --
local CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0"
local DiscordLink = "https://discord.gg/tArgVpGrEA"

local Config = {
    Active = false,
    Aimbot = false,
    FOV = 2000,
    ESP_Box = false,
    Fly = false,
    FlySpeed = 50,
    NoClip = false,
    MenuKey = "K",
    TP_Key = "E", -- Touche pour la téléportation
    TP_Distance = 50
}

-- Nettoyage
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SoloCheat_Master" or v.Name == "SoloKeySystem" then v:Destroy() end
end

-- [[ FONCTIONS CORE ]] --
local function GetClosestTarget()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral") then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < nearest then nearest = dist; target = head end
                end
            end
        end
    end
    return target
end

local function ApplyESP(p)
    local function Create()
        local char = p.Character or p.CharacterAdded:Wait()
        local high = char:FindFirstChild("SoloHighlight") or Instance.new("Highlight", char)
        high.Name = "SoloHighlight"; high.DepthMode = "AlwaysOnTop"
        high.FillColor = Color3.fromRGB(0, 255, 65); high.OutlineColor = Color3.new(1, 1, 1)
        local loop; loop = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not Config.Active then if high then high:Destroy() end; loop:Disconnect(); return end
            high.Enabled = Config.ESP_Box and (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
        end)
    end
    p.CharacterAdded:Connect(Create); if p.Character then Create() end
end

-- [[ MENU PRINCIPAL ]] --
local function MainCheat()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloCheat_Master"
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 520, 0, 380); Main.Position = UDim2.new(0.5, -260, 0.5, -190); Main.BackgroundColor3 = Color3.fromRGB(12,12,12); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 65)

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
        local function u() b.Text = t.." : "..(Config[k] and "ON" or "OFF"); b.TextColor3 = Config[k] and Color3.new(0,1,0) or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[k] = not Config[k]; u() end); u()
    end

    local T1 = Tab("Combat"); local T2 = Tab("Visuals"); local T3 = Tab("Misc"); local T4 = Tab("Discord")
    Toggle(T1, "AIMLOCK (R-CLICK)", "Aimbot")
    Toggle(T2, "ESP (MURS)", "ESP_Box")
    Toggle(T3, "FLY MODE", "Fly")
    Toggle(T3, "NOCLIP", "NoClip")
    
    local TpInfo = Instance.new("TextLabel", T3); TpInfo.Size = UDim2.new(1,-10,0,30); TpInfo.Text = "BLINK TP KEY : ["..Config.TP_Key.."]"; TpInfo.TextColor3 = Color3.new(0.7,0.7,0.7); TpInfo.Font = "Code"; TpInfo.BackgroundTransparency = 1

    local DiscBtn = Instance.new("TextButton", T4); DiscBtn.Size = UDim2.new(1,-10,0,45); DiscBtn.Text = "JOIN DISCORD"; DiscBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); DiscBtn.TextColor3 = Color3.new(1,1,1); DiscBtn.Font = "Code"; Instance.new("UICorner", DiscBtn)
    DiscBtn.MouseButton1Click:Connect(function() setclipboard(DiscordLink); DiscBtn.Text = "LINK COPIED !"; task.wait(2); DiscBtn.Text = "JOIN DISCORD" end)

    local RightHold = false
    UIS.InputBegan:Connect(function(i, g) 
        if i.UserInputType == Enum.UserInputType.MouseButton2 then RightHold = true end
        if not g and i.KeyCode.Name == Config.TP_Key and Config.Active then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * Config.TP_Distance) end
        end
        if not g and i.KeyCode.Name == Config.MenuKey then Main.Visible = not Main.Visible end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then RightHold = false end end)

    RunService.RenderStepped:Connect(function()
        if not Config.Active then return end
        if Config.Aimbot and RightHold then
            local t = GetClosestTarget()
            if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
        end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Config.Fly then
            hrp.Velocity = Vector3.new(0, 1.5, 0)
            local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
            if m.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (m * (Config.FlySpeed/15)) end
        end
    end)
    RunService.Stepped:Connect(function() if Config.Active and Config.NoClip and LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
    
    T1.Visible = true
end

-- [[ KEY SYSTEM ]] --
local function KeySystem()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloKeySystem"
    local Frame = Instance.new("Frame", UI); Frame.Size = UDim2.new(0, 400, 0, 220); Frame.Position = UDim2.new(0.5, -200, 0.5, -110); Frame.BackgroundColor3 = Color3.fromRGB(15,15,15); Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame); Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 65)
    local Title = Instance.new("TextLabel", Frame); Title.Text = "SOLO CHEAT | ENTER KEY"; Title.Size = UDim2.new(1,0,0,50); Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = "Code"
    local Box = Instance.new("TextBox", Frame); Box.Size = UDim2.new(0.9, 0, 0, 45); Box.Position = UDim2.new(0.05, 0, 0.3, 0); Box.BackgroundColor3 = Color3.fromRGB(25,25,25); Box.TextColor3 = Color3.new(0,255,100); Box.PlaceholderText = "Paste Key Here..."; Box.Text = ""; Box.Font = "Code"; Box.TextScaled = true; Instance.new("UICorner", Box)
    local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(0.9, 0, 0, 45); Btn.Position = UDim2.new(0.05, 0, 0.65, 0); Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 40); Btn.TextColor3 = Color3.new(1,1,1); Btn.Text = "ACTIVATE LICENSE"; Btn.Font = "Code"; Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        if Box.Text == CorrectKey then
            Btn.Text = "SUCCESS !"; Config.Active = true; UI:Destroy(); MainCheat()
            for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ApplyESP(p) end end
            Players.PlayerAdded:Connect(ApplyESP)
        else
            Btn.Text = "INVALID KEY"; task.wait(1); Btn.Text = "ACTIVATE LICENSE"
        end
    end)
end

KeySystem()
