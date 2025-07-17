local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Mistify",
    SubTitle = "by Alchemist",
    TabWidth = 120,
    Size = UDim2.fromOffset(460, 320),
    Acrylic = true,
    Theme = "Dark",
    ThemeColor = Color3.fromRGB(0, 255, 0),
    MinimizeKey = Enum.KeyCode.RightControl
})

local MiscTab = Window:AddTab({ Title = "Misc", Icon = "settings" })
local InfoTab = Window:AddTab({ Title = "Info", Icon = "info" })
local VisualsTab = Window:AddTab({ Title = "Visuals", Icon = "eye" })

MiscTab:AddButton({
    Title = "Tp to Stillwater",
    Description = "Teleports you to Stillwater",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alchemist-cloud/newstillwater/refs/heads/main/alchemist.lua", true))()
    end
})

MiscTab:AddButton({
    Title = "Tp to Sterling",
    Description = "Teleports you to Sterling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tptostearling.github.io/refs/heads/main/Stearlingtown.lua", true))()
    end
})

MiscTab:AddButton({
    Title = "Tp to Castle",
    Description = "Teleports you to Castle",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua", true))()
    end
})


MiscTab:AddButton({
    Title = "Tp to Tesla lab",
    Description = "Teleports you to Tesla Lab",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/tptotesla.github.io/refs/heads/main/Tptotesla.lua", true))()
    end
})

MiscTab:AddButton({
    Title = "Tp to Fort",
    Description = "Teleports you to Fort",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua", true))()
    end
})

local executorName = (identifyexecutor and identifyexecutor()) or "Unknown"
InfoTab:AddParagraph({ Title = "Executor:", Content = executorName })
InfoTab:AddParagraph({ Title = "Discord:", Content = "alchemist_gaming2.0" })

VisualsTab:AddToggle("espMobs", {
    Title = "ESP Mobs",
    Default = false,
    Callback = function(enabled)
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local radius = 50
        local highlights = {}


        if enabled then
            highlights = {}
            getgenv().espRunning = true
            RunService.Heartbeat:Connect(function()
                if not getgenv().espRunning then return end
                for _, model in ipairs(workspace:GetChildren()) do
                    if model:IsA("Model")
                    and model:FindFirstChild("Humanoid")
                    and model:FindFirstChild("HumanoidRootPart")
                    and not Players:GetPlayerFromCharacter(model)
                    and (hrp.Position - model.HumanoidRootPart.Position).Magnitude < radius
                    and model.HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 0.1 then
                        if not highlights[model] then
                            local hl = Instance.new("Highlight")
                            hl.FillColor = Color3.new(1, 0, 0)
                            hl.OutlineTransparency = 1
                            hl.FillTransparency = 0.3
                            hl.Adornee = model
                            hl.Parent = model
                            highlights[model] = hl
                        end
                    else
                        if highlights[model] then
                            highlights[model]:Destroy()
                            highlights[model] = nil
                        end
                    end
                end
            end)
        else
            getgenv().espRunning = false
            for model, hl in pairs(highlights) do
                if hl then hl:Destroy() end
            end
        end
    end
})


VisualsTab:AddToggle("aimbot", {
    Title = "Aimbot",
    Default = false,
    Callback = function(enabled)
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local conn


        local function getNearestNPC()
            local closest, dist = nil, math.huge
            local char = localPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
            local myPos = char.HumanoidRootPart.Position


            for _, model in ipairs(workspace:GetChildren()) do
                if model:IsA("Model")
                and model:FindFirstChild("Humanoid")
                and model:FindFirstChild("HumanoidRootPart")
                and model.Humanoid.Health > 0
                and not Players:GetPlayerFromCharacter(model) then
                    local d = (model.HumanoidRootPart.Position - myPos).Magnitude
                    if d < dist then
                        dist = d
                        closest = model
                    end
                end
            end
            return closest
        end


        if enabled then
            conn = RunService.RenderStepped:Connect(function()
                local target = getNearestNPC()
                if target and target:FindFirstChild("HumanoidRootPart") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.HumanoidRootPart.Position)
                end
            end)
        else
            if conn then conn:Disconnect() end
        end
    end
})


VisualsTab:AddToggle("fullbright", {
    Title = "Fullbright",
    Default = false,
    Callback = function(enabled)
        local Lighting = game:GetService("Lighting")
        if enabled then
            getgenv().OriginalLightingSettings = {
                Brightness = Lighting.Brightness,
                FogEnd = Lighting.FogEnd,
                FogStart = Lighting.FogStart,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient
            }
            Lighting.Brightness = 2
            Lighting.FogEnd = 1e10
            Lighting.FogStart = 0
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            if getgenv().OriginalLightingSettings then
                Lighting.Brightness = getgenv().OriginalLightingSettings.Brightness
                Lighting.FogEnd = getgenv().OriginalLightingSettings.FogEnd
                Lighting.FogStart = getgenv().OriginalLightingSettings.FogStart
                Lighting.Ambient = getgenv().OriginalLightingSettings.Ambient
                Lighting.OutdoorAmbient = getgenv().OriginalLightingSettings.OutdoorAmbient
            end
        end
    end
})
