local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AlchemistUI"
ScreenGui.ResetOnSpawn = false
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 then
  dragging = true
  dragStart = input.Position
  startPos = MainFrame.Position
  input.Changed:Connect(function()
   if input.UserInputState == Enum.UserInputState.End then
    dragging = false
   end
  end)
 end
end)


MainFrame.InputChanged:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseMovement then
  dragInput = input
 end
end)


RunService.InputChanged:Connect(function(input)
 if input == dragInput and dragging then
  local delta = input.Position - dragStart
  MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
 end
end)


local Tabs = {}
local tabNames = {"Info", "Misc", "Visual"}
local currentTab = nil


local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.BackgroundTransparency = 1


for i, name in ipairs(tabNames) do
 local tabButton = Instance.new("TextButton", TabBar)
 tabButton.Size = UDim2.new(0, 100, 0, 30)
 tabButton.Position = UDim2.new(0, (i - 1) * 105 + 10, 0, 2)
 tabButton.Text = name
 tabButton.Font = Enum.Font.GothamSemibold
 tabButton.TextColor3 = Color3.new(1, 1, 1)
 tabButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
 tabButton.BackgroundTransparency = 0.3
 tabButton.BorderSizePixel = 0


 local contentFrame = Instance.new("Frame", MainFrame)
 contentFrame.Size = UDim2.new(1, -20, 1, -45)
 contentFrame.Position = UDim2.new(0, 10, 0, 40)
 contentFrame.Visible = false
 contentFrame.BackgroundTransparency = 1


 Tabs[name] = contentFrame


 tabButton.MouseButton1Click:Connect(function()
  if currentTab then
   Tabs[currentTab].Visible = false
  end
  currentTab = name
  contentFrame.Visible = true
 end)


 if i == 1 then
  currentTab = name
  contentFrame.Visible = true
 end
end


local Misc = Tabs["Misc"]


local function addButton(tab, text, callback)
 local btn = Instance.new("TextButton", tab)
 btn.Size = UDim2.new(0, 200, 0, 30)
 btn.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 35)
 btn.Text = text
 btn.Font = Enum.Font.Gotham
 btn.TextColor3 = Color3.new(1,1,1)
 btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
 btn.BackgroundTransparency = 0.3
 btn.BorderSizePixel = 0
 btn.MouseButton1Click:Connect(callback)
end


addButton(Misc, "Tp to Stillwater", function()
 loadstring(game:HttpGet("https://raw.githubusercontent.com/Alchemist-cloud/newstillwater/refs/heads/main/alchemist.lua", true))()
end)


addButton(Misc, "Tp to Castle", function()
 loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua", true))()
end)


addButton(Misc, "Tp to Sterling", function()
 loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tptostearling.github.io/refs/heads/main/Stearlingtown.lua", true))()
end)


addButton(Misc, "Tp to Fort", function()
 loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua", true))()
end)


addButton(Misc, "Tp to Tesla Lab", function()
 loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/tptotesla.github.io/refs/heads/main/Tptotesla.lua", true))()
end)


local aimbotOn = false
local aimbotConnection
local currentTarget


local function getClosestTarget()
 local shortest = math.huge
 local target = nil
 for _, npc in pairs(workspace:GetDescendants()) do
  if npc:IsA("Model") and not Players:GetPlayerFromCharacter(npc) and npc ~= Player.Character then
   local humanoid = npc:FindFirstChildOfClass("Humanoid")
   local hrp = npc:FindFirstChild("HumanoidRootPart")
   if humanoid and hrp and humanoid.Health > 0 then
    local dir = (Player.Character.HumanoidRootPart.Position - hrp.Position).Unit
    if hrp.AssemblyLinearVelocity:Dot(dir) > 0.5 then
     local dist = (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude
     if dist < shortest then
      shortest = dist
      target = npc
     end
    end
   end
  end
 end
 return target
end


addButton(Misc, "Toggle Aimbot", function()
 aimbotOn = not aimbotOn
 if aimbotOn then
  aimbotConnection = RunService.RenderStepped:Connect(function()
   if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
   if not currentTarget then currentTarget = getClosestTarget() end
   if currentTarget then
    local part = currentTarget:FindFirstChild("Head") or currentTarget:FindFirstChild("HumanoidRootPart")
    if part then Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position) end
   end
  end)
 else
  if aimbotConnection then aimbotConnection:Disconnect() end
  currentTarget = nil
 end
end)


local Visual = Tabs["Visual"]


local mobESPOn = false
local mobESPConnection
local highlighted = {}


addButton(Visual, "Toggle ESP Mobs", function()
 mobESPOn = not mobESPOn
 if mobESPOn then
  local char = Player.Character or Player.CharacterAdded:Wait()
  local HRP = char:WaitForChild("HumanoidRootPart")
  local radius = 50


  mobESPConnection = RunService.Heartbeat:Connect(function()
   for _, model in pairs(workspace:GetChildren()) do
    if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model ~= char then
     local hrp = model.HumanoidRootPart
     local dist = (HRP.Position - hrp.Position).Magnitude
     local isPlayer = Players:GetPlayerFromCharacter(model)
     if dist < radius and hrp.AssemblyLinearVelocity.Magnitude > 0.1 and not isPlayer and not highlighted[model] then
      local h = Instance.new("Highlight")
      h.FillColor = Color3.new(1, 0, 0)
      h.OutlineTransparency = 1
      h.FillTransparency = 0.3
      h.Adornee = model
      h.Parent = model
      highlighted[model] = h
     elseif dist >= radius or isPlayer then
      if highlighted[model] then highlighted[model]:Destroy() highlighted[model] = nil end
     end
    end
   end
  end)
 else
  if mobESPConnection then mobESPConnection:Disconnect() end
  for model, h in pairs(highlighted) do if h then h:Destroy() end end
  table.clear(highlighted)
 end
end)


local fbOn = false
local fbLoop


addButton(Visual, "Toggle Fullbright", function()
 fbOn = not fbOn
 local lighting = game:GetService("Lighting")
 if fbOn then
  fbLoop = RunService.RenderStepped:Connect(function()
   lighting.FogEnd = 1e10
   lighting.Brightness = 5
   lighting.GlobalShadows = false
   lighting.OutdoorAmbient = Color3.new(1, 1, 1)
  end)
 else
  if fbLoop then fbLoop:Disconnect() end
  lighting.FogEnd = 1000
  lighting.Brightness = 2
  lighting.GlobalShadows = true
  lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
 end
end)


addButton(Tabs["Info"], "Made by Alchemist", function()
 setclipboard("Alchemist hates using custom uis")
end)
