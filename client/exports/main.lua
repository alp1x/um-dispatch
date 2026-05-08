local Utils = require 'client.modules.utils'

local GetStreetAndZone = Utils.GetStreetAndZone
local GetPlayerGender = Utils.GetPlayerGender
local GetWeaponName = Utils.GetWeaponName

local function Shooting()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('shooting'),
        codeName = 'shooting',
        code = '10-11',
        icon = 'fas fa-gun',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        gender = GetPlayerGender(),
        weapon = GetWeaponName(),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('Shooting', Shooting)



local function Fight()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('melee'),
        codeName = 'fight',
        code = '10-10',
        icon = 'fas fa-hand-fist',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('Fight', Fight)
