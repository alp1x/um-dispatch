local Config = require 'shared.config'
local TrackJobs = require 'server.trackjobs'

local calls = {}
local callsById = {}
local callCount = 0

TrackJobs.Initialize()

local function getCalls()
    return calls
end

local function buildUnit(player)
    local data = player.PlayerData
    return {
        citizenid = data.citizenid,
        charinfo = data.charinfo,
        metadata = data.metadata,
        job = data.job,
    }
end

RegisterNetEvent('ps-dispatch:server:notify', function(data)
    if type(data) ~= 'table' or type(data.jobs) ~= 'table' then return end

    callCount = callCount + 1
    data.id = callCount
    data.time = os.time() * 1000
    data.units = {}

    if #calls >= Config.MaxCallList then
        local removed = table.remove(calls, 1)
        if removed then callsById[removed.id] = nil end
    end

    calls[#calls + 1] = data
    callsById[data.id] = data

    local targets = TrackJobs.GetTargetPlayers(data.jobs)
    for i = 1, #targets do
        TriggerClientEvent('ps-dispatch:client:notify', targets[i], data)
    end
end)

RegisterNetEvent('ps-dispatch:server:attach', function(id)
    local call = callsById[id]
    if not call then return end

    local player = Bridge.GetPlayer(source)
    if not player then return end

    local citizenid = player.PlayerData.citizenid
    local units = call.units
    for i = 1, #units do
        if units[i].citizenid == citizenid then return end
    end

    units[#units + 1] = buildUnit(player)
end)

RegisterNetEvent('ps-dispatch:server:detach', function(id)
    local call = callsById[id]
    if not call then return end

    local player = Bridge.GetPlayer(source)
    if not player then return end

    local citizenid = player.PlayerData.citizenid
    local units = call.units
    for i = 1, #units do
        if units[i].citizenid == citizenid then
            table.remove(units, i)
            return
        end
    end
end)

lib.callback.register('ps-dispatch:callback:getLatestDispatch', function()
    return calls[#calls]
end)

lib.callback.register('ps-dispatch:callback:getCalls', getCalls)

exports('GetDispatchCalls', getCalls)
