-- src/modules/AntiAFK.lua
-- Lógica de Anti-AFK

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local Config = require(script.Parent.Config)

local AntiAFK = {}

function AntiAFK.Enable()
    local player = Players.LocalPlayer
    player.Idled:Connect(function()
        if Config.HNkUI.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(0.5)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end)
end

return AntiAFK
