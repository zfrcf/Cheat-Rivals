-- [[ SoloCheat - V1 PERMANENT EDITION ]] --
-- [[ AUTO-SAVE KEY | ELITE ESP | GHOST BLINK | OPTIMIZED ]] --

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]] --
local Config = {
    Active = true,
    SaveFile = "SoloCheat_Auth.txt", -- Fichier sauvegardé sur ton PC
    Silent = false, FOV = 200, ShowFOV = true, TargetPart = "Head",
    Fly = false, FlySpeed = 60, NoClip = false,
    ESP_Box = false, ESP_HealthText = false,
    Invisible = false, 
    TP_Key = Enum.KeyCode.E,
    MenuKey = Enum.KeyCode.K,
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    AccentColor = Color3.fromRGB(0, 255, 65),
    AllyColor = Color3.fromRGB(0, 150, 255),
    BgColor = Color3.fromRGB(5, 5, 5),
    SecColor = Color3.fromRGB(15, 15, 15),
    Rounded = UDim.new(0, 12)
}

-- [[ MOTEUR SILENT AIM (ANTI-ALLIÉS & ANTI-MORTS) ]] --
local function GetClosestTarget()
    local target = nil
    local nearestDistance = Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local isEnemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            local hum = p.Character:FindFirstChild("Humanoid")
            if isEnemy and hum and hum.Health > 0 then
                local part = p.Character[Config.TargetPart]
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = UIS:GetMouseLocation()
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < nearestDistance then
                        nearestDistance = dist
                        target = part
                    end
                end
            end
        end
    end
    return target
end

-- [[ ESP AVEC BARRE DE VIE DYNAMIQUE ]] --
local function CreateESP(p)
    local function SetupESP(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10)
        if not head then return end

        local box = Instance.new("BoxHandleAdornment", CoreGui)
        box.AlwaysOnTop = true; box.Size = Vector3.new(4, 6, 0.05); box.Transparency = 0.7; box.Adornee = char
        local bill = Instance.new("BillboardGui", CoreGui)
        bill.Size = UDim2.new(0, 80, 0, 10); bill.AlwaysOnTop = true; bill.ExtentsOffset = Vector3.new(0, 3.5, 0); bill.Adornee = head
        local bgBar = Instance.new("Frame", bill); bgBar.Size = UDim2.new(1, 0, 1, 0); bgBar.BackgroundColor3 = Color3.new(0,0,0); bgBar.BorderSizePixel = 0
        local healthBar = Instance.new("Frame", bgBar); healthBar.Size = UDim2.new(1, 0, 1, 0); healthBar.BorderSizePixel = 0
        local hpLabel = Instance.new("TextLabel", bill); hpLabel.Size = UDim2.new(1, 0, 1, 0); hpLabel.Position = UDim2.new(0, 0, -1.2, 0); hpLabel.BackgroundTransparency = 1; hpLabel.Font = "Code"; hpLabel.TextSize = 12; hpLabel.TextColor3 = Color3.new(1,1,1)

        local conn; conn = RunService.RenderStepped:Connect(function()
            if not char.Parent or not Config.Active then box:Destroy(); bill:Destroy(); conn:Disconnect(); return end
            box.Visible = Config.ESP_Box; bill.Enabled = Config.ESP_HealthText
            local isAlly = (p.Team == LocalPlayer.Team and tostring(p.Team) ~= "Neutral")
            box.Color3 = isAlly and Config.AllyColor or Config.AccentColor
            local hum = char:FindFirstChild("Humanoid")
            if hum and bill.Enabled then
                local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                healthBar.Size = UDim2.new(hpPercent, 0, 1, 0)
                healthBar.BackgroundColor3 = Color3.fromHSV(hpPercent * 0.3, 1, 1)
                hpLabel.Text = p.Name:upper() .. " [" .. math.floor(hum.Health) .. "]"
            end
        end)
    end
    p.CharacterAdded:Connect(SetupESP); if p.Character then SetupESP(p.Character) end
end

-- [[ INTERFACE MAIN ]] --
local function LaunchCheat()
    local MainUI = Instance.new("ScreenGui", CoreGui)
    local MainFrame = Instance.new("Frame", MainUI); MainFrame.Size = UDim2.new(0, 580, 0, 430); MainFrame.Position = UDim2.new(0.5, -290, 0.5, -215); MainFrame.BackgroundColor3 = Config.BgColor; Instance.new("UICorner", MainFrame).CornerRadius = Config.Rounded
    Instance.new("UIStroke", MainFrame).Color = Config.AccentColor

    local TopBar = Instance.new("Frame", MainFrame); TopBar.Size = UDim2.new(1, 0, 0, 45); TopBar.BackgroundColor3 = Config.SecColor; Instance.new("UICorner", TopBar).CornerRadius = Config.Rounded
    local Title = Instance.new("TextLabel", TopBar); Title.Size = UDim2.new(1, 0, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0); Title.Text = "SOLOCHIET // RIVALS_ELITE"; Title.TextColor3 = Config.AccentColor; Title.Font = "Code"; Title.TextSize = 18; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0
    local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -40, 0.5, -17); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.Font = "Code"; CloseBtn.TextSize = 22

    local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Size = UDim2.new(0, 150, 1, -60); Sidebar.Position = UDim2.new(0, 10, 0, 55); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)
    local Container = Instance.new("Frame", MainFrame); Container.Size = UDim2.new(1, -180, 1, -65); Container.Position = UDim2.new(0, 170, 0, 55); Container.BackgroundTransparency = 1

    local function AddTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar); TabBtn.Size = UDim2.new(1, 0, 0, 40); TabBtn.Text = "[ " .. name:upper() .. " ]"; TabBtn.BackgroundColor3 = Config.SecColor; TabBtn.TextColor3 = Color3.new(0.6, 0.6, 0.6); TabBtn.Font = "Code"; Instance.new("UICorner", TabBtn)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)
        return Page
    end

    local function AddToggle(parent, text, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 45); b.Text = "> " .. text .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(15, 15, 15); b.TextColor3 = Color3.new(1, 1, 1); b.Font = "Code"; Instance.new("UICorner", b)
        local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(40, 40, 40)
        b.MouseButton1Click:Connect(function() 
            Config[key] = not Config[key]
            b.Text = "> " .. text .. " : " .. (Config[key] and "ON" or "OFF")
            b.TextColor3 = Config[key] and Config.AccentColor or Color3.new(1, 1, 1); s.Color = Config[key] and Config.AccentColor or Color3.fromRGB(40, 40, 40)
        end)
    end

    local function AddSlider(parent, text, key, min, max)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 60); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = "// " .. text .. " : " .. Config[key]; l.TextColor3 = Config.AccentColor; l.Font = "Code"; l.BackgroundTransparency = 1; l.TextXAlignment = 0
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(1, 0, 0, 8); b.Position = UDim2.new(0, 0, 0.6, 0); b.Text = ""; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", b)
        local fill = Instance.new("Frame", b); fill.Size = UDim2.new((Config[key]-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Config.AccentColor; Instance.new("UICorner", fill)
        b.MouseButton1Click:Connect(function()
            local m = math.clamp((UIS:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
            Config[key] = math.floor(min + (m * (max - min))); l.Text = "// " .. text .. " : " .. Config[key]; fill.Size = UDim2.new(m, 0, 1, 0)
        end)
    end

    local function AddKey(parent, text, key)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.Text = "> BIND_" .. text; l.TextColor3 = Color3.new(0.8, 0.8, 0.8); l.Font = "Code"; l.BackgroundTransparency = 1; l.TextXAlignment = 0
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 100, 0, 30); b.Position = UDim2.new(1, -100, 0.5, -15); b.Text = "[" .. Config[key].Name .. "]"; b.BackgroundColor3 = Config.SecColor; b.TextColor3 = Config.AccentColor; b.Font = "Code"; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() b.Text = "[...]"; local c; c = UIS.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Keyboard then Config[key] = i.KeyCode; b.Text = "[" .. i.KeyCode.Name .. "]"; c:Disconnect() end end) end)
    end

    local TCombat = AddTab("Combat"); local TVisual = AddTab("Visuals"); local TVisibility = AddTab("Visibility"); local TMovement = AddTab("Movement"); local TSettings = AddTab("Settings")
    AddToggle(TCombat, "AIM_SILENT", "Silent"); AddToggle(TCombat, "DRAW_FOV", "ShowFOV")
    AddToggle(TVisual, "ESP_BOX", "ESP_Box"); AddToggle(TVisual, "ESP_HEALTH_BAR", "ESP_HealthText")
    AddToggle(TVisibility, "GHOST_MODE", "Invisible")
    AddToggle(TMovement, "MOVE_FLY", "Fly"); AddToggle(TMovement, "MOVE_NOCLIP", "NoClip")
    AddSlider(TSettings, "FOV_VALUE", "FOV", 50, 800); AddSlider(TSettings, "FLY_SPEED", "FlySpeed", 1, 200)
    AddKey(TSettings, "GHOST_BLINK", "TP_Key"); AddKey(TSettings, "MENU_TOGGLE", "MenuKey")

    local Circle = Drawing.new("Circle"); Circle.Thickness = 1; Circle.Color = Config.AccentColor; Circle.Transparency = 0.7
    RunService.RenderStepped:Connect(function()
        if not Config.Active then return end
        Circle.Visible = Config.ShowFOV; Circle.Radius = Config.FOV; Circle.Position = UIS:GetMouseLocation()
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t then local p = Camera:WorldToViewportPoint(t.Position); mousemoverel((p.X - UIS:GetMouseLocation().X)/2, (p.Y - UIS:GetMouseLocation().Y)/2) end
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if Config.Invisible then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end end end
            if Config.Fly then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0.1, 0)
                local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
                if m.Magnitude > 0 then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (m * (Config.FlySpeed/10)) end
            end
        end
    end)

    UIS.InputBegan:Connect(function(i, g) 
        if g then return end
        if i.KeyCode == Config.MenuKey then MainFrame.Visible = not MainFrame.Visible 
        elseif i.KeyCode == Config.TP_Key then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then TweenService:Create(hrp, TweenInfo.new(0.15), {CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 30)}):Play() end
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function() Config.Active = false; Circle:Remove(); MainUI:Destroy() end)
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
    Players.PlayerAdded:Connect(CreateESP); TCombat.Visible = true
end

-- [[ KEY SYSTEM AVEC SAUVEGARDE LOCALE ]] --
local function StartKey()
    -- Check si la clé est déjà enregistrée sur le PC
    if isfile and isfile(Config.SaveFile) then
        local savedKey = readfile(Config.SaveFile)
        if savedKey == Config.CorrectKey then
            print("SoloCheat: Clé valide détectée sur le PC. Lancement...")
            LaunchCheat()
            return
        end
    end

    local KeyUI = Instance.new("ScreenGui", CoreGui)
    local KF = Instance.new("Frame", KeyUI); KF.Size = UDim2.new(0, 420, 0, 260); KF.Position = UDim2.new(0.5, -210, 0.5, -130); KF.BackgroundColor3 = Config.BgColor; Instance.new("UICorner", KF); Instance.new("UIStroke", KF).Color = Config.AccentColor
    local L = Instance.new("TextLabel", KF); L.Size = UDim2.new(1, 0, 0, 60); L.Text = "AUTHENTICATION_REQUIRED"; L.TextColor3 = Config.AccentColor; L.Font = "Code"; L.TextSize = 18; L.BackgroundTransparency = 1
    local B = Instance.new("TextBox", KF); B.Size = UDim2.new(0.8, 0, 0, 45); B.Position = UDim2.new(0.1, 0, 0.35, 0); B.PlaceholderText = "ENTREZ LA CLÉ..."; B.BackgroundColor3 = Config.SecColor; B.TextColor3 = Color3.new(1,1,1); B.Font = "Code"; Instance.new("UICorner", B)
    local V = Instance.new("TextButton", KF); V.Size = UDim2.new(0.4, -5, 0, 45); V.Position = UDim2.new(0.1, 0, 0.65, 0); V.Text = "[ EXECUTE ]"; V.BackgroundColor3 = Color3.fromRGB(20, 40, 20); V.TextColor3 = Config.AccentColor; V.Font = "Code"; Instance.new("UICorner", V)
    local G = Instance.new("TextButton", KF); G.Size = UDim2.new(0.4, -5, 0, 45); G.Position = UDim2.new(0.5, 5, 0.65, 0); G.Text = "[ DISCORD ]"; G.BackgroundColor3 = Config.SecColor; G.TextColor3 = Color3.new(0.8, 0.8, 0.8); G.Font = "Code"; Instance.new("UICorner", G)

    V.MouseButton1Click:Connect(function() 
        if B.Text == Config.CorrectKey then 
            if writefile then writefile(Config.SaveFile, B.Text) end -- SAUVEGARDE SUR LE PC
            KeyUI:Destroy(); LaunchCheat() 
        else 
            B.Text = ""; B.PlaceholderText = "CLÉ INCORRECTE !"
        end 
    end)
    G.MouseButton1Click:Connect(function() setclipboard(Config.Discord) end)
end

StartKey()
