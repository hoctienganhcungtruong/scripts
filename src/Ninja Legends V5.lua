-- Load the Aether v9 UI Library
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v10.lua"))()

-- Instantiate UI Window
local UI = Aether.new(
    "⚡ Aether v10 | Ninja Legends", 
    Vector2.new(580, 420), 
    Vector2.new(450, 250)
)

-- Create Tabs
local MainTab = UI:AddTab("Main")
local SettingsTab = UI:AddTab("Settings")

-- State Variables
local autoSellEnabled = false
local autoSwingEnabled = false
local autoBuySwordsEnabled = false
local autoBuyRanksEnabled = false
local autoBuyCrystalsEnabled = false
local selectedCrystal = "Blue Crystal"

local removeEffectsEnabled = false
local muteSoundsEnabled = false
local removeTexturesEnabled = false

-- Keep track of original textures so we can restore them if toggled off
local textureCache = {}

-- Island Data Table (Order-dependent)
local islandData = {
    { name = "Enchanted Island", pos = Vector3.new(73, 765, -135) },
    { name = "Astral Island", pos = Vector3.new(217, 2013, 263) },
    { name = "Mystical Island", pos = Vector3.new(141, 4047, 65) },
    { name = "Space Island", pos = Vector3.new(144, 5656, 82) },
    { name = "Tundra Island", pos = Vector3.new(148, 9284, 87) },
    { name = "Eternal Island", pos = Vector3.new(149, 13679, 92) },
    { name = "Sandstorm", pos = Vector3.new(146, 17686, 88) },
    { name = "Thunderstorm", pos = Vector3.new(147, 24069, 85) },
    { name = "Ancient Inferno Island", pos = Vector3.new(148, 28256, 83) },
    { name = "Midnight Shadow Island", pos = Vector3.new(149, 33206, 84) },
    { name = "Mythical Souls Island", pos = Vector3.new(148, 39317, 87) },
    { name = "Winter Wonder Island", pos = Vector3.new(147, 46010, 82) },
    { name = "Golden Master Island", pos = Vector3.new(147, 52607, 81) },
    { name = "Dragon Legend Island", pos = Vector3.new(143, 59594, 83) },
    { name = "Cybernetic Legends Island", pos = Vector3.new(147, 66668, 86) },
    { name = "Skystorm Ultraus Island", pos = Vector3.new(148, 70270, 85) },
    { name = "Chaos Legends Island", pos = Vector3.new(146, 74442, 81) },
    { name = "Soul Fusion Island", pos = Vector3.new(149, 79746, 85) },
    { name = "Dark Elements Island", pos = Vector3.new(148, 83198, 85) },
    { name = "Inner Peace Island", pos = Vector3.new(148, 87050, 85) },
    { name = "Blazing Vortex Island", pos = Vector3.new(148, 91245, 85) }
}

-- Safe Teleport Helper Function
local function teleportTo(vectorPosition)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(vectorPosition)
    end
end

-- ================= MAIN TAB CONTROLS =================

-- 1. Automation Toggles
MainTab:AddToggle("Auto Sell", false, function(state)
    autoSellEnabled = state
end)

MainTab:AddToggle("Auto Swing", false, function(state)
    autoSwingEnabled = state
end)

MainTab:AddLabel("Auto Purchasers", "h2")

MainTab:AddToggle("Auto Buy Swords", false, function(state)
    autoBuySwordsEnabled = state
end)

MainTab:AddToggle("Auto Buy Ranks", false, function(state)
    autoBuyRanksEnabled = state
end)

MainTab:AddInput("Crystal/Bell Name", "Blue Crystal", function(text)
    selectedCrystal = text
end)

MainTab:AddToggle("Auto Buy Crystals", false, function(state)
    autoBuyCrystalsEnabled = state
end)

-- 2. Teleports Section
MainTab:AddLabel("Islands & Teleports", "h2")

-- Unlock All Islands Button
MainTab:AddButton("Unlock All Islands", function()
    task.spawn(function()
        for _, island in ipairs(islandData) do
            teleportTo(island.pos)
            task.wait(0.5) -- Brief delay to allow island unlock region detection
        end
    end)
end)

-- Collapsible Individual Island Teleports
local TeleportGroup = MainTab:AddCollapsible("Islands Teleport")
for _, island in ipairs(islandData) do
    TeleportGroup:AddButton("TP to " .. island.name, function()
        teleportTo(island.pos)
    end)
end

-- ================= SETTINGS TAB (OPTIMIZATION) =================
SettingsTab:AddLabel("Performance Boosters", "h1")

-- 1. Remove Effects (Trails, Particles)
SettingsTab:AddToggle("Remove Effects", false, function(state)
    removeEffectsEnabled = state
    if state then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
                obj.Enabled = false
            end
        end
    end
end)

-- 2. Mute Sounds
SettingsTab:AddToggle("Mute Game Sounds", false, function(state)
    muteSoundsEnabled = state
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("Sound") then
            obj.Volume = state and 0 or (obj:FindFirstChild("OriginalVolume") and obj.OriginalVolume.Value or obj.Volume)
        end
    end
end)

-- 3. Remove Textures (Plastic Graphics)
SettingsTab:AddToggle("Remove Textures", false, function(state)
    removeTexturesEnabled = state
    if state then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") then
                textureCache[obj] = obj.Parent
                obj.Parent = nil
            end
        end
    else
        for obj, parent in pairs(textureCache) do
            if obj and parent then
                obj.Parent = parent
            end
        end
        table.clear(textureCache)
    end
end)

-- 4. Disable 3D Rendering (Black Screen CPU Saver)
SettingsTab:AddToggle("Disable 3D Rendering", false, function(state)
    game:GetService("RunService"):Set3DRenderingEnabled(not state)
end)

-- ================= HELPER FUNCTIONS =================

local function getActiveSellPart()
    local sellFolder = workspace:FindFirstChild("sellAreaCircles")
    if not sellFolder then return nil end

    local target = sellFolder:FindFirstChild("sellAreaCircle16") 
    if not target then
        target = sellFolder:FindFirstChild("sellAreaCircle")
    end
    if not target then
        local children = sellFolder:GetChildren()
        if #children > 0 then
            target = children[1]
        end
    end

    return target and target:FindFirstChild("circleInner")
end

-- ================= BACKGROUND LOOPS =================

-- 1. Auto Sell Loop
task.spawn(function()
    while true do
        task.wait(0.5)
        if autoSellEnabled then
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")

            if rootPart then
                local sellPart = getActiveSellPart()
                if sellPart and sellPart:FindFirstChild("TouchInterest") then
                    firetouchinterest(rootPart, sellPart, 0)
                    task.wait(0.1)
                    firetouchinterest(rootPart, sellPart, 1)
                end
            end
        end
    end
end)

-- 2. Auto Swing Loop
task.spawn(function()
    while true do
        task.wait() 
        if autoSwingEnabled then
            local player = game:GetService("Players").LocalPlayer
            local ninjaEvent = player:FindFirstChild("ninjaEvent")
            
            if ninjaEvent then
                ninjaEvent:FireServer("swingKatana")
            end
        end
    end
end)

-- 3. Auto Buy Swords Loop
task.spawn(function()
    while true do
        task.wait(0.8)
        if autoBuySwordsEnabled then
            local player = game:GetService("Players").LocalPlayer
            local ninjaEvent = player:FindFirstChild("ninjaEvent")
            
            if ninjaEvent then
                ninjaEvent:FireServer("buyAllSwords", "Blades")
            end
        end
    end
end)

-- 4. Auto Buy Ranks Loop
task.spawn(function()
    while true do
        task.wait(1.0)
        if autoBuyRanksEnabled then
            local player = game:GetService("Players").LocalPlayer
            local ninjaEvent = player:FindFirstChild("ninjaEvent")
            
            if ninjaEvent then
                ninjaEvent:FireServer("buyNextRank")
            end
        end
    end
end)

-- 5. Auto Buy Crystals / Bells Loop
task.spawn(function()
    while true do
        task.wait(1.2)
        if autoBuyCrystalsEnabled then
            local player = game:GetService("Players").LocalPlayer
            local ninjaEvent = player:FindFirstChild("ninjaEvent")
            
            if ninjaEvent then
                ninjaEvent:FireServer("openCrystal", selectedCrystal, "single")
            end
        end
    end
end)

-- ================= DYNAMIC RUNTIME LISTENERS =================

workspace.DescendantAdded:Connect(function(descendant)
    task.wait()
    
    if removeEffectsEnabled then
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Fire") or descendant:IsA("Smoke") then
            descendant.Enabled = false
        end
    end
    
    if removeTexturesEnabled then
        if descendant:IsA("Texture") or descendant:IsA("Decal") then
            descendant.Parent = nil
        end
    end
end)

game.DescendantAdded:Connect(function(descendant)
    if muteSoundsEnabled and descendant:IsA("Sound") then
        task.wait()
        local origVal = Instance.new("DoubleConstrainedValue")
        origVal.Name = "OriginalVolume"
        origVal.Value = descendant.Volume
        origVal.Parent = descendant
        
        descendant.Volume = 0
    end
end)
