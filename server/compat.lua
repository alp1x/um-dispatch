-- Compatibility layer: tgiann-policealert -> um-dispatch (server side)
-- Hijacks `exports['tgiann-policealert']:Alert(src, data)` and `:SendCustomAlert(...)`.
-- Requires `provide 'tgiann-policealert'` in fxmanifest.

local function buildIcon(name)
    if type(name) ~= 'string' or name == '' then return 'fas fa-bell' end
    return name:find(' ', 1, true) and name or 'fas fa-' .. name
end

local function toCoords(c)
    if type(c) ~= 'table' and type(c) ~= 'vector3' and type(c) ~= 'vector4' then return nil end
    return vec3(c.x or c[1] or 0.0, c.y or c[2] or 0.0, c.z or c[3] or 0.0)
end

local function buildAlertBlock(data)
    return {
        radius = 0,
        sprite = data.blip or 280,
        color = 1,
        scale = 1.5,
        length = 2,
        sound = data.soundName or 'Lose_1st',
        sound2 = 'GTAO_FM_Events_Soundset',
        offset = false,
        flash = false,
    }
end

local function fillFromPlayer(dispatchData, src)
    if not src or src <= 0 then return end

    local player = Bridge.GetPlayer(src)
    if not player then return end

    local pdata = player.PlayerData
    if pdata.metadata then
        dispatchData.callsign = pdata.metadata.callsign
    end
    if pdata.charinfo then
        dispatchData.name = (pdata.charinfo.firstname or '') .. ' ' .. (pdata.charinfo.lastname or '')
    end
end

local function buildStreet(location)
    if type(location) ~= 'table' then return '' end

    local street = location.street or ''
    local avenue = location.avenue or ''

    if street ~= '' and avenue ~= '' then return street .. ', ' .. avenue end
    if street ~= '' then return street end
    return avenue
end

local function Alert(src, data)
    if type(data) ~= 'table' then return end

    local coords = toCoords(data.coords)
    if not coords and src then
        local ped = GetPlayerPed(src)
        if ped > 0 then coords = GetEntityCoords(ped) end
    end

    local dispatchData = {
        message = data.label or 'Alert',
        codeName = 'tgiann_alert',
        code = data.code or '10-80',
        icon = buildIcon(data.icon),
        priority = 2,
        coords = coords or vec3(0.0, 0.0, 0.0),
        street = '',
        alertTime = nil,
        jobs = data.jobs or { 'leo' },
        alert = buildAlertBlock(data),
    }

    fillFromPlayer(dispatchData, src)

    TriggerEvent('ps-dispatch:server:notify', dispatchData)
end

local function SendCustomAlert(alertData, jobs)
    if type(alertData) ~= 'table' then return end

    local dispatchData = {
        message = alertData.label or 'Alert',
        codeName = 'tgiann_custom',
        code = alertData.code or '10-80',
        icon = buildIcon(alertData.icon),
        priority = 2,
        coords = toCoords(alertData.coords) or vec3(0.0, 0.0, 0.0),
        street = '',
        alertTime = alertData.duration,
        jobs = jobs or { 'leo' },
        alert = buildAlertBlock(alertData),
    }

    local info = alertData.information
    if type(info) == 'table' then
        dispatchData.street = buildStreet(info.location)

        if type(info.vehicle) == 'table' then
            dispatchData.vehicle = info.vehicle.label
            dispatchData.plate = info.vehicle.plate
            if type(info.vehicle.color) == 'table' then
                dispatchData.color = info.vehicle.color.text
            end
        end

        if info.gender then
            dispatchData.gender = (info.gender == 'm' or info.gender == 'male') and 'male' or 'female'
        end
    end

    if alertData.src then
        fillFromPlayer(dispatchData, alertData.src)
    end

    TriggerEvent('ps-dispatch:server:notify', dispatchData)
end

AddEventHandler('__cfx_export_tgiann-policealert_Alert', function(setCB)
    setCB(Alert)
end)

AddEventHandler('__cfx_export_tgiann-policealert_SendCustomAlert', function(setCB)
    setCB(SendCustomAlert)
end)
