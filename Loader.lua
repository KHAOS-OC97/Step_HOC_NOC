-- HOC NOC ELITE - Loader.lua (OneFile)
-- Pronto para uso via loadstring(game:HttpGet("https://raw.githubusercontent.com/main2/Loader.lua", true))()

-- ONE FILE: Todos os módulos embutidos

-- Config
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

-- Services
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

-- ESP
local ESP = {}
do
    local Players = Services.Players
    local RunService = Services.RunService
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
end

-- PlayerUtils
local PlayerUtils = {}
do
    local Players = Services.Players
    local UserInputService = Services.UserInputService
    local RunService = Services.RunService
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
end

-- AntiAFK
local AntiAFK = {}
do
    local Players = Services.Players
    local VirtualUser = game:GetService("VirtualUser")
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
end

-- Emotes
local Emotes = {}
do
    local emoteGui
    local initialized = false
    function Emotes.Toggle()
        if emoteGui then
            emoteGui.Enabled = not emoteGui.Enabled
        end
    end
    function Emotes.IsOpen()
        return emoteGui and emoteGui.Enabled or false
    end
    function Emotes.CreateEmoteButton(parent, onClick)
        local TweenService = Services.TweenService
        local btn = Instance.new("TextButton")
        btn.Name = "EmoteButton"
        btn.Size = UDim2.new(0, 120, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        btn.Text = "EMOTE"
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.AutoButtonColor = true
        btn.Parent = parent
        btn.BorderSizePixel = 0
        btn.ZIndex = 2
        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 2
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 6)
        task.spawn(function()
            local h = 0
            while btn and btn.Parent do
                h = (h + 0.01) % 1
                pcall(function() stroke.Color = Color3.fromHSV(h, 0.8, 1) end)
                task.wait(0.02)
            end
        end)
        btn.MouseButton1Click:Connect(function()
            if typeof(onClick) == "function" then onClick() end
        end)
        return btn
    end
    function Emotes.Init(ctx)
        if initialized then return end
        initialized = true
        -- (restante do catálogo de emotes pode ser implementado aqui)
    end
end

-- Fly
local Fly = {}
do
    local _cfg, _svc, _state, _runtime, _contextActionService
    local ZERO = Vector3.new(0, 0, 0)
    local UP = Vector3.new(0, 1, 0)
    local TOGGLE_ACTION = "HOCNOC_ToggleFly"
    local function syncFlyButton()
        if not _state or not _state.Stored or not _state.Stored.FlyBtn then return end
        _state.Stored.FlyBtn.Text = _G_Fly and "FLY: ON" or "FLY: OFF"
    end
    local function getCharacterParts()
        local player = _svc and _svc.LocalPlayer
        local char = player and player.Character
        if not char then return nil end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return nil end
        return char, hum, root
    end
    local function setFlightState(hum, enabled)
        if not hum then return end
        pcall(function()
            hum.AutoRotate = not enabled
            hum.PlatformStand = enabled
            hum:ChangeState(enabled and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp)
        end)
    end
    local function clearFlightState()
        if not _runtime then return end
        _runtime.Keys = {}
    end
    local function getVerticalInput()
        local vertical = 0
        if _runtime.Keys[Enum.KeyCode.Space] then vertical = vertical + 1 end
        if _runtime.Keys[Enum.KeyCode.LeftShift] then vertical = vertical - 1 end
        return vertical
    end
    local function getFlightSpeed()
        local walkSpeed = tonumber(_G_WalkSpeed)
        if walkSpeed and walkSpeed > 0 then
            return walkSpeed * 2
        end
        return _cfg and _cfg.FLY_SPEED or 70
    end
    local function getMoveDirection(cameraCFrame)
        local flatLook = Vector3.new(cameraCFrame.LookVector.X, 0, cameraCFrame.LookVector.Z)
        local flatRight = Vector3.new(cameraCFrame.RightVector.X, 0, cameraCFrame.RightVector.Z)
        if flatLook.Magnitude > 0 then flatLook = flatLook.Unit end
        if flatRight.Magnitude > 0 then flatRight = flatRight.Unit end
        local direction = ZERO
        if _runtime.Keys[Enum.KeyCode.W] then direction = direction + flatLook end
        if _runtime.Keys[Enum.KeyCode.S] then direction = direction - flatLook end
        if _runtime.Keys[Enum.KeyCode.D] then direction = direction + flatRight end
        if _runtime.Keys[Enum.KeyCode.A] then direction = direction - flatRight end
        if direction.Magnitude > 0 then direction = direction.Unit end
        return direction
    end
    local function detachFlight()
        local _, hum, root = getCharacterParts()
        setFlightState(hum, false)
        _runtime.Active = false
        _runtime.TargetPosition = nil
        _runtime.HoldY = nil
        if root then
            pcall(function()
                root.AssemblyLinearVelocity = ZERO
                root.AssemblyAngularVelocity = ZERO
            end)
        end
    end
    local function updateFlight(dt)
        if not _G_Fly then return end
        local char, hum, root = getCharacterParts()
        if not char or not hum or not root then return end
        local camera = workspace.CurrentCamera
        local cameraCFrame = camera and camera.CFrame or root.CFrame
        local horizontalDirection = getMoveDirection(cameraCFrame)
        local verticalInput = getVerticalInput()
        local speed = getFlightSpeed() * math.max(dt or 0.016, 0.016)
        local targetPosition = _runtime.TargetPosition or root.Position
        local holdY = _runtime.HoldY or root.Position.Y
        local nextPosition = targetPosition + (horizontalDirection * speed)
        local facing = Vector3.new(cameraCFrame.LookVector.X, 0, cameraCFrame.LookVector.Z)
        if verticalInput ~= 0 then
            holdY = holdY + (verticalInput * speed)
        end
        nextPosition = Vector3.new(nextPosition.X, holdY, nextPosition.Z)
        if facing.Magnitude <= 0 then
            facing = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
        end
        if facing.Magnitude <= 0 then
            facing = Vector3.new(0, 0, -1)
        else
            facing = facing.Unit
        end
        setFlightState(hum, true)
        _runtime.Active = true
        _runtime.TargetPosition = nextPosition
        _runtime.HoldY = holdY
        pcall(function()
            root.AssemblyLinearVelocity = ZERO
            root.AssemblyAngularVelocity = ZERO
            char:PivotTo(CFrame.lookAt(nextPosition, nextPosition + facing, UP))
        end)
    end
    function Fly.CreateFlyButton(parent)
        local TweenService = Services.TweenService
        local btn = Instance.new("TextButton")
        btn.Name = "FlyButton"
        btn.Size = UDim2.new(0, 120, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        btn.Text = _G_Fly and "FLY: ON" or "FLY: OFF"
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.AutoButtonColor = true
        btn.Parent = parent
        btn.BorderSizePixel = 0
        btn.ZIndex = 2
        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 2
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 6)
        task.spawn(function()
            local h = 0
            while btn and btn.Parent do
                h = (h + 0.01) % 1
                pcall(function() stroke.Color = Color3.fromHSV(h, 0.8, 1) end)
                task.wait(0.02)
            end
        end)
        btn.MouseButton1Click:Connect(function()
            Fly.Toggle()
            btn.Text = _G_Fly and "FLY: ON" or "FLY: OFF"
        end)
        return btn
    end
    function Fly.Init(ctx)
        _cfg = ctx.Config
        _svc = ctx.Services
        _state = ctx.State
        _contextActionService = game:GetService("ContextActionService")
        _G.__HOC_RUNTIME = _G.__HOC_RUNTIME or {}
        _G.__HOC_RUNTIME.Fly = _G.__HOC_RUNTIME.Fly or {
            HeartbeatConn = nil,
            InputBeganConn = nil,
            InputEndedConn = nil,
            CharConn = nil,
            ToggleBound = false,
            Keys = {},
            Active = false,
            TargetPosition = nil,
            HoldY = nil,
        }
        _runtime = _G.__HOC_RUNTIME.Fly
        if _runtime.HeartbeatConn then pcall(function() _runtime.HeartbeatConn:Disconnect() end) end
        if _runtime.InputBeganConn then pcall(function() _runtime.InputBeganConn:Disconnect() end) end
        if _runtime.InputEndedConn then pcall(function() _runtime.InputEndedConn:Disconnect() end) end
        if _runtime.CharConn then pcall(function() _runtime.CharConn:Disconnect() end) end
        if _runtime.ToggleBound and _contextActionService then
            pcall(function() _contextActionService:UnbindAction(TOGGLE_ACTION) end)
            _runtime.ToggleBound = false
        end
        clearFlightState()
        syncFlyButton()
        if _contextActionService then
            pcall(function()
                _contextActionService:BindActionAtPriority(
                    TOGGLE_ACTION,
                    function(_, inputState)
                        if inputState ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end
                        if _svc.UserInputService:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
                        Fly.Toggle()
                        syncFlyButton()
                        return Enum.ContextActionResult.Sink
                    end,
                    false,
                    Enum.ContextActionPriority.High.Value,
                    Enum.KeyCode.F
                )
                _runtime.ToggleBound = true
            end)
        end
        _runtime.InputBeganConn = _svc.UserInputService.InputBegan:Connect(function(input, processed)
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F then
                return
            end
            if processed or _svc.UserInputService:GetFocusedTextBox() then return end
            _runtime.Keys[input.KeyCode] = true
        end)
        _runtime.InputEndedConn = _svc.UserInputService.InputEnded:Connect(function(input)
            _runtime.Keys[input.KeyCode] = nil
        end)
        _runtime.HeartbeatConn = _svc.RunService.Heartbeat:Connect(function(dt)
            if not _G_Running then
                if _G_Fly then
                    _G_Fly = false
                    clearFlightState()
                    detachFlight()
                    syncFlyButton()
                end
                return
            end
            if _G_Fly then
                updateFlight(dt)
            elseif _runtime.Active then
                detachFlight()
            end
        end)
        _runtime.CharConn = _svc.LocalPlayer.CharacterAdded:Connect(function()
            _runtime.Active = false
            _runtime.TargetPosition = nil
            _runtime.HoldY = nil
            clearFlightState()
            if _G_Fly then
                task.delay(0.15, function()
                    if _G_Fly and _G_Running then
                        updateFlight(0.016)
                    end
                end)
            end
        end)
        if _G_Fly then
            task.defer(function()
                updateFlight(0.016)
            end)
        end
    end
    function Fly.Toggle()
        _G_Fly = not _G_Fly
        clearFlightState()
        syncFlyButton()
        if _G_Fly then
            local _, _, root = getCharacterParts()
            _runtime.TargetPosition = root and root.Position or nil
            _runtime.HoldY = root and root.Position.Y or nil
            updateFlight(0.016)
        else
            detachFlight()
        end
        return _G_Fly
    end
    function Fly.IsFlying()
        return _G_Fly == true
    end
end

-- MAIN SCRIPT (adaptado para one file)
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local RunService = Services.RunService

task.spawn(function() UI.Cleanup() end)
task.wait(0.1)
local ScreenGui, Main, MainStroke = UI.CreateMainGUI()

task.spawn(function()
    local h = 0
    while Main and Main.Parent do
        h = (h + 0.007) % 1
        Config.GlobalColor = Color3.fromHSV(h, 0.8, 1)
        pcall(function() MainStroke.Color = Config.GlobalColor end)
        task.wait(0.02)
    end
end)

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

local btnRow = Instance.new("Frame", Main)
btnRow.Size = UDim2.new(0.9, 0, 0, 38)
btnRow.Position = UDim2.new(0.05, 0, 0.57, 0)
btnRow.BackgroundTransparency = 1
btnRow.ZIndex = 2
local EmoteBtn = Emotes.CreateEmoteButton(btnRow, function()
    Emotes.Toggle()
end)
EmoteBtn.Position = UDim2.new(0, 0, 0, 0)
EmoteBtn.Size = UDim2.new(0.48, -2, 1, 0)
local FlyBtn = Fly.CreateFlyButton(btnRow)
FlyBtn.Position = UDim2.new(0.52, 2, 0, 0)
FlyBtn.Size = UDim2.new(0.48, -2, 1, 0)

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

ESP.Start()
PlayerUtils.InfiniteJump()
PlayerUtils.WalkSpeedGodLoop()
AntiAFK.Enable()

UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.LeftControl then Main.Visible = not Main.Visible end
end)

print("KChaos CKhaos Step v8.2 - GLASS EDITION (one file)")
