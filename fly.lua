
-- fly.lua
-- Simple Roblox flying script

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local speed = 50
local flying = false
local bodyVelocity

mouse.KeyDown:Connect(function(key)
    if key == "f" then  -- press F to toggle fly
        flying = not flying
        if flying then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Parent = player.Character.HumanoidRootPart
        else
            bodyVelocity:Destroy()
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if flying and bodyVelocity then
        local direction = Vector3.new()
        if mouse.KeyDown:Wait() == "w" then direction = direction + player.Character.HumanoidRootPart.CFrame.LookVector end
        if mouse.KeyDown:Wait() == "s" then direction = direction - player.Character.HumanoidRootPart.CFrame.LookVector end
        if mouse.KeyDown:Wait() == "a" then direction = direction - player.Character.HumanoidRootPart.CFrame.RightVector end
        if mouse.KeyDown:Wait() == "d" then direction = direction + player.Character.HumanoidRootPart.CFrame.RightVector end
        bodyVelocity.Velocity = direction.Unit * speed
    end
end)
