-- Compatibility layer: tgiann-policealert -> um-dispatch (client side)
-- Hijacks `exports['tgiann-policealert']:Alert(data)` and routes it through um-dispatch.
-- Requires `provide 'tgiann-policealert'` in fxmanifest.

local Utils = require 'client.modules.utils'

local GetStreetAndZone = Utils.GetStreetAndZone
local GetVehicleData = Utils.GetVehicleData
local GetPlayerGender = Utils.GetPlayerGender

local function buildIcon(name)
    if type(name) ~= 'string' or name == '' then return 'fas fa-bell' end
    return name:find(' ', 1, true) and name or 'fas fa-' .. name
end

local function toCoords(c)
    if type(c) ~= 'table' and type(c) ~= 'vector3' and type(c) ~= 'vector4' then return nil end
    return vec3(c.x or c[1] or 0.0, c.y or c[2] or 0.0, c.z or c[3] or 0.0)
end

local function Alert(data)
    if type(data) ~= 'table' then return end

    local coords = toCoords(data.coords) or GetEntityCoords(cache.ped)

    local dispatchData = {
        message = data.label or 'Alert',
        codeName = 'tgiann_alert',
        code = data.code or '10-80',
        icon = buildIcon(data.icon),
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' },
        alert = {
            radius = 0,
            sprite = data.blip or 280,
            color = 1,
            scale = 1.5,
            length = 2,
            sound = data.soundName or 'Lose_1st',
            sound2 = 'GTAO_FM_Events_Soundset',
            offset = false,
            flash = false,
        },
    }

    if data.gender ~= false then
        dispatchData.gender = GetPlayerGender()
    end

    if data.vehicle and cache.vehicle then
        local vehicleData = GetVehicleData(cache.vehicle)
        if data.vehicle.label ~= false then dispatchData.vehicle = vehicleData.name end
        if data.vehicle.plate ~= false then dispatchData.plate = vehicleData.plate end
        if data.vehicle.color ~= false then dispatchData.color = vehicleData.color end
    end

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end

AddEventHandler('__cfx_export_tgiann-policealert_Alert', function(setCB)
    setCB(Alert)
end)


-- Legacy event: Tgiann-PolisBildirim:BildirimGonder
RegisterNetEvent('Tgiann-PolisBildirim:BildirimGonder', function(data)
    if type(data) ~= 'table' then return end

    local jobs = { data.jobs or 'police' }
    if data.news then jobs[#jobs + 1] = 'news' end

    Alert({
        jobs = jobs,
        label = data.name,
        code = data.code,
        blip = data.blip,
        coords = data.coords,
        vehicle = data.vehicle ~= false and {
            label = true,
            plate = data.plate ~= false,
            color = true,
        } or nil,
    })
end)


-- Legacy event: tgiann-policeAlert:alert
RegisterNetEvent('tgiann-policeAlert:alert', function(alertName, plate, alertCoord, vehicle)
    Alert({
        jobs = { 'leo' },
        label = alertName,
        coords = alertCoord,
        vehicle = vehicle ~= false and {
            label = true,
            plate = plate ~= false,
            color = true,
        } or nil,
    })
end)
