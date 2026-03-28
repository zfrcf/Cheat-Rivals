-- [[ SoloCheat - V1 PRO ]] --
-- [[ INTERFACE PREMIUM + GET KEY DISCORD ]] --

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [[ CONFIGURATION INTERNE (VALEURS PAR DÉFAUT) ]] --
local Config = {
    Silent = false,
    FOV = 200,
    ShowFOV = true,
    TargetPart = "Head",
    Fly = false,
    FlySpeed = 2, -- CFrame est sensible, 2 est déjà rapide
    NoClip = false,
    ESP_Box = false,
    ESP_HealthText = false,
    TP_Key = Enum.KeyCode.E,
    MenuKey = Enum.KeyCode.K,
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    AccentColor = Color3.fromRGB(0, 255, 150),
    BgColor = Color3.fromRGB(15, 15, 15),
    SecColor = Color3.fromRGB(25, 25, 25)
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

-- [[ FONCTIONS CORE (CIBLAGE + MOUVEMENT) ]] --
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

-- [[ LOOP PRINCIPALE ]] --
local function StartCoreLogic()
    -- FOV Circle
    local FOVCircle = Drawing.new("Circle"); FOVCircle.Thickness = 1; FOVCircle.Color = Config.AccentColor; FOVCircle.Transparency = 1; FOVCircle.Visible = false

    -- Silent Aim (Cible Proche - Clic Droit)
    RunService.RenderStepped:Connect(function()
        FOVCircle.Visible = Config.ShowFOV; FOVCircle.Radius = Config.FOV; FOVCircle.Position = UIS:GetMouseLocation()
        
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t and mousemoverel then
                local pos = Camera:WorldToViewportPoint(t.Position)
                mousemoverel(pos.X - UIS:GetMouseLocation().X, pos.Y - UIS:GetMouseLocation().Y)
            end
        end

        -- Fly & NoClip
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            if Config.Fly then
                hrp.Velocity = Vector3.new(0,0.1,0)
                local dir = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                if dir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (dir * Config.FlySpeed) end
            end
            if Config.NoClip then
                for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
        end
    end)

    -- ESP SYSTEM (BOX + TEXT NAME & HP)
    local function CreatePlayerESP(p)
        p.CharacterAdded:Connect(function(char)
            task.wait(1); local head = char:WaitForChild("Head"); local hum = char:WaitForChild("Humanoid")
            local box = Instance.new("BoxHandleAdornment", char); box.Adornee = char; box.AlwaysOnTop = true; box.Size = Vector3.new(4,6,1); box.Color3 = Config.AccentColor; box.Transparency = 0.7; box.ZIndex = 10
            local bill = Instance.new("BillboardGui", head); bill.Size = UDim2.new(0, 150, 0, 60); bill.AlwaysOnTop = true; bill.ExtentsOffset = Vector3.new(0, 3.5, 0)
            local label = Instance.new("TextLabel", bill); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Font = "GothamBold"; label.TextSize = 13; label.TextStrokeTransparency = 0
            RunService.Heartbeat:Connect(function()
                box.Visible = Config.ESP_Box; label.Visible = Config.ESP_HealthText
                if label.Visible then
                    label.Text = p.Name .. "\nHP: " .. math.floor(hum.Health)
                    label.TextColor3 = Color3.fromHSV(hum.Health/100 * 0.35, 1, 1) -- Vert vers Rouge
                end
            end)
        end)
    end
    for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePlayerESP(p) end end
    Players.PlayerAdded:Connect(CreatePlayerESP)
end

-- [[ INTERFACE MAIN CHEAT (LE RETOUR DE PREMIUM) ]] --
local function InitCheat()
    if CoreGui:FindFirstChild("SoloV1_Main") then CoreGui.SoloV1_Main:Destroy() end
    local MainUI = Instance.new("ScreenGui", CoreGui); MainUI.Name = "SoloV1_Main"
    local Frame = Instance.new("Frame", MainUI); Frame.Size = UDim2.new(0, 560, 0, 420); Frame.Position = UDim2.new(0.5, -280, 0.5, -210); Frame.BackgroundColor3 = Config.BgColor
    Instance.new("UICorner", Frame); local Stroke = Instance.new("UIStroke", Frame); Stroke.Color = Config.AccentColor; MakeDraggable(Frame)

    -- Title Bar
    local TopBar = Instance.new("Frame", Frame); TopBar.Size = UDim2.new(1,0,0,35); TopBar.BackgroundColor3 = Config.SecColor
    Instance.new("UICorner", TopBar); MakeDraggable(TopBar, Frame)
    local Title = Instance.new("TextLabel", TopBar); Title.Size = UDim2.new(1,0,1,0); Title.Text = "SoloCheat - V1 PRO"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1

    -- Sidebar (Tabs)
    local Sidebar = Instance.new("Frame", Frame); Sidebar.Size = UDim2.new(0, 140, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner", Sidebar); local SideLayout = Instance.new("UIListLayout", Sidebar); SideLayout.Padding = UDim.new(0, 5); SideLayout.HorizontalAlignment = "Center"

    -- Container (Page Content)
    local Container = Instance.new("Frame", Frame); Container.Size = UDim2.new(1, -150, 1, -50); Container.Position = UDim2.new(0, 145, 0, 45); Container.BackgroundTransparency = 1

    local function CreateTab(name)
        local btn = Instance.new("TextButton", Sidebar); btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Text = name; btn.BackgroundColor3 = Config.SecColor; btn.TextColor3 = Color3.fromRGB(150,150,150); btn.Font = "Gotham"
        local page = Instance.new("ScrollingFrame", Container); page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1; page.CanvasSize = UDim2.new(0,0,2,0)
        Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
        
        btn.MouseButton1Click:Connect(function() 
            for _,v in pairs(Container:GetChildren()) do v.Visible = false end
            for _,b in pairs(Sidebar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150,150,150) end end
            page.Visible = true; btn.TextColor3 = Config.AccentColor
        end)
        return page, btn
    end

    local function AddToggle(parent, text, cfg, key)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1,-10,0,40); f.BackgroundColor3 = Config.SecColor; Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,-50,1,0); l.Position = UDim2.new(0,10,0,0); l.Text = text; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = 0
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0,35,0,18); b.Position = UDim2.new(1,-45,0.5,-9); b.Text = ""; b.BackgroundColor3 = cfg[key] and Config.AccentColor or Color3.fromRGB(50,50,50)
        Instance.new("UICorner", b, UDim.new(1,0))
        b.MouseButton1Click:Connect(function() cfg[key] = not cfg[key]; b.BackgroundColor3 = cfg[key] and Config.AccentColor or Color3.fromRGB(50,50,50) end)
    end

    local T1, B1 = CreateTab("Combat"); local T2, B2 = CreateTab("Visuals"); local T3, B3 = CreateTab("Movement")
    
    AddToggle(T1, "SILENT AIM (R-CLICK)", Config, "Silent")
    AddToggle(T1, "SHOW FOV CIRCLE", Config, "ShowFOV")
    AddToggle(T2, "ESP BOXES", Config, "ESP_Box")
    AddToggle(T2, "ESP NAME & HP", Config, "ESP_HealthText")
    AddToggle(T3, "FLY MODE (CFrame)", Config, "Fly")
    AddToggle(T3, "NOCLIP (ANTI-VOID)", Config, "NoClip")

    -- TOUCHE TP SUR E
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Config.TP_Key and LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit * CFrame.new(0,3,0) end
        if i.KeyCode == Config.MenuKey then Frame.Visible = not Frame.Visible end
    end)

    StartCoreLogic(); T1.Visible = true; B1.TextColor3 = Config.AccentColor
end

-- [[ SYSTÈME DE CLÉ PRO (NOUVELLE UI) ]] --
local function InitKeySystem()
    if CoreGui:FindFirstChild("SoloV1_Key") then CoreGui.SoloV1_Key:Destroy() end
    local KeyUI = Instance.new("ScreenGui", CoreGui); KeyUI.Name = "SoloV1_Key"
    local KFrame = Instance.new("Frame", KeyUI); KFrame.Size = UDim2.new(0, 450, 0, 300); KFrame.Position = UDim2.new(0.5, -225, 0.5, -150); KFrame.BackgroundColor3 = Config.BgColor
    Instance.new("UICorner", KFrame); local KStroke = Instance.new("UIStroke", KFrame); KStroke.Color = Config.AccentColor; MakeDraggable(KFrame)

    -- TITRE EN GROS AU DESSUS (TA DEMANDE)
    local KTitle = Instance.new("TextLabel", KFrame); KTitle.Size = UDim2.new(1, 0, 0, 60); KTitle.Text = "SoloCheat"; KTitle.TextColor3 = Config.AccentColor; KTitle.Font = "GothamBold"; KTitle.TextSize = 25; KTitle.BackgroundTransparency = 1
    local KSub = Instance.new("TextLabel", KFrame); KSub.Size = UDim2.new(1, 0, 0, 20); KSub.Position = UDim2.new(0, 0, 0, 50); KSub.Text = "- V1 PRO - Entrez votre clé"; KSub.TextColor3 = Color3.new(1,1,1); KSub.Font = "Gotham"; KSub.TextSize = 10; KSub.BackgroundTransparency = 1

    local KBox = Instance.new("TextBox", KFrame); KBox.Size = UDim2.new(0.8, 0, 0, 45); KBox.Position = UDim2.new(0.1, 0, 0.35, 0); KBox.BackgroundColor3 = Config.SecColor; KBox.TextColor3 = Color3.new(1,1,1); KBox.PlaceholderText = "Collez la clé ici..."; KBox.Text = ""
    Instance.new("UICorner", KBox)

    -- BOUTON GET KEY ET BOUTON VALIDER CÔTE À CÔTE (TA DEMANDE)
    local ValidBtn = Instance.new("TextButton", KFrame); ValidBtn.Size = UDim2.new(0.4, -5, 0, 40); ValidBtn.Position = UDim2.new(0.1, 0, 0.65, 0); ValidBtn.BackgroundColor3 = Config.AccentColor; ValidBtn.Text = "VALIDER V1"; ValidBtn.Font = "GothamBold"; ValidBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", ValidBtn)

    local GetKeyBtn = Instance.new("TextButton", KFrame); GetKeyBtn.Size = UDim2.new(0.4, -5, 0, 40); GetKeyBtn.Position = UDim2.new(0.5, 5, 0.65, 0); GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); GetKeyBtn.Text = "[ Get Key ]"; GetKeyBtn.Font = "GothamBold"; GetKeyBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", GetKeyBtn)

    ValidBtn.MouseButton1Click:Connect(function()
        if KBox.Text == Config.CorrectKey then KeyUI:Destroy(); InitCheat() else ValidBtn.Text = "CLÉ FAUSSE"; task.wait(1); ValidBtn.Text = "VALIDER V1" end
    end)

    GetKeyBtn.MouseButton1Click:Connect(function() setclipboard(Config.Discord); GetKeyBtn.Text = "LIEN COPIÉ !" task.wait(1) GetKeyBtn.Text = "[ Get Key ]" end)
end

InitKeySystem()
