-- src/modules/Config.lua
-- Configurações globais e variáveis compartilhadas

local Config = {}

Config.GlobalColor = Color3.new(1, 1, 1)
Config.TargetUsers = {"Henry_OC97", "Marine_A79"}
Config.HNkUI = {
    AntiAFK = false,
    ESP = false,
    God = false,
    Jump = false,        -- Infinite Jump OFF by default
    WalkSpeed = 16,
    FOV = 70
}

return Config
