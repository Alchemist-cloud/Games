local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Mistify" .. Fluent.Version,
    SubTitle = "by alchemist",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})


Fluent:Notify({
    Title = "thanks for using the script",
    Content = "made by alchemist",
    Duration = 5
})


local Tabs = {
    Misc = Window:AddTab({ Title = "Misc", Icon = "grid" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Info = Window:AddTab({ Title = "Info", Icon = "info" })
}
Tabs.Misc:AddButton({
    Title = "Tp to stillwater",
    Description = "Teleport to Stillwater",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alchemist-cloud/newstillwater/refs/heads/main/alchemist.lua", true))()
    end
})


Tabs.Misc:AddButton({
    Title = "Tp to castle",
    Description = "Teleport to Castle",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua", true))()
    end
})


Tabs.Misc:AddButton({
    Title = "Tp to sterling",
    Description = "Teleport to Sterling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tptostearling.github.io/refs/heads/main/Stearlingtown.lua", true))()
    end
})


Tabs.Misc:AddButton({
    Title = "Tp to Fort",
    Description = "Teleport to Fort",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua", true))()
    end
})


Tabs.Misc:AddButton({
    Title = "Tp to Tesla lab",
    Description = "Teleport to Tesla lab",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/tptotesla.github.io/refs/heads/main/Tptotesla.lua", true))()
    end
})
local espConnection
local highlighted = {}


Tabs.Visuals:AddToggle("EspMobs", {
    Title = "Esp Mobs",
    Description = "ESP MOBS",
    Default = false,
    Callback = function(state)
        if state then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local HRP = character:WaitForChild("HumanoidRootPart")
            local radius = 50


            espConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for _, model in pairs(workspace:GetChildren()) do
                    if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model ~= character then
                        local hrp = model.HumanoidRootPart
                        local dist = (HRP.Position - hrp.Position).Magnitude
                        local isPlayer = game.Players:GetPlayerFromCharacter(model)
                        local alreadyHas = highlighted[model]


                        if dist < radius and hrp.AssemblyLinearVelocity.Magnitude > 0.1 and not isPlayer then
                            if not alreadyHas then
                                local highlight = Instance.new("Highlight")
                                highlight.FillColor = Color3.new(1, 0, 0)
                                highlight.OutlineTransparency = 1
                                highlight.FillTransparency = 0.3
                                highlight.Adornee = model
                                highlight.Parent = model
                                highlighted[model] = highlight
                            end
                        else
                            if alreadyHas then
                                alreadyHas:Destroy()
                                highlighted[model] = nil
                            end
                        end
                    end
                end
            end)
        else
            if espConnection then
                espConnection:Disconnect()
                espConnection = nil
            end
            for model, highlight in pairs(highlighted) do
                if highlight then
                    highlight:Destroy()
                end
            end
            table.clear(highlighted)
        end
    end
})

Tabs.Visuals:AddToggle("FullbrightToggle", {
    Title = "Fullbright",
    Description = "Fullbright",
    Default = false,
    Callback = function(state)
        local lighting = game:GetService("Lighting")


        if state then
            lighting.FogEnd = 1e10
            lighting.Brightness = 5
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            lighting.FogEnd = 1000
            lighting.Brightness = 2
            lighting.GlobalShadows = true
            lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera


local aimbotConnection
local currentTarget = nil


local function getClosestTarget()
    local closestNPC = nil
    local shortestDistance = math.huge


    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and not Players:GetPlayerFromCharacter(npc) and npc ~= player.Character then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            local hrp = npc:FindFirstChild("HumanoidRootPart")


            if humanoid and hrp and humanoid.Health > 0 then
                local npcVelocity = hrp.AssemblyLinearVelocity
                local directionToPlayer = (player.Character.HumanoidRootPart.Position - hrp.Position).Unit
                local movingTowardPlayer = npcVelocity:Dot(directionToPlayer) > 0.5


                if movingTowardPlayer then
                    local distance = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestNPC = npc
                    end
                end
            end
        end
    end


    return closestNPC
end


Tabs.Misc:AddToggle("AimbotToggle", {
    Title = "Aimbot",
    Description = "Aimbot can't u read heh",
    Default = false,
    Callback = function(state)
        if state then
            aimbotConnection = RunService.RenderStepped:Connect(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end


                if currentTarget then
                    local humanoid = currentTarget:FindFirstChildOfClass("Humanoid")
                    if not humanoid or humanoid.Health <= 0 then
                        currentTarget = nil
                    end
                end


                if not currentTarget then
                    currentTarget = getClosestTarget()
                end


                if currentTarget then
                    local targetPart = currentTarget:FindFirstChild("Head") or currentTarget:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
                    end
                end
            end)
        else
            if aimbotConnection then
                aimbotConnection:Disconnect()
                aimbotConnection = nil
                currentTarget = nil
            end
        end
    end
})
