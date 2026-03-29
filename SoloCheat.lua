-- [[ SoloCheat - V1 OMNIPOTENT // REGLAGE FINAL ]] --
-- [[ SILENT AIM V2 + PERMA-INVIS + AUTO-SAVE ]] --

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
    SaveFile = "SoloCheat_Auth.txt",
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

-- [[ FONCTION DE VISIBILITÉ (FIXED) ]] --
local function ToggleInvis(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            if v.Name ~= "HumanoidRootPart" then
                v.Transparency = state and 1 or 0
            end
        end
    end
end

-- [[ MOTEUR SILENT AIM (OPTIMISÉ AVEC WALL CHECK) ]] --
local function IsVisible(part)
    local char = LocalPlayer.Character
    if not char then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char, CoreGui, Camera}
    
    local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 500, params)
    return result and result.Instance:IsDescendantOf(part.Parent)
end

local function GetClosestTarget()
    local target = nil
    local nearestDistance = Config.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            local hum = p.Character:FindFirstChild("Humanoid")
            local isEnemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            
            -- Vérification : En vie + Ennemi
            if isEnemy and hum and hum.Health > 0 then
                local part = p.Character[Config.TargetPart]
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                
                if onScreen and IsVisible(part) then
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

-- [[ ESP & INTERFACE (CONSERVÉS) ]] --
local function CreateESP(p)
    local function SetupESP(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10)
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
            box.Color3 = (p.Team == LocalPlayer.Team and tostring(p.Team) ~= "Neutral") and Config.AllyColor or Config.AccentColor
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

-- [[ LANCEUR PRINCIPAL ]] --
local function LaunchCheat()
    local MainUI = Instance.new("ScreenGui", CoreGui)
    local MainFrame = Instance.new("Frame", MainUI); MainFrame.Size = UDim2.new(0, 580, 0, 430); MainFrame.Position = UDim2.new(0.5, -290, 0.5, -215); MainFrame.BackgroundColor3 = Config.BgColor; Instance.new("UICorner", MainFrame)
    local TopBar = Instance.new("Frame", MainFrame); TopBar.Size = UDim2.new(1, 0, 0, 45); TopBar.BackgroundColor3 = Config.SecColor; Instance.new("UICorner", TopBar)
    local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Size = UDim2.new(0, 150, 1, -60); Sidebar.Position = UDim2.new(0, 10, 0, 55); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)
    local Container = Instance.new("Frame", MainFrame); Container.Size = UDim2.new(1, -180, 1, -65); Container.Position = UDim2.new(0, 170, 0, 55); Container.BackgroundTransparency = 1

    local function AddTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar); TabBtn.Size = UDim2.new(1, 0, 0, 40); TabBtn.Text = "[ " .. name:upper() .. " ]"; TabBtn.BackgroundColor3 = Config.SecColor; TabBtn.TextColor3 = Color3.new(0.6, 0.6, 0.6); TabBtn.Font = "Code"; Instance.new("UICorner", TabBtn)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
        TabBtn.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; Page.Visible = true end)
        return Page
    end

    local function AddToggle(parent, text, key, callback)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -10, 0, 45); b.Text = "> " .. text .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(15, 15, 15); b.TextColor3 = Color3.new(1, 1, 1); b.Font = "Code"; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() 
            Config[key] = not Config[key]
            b.Text = "> " .. text .. " : " .. (Config[key] and "ON" or "OFF")
            b.TextColor3 = Config[key] and Config.AccentColor or Color3.new(1, 1, 1)
            if callback then callback(Config[key]) end
        end)
    end

    local TCombat = AddTab("Combat"); local TVisual = AddTab("Visuals"); local TVisibility = AddTab("Visibility"); local TMovement = AddTab("Movement"); local TSettings = AddTab("Settings")
    AddToggle(TCombat, "AIM_SILENT", "Silent"); AddToggle(TVisual, "ESP_BOX", "ESP_Box"); AddToggle(TVisual, "ESP_HEALTH", "ESP_HealthText")
    AddToggle(TVisibility, "GHOST_MODE", "Invisible", function(s) ToggleInvis(s) end)
    AddToggle(TMovement, "MOVE_FLY", "Fly")

    local Circle = Drawing.new("Circle"); Circle.Thickness = 1; Circle.Color = Config.AccentColor; Circle.Transparency = 0.7
    
    -- BOUCLE DE RENDU (AIM & FLY)
    RunService.RenderStepped:Connect(function()
        if not Config.Active then return end
        Circle.Visible = Config.ShowFOV; Circle.Radius = Config.FOV; Circle.Position = UIS:GetMouseLocation()
        
        -- SILENT AIM ACTIF AU CLIC DROIT
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosestTarget()
            if t then 
                local p = Camera:WorldToViewportPoint(t.Position)
                mousemoverel((p.X - UIS:GetMouseLocation().X)/1.8, (p.Y - UIS:GetMouseLocation().Y)/1.8) 
            end
        end

        -- MAINTENANCE DE L'INVISIBILITÉ (POUR LES NOUVEAUX ITEMS)
        if Config.Invisible and tick() % 1 < 0.1 then ToggleInvis(true) end

        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Config.Fly then
            hrp.Velocity = Vector3.new(0, 0.1, 0)
            local m = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
            if m.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (m * (Config.FlySpeed/10)) end
        end
    end)

    UIS.InputBegan:Connect(function(i, g) 
        if g then return end
        if i.KeyCode == Config.MenuKey then MainFrame.Visible = not MainFrame.Visible 
        elseif i.KeyCode == Config.TP_Key then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then TweenService:Create(hrp, TweenInfo.new(0.1), {CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 35)}):Play() end
        end
    end)

    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
    Players.PlayerAdded:Connect(CreateESP); TCombat.Visible = true
end

-- [[ SYSTEME DE CLÉ AVEC SAUVEGARDE ]] --
local function StartKey()
    if isfile and isfile(Config.SaveFile) and readfile(Config.SaveFile) == Config.CorrectKey then LaunchCheat() return end
    local KeyUI = Instance.new("ScreenGui", CoreGui)
    local KF = Instance.new("Frame", KeyUI); KF.Size = UDim2.new(0, 420, 0, 260); KF.Position = UDim2.new(0.5, -210, 0.5, -130); KF.BackgroundColor3 = Config.BgColor; Instance.new("UICorner", KF)
    local B = Instance.new("TextBox", KF); B.Size = UDim2.new(0.8, 0, 0, 45); B.Position = UDim2.new(0.1, 0, 0.35, 0); B.PlaceholderText = "TOKEN_REQUIRED..."; B.TextColor3 = Color3.new(1,1,1); B.Font = "Code"; Instance.new("UICorner", B)
    local V = Instance.new("TextButton", KF); V.Size = UDim2.new(0.4, -5, 0, 45); V.Position = UDim2.new(0.1, 0, 0.65, 0); V.Text = "[ EXECUTE ]"; V.BackgroundColor3 = Color3.fromRGB(20, 40, 20); V.TextColor3 = Config.AccentColor; V.Font = "Code"; Instance.new("UICorner", V)
    V.MouseButton1Click:Connect(function() if B.Text == Config.CorrectKey then if writefile then writefile(Config.SaveFile, B.Text) end; KeyUI:Destroy(); LaunchCheat() end end)
end

StartKey()
