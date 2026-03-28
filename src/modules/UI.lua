-- src/modules/UI.lua
-- Responsável pela interface gráfica, notificações e botões

local Config = require(script.Parent.Config)
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local UI = {}

function UI.Cleanup()
    if CoreGui:FindFirstChild("HOC_NOC_ELITE_V2") then pcall(function() CoreGui.HOC_NOC_ELITE_V2:Destroy() end) end
    if CoreGui:FindFirstChild("KChaos_Notify") then pcall(function() CoreGui.KChaos_Notify:Destroy() end) end
end

function UI.NotifyElite(msg, state)
    if CoreGui:FindFirstChild("KChaos_Notify") then pcall(function() CoreGui.KChaos_Notify:Destroy() end) end
    local g = Instance.new("ScreenGui", CoreGui)
    g.Name = "KChaos_Notify"
    local f = Instance.new("Frame", g)
    f.Size = UDim2.new(0, 220, 0, 45)
    f.Position = UDim2.new(0.5, -110, 0.15, 0)
    f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local sk = Instance.new("UIStroke", f)
    sk.Thickness = 2
    task.spawn(function() while f.Parent do pcall(function() sk.Color = Config.GlobalColor end) task.wait(0.02) end end)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.Text = msg
    t.TextColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 60, 60)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    task.delay(3, function() pcall(function() g:Destroy() end) end)
end

function UI.CreateMainGUI()
    -- Criação do GUI principal (sem lógica de toggles/botões)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "HOC_NOC_ELITE_V2"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 210, 0, 260)
    Main.Position = UDim2.new(1, -470, 0, 10)
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BackgroundTransparency = 0.4
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local BackgroundImg = Instance.new("ImageLabel", Main)
    BackgroundImg.Name = "EliteBackground"
    BackgroundImg.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImg.Position = UDim2.new(0, 0, 0, 0)
    BackgroundImg.BackgroundTransparency = 1
    BackgroundImg.Image = "rbxassetid://138676643657782"
    BackgroundImg.ScaleType = Enum.ScaleType.Crop
    BackgroundImg.ImageTransparency = 0.3
    BackgroundImg.ZIndex = 0
    Instance.new("UICorner", BackgroundImg).CornerRadius = UDim.new(0, 8)

    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Thickness = 2
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundTransparency = 1
    Title.Text = "🇧🇷 KChaos CKhaos Step Dance 🇺🇸"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextColor3 = Color3.new(1,1,1)
    Title.ZIndex = 2

    return ScreenGui, Main, MainStroke
end

return UI
