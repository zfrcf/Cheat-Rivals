-- [[ SoloCheat - V1 REBORN // FIX EDITION ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ CONFIG ]] --
local CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0"
local DiscordLink = "https://discord.gg/VDNw9dXnJe"

local Config = {
    Active = false,
    SilentAim = false,
    Triggerbot = false,
    FOV = 150,
    ShowFOV = true,
    TargetPart = "Head",
    ESP_Box = false,
    ESP_Health = false,
    Fly = false,
    FlySpeed = 65,
    NoClip = false,
    Invisible = false,
    SlideJump = false,
    SlidePowerPercent = 50,
    MenuKey = "K",
    TP_Key = "E"
}

-- [[ CLEANUP ]] --
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SoloCheat_Omnipotent" or v.Name == "SoloKeySystem" then v:Destroy() end
end

-- [[ AIMBOT & ESP LOGIC ]] --
local function GetClosestLivingEnemy()
    local target, nearestDistance = nil, math.huge
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                if p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral" then
                    local dist = (p.Character[Config.TargetPart].Position - myRoot.Position).Magnitude
                    local _, onScreen = Camera:WorldToViewportPoint(p.Character[Config.TargetPart].Position)
                    if onScreen and dist < nearestDistance then nearestDistance = dist; target = p.Character[Config.TargetPart] end
                end
            end
        end
    end
    return target
end

local function ApplyESP(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not root then return end
        local Box = Instance.new("BoxHandleAdornment", CoreGui); Box.Adornee = root; Box.AlwaysOnTop = true; Box.Size = Vector3.new(4, 6, 0.1); Box.Transparency = 0.6; Box.Color3 = Color3.fromRGB(0, 255, 65)
        local Bill = Instance.new("BillboardGui", CoreGui); Bill.Adornee = char:WaitForChild("Head"); Bill.Size = UDim2.new(0, 70, 0, 8); Bill.AlwaysOnTop = true; Bill.ExtentsOffset = Vector3.new(0, 3, 0)
        local BG = Instance.new("Frame", Bill); BG.Size = UDim2.new(1,0,1,0); BG.BackgroundColor3 = Color3.new(0,0,0); local Bar = Instance.new("Frame", BG); Bar.Size = UDim2.new(1,0,1,0); Bar.BackgroundColor3 = Color3.new(0,1,0); Bar.BorderSizePixel = 0
        local loop; loop = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not Config.Active then Box:Destroy(); Bill:Destroy(); loop:Disconnect(); return end
            local enemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            Box.Visible = Config.ESP_Box and enemy; Bill.Enabled = Config.ESP_Health and enemy
            if char:FindFirstChild("Humanoid") then Bar.Size = UDim2.new(math.clamp(char.Humanoid.Health/char.Humanoid.MaxHealth, 0, 1), 0, 1, 0) end
        end)
    end)
end

-- [[ MAIN UI ]] --
local function InitUI()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloCheat_Omnipotent"
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 550, 0, 420); Main.Position = UDim2.new(0.5, -275, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(12,12,12); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 65); Instance.new("UICorner", Main)
    
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1,0,0,35); Top.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", Top)
    local Title = Instance.new("TextLabel", Top); Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "  SoloCheat V1 Reborn"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "Code"; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 45); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -160, 1, -50); Container.Position = UDim2.new(0, 150, 0, 45); Container.BackgroundTransparency = 1

    local function Tab(name)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name:upper(); b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0; Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; p.Visible = true end); return p
    end

    local function Toggle(p, t, k)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Font = "Code"; Instance.new("UICorner", b)
        local function u() b.Text = t.." : "..(Config[k] and "ON" or "OFF"); b.TextColor3 = Config[k] and Color3.fromRGB(0, 255, 65) or Color3.new(1,1,1) end
        b.MouseButton1Click:Connect(function() Config[k] = not Config[k]; u() end); u()
    end

    local C = Tab("Combat"); local V = Tab("Visuals"); local M = Tab("Movement"); local S = Tab("Settings")
    Toggle(C, "SILENT AIM", "SilentAim"); Toggle(C, "TRIGGERBOT", "Triggerbot"); Toggle(C, "SHOW FOV", "ShowFOV")
    Toggle(V, "ESP BOX", "ESP_Box"); Toggle(V, "ESP HEALTH", "ESP_Health")
    Toggle(M, "FLY", "Fly"); Toggle(M, "NOCLIP", "NoClip"); Toggle(M, "INVISIBLE", "Invisible"); Toggle(M, "SLIDE JUMP", "SlideJump")

    -- Slider Slide Power
    local SliderFrame = Instance.new("Frame", S); SliderFrame.Size = UDim2.new(1, -10, 0, 65); SliderFrame.BackgroundColor3 = Color3.fromRGB(30,30,30); Instance.new("UICorner", SliderFrame)
    local SliderTitle = Instance.new("TextLabel", SliderFrame); SliderTitle.Size = UDim2.new(1, 0, 0, 30); SliderTitle.Text = "SLIDE POWER: " .. Config.SlidePowerPercent .. "%"; SliderTitle.TextColor3 = Color3.new(1,1,1); SliderTitle.BackgroundTransparency = 1; SliderTitle.Font = "Code"
    local SliderBar = Instance.new("Frame", SliderFrame); SliderBar.Size = UDim2.new(0.8, 0, 0, 8); SliderBar.Position = UDim2.new(0.1, 0, 0.7, 0); SliderBar.BackgroundColor3 = Color3.fromRGB(50,50,50); Instance.new("UICorner", SliderBar)
    local SliderDot = Instance.new("Frame", SliderBar); SliderDot.Size = UDim2.new(0, 16, 1, 8); SliderDot.Position = UDim2.new(Config.SlidePowerPercent/100, -8, -0.5, 0); SliderDot.BackgroundColor3 = Color3.fromRGB(0, 255, 65); Instance.new("UICorner", SliderDot)

    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderDot.Position = UDim2.new(pos, -8, -0.5, 0); Config.SlidePowerPercent = math.floor(pos * 100); SliderTitle.Text = "SLIDE POWER: " .. Config.SlidePowerPercent .. "%"
    end
    SliderBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then UpdateSlider(i) end end)
    UIS.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then UpdateSlider(i) end end)

    local FOV_D = Drawing.new("Circle"); FOV_D.Thickness = 1; FOV_D.Color = Color3.fromRGB(0, 255, 65); FOV_D.Transparency = 0.8
    RunService.RenderStepped:Connect(function()
        if not Config.Active then FOV_D:Remove(); return end
        FOV_D.Visible = Config.ShowFOV; FOV_D.Radius = Config.FOV; FOV_D.Position = UIS:GetMouseLocation()
        if Config.SilentAim and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestLivingEnemy()
            if t and mousemoverel then
                local pos = Camera:WorldToViewportPoint(t.Position); mousemoverel(pos.X - UIS:GetMouseLocation().X, pos.Y - UIS:GetMouseLocation().Y)
            end
        end
        if Config.Triggerbot and Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") then
             local p = Players:GetPlayerFromCharacter(Mouse.Target.Parent)
             if p and (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral") and Mouse.Target.Parent.Humanoid.Health > 0 then mouse1click() end
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if Config.Fly then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0)
                local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                if m.Magnitude > 0 then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (m * (Config.FlySpeed/12)) end
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    if Config.NoClip then v.CanCollide = false end
                    if Config.Invisible and v.Name ~= "HumanoidRootPart" then v.Transparency = 1 elseif not Config.Invisible and v.Transparency == 1 then v.Transparency = 0 end
                elseif v:IsA("Decal") then v.Transparency = Config.Invisible and 1 or 0 end
            end
        end
    end)

    UIS.JumpRequest:Connect(function()
        if Config.Active and Config.SlideJump and LocalPlayer.Character then
            local hrp, hum = LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = hum.MoveDirection * ((Config.SlidePowerPercent / 100) * 350) + Vector3.new(0, 35, 0)
            end
        end
    end)

    UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode.Name == Config.MenuKey then Main.Visible = not Main.Visible end end)
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ApplyESP(p) end end; Players.PlayerAdded:Connect(ApplyESP); C.Visible = true
end

-- [[ REPAIRED KEY SYSTEM ]] --
local function KeySystem()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloKeySystem"
    local Frame = Instance.new("Frame", UI); Frame.Size = UDim2.new(0, 400, 0, 300); Frame.Position = UDim2.new(0.5, -200, 0.5, -150); Frame.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 65); Instance.new("UICorner", Frame)
    
    local Title = Instance.new("TextLabel", Frame); Title.Size = UDim2.new(1,0,0,50); Title.Text = "SOLOCHEAT KEY SYSTEM"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "CodeBold"; Title.BackgroundTransparency = 1
    local Box = Instance.new("TextBox", Frame); Box.Size = UDim2.new(0.8, 0, 0, 45); Box.Position = UDim2.new(0.1, 0, 0.3, 0); Box.BackgroundColor3 = Color3.fromRGB(25,25,25); Box.TextColor3 = Color3.new(1,1,1); Box.Text = ""; Box.PlaceholderText = "Enter Key Here..."; Box.Font = "Code"; Instance.new("UICorner", Box)
    
    local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(0.8, 0, 0, 45); Btn.Position = UDim2.new(0.1, 0, 0.55, 0); Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 65); Btn.Text = "VALIDATE"; Btn.Font = "CodeBold"; Instance.new("UICorner", Btn)
    local DiscBtn = Instance.new("TextButton", Frame); DiscBtn.Size = UDim2.new(0.8, 0, 0, 35); DiscBtn.Position = UDim2.new(0.1, 0, 0.78, 0); DiscBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); DiscBtn.Text = "COPY DISCORD LINK"; DiscBtn.TextColor3 = Color3.new(1,1,1); DiscBtn.Font = "Code"; Instance.new("UICorner", DiscBtn)

    DiscBtn.MouseButton1Click:Connect(function() setclipboard(DiscordLink); DiscBtn.Text = "COPIED!" ; task.wait(2); DiscBtn.Text = "COPY DISCORD LINK" end)
    
    Btn.MouseButton1Click:Connect(function()
        print("Click detected, checking key...")
        if Box.Text == CorrectKey then
            Config.Active = true
            UI:Destroy()
            InitUI()
        else
            Btn.Text = "INVALID KEY"
            task.wait(1.5)
            Btn.Text = "VALIDATE"
        end
    end)
end

KeySystem()
