-- src/modules/PlayerUtils.lua
-- Funções utilitárias do jogador: WalkSpeed, GodMode, Infinite Jump, Teleporte

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Config = require(script.Parent.Config)
local UI = require(script.Parent.UI)

local PlayerUtils = {}
local player = Players.LocalPlayer

function PlayerUtils.InfiniteJump()
    UserInputService.JumpRequest:Connect(function()
        if not Config.HNkUI.Jump then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
    end)
end

function PlayerUtils.WalkSpeedGodLoop()
    RunService.Heartbeat:Connect(function()
        pcall(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local hum = player.Character:FindFirstChild("Humanoid")
                hum.WalkSpeed = Config.HNkUI.WalkSpeed or 16
                if Config.HNkUI.God then
                    hum.Health = hum.MaxHealth or 100
                end
            end
        end)
    end)
end

function PlayerUtils.TeleportToTarget()
    local found = false
    for _, p in pairs(Players:GetPlayers()) do
        if table.find(Config.TargetUsers, p.Name) and p ~= player then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function() player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end)
                UI.NotifyElite("LINK ESTABELECIDO: " .. p.Name, true)
                found = true
                break
            end
        end
    end
    if not found then UI.NotifyElite("ALIADO NÃO ENCONTRADO", false) end
end

return PlayerUtils
