-- [[ SoloCheat - V1 ]] --
-- [[ RECONSTRUCTION COMPLÈTE - BOUTONS FIXÉS ]] --

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [[ CONFIGURATION INTERNE ]] --
local Config = {
    Silent = false,
    FOV = 200,
    ShowFOV = true,
    Fly = false,
    NoClip = false,
    ESP_Box = false,
    ESP_HealthText = false,
    FlySpeed = 2,
    TP_Key = Enum.KeyCode.E,
    MenuKey = Enum.KeyCode.K,
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0"
}

-- [[ FONCTIONS DE CIBLAGE ]] --
local function GetClosest()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
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

-- [[ INTERFACE SoloCheat - V1 ]] --
local function StartV1()
    if CoreGui:FindFirstChild("SoloV1") then CoreGui.SoloV1:Destroy() end
    
    local MainUI = Instance.new("ScreenGui", CoreGui); MainUI.Name = "SoloV1"
    local Frame = Instance.new("Frame", MainUI); Frame.Size = UDim2.new(0, 500, 0, 350); Frame.Position = UDim2.new(0.5, -250, 0.5, -175); Frame.BackgroundColor3 = Color3.fromRGB(15,15,15); Frame.Active = true; Frame.Draggable = true
    Instance.new("UICorner", Frame)
    
    local Title = Instance.new("TextLabel", Frame); Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "SoloCheat - V1"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundColor3 = Color3.fromRGB(25,25,25); Title.Font = "GothamBold"
    
    local Content = Instance.new("ScrollingFrame", Frame); Content.Size = UDim2.new(1, -20, 1, -50); Content.Position = UDim2.new(0, 10, 0, 45); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 2
    local List = Instance.new("UIListLayout", Content); List.Padding = UDim.new(0, 8)

    -- FONCTION BOUTON (CORRIGÉE)
    local function CreateToggle(name, prop)
        local b = Instance.new("TextButton", Content); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = name .. " : OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"
        Instance.new("UICorner", b)
        
        -- Mise à jour visuelle si déjà activé
        if Config[prop] then b.Text = name .. " : ON"; b.TextColor3 = Color3.fromRGB(0, 255, 150) end

        b.MouseButton1Click:Connect(function()
            Config[prop] = not Config[prop]
            b.Text = name .. " : " .. (Config[prop] and "ON" or "OFF")
            b.TextColor3 = Config[prop] and Color3.fromRGB(0, 255, 150) or Color3.new(1,1,1)
        end)
    end

    -- Création des boutons un par un
    CreateToggle("SILENT AIM (R-CLICK)", "Silent")
    CreateToggle("SHOW FOV CIRCLE", "ShowFOV")
    CreateToggle("ESP BOXES", "ESP_Box")
    CreateToggle("ESP NAME & HP", "ESP_HealthText")
    CreateToggle("FLY MODE", "Fly")
    CreateToggle("NOCLIP (ANTI-VOID)", "NoClip")

    -- [[ BOUCLE DE RENDU ]] --
    local FOVCircle = Drawing.new("Circle"); FOVCircle.Thickness = 1; FOVCircle.Color = Color3.fromRGB(0, 255, 150)

    RunService.RenderStepped:Connect(function()
        FOVCircle.Visible = Config.ShowFOV; FOVCircle.Radius = Config.FOV; FOVCircle.Position = UIS:GetMouseLocation()
        
        -- SILENT AIM
        if Config.Silent and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local t = GetClosest()
            if t and mousemoverel then
                local pos = Camera:WorldToViewportPoint(t.Position)
                mousemoverel(pos.X - UIS:GetMouseLocation().X, pos.Y - UIS:GetMouseLocation().Y)
            end
        end

        -- FLY & NOCLIP
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

    -- ESP SYSTEM
    local function AddESP(p)
        p.CharacterAdded:Connect(function(char)
            task.wait(1)
            local head = char:WaitForChild("Head"); local hum = char:WaitForChild("Humanoid")
            local box = Instance.new("BoxHandleAdornment", char); box.Adornee = char; box.AlwaysOnTop = true; box.Size = Vector3.new(4,6,1); box.Color3 = Color3.fromRGB(0, 255, 150); box.Transparency = 0.7
            local bill = Instance.new("BillboardGui", head); bill.Size = UDim2.new(0, 100, 0, 40); bill.AlwaysOnTop = true; bill.ExtentsOffset = Vector3.new(0, 3, 0)
            local lbl = Instance.new("TextLabel", bill); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,1,1); lbl.TextSize = 12; lbl.Font = "GothamBold"
            
            RunService.Heartbeat:Connect(function()
                box.Visible = Config.ESP_Box
                lbl.Visible = Config.ESP_HealthText
                if lbl.Visible then 
                    lbl.Text = p.Name .. "\nHP: " .. math.floor(hum.Health)
                    lbl.TextColor3 = Color3.fromHSV(hum.Health/100 * 0.35, 1, 1)
                end
            end)
        end)
    end
    for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then AddESP(p) end end
    Players.PlayerAdded:Connect(AddESP)

    -- TOUCHE MENU
    UIS.InputBegan:Connect(function(i) if i.KeyCode == Config.MenuKey then Frame.Visible = not Frame.Visible end end)
end

-- [[ SYSTÈME DE CLÉ ]] --
local KeyUI = Instance.new("ScreenGui", CoreGui); local KFrame = Instance.new("Frame", KeyUI); KFrame.Size = UDim2.new(0, 400, 0, 200); KFrame.Position = UDim2.new(0.5, -200, 0.5, -100); KFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner", KFrame); local KBox = Instance.new("TextBox", KFrame); KBox.Size = UDim2.new(0.8, 0, 0, 40); KBox.Position = UDim2.new(0.1, 0, 0.3, 0); KBox.Text = ""; KBox.PlaceholderText = "Entrez la clé V1..."
local KBtn = Instance.new("TextButton", KFrame); KBtn.Size = UDim2.new(0.4, 0, 0, 40); KBtn.Position = UDim2.new(0.3, 0, 0.65, 0); KBtn.Text = "VALIDER"

KBtn.MouseButton1Click:Connect(function()
    if KBox.Text == Config.CorrectKey then KeyUI:Destroy(); StartV1() end
end)
