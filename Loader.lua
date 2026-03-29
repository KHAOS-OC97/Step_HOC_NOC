-- HOC NOC ELITE - Loader.lua (OneFile)
-- Pronto para uso via loadstring(game:HttpGet("https://raw.githubusercontent.com/main2/Loader.lua", true))()

local GITHUB_RAW_BASE = 
    "https://raw.githubusercontent.com/KHAOS-OC97/Step_HOC_NOC/main/"
local CACHE_BUSTER = tostring(os.time())

local CACHE_BUSTER = tostring(os.time())


-- CONFIG
local Config = {}
Config.GlobalColor = Color3.new(1, 1, 1)
Config.TargetUsers = {"Henry_OC97", "Marine_A79"}
Config.HNkUI = {
    AntiAFK = false,
    ESP = false,
    God = false,
    Jump = false,
    WalkSpeed = 16,
    FOV = 70
}

-- SERVICES
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    CoreGui = game:GetService("CoreGui"),
}

-- UI
local UI = {}
function UI.Cleanup()
    if Services.CoreGui:FindFirstChild("HOC_NOC_ELITE_V2") then pcall(function() Services.CoreGui.HOC_NOC_ELITE_V2:Destroy() end) end
    if Services.CoreGui:FindFirstChild("KChaos_Notify") then pcall(function() Services.CoreGui.KChaos_Notify:Destroy() end) end
end
function UI.NotifyElite(msg, state)
    if Services.CoreGui:FindFirstChild("KChaos_Notify") then pcall(function() Services.CoreGui.KChaos_Notify:Destroy() end) end
    local g = Instance.new("ScreenGui", Services.CoreGui)
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
    local ScreenGui = Instance.new("ScreenGui", Services.CoreGui)
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

-- (Cole aqui o restante dos módulos: ESP, PlayerUtils, AntiAFK, Emotes, Fly)
-- (Cole aqui o corpo do MainScript.lua, substituindo requires por as variáveis locais)

-- Pronto para uso via:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/main2/Loader.lua", true))()
