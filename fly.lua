
-- Roblox Fly Script with GUI
-- Place this in a LocalScript inside StarterPlayerScripts

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Create GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.9, -50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(1, -10, 1, -10)
flyButton.Position = UDim2.new(0, 5, 0, 5)
flyButton.Text = "Toggle Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextScaled = true

-- Fly logic
local flying = false
local speed = 50
local bodyVelocity

local function toggleFly()
    flying = not flying
    if flying then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = player.Character.HumanoidRootPart
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
end

flyButton.MouseButton1Click:Connect(toggleFly)

-- Update velocity while flying
runService.RenderStepped:Connect(function()
    if flying and bodyVelocity then
        local direction = Vector3.new(0,0,0)
        if uis:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0,1,0) end
        bodyVelocity.Velocity = direction.Unit * speed
    end
end)
