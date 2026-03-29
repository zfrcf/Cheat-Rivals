-- [[ SoloCheat - V1 OMNIPOTENT // THE STABLE ONE ]] --
-- [[ AIMLOCK DIRECT | ESP HIGHLIGHT | NO-BUG ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Nettoyage des anciennes interfaces
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SoloCheat_Omni_Final" then v:Destroy() end
end

local Config = {
    Active = true,
    Aimbot = false,
    FOV = 2000,
    ESP_Box = false,
    MenuKey = "K"
}

-- [[ AIMLOCK BRUT (FORCE LA CAMÉRA) ]] --
local function GetClosestTarget()
    local target, nearest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local hum = p.Character:FindFirstChild("Humanoid")
            -- On vérifie juste si l'ennemi est vivant et d'une autre équipe
            if hum and hum.Health > 0 and (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral") then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if dist < nearest then
                        nearest = dist
                        target = head
                    end
                end
            end
        end
    end
    return target
end

-- [[ ESP HIGHLIGHT (SILHOUETTE À TRAVERS LES MURS) ]] --
local function ApplyESP(p)
    local function Create()
        local char = p.Character or p.CharacterAdded:Wait()
        -- On crée l'effet de surbrillance
        local high = char:FindFirstChild("SoloHighlight") or Instance.new("Highlight", char)
        high.Name = "SoloHighlight"
        high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- VOIR À TRAVERS LES MURS
        high.FillColor = Color3.fromRGB(0, 255, 65)
        high.OutlineColor = Color3.new(1, 1, 1)

        local loop; loop = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent or not Config.Active then 
                if high then high:Destroy() end
                loop:Disconnect()
                return 
            end
            -- L'ESP s'affiche si l'option est ON et que c'est un ennemi
            local enemy = (p.Team ~= LocalPlayer.Team or tostring(p.Team) == "Neutral")
            high.Enabled = Config.ESP_Box and enemy
        end)
    end
    p.CharacterAdded:Connect(Create)
    if p.Character then Create() end
end

-- [[ INTERFACE SIMPLE ET SOLIDE ]] --
local function LaunchUI()
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloCheat_Omni_Final"
    local Main = Instance.new("Frame", UI); Main.Size = UDim2.new(0, 400, 0, 250); Main.Position = UDim2.new(0.5, -200, 0.5, -125); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 65)

    local Title = Instance.new("TextLabel", Main); Title.Text = "SOLO MASTER (AIM + ESP)"; Title.Size = UDim2.new(1, 0, 0, 40); Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = "Code"
    
    local List = Instance.new("Frame", Main); List.Size = UDim2.new(1, -20, 1, -60); List.Position = UDim2.new(0, 10, 0, 50); List.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", List); Layout.Padding = UDim.new(0, 10)

    local function AddToggle(txt, key)
        local btn = Instance.new("TextButton", List); btn.Size = UDim2.new(1, 0, 0, 45); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.Font = "Code"; Instance.new("UICorner", btn)
        local function upd() 
            btn.Text = txt .. " : " .. (Config[key] and "ON" or "OFF")
            btn.TextColor3 = Config[key] and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
        end
        btn.MouseButton1Click:Connect(function() Config[key] = not Config[key]; upd() end)
        upd()
    end

    AddToggle("AIMLOCK (CLIC DROIT)", "Aimbot")
    AddToggle("ESP ENNEMIS (MURS)", "ESP_Box")

    -- [[ BOUCLE DE FONCTIONNEMENT ]] --
    local RightHolding = false
    UIS.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then RightHolding = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then RightHolding = false end end)

    RunService.RenderStepped:Connect(function()
        if Config.Active and Config.Aimbot and RightHolding then
            local t = GetClosestTarget()
            if t then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
            end
        end
    end)
    
    -- Touche Menu (K)
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode.Name == Config.MenuKey then Main.Visible = not Main.Visible end
    end)
end

-- Lancement
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ApplyESP(p) end end
Players.PlayerAdded:Connect(ApplyESP)
LaunchUI()
