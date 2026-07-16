-- Load the Aether UI Library
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v9.lua"))()

-- Instantiate UI Window
local UI = Aether.new("⚡ Aether v5 | Ninja Legends", Vector2.new(580, 420))

-- Create Tabs
local MainTab = UI:AddTab("Main")

-- State Variables
local autoSellEnabled = false
local autoSwingEnabled = false

-- Add Auto Sell Toggle
MainTab:AddToggle("Auto Sell", false, function(state)
    autoSellEnabled = state
    print("Auto Sell status changed to:", state)
end)

-- Add Auto Swing Toggle
MainTab:AddToggle("Auto Swing", false, function(state)
    autoSwingEnabled = state
    print("Auto Swing status changed to:", state)
end)

-- Find any valid sell circle currently loaded in the game
local function getActiveSellPart()
    local sellFolder = workspace:FindFirstChild("sellAreaCircles")
    if not sellFolder then return nil end

    -- Try to find the specific one you found (Circle 16)
    local target = sellFolder:FindFirstChild("sellAreaCircle16") 
    
    -- If that doesn't exist, fall back to the default main circle
    if not target then
        target = sellFolder:FindFirstChild("sellAreaCircle")
    end

    -- If still nothing, just grab the very first sell circle loaded in the folder
    if not target then
        local children = sellFolder:GetChildren()
        if #children > 0 then
            target = children[1]
        end
    end

    return target and target:FindFirstChild("circleInner")
end

-- Optimized Auto Sell Loop (No UI check needed)
task.spawn(function()
    while true do
        task.wait(0.5) -- Fires twice a second to keep network usage light but fast
        if autoSellEnabled then
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")

            if rootPart then
                local sellPart = getActiveSellPart()
                if sellPart and sellPart:FindFirstChild("TouchInterest") then
                    -- Simulate stepping on the circle
                    firetouchinterest(rootPart, sellPart, 0)
                    task.wait(0.1) -- Slightly longer wait to guarantee server registration
                    -- Simulate stepping off
                    firetouchinterest(rootPart, sellPart, 1)
                end
            end
        end
    end
end)

-- Optimized Auto Swing Loop
task.spawn(function()
    while true do
        task.wait() -- Executes as fast as the engine allows
        if autoSwingEnabled then
            local player = game:GetService("Players").LocalPlayer
            local ninjaEvent = player:FindFirstChild("ninjaEvent")
            
            if ninjaEvent then
                ninjaEvent:FireServer("swingKatana")
            end
        end
    end
end)
