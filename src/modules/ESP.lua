-- src/modules/ESP.lua
-- Lógica de ESP (BillboardGui nos jogadores)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Config = require(script.Parent.Config)

local ESP = {}
local espTable = {}
local hue = 0

function ESP.Cleanup()
    for p, data in pairs(espTable) do
        if data and data.billboard then pcall(function() data.billboard:Destroy() end) end
    end
    espTable = {}
end

function ESP.Start()
    RunService.Heartbeat:Connect(function()
        hue = (hue + 0.005) % 1
        local rgbColor = Color3.fromHSV(hue, 1, 1)
        if not Config.HNkUI.ESP then
            ESP.Cleanup()
            return
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local existing = espTable[p]
                if not existing or not existing.billboard or not existing.billboard.Parent then
                    local bill = Instance.new("BillboardGui", head)
                    bill.Name = "HNkESP"
                    bill.Size = UDim2.new(0, 120, 0, 50)
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    bill.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bill)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = p.DisplayName
                    txt.Font = Enum.Font.GothamBlack
                    txt.TextScaled = true
                    txt.TextStrokeTransparency = 0
                    txt.TextColor3 = rgbColor
                    espTable[p] = { billboard = bill, text = txt }
                else
                    pcall(function() existing.text.TextColor3 = rgbColor end)
                    pcall(function() if existing.text.Text ~= p.DisplayName then existing.text.Text = p.DisplayName end end)
                end
            else
                if espTable[p] and espTable[p].billboard then pcall(function() espTable[p].billboard:Destroy() end) end
                espTable[p] = nil
            end
        end
    end)
    Players.PlayerRemoving:Connect(function(plr)
        if espTable[plr] and espTable[plr].billboard then pcall(function() espTable[plr].billboard:Destroy() end) end
        espTable[plr] = nil
    end)
end

return ESP
