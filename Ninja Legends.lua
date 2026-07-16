-- Load the Aether UI Library
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v9.lua"))()

-- Instantiate UI Window
local UI = Aether.new("Ninja Legends - TMHub", Vector2.new(580, 420))

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

-- Optimized Auto Sell Loop
task.spawn(function()
    while true do
        task.wait(0.1)
        if autoSellEnabled then
            local player = game:GetService("Players").LocalPlayer
            local playerGui = player:FindFirstChild("PlayerGui")
            local gameGui = playerGui and playerGui:FindFirstChild("gameGui")
            local maxNinjitsuMenu = gameGui and gameGui:FindFirstChild("maxNinjitsuMenu")

            -- Only attempt to sell if the "Bag Full" popup is on screen
            if maxNinjitsuMenu and maxNinjitsuMenu.Visible then
                local character = player.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                local sellAreaCircles = workspace:FindFirstChild("sellAreaCircles")
                local sellArea = sellAreaCircles and sellAreaCircles:FindFirstChild("sellAreaCircle16")
                local circleInner = sellArea and sellArea:FindFirstChild("circleInner")

                -- Trigger interaction if everything exists
                if rootPart and circleInner and circleInner:FindFirstChild("TouchInterest") then
                    firetouchinterest(rootPart, circleInner, 0) -- Touch Start
                    task.wait(0.05)
                    firetouchinterest(rootPart, circleInner, 1) -- Touch End
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
