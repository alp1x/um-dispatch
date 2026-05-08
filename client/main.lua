local Config = require 'shared.config'
local Blips = require 'shared.blips'
local Utils = require 'client.modules.utils'
local DispatchBlips = require 'client.modules.blips'
local PhoneCall = require 'client.modules.phonecall'

local toggleUI = Utils.toggleUI
local IsOnDuty = Utils.IsOnDuty
local GetStreetAndZone = Utils.GetStreetAndZone
local AddDispatchBlip = DispatchBlips.AddDispatchBlip

PlayerData = {}

alertsDisabled = false
local waypointCooldown = false
local activeAlertExpire = 0
local RespondToDispatch, OpenDispatchMenu = nil, nil

local lastEmergencyTime = 0
local emergencyJobs = {
    ['911'] = { 'leo' },
    ['311'] = { 'ems' },
}


---@param data table -- An array of jobs to check against
---@return boolean
local function isJobValid(data)
    if not PlayerData.job then return false end
    if type(data) ~= 'table' then return false end
    return lib.table.contains(data, PlayerData.job.type)
end

local function openMenu()
    if not lib.table.contains(Config.Jobs, PlayerData.job.type) then return end
    local calls = lib.callback.await('ps-dispatch:callback:getCalls', false)

    if #calls == 0 then
        lib.notify({ description = locale('no_calls'), position = 'top', type = 'error' })
        return
    end

    SendNUIMessage({ action = 'setDispatchs', data = calls })
    toggleUI(true)
end

local function setWaypoint()
    if not IsOnDuty() then return end

    local data = lib.callback.await('ps-dispatch:callback:getLatestDispatch', false)
    if not data then return end

    if data.alertTime == nil then data.alertTime = Config.AlertTime end
    if data.time < GetGameTimer() * 1000 then return end
    if waypointCooldown or not lib.table.contains(data.jobs, PlayerData.job.type) then return end

    SetNewWaypoint(data.coords.x, data.coords.y)
    TriggerServerEvent('ps-dispatch:server:attach', data.id)
    lib.notify({ description = locale('waypoint_set'), position = 'top', type = 'success' })

    waypointCooldown = true
    SetTimeout(data.alertTime * 1000, function()
        waypointCooldown = false
    end)
end

local function setupDispatch()
    local playerInfo = Bridge.GetPlayerData()
    if not playerInfo or not playerInfo.job then return end

    if not lib.table.contains(Config.Jobs, playerInfo.job.type) then return end

    PlayerData = {
        charinfo = {
            firstname = playerInfo.charinfo.firstname,
            lastname = playerInfo.charinfo.lastname,
        },
        metadata = {
            callsign = playerInfo.metadata.callsign,
        },
        citizenid = playerInfo.citizenid,
        job = {
            type = playerInfo.job.type,
            name = playerInfo.job.name,
            label = playerInfo.job.label,
        },
    }

    Wait(1000)

    SendNUIMessage({
        action = 'setupUI',
        data = {
            locales = lib.getLocales(),
            player = PlayerData,
            keybind = Config.RespondKeybind,
            maxCallList = Config.MaxCallList,
            shortCalls = Config.ShortCalls,
        }
    })

    -- Keybinds
    RespondToDispatch = lib.addKeybind({
        name = 'RespondToDispatch',
        description = 'Set waypoint to last call location',
        defaultKey = Config.RespondKeybind,
        onPressed = setWaypoint,
    })

    OpenDispatchMenu = lib.addKeybind({
        name = 'OpenDispatchMenu',
        description = 'Open Dispatch Menu',
        defaultKey = Config.OpenDispatchMenu,
        onPressed = openMenu,
    })
end



-- Bridge lifecycle
Bridge.OnPlayerLoaded(function()
    setupDispatch()
end)

Bridge.OnJobUpdate(setupDispatch)


-- Events
RegisterNetEvent('ps-dispatch:client:notify', function(data)
    if GetInvokingResource() then return end
    if alertsDisabled then return end
    if not isJobValid(data.jobs) then return end
    if not IsOnDuty() then return end

    if data.alertTime == nil then data.alertTime = Config.AlertTime end
    local timer = data.alertTime * 1000

    SendNUIMessage({
        action = 'newCall',
        data = { data = data, timer = timer },
    })

    AddDispatchBlip(data, Blips[data.codeName] or data.alert)

    if not RespondToDispatch or not OpenDispatchMenu then return end

    RespondToDispatch:disable(false)
    OpenDispatchMenu:disable(true)

    local expireAt = GetGameTimer() + timer
    activeAlertExpire = expireAt

    SetTimeout(timer, function()
        if activeAlertExpire ~= expireAt then return end
        activeAlertExpire = 0
        OpenDispatchMenu:disable(false)
        RespondToDispatch:disable(true)
    end)
end)

RegisterNetEvent('ps-dispatch:client:sendCode', function(codeData)
    if GetInvokingResource() then return end
    if type(codeData) ~= 'table' then return end
    if not PlayerData.job or PlayerData.job.type ~= 'leo' then return end

    local coords = GetEntityCoords(cache.ped)
    local dispatchData = {
        message = codeData.message or 'Code',
        codeName = 'officercode',
        code = codeData.code or 'Code',
        icon = codeData.icon or 'fas fa-bell',
        priority = codeData.priority or 1,
        coords = coords,
        callsign = PlayerData.metadata and PlayerData.metadata.callsign or nil,
        name = PlayerData.charinfo and (PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname) or nil,
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' },
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end)



---@param data string -- Message
---@param type string -- What type of emergency ('911' | '311')
---@param anonymous boolean
RegisterNetEvent('ps-dispatch:client:sendEmergencyMsg', function(data, type, anonymous)
    if GetInvokingResource() then return end
    local now = GetGameTimer()

    if now - lastEmergencyTime < Config.AlertCommandCooldown * 1000 then
        Bridge.Notify('Command on cooldown', 'error', 5000)
        return
    end

    lastEmergencyTime = now
    PhoneCall(data, anonymous, emergencyJobs[type], type)
end)


AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    setupDispatch()
end)
