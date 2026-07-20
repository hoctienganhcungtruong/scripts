local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Clean up any existing UI with the same name
if CoreGui:FindFirstChild("XYZ_Tracker_UI") then
    CoreGui.XYZ_Tracker_UI:Destroy()
end

-- ScreenGui Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XYZ_Tracker_UI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Main Container Frame
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 200, 0, 70)
frame.Position = UDim2.new(0.01, 0, 0.01, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- Allows you to drag the UI around
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 70)
stroke.Thickness = 1
stroke.Parent = frame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 4)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "REAL-TIME COORDINATES"
title.TextColor3 = Color3.fromRGB(160, 160, 175)
title.TextSize = 10
title.Parent = frame

-- Coordinates Text Label
local coordsText = Instance.new("TextLabel")
coordsText.Name = "CoordsLabel"
coordsText.Size = UDim2.new(1, -10, 0, 36)
coordsText.Position = UDim2.new(0, 5, 0, 26)
coordsText.BackgroundTransparency = 1
coordsText.Font = Enum.Font.RobotoMono
coordsText.Text = "X: 0.00 | Y: 0.00 | Z: 0.00"
coordsText.TextColor3 = Color3.fromRGB(255, 255, 255)
coordsText.TextSize = 13
coordsText.Parent = frame

-- Real-Time Render Loop
RunService.RenderStepped:Connect(function()
    local localPlayer = Players.LocalPlayer
    if localPlayer and localPlayer.Character then
        local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            coordsText.Text = string.format("X: %.2f  Y: %.2f  Z: %.2f", pos.X, pos.Y, pos.Z)
        else
            coordsText.Text = "Waiting for character..."
        end
    else
        coordsText.Text = "No LocalPlayer found"
    end
end)

print("[XYZ Tracker]: Successfully injected into CoreGui!")
