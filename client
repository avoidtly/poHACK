-- poHACK UI | Blox Fruits | Sea 1 Universal Auto Farm
-- Executor: any UNC-compatible (Wave, Solara, Synapse Z)
-- Game: Blox Fruits
-- Paste and inject

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer

-- // Sea 1 Level Map
local SEA1_ZONES = {
    {min = 1,   max = 15,  island = "Starter Island",    mob = "Bandit",          questNPC = "Guard"},
    {min = 15,  max = 30,  island = "Jungle",            mob = "Gorilla",         questNPC = "Gorilla King"},
    {min = 30,  max = 60,  island = "Pirate Village",    mob = "Pirate",          questNPC = "Village Elder"},
    {min = 60,  max = 90,  island = "Desert",            mob = "Desert Bandit",   questNPC = "Desert King"},
    {min = 90,  max = 120, island = "Frozen Village",    mob = "Snow Bandit",     questNPC = "Frozen Village Chief"},
    {min = 120, max = 170, island = "Marine Fortress",   mob = "Marine",          questNPC = "Marine Captain"},
    {min = 170, max = 220, island = "Skylands",          mob = "Sky Bandit",      questNPC = "Sky Scientist"},
    {min = 220, max = 280, island = "Prison",            mob = "Prisoner",        questNPC = "Chief Warden"},
    {min = 280, max = 340, island = "Colosseum",         mob = "Toga Warrior",    questNPC = "Colosseum Boss"},
    {min = 340, max = 420, island = "Magma Village",     mob = "Magma Ninja",     questNPC = "Magma Elder"},
    {min = 420, max = 500, island = "Underwater City",   mob = "Droids",          questNPC = "Underwater Elder"},
    {min = 500, max = 625, island = "Fountain City",     mob = "Fountain Citizen",questNPC = "Fountain Elder"},
    {min = 625, max = 700, island = "Upper Skylands",    mob = "Wysper",          questNPC = "Upper Sky Chief"},
}

-- // Mob Spawn Offsets (approximate CFrames per island)
local ISLAND_POSITIONS = {
    ["Starter Island"]   = Vector3.new(977, 17, 1290),
    ["Jungle"]           = Vector3.new(-1109, 18, 386),
    ["Pirate Village"]   = Vector3.new(-1383, 10, 1850),
    ["Desert"]           = Vector3.new(934, 85, -1251),
    ["Frozen Village"]   = Vector3.new(1175, 135, -3038),
    ["Marine Fortress"]  = Vector3.new(-3116, 9, -561),
    ["Skylands"]         = Vector3.new(-4838, 528, -1383),
    ["Prison"]           = Vector3.new(4813, 10, -4004),
    ["Colosseum"]        = Vector3.new(-905, 18, -3400),
    ["Magma Village"]    = Vector3.new(-4541, 730, -758),
    ["Underwater City"]  = Vector3.new(61164, 13, 1537),
    ["Fountain City"]    = Vector3.new(-1591, 113, -3615),
    ["Upper Skylands"]   = Vector3.new(-7894, 1050, -380),
}

-- // Utility
local function getLevel()
    local stats = lp:FindFirstChild("leaderstats") or lp:FindFirstChild("Stats")
    if stats then
        local lvl = stats:FindFirstChild("Level") or stats:FindFirstChild("Lv")
        if lvl then return lvl.Value end
    end
    return 1
end

local function getZone(level)
    for _, zone in ipairs(SEA1_ZONES) do
        if level >= zone.min and level < zone.max then
            return zone
        end
    end
    return SEA1_ZONES[#SEA1_ZONES]
end

local function getRoot()
    local char = lp.Character
    if char then return char:FindFirstChild("HumanoidRootPart") end
end

local function getHumanoid()
    local char = lp.Character
    if char then return char:FindFirstChild("Humanoid") end
end

local function teleportTo(pos)
    local root = getRoot()
    if root then
        root.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
    end
end

local function findNearestMob(mobName)
    local root = getRoot()
    if not root then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:find(mobName) then
            local mobRoot = v:FindFirstChild("HumanoidRootPart")
            local hum = v:FindFirstChild("Humanoid")
            if mobRoot and hum and hum.Health > 0 then
                local dist = (root.Position - mobRoot.Position).Magnitude
                if dist < nearestDist then
                    nearest = v
                    nearestDist = dist
                end
            end
        end
    end
    return nearest
end

local function attackMob(mob)
    local root = getRoot()
    local hum = getHumanoid()
    if not root or not mob then return end
    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
    if not mobRoot then return end
    -- teleport on top and let auto attack do the rest
    root.CFrame = CFrame.new(mobRoot.Position + Vector3.new(0, 3, 0))
    -- simulate click on mob for melee
    local args = {
        [1] = mob
    }
    -- fire melee remote if available
    local remote = workspace:FindFirstChild("Remotes") 
        and workspace.Remotes:FindFirstChild("CDamage")
    if remote then
        pcall(function() remote:FireServer(unpack(args)) end)
    end
end

-- // Auto Farm State
local farmActive = false
local farmLoop = nil
local statusLabel

local function startFarm()
    farmActive = true
    if statusLabel then statusLabel.Text = "Status: Farming..." end

    farmLoop = RunService.Heartbeat:Connect(function()
        if not farmActive then
            farmLoop:Disconnect()
            return
        end

        local level = getLevel()
        local zone = getZone(level)
        local islandPos = ISLAND_POSITIONS[zone.island]

        -- go to island if far away
        local root = getRoot()
        if root and islandPos then
            local dist = (root.Position - islandPos).Magnitude
            if dist > 300 then
                teleportTo(islandPos)
                task.wait(0.5)
            end
        end

        -- find and kill mob
        local mob = findNearestMob(zone.mob)
        if mob then
            attackMob(mob)
            task.wait(0.2)
        else
            -- no mob found, move around island slightly
            if root and islandPos then
                local offset = Vector3.new(math.random(-50, 50), 0, math.random(-50, 50))
                root.CFrame = CFrame.new(islandPos + offset + Vector3.new(0, 5, 0))
                task.wait(0.5)
            end
        end
    end)
end

local function stopFarm()
    farmActive = false
    if statusLabel then statusLabel.Text = "Status: Idle" end
end

-- // UI
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")
local ButtonContainer = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "poHACK"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success, result = pcall(function() return gethui() end)
ScreenGui.Parent = success and result or lp.PlayerGui

Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.35, 0, 0.3, 0)
Main.Size = UDim2.new(0, 280, 0, 420)
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 0, 180)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(25, 10, 40)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 36)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "poHACK"
Title.TextColor3 = Color3.fromRGB(180, 80, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TopBar
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 12, 0, 18)
SubTitle.Size = UDim2.new(1, -80, 0, 16)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "Blox Fruits | Sea 1 Auto Farm"
SubTitle.TextColor3 = Color3.fromRGB(100, 100, 120)
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(1, -52, 0, 8)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "–"
MinimizeBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
MinimizeBtn.TextSize = 16

CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -26, 0, 8)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextSize = 14

ButtonContainer.Parent = Main
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Position = UDim2.new(0, 0, 0, 44)
ButtonContainer.Size = UDim2.new(1, 0, 1, -44)

UIListLayout.Parent = ButtonContainer
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = ButtonContainer
UIPadding.PaddingTop = UDim.new(0, 8)

-- // Status Label
statusLabel = Instance.new("TextLabel")
statusLabel.Parent = ButtonContainer
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 12, 35)
statusLabel.Size = UDim2.new(0, 248, 0, 28)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
statusLabel.TextSize = 12
statusLabel.BorderSizePixel = 0
local slCorner = Instance.new("UICorner")
slCorner.CornerRadius = UDim.new(0, 6)
slCorner.Parent = statusLabel

-- level display
local levelLabel = Instance.new("TextLabel")
levelLabel.Parent = ButtonContainer
levelLabel.BackgroundColor3 = Color3.fromRGB(20, 12, 35)
levelLabel.Size = UDim2.new(0, 248, 0, 28)
levelLabel.Font = Enum.Font.Gotham
levelLabel.Text = "Level: checking..."
levelLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
levelLabel.TextSize = 12
levelLabel.BorderSizePixel = 0
local llCorner = Instance.new("UICorner")
llCorner.CornerRadius = UDim.new(0, 6)
llCorner.Parent = levelLabel

-- update level label every second
task.spawn(function()
    while task.wait(1) do
        local lvl = getLevel()
        local zone = getZone(lvl)
        levelLabel.Text = "Lv " .. lvl .. " → " .. zone.island
    end
end)

-- // Button Factory
local function makeButton(label, color, callback)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    local stroke = Instance.new("UIStroke")

    btn.Parent = ButtonContainer
    btn.BackgroundColor3 = Color3.fromRGB(28, 18, 45)
    btn.Size = UDim2.new(0, 248, 0, 38)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = label
    btn.TextColor3 = color or Color3.fromRGB(220, 200, 255)
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    stroke.Color = color or Color3.fromRGB(80, 0, 180)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(28, 18, 45)
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- // Farm Toggle
local farmToggle = makeButton("▶  Start Auto Farm", Color3.fromRGB(80, 220, 120), function() end)
farmToggle.MouseButton1Click:Connect(function()
    if farmActive then
        stopFarm()
        farmToggle.Text = "▶  Start Auto Farm"
        farmToggle.TextColor3 = Color3.fromRGB(80, 220, 120)
    else
        startFarm()
        farmToggle.Text = "⏹  Stop Auto Farm"
        farmToggle.TextColor3 = Color3.fromRGB(220, 80, 80)
    end
end)

makeButton("🚀  Load Hoho Hub", Color3.fromRGB(160, 80, 255), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
end)

makeButton("🔄  Auto Rejoin", Color3.fromRGB(80, 180, 255), function()
    lp.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            TeleportService:Teleport(game.PlaceId)
        end
    end)
end)

makeButton("👥  Goto Nearest Player", Color3.fromRGB(80, 220, 160), function()
    local char = lp.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
            break
        end
    end
end)

makeButton("🌐  Rejoin Server", Color3.fromRGB(255, 160, 60), function()
    TeleportService:Teleport(game.PlaceId)
end)

makeButton("❌  Close poHACK", Color3.fromRGB(200, 60, 60), function()
    stopFarm()
    ScreenGui:Destroy()
end)

-- // Dragging
local dragging, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMove then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- // Minimize
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ButtonContainer.Visible = not minimized
    Main.Size = minimized and UDim2.new(0, 280, 0, 36) or UDim2.new(0, 280, 0, 420)
    MinimizeBtn.Text = minimized and "□" or "–"
end)

CloseBtn.MouseButton1Click:Connect(function()
    stopFarm()
    ScreenGui:Destroy()
end)

print("[poHACK] loaded — Sea 1 universal auto farm ready")
