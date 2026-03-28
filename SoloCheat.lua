-- [[ SoloCheat - V1 PRO ULTIMATE ]] --
-- [[ KEYBINDS + SMART TP + MENU INDICATOR ]] --

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
    Silent = false, FOV = 200, ShowFOV = true, TargetPart = "Head",
    Fly = false, FlySpeed = 2, NoClip = false,
    ESP_Box = false, ESP_HealthText = false,
    TP_Mode = "Mouse", -- "Mouse" ou "Look"
    TP_Key = Enum.KeyCode.E,
    MenuKey = Enum.KeyCode.K,
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    AccentColor = Color3.fromRGB(0, 255, 150),
    BgColor = Color3.fromRGB(15, 15, 15),
    SecColor = Color3.fromRGB(25, 25, 25)
}

-- [[ CORE FUNCTIONS ]] --
local function GetClosestTarget()
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

-- [[ INTERFACE MAIN ]] --
local function InitCheat()
    local MainUI = Instance.new("ScreenGui", CoreGui); MainUI.Name = "SoloV1_Ultimate"
    local Frame = Instance.new("Frame", MainUI); Frame.Size = UDim2.new(0, 560, 0, 420); Frame.Position = UDim2.new(0.5, -280, 0.5, -210); Frame.BackgroundColor3 = Config.BgColor
    Instance.new("UICorner", Frame); Instance.new("UIStroke", Frame).Color = Config.AccentColor

    -- Top Bar avec indicateur [ K ] (Ta demande)
    local TopBar = Instance.new("Frame", Frame); TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Config.SecColor
    Instance.new("UICorner", TopBar)
    local Title = Instance.new("TextLabel", TopBar); Title.Size = UDim2.new(1, -60, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0); Title.Text = "SoloCheat - V1 PRO"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0
    local MiniHint = Instance.new("TextLabel", TopBar); MiniHint.Size = UDim2.new(0, 50, 1, 0); MiniHint.Position = UDim2.new(1, -55, 0, 0); MiniHint.Text = "- [ K ]"; MiniHint.TextColor3 = Config.AccentColor; MiniHint.Font = "GothamBold"; MiniHint.BackgroundTransparency = 1

    local Sidebar = Instance.new("Frame", Frame); Sidebar.Size = UDim2.new(0, 140, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", Sidebar)
    local Container = Instance.new("Frame", Frame); Container.Size = UDim2.new(1, -150, 1, -50); Container.Position = UDim2.new(0, 145, 0, 45); Container.BackgroundTransparency = 1

    local function CreateTab(name)
        local btn = Instance.new("TextButton", Sidebar); btn.Size = UDim2.new(1, 0, 0, 40); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30,30,30); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "Gotham"
        local page = Instance.new("ScrollingFrame", Container); page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1; page.ScrollBarThickness = 0
        Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(function() 
            for _,v in pairs(Container:GetChildren()) do v.Visible = false end
            page.Visible = true 
        end)
        return page
    end

    local function AddToggle(parent, text, cfg, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 40); b.Text = text.." : OFF"; b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            cfg[key] = not cfg[key]
            b.Text = text.." : "..(cfg[key] and "ON" or "OFF")
            b.TextColor3 = cfg[key] and Config.AccentColor or Color3.new(1,1,1)
        end)
    end

    local function AddKeybind(parent, text, cfg, key)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1,-10,0,40); f.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6,0,1,0); l.Position = UDim2.new(0,10,0,0); l.Text = text; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = 0
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.3,0,0.7,0); b.Position = UDim2.new(0.65,0,0.15,0); b.Text = cfg[key].Name; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Config.AccentColor; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            b.Text = "..."; local conn; conn = UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    cfg[key] = i.KeyCode; b.Text = i.KeyCode.Name; conn:Disconnect()
                end
            end)
        end)
    end

    -- PAGES
    local T1 = CreateTab("Combat"); local T2 = CreateTab("Visuals"); local T3 = CreateTab("Movement"); local T4 = CreateTab("Settings")

    AddToggle(T1, "SILENT AIM (R-CLICK)", Config, "Silent")
    AddToggle(T1, "SHOW FOV CIRCLE", Config, "ShowFOV")
    AddToggle(T2, "ESP BOXES", Config, "ESP_Box")
    AddToggle(T2, "ESP NAME & HP", Config, "ESP_HealthText")
    AddToggle(T3, "FLY MODE", Config, "Fly")
    AddToggle(T3, "NOCLIP", Config, "NoClip")

    -- SETTINGS SMART TP (Ta demande)
    local TPBtn = Instance.new("TextButton", T4); TPBtn.Size = UDim2.new(1,-10,0,40); TPBtn.Text = "TP MODE: " .. Config.TP_Mode:upper(); TPBtn.BackgroundColor3 = Color3.fromRGB(25,25,25); TPBtn.TextColor3 = Color3.new(1,1,1)
    TPBtn.MouseButton1Click:Connect(function()
        Config.TP_Mode = (Config.TP_Mode == "Mouse" and "Look" or "Mouse")
        TPBtn.Text = "TP MODE: " .. Config.TP_Mode:upper()
    end)
    AddKeybind(T4, "TP KEY", Config, "TP_Key")
    AddKeybind(T4, "MENU KEY", Config, "MenuKey")

    -- LOOPS
    local FOVCircle = Drawing.new("Circle"); FOVCircle.Thickness = 1; FOVCircle.Color = Config.AccentColor
    RunService.RenderStepped:Connect(function()
        FOVCircle.Visible = Config.ShowFOV; FOVCircle.Radius = Config.FOV; FOVCircle.Position = UIS:GetMouseLocation()
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t and mousemoverel then
                local pos = Camera:WorldToViewportPoint(t.Position); mousemoverel(pos.X - UIS:GetMouseLocation().X, pos.Y - UIS:GetMouseLocation().Y)
            end
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and Config.Fly then
            local hrp = char.HumanoidRootPart; hrp.Velocity = Vector3.new(0,0.1,0)
            local dir = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
            if dir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (dir * Config.FlySpeed) end
        end
        if char and Config.NoClip then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end)

    -- SMART TP LOGIC
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Config.TP_Key and LocalPlayer.Character then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if Config.TP_Mode == "Mouse" then
                hrp.CFrame = Mouse.Hit * CFrame.new(0,3,0)
            else
                hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 25) -- TP 25 studs devant le regard
            end
        end
        if i.KeyCode == Config.MenuKey then Frame.Visible = not Frame.Visible end
    end)

    T1.Visible = true
end

-- [[ KEY SYSTEM ]] --
local function InitKeySystem()
    local KeyUI = Instance.new("ScreenGui", CoreGui); KeyUI.Name = "SoloV1_Key"
    local KFrame = Instance.new("Frame", KeyUI); KFrame.Size = UDim2.new(0, 450, 0, 300); KFrame.Position = UDim2.new(0.5, -225, 0.5, -150); KFrame.BackgroundColor3 = Config.BgColor; Instance.new("UICorner", KFrame)
    local KTitle = Instance.new("TextLabel", KFrame); KTitle.Size = UDim2.new(1, 0, 0, 60); KTitle.Text = "SoloCheat"; KTitle.TextColor3 = Config.AccentColor; KTitle.Font = "GothamBold"; KTitle.TextSize = 30; KTitle.BackgroundTransparency = 1
    local KBox = Instance.new("TextBox", KFrame); KBox.Size = UDim2.new(0.8, 0, 0, 45); KBox.Position = UDim2.new(0.1, 0, 0.35, 0); KBox.BackgroundColor3 = Config.SecColor; KBox.TextColor3 = Color3.new(1,1,1); KBox.PlaceholderText = "Clé V1..."; KBox.Text = ""; Instance.new("UICorner", KBox)
    local ValidBtn = Instance.new("TextButton", KFrame); ValidBtn.Size = UDim2.new(0.4, -5, 0, 40); ValidBtn.Position = UDim2.new(0.1, 0, 0.65, 0); ValidBtn.BackgroundColor3 = Config.AccentColor; ValidBtn.Text = "VALIDER"; ValidBtn.Font = "GothamBold"
    local GetKeyBtn = Instance.new("TextButton", KFrame); GetKeyBtn.Size = UDim2.new(0.4, -5, 0, 40); GetKeyBtn.Position = UDim2.new(0.5, 5, 0.65, 0); GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); GetKeyBtn.Text = "[ Get Key ]"; GetKeyBtn.Font = "GothamBold"; GetKeyBtn.TextColor3 = Color3.new(1,1,1)
    ValidBtn.MouseButton1Click:Connect(function() if KBox.Text == Config.CorrectKey then KeyUI:Destroy(); InitCheat() end end)
    GetKeyBtn.MouseButton1Click:Connect(function() setclipboard(Config.Discord) end)
end

InitKeySystem()
