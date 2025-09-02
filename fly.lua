-- Delta-Friendly Roblox Fly Script with Mobile GUI
-- Copy and paste into Delta executor

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Wait until character loads
if not player.Character then player.CharacterAdded:Wait() end
local hrp = player.Character:WaitForChild("HumanoidRootPart")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 260)
frame.Position = UDim2.new(0.5, -110, 0.7, -130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true

-- Direction buttons
local buttons = {}
local directions = {"Forward", "Back", "Left", "Right", "Up", "Down"}

for i, dir in ipairs(directions) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.Position = UDim2.new(0, (i%2)*110, 0, math.floor((i-1)/2)*45)
    btn.Text = dir
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    buttons[dir] = btn
end

local toggleFly = Instance.new("TextButton", frame)
toggleFly.Size = UDim2.new(1, -10, 0, 40)
toggleFly.Position = UDim2.new(0,5,1,-45)
toggleFly.Text = "Toggle Fly"
toggleFly.TextScaled = true
toggleFly.BackgroundColor3 = Color3.fromRGB(255,85,0)
toggleFly.TextColor3 = Color3.fromRGB(255,255,255)

-- Fly logic
local flying = false
local speed = 50
local bodyVelocity

toggleFly.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = hrp
    else
        if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity=nil end
    end
end)

-- Direction states
local dirState = {Forward=false, Back=false, Left=false, Right=false, Up=false, Down=false}

for dir, btn in pairs(buttons) do
    btn.MouseButton1Down:Connect(function() dirState[dir]=true end)
    btn.MouseButton1Up:Connect(function() dirState[dir]=false end)
end

runService.RenderStepped:Connect(function()
    if flying and bodyVelocity then
        local cam = workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        if dirState.Forward then move = move + cam.LookVector end
        if dirState.Back then move = move - cam.LookVector end
        if dirState.Left then move = move - cam.RightVector end
        if dirState.Right then move = move + cam.RightVector end
        if dirState.Up then move = move + Vector3.new(0,1,0) end
        if dirState.Down then move = move - Vector3.new(0,1,0) end
        if move.Magnitude > 0 then move = move.Unit end
        bodyVelocity.Velocity = move * speed
    end
end)
