local Utils = require 'client.modules.utils'

local GetPlayerGender = Utils.GetPlayerGender
local GetStreetAndZone = Utils.GetStreetAndZone

local function PrisonBreak()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('prisonbreak'),
        codeName = 'prisonbreak',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('PrisonBreak', PrisonBreak)



local function DrugSale()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('drugsell'),
        codeName = 'suspicioushandoff',
        code = '10-13',
        icon = 'fas fa-tablets',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('DrugSale', DrugSale)

local function SuspiciousActivity()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('susactivity'),
        codeName = 'susactivity',
        code = '10-66',
        icon = 'fas fa-tablets',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('SuspiciousActivity', SuspiciousActivity)



local function InjuriedPerson()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('persondown'),
        codeName = 'civdown',
        code = '10-69',
        icon = 'fas fa-face-dizzy',
        priority = 1,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = 10,
        jobs = { 'ems' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('InjuriedPerson', InjuriedPerson)

local function DeceasedPerson()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('civbled'),
        codeName = 'civdead',
        code = '10-69',
        icon = 'fas fa-skull',
        priority = 1,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = 10,
        jobs = { 'ems' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('DeceasedPerson', DeceasedPerson)

local function OfficerDown()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('officerdown'),
        codeName = 'officerdown',
        code = '10-99',
        icon = 'fas fa-skull',
        priority = 1,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
        callsign = PlayerData.metadata["callsign"],
        alertTime = 10,
        jobs = { 'ems', 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('OfficerDown', OfficerDown)

local function OfficerBackup()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('officerbackup'),
        codeName = 'officerbackup',
        code = '10-32',
        icon = 'fas fa-skull',
        priority = 1,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
        callsign = PlayerData.metadata["callsign"],
        alertTime = 10,
        jobs = { 'ems', 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('OfficerBackup', OfficerBackup)

RegisterNetEvent("ps-dispatch:client:officerbackup", function() OfficerBackup() end)

local function OfficerInDistress()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('officerdistress'),
        codeName = 'officerdistress',
        code = '10-99',
        icon = 'fas fa-skull',
        priority = 1,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
        callsign = PlayerData.metadata["callsign"],
        alertTime = 10,
        jobs = { 'ems', 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('OfficerInDistress', OfficerInDistress)

local function EmsDown()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('emsdown'),
        codeName = 'emsdown',
        code = '10-99',
        icon = 'fas fa-skull',
        priority = 1,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
        callsign = PlayerData.metadata["callsign"],
        alertTime = 10,
        jobs = { 'ems', 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('EmsDown', EmsDown)


local function Explosion()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('explosion'),
        codeName = 'explosion',
        code = '10-80',
        icon = 'fas fa-fire',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('Explosion', Explosion)



--- Events
RegisterNetEvent("ps-dispatch:client:emsdown", function()
    if GetInvokingResource() then return end
    EmsDown()
end)

RegisterNetEvent("ps-dispatch:client:officerdown", function()
    if GetInvokingResource() then return end
    OfficerDown()
end)
