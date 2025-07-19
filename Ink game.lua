if game.PlaceId ~= 7008997940 then
return
end

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
Title = 'Mistify | Made by Alchemist',
Center = true,
AutoShow = true
})
local Tabs = {
Info    = Window:AddTab('Info'),
Main    = Window:AddTab('Main'),
Visuals = Window:AddTab('Visuals'),
}

Tabs.Info:AddLabel('Welcome to Mistify')

Tabs.Main:AddLabel('Main functionality goes here.')

Tabs.Main:AddButton({
Text = 'Auto Dalgona',
Func = function()
local success = pcall(function()
local mod = game.ReplicatedStorage:FindFirstChild("Modules", true)
mod = mod and mod:FindFirstChild("Games", true)
mod = mod and mod:FindFirstChild("DalgonaClient", true)
if not mod then error("no dalgona") end

for _, v in ipairs(getreg()) do  
            if typeof(v) == "function" and islclosure(v) then  
                local env = getfenv(v)  
                if env and env.script == mod then  
                    local info = debug.getinfo(v)  
                    if info and info.nups == 73 then  
                        setupvalue(v, 31, 9e9)  
                        break  
                    end  
                end  
            end  
        end  
    end)  
    if not success then  
        game.StarterGui:SetCore("SendNotification", {  
            Title = "Mistify",  
            Text = "Error! No dalgona found. Make sure you're in the mini game before clicking.",  
            Duration = 4  
        })  
    end  
end

})

Tabs.Main:AddButton({
Text = "Teleport to the end in red light green light",
Func = function()
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local ts = game:GetService("TweenService")  
    local goal = {CFrame = CFrame.new(-46, 1024.7, 136.4)}  
    local info = TweenInfo.new(2, Enum.EasingStyle.Linear)  
    ts:Create(root, info, goal):Play()  
end

})

Tabs.Visuals:AddLabel('Visuals & appearance controls here.')

local espKillers, espHiders, espPlayers = false, false, false
local adorners = {}
local billboardESP = {}

local function clearESP()
for _, ad in ipairs(adorners) do
if ad and ad.Parent then ad:Destroy() end
end
adorners = {}
end

local function updateESP()
clearESP()
for _, player in ipairs(game.Players:GetPlayers()) do
if player ~= game.Players.LocalPlayer and player.Character then
local hasKnife = false

for _, tool in ipairs(player.Backpack:GetChildren()) do  
            if tool:IsA("Tool") and tool.Name:lower() == "knife" then  
                hasKnife = true  
                break  
            end  
        end  
        for _, tool in ipairs(player.Character:GetChildren()) do  
            if tool:IsA("Tool") and tool.Name:lower() == "knife" then  
                hasKnife = true  
                break  
            end  
        end  

        local root = player.Character:FindFirstChild("HumanoidRootPart")  
        if root then  
            if espKillers and hasKnife then  
                local box = Instance.new("BoxHandleAdornment")  
                box.Adornee = root  
                box.Size = root.Size  
                box.Color3 = Color3.fromRGB(255, 0, 0)  
                box.Transparency = 0.5  
                box.AlwaysOnTop = true  
                box.Parent = root  
                table.insert(adorners, box)  
            elseif espHiders and not hasKnife then  
                local box = Instance.new("BoxHandleAdornment")  
                box.Adornee = root  
                box.Size = root.Size  
                box.Color3 = Color3.fromRGB(0, 0, 255)  
                box.Transparency = 0.5  
                box.AlwaysOnTop = true  
                box.Parent = root  
                table.insert(adorners, box)  
            end  
        end  
    end  
end

end

local function clearBillboardESP()
for _, esp in ipairs(billboardESP) do
if esp and esp.Parent then esp:Destroy() end
end
billboardESP = {}
end

local function updateBillboardESP()
clearBillboardESP()
for _, player in ipairs(game.Players:GetPlayers()) do
if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
local hrp = player.Character.HumanoidRootPart
local humanoid = player.Character.Humanoid

local tag = Instance.new("BillboardGui")  
        tag.Adornee = hrp  
        tag.Size = UDim2.new(0, 200, 0, 50)  
        tag.StudsOffset = Vector3.new(0, 3, 0)  
        tag.AlwaysOnTop = true  
        tag.Name = "PlayerESP"  

        local text = Instance.new("TextLabel")  
        text.Size = UDim2.new(1, 0, 1, 0)  
        text.BackgroundTransparency = 1  
        text.TextColor3 = Color3.new(1, 1, 1)  
        text.TextStrokeTransparency = 0  
        text.Font = Enum.Font.SourceSansBold  
        text.TextScaled = true  

        local distance = math.floor((hrp.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)  
        text.Text = string.format("%s | %d HP | %d Studs", player.DisplayName or player.Name, math.floor(humanoid.Health), distance)  
        text.Parent = tag  
        tag.Parent = hrp  

        table.insert(billboardESP, tag)  
    end  
end

end

Tabs.Visuals:AddToggle({
Text = "ESP Killers",
Default = false,
Callback = function(v)
espKillers = v
updateESP()
end
})

Tabs.Visuals:AddToggle({
Text = "ESP Hiders",
Default = false,
Callback = function(v)
espHiders = v
updateESP()
end
})

Tabs.Visuals:AddToggle({
Text = "ESP Players",
Default = false,
Callback = function(v)
espPlayers = v
if not v then
clearBillboardESP()
else
updateBillboardESP()
end
end
})

task.spawn(function()
while true do
if espKillers or espHiders then
pcall(updateESP)
end
task.wait(1.5)
end
end)

task.spawn(function()
while true do
if espPlayers then
pcall(updateBillboardESP)
end
task.wait(2)
end
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Info)
SaveManager:BuildConfigSection(Tabs.Info) what extra logics should I add bruuu
