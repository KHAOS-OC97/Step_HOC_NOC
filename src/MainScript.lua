-- src/MainScript.lua
-- Script principal: carrega e conecta os módulos


local Config = require(script.modules.Config)
local UI = require(script.modules.UI)
local ESP = require(script.modules.ESP)
local PlayerUtils = require(script.modules.PlayerUtils)
local AntiAFK = require(script.modules.AntiAFK)
local Emotes = require(script.modules.Emotes)
local Fly = require(script.modules.Fly)
local Services = require(script.modules.Services)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Limpeza inicial
task.spawn(function() UI.Cleanup() end)

-- Criação da interface principal
task.wait(0.1)
local ScreenGui, Main, MainStroke = UI.CreateMainGUI()

-- Loop RGB Global
task.spawn(function()
    local h = 0
    while Main and Main.Parent do
        h = (h + 0.007) % 1
        Config.GlobalColor = Color3.fromHSV(h, 0.8, 1)
        pcall(function() MainStroke.Color = Config.GlobalColor end)
        task.wait(0.02)
    end
end)

-- Criação dos toggles
local function createToggle(labelText, yOffset, key)
    local container = Instance.new("Frame", Main)
    container.Size = UDim2.new(0.9, 0, 0, 28)
    container.Position = UDim2.new(0.05, 0, yOffset, 0)
    container.BackgroundTransparency = 1
    container.ZIndex = 2

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.66, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(240,240,240)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 11
    label.ZIndex = 2

    local switch = Instance.new("TextButton", container)
    switch.Size = UDim2.new(0, 36, 0, 18)
    switch.Position = UDim2.new(0.78, 0, 0.2, 0)
    switch.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    switch.Text = ""
    switch.ZIndex = 2
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0,12,0,12)
    knob.Position = UDim2.new(0,2,0.5,-6)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.ZIndex = 3
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        Config.HNkUI[key] = not Config.HNkUI[key]
        local state = Config.HNkUI[key]
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)}):Play()
        TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = state and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(150, 0, 0)}):Play()
        label.TextColor3 = state and Color3.new(1,1,1) or Color3.fromRGB(240,240,240)
        if key == "AntiAFK" then UI.NotifyElite(state and "🛡️ ANTI-AFK: ATIVO" or "⚠️ ANTI-AFK: INATIVO", state) end
    end)
end

local funcs = { {k="AntiAFK", l="ANTI-AFK MARINES"}, {k="ESP", l="ESP VISION"}, {k="God", l="GOD MODE"}, {k="Jump", l="INFINITE JUMP"} }
for i, f in ipairs(funcs) do createToggle(f.l, 0.15 + (i-1)*0.11, f.k) end

-- Botões RGB
local function createRGBButton(text, yPos)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local strk = Instance.new("UIStroke", btn)
    strk.Thickness = 1.5
    strk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    task.spawn(function()
        while btn and btn.Parent do
            pcall(function() strk.Color = Config.GlobalColor end)
            task.wait(0.02)
        end
    end)
    return btn
end


-- Botões EMOTE e FLY lado a lado
local btnRow = Instance.new("Frame", Main)
btnRow.Size = UDim2.new(0.9, 0, 0, 38)
btnRow.Position = UDim2.new(0.05, 0, 0.57, 0)
btnRow.BackgroundTransparency = 1
btnRow.ZIndex = 2

-- Botão EMOTE
local EmoteBtn = Emotes.CreateEmoteButton(btnRow, function()
    Emotes.Toggle()
end)
EmoteBtn.Position = UDim2.new(0, 0, 0, 0)
EmoteBtn.Size = UDim2.new(0.48, -2, 1, 0)

-- Botão FLY
local FlyBtn = Fly.CreateFlyButton(btnRow)
FlyBtn.Position = UDim2.new(0.52, 2, 0, 0)
FlyBtn.Size = UDim2.new(0.48, -2, 1, 0)

-- Contexto compartilhado para módulos
local ctx = {
    Config = Config,
    Services = Services,
    State = { Stored = { FlyBtn = FlyBtn, EmoteBtn = EmoteBtn } },
}
Emotes.Init(ctx)
Fly.Init(ctx)

local FovBtn = createRGBButton("DRONE VIEW (FOV): 70", 0.72)
local TpBtn = createRGBButton("🚀 EXTRAÇÃO ELITE (TP)", 0.87)

FovBtn.MouseButton1Click:Connect(function()
    local c = Config.HNkUI.FOV
    Config.HNkUI.FOV = (c == 70 and 90) or (c == 90 and 120) or 70
    FovBtn.Text = "DRONE VIEW (FOV): " .. Config.HNkUI.FOV
    pcall(function() workspace.CurrentCamera.FieldOfView = Config.HNkUI.FOV end)
end)

TpBtn.MouseButton1Click:Connect(function()
    PlayerUtils.TeleportToTarget()
end)

-- Ativa funcionalidades
ESP.Start()
PlayerUtils.InfiniteJump()
PlayerUtils.WalkSpeedGodLoop()
AntiAFK.Enable()

-- Toggle visibilidade com CTRL
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.LeftControl then Main.Visible = not Main.Visible end
end)

print("KChaos CKhaos Step v8.2 - GLASS EDITION (modularizado)")
