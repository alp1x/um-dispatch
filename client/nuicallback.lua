local Utils = require 'client.modules.utils'
local DispatchBlips = require 'client.modules.blips'

local toggleUI = Utils.toggleUI
local SetBlipsMuted = DispatchBlips.SetBlipsMuted
local ClearDispatchBlips = DispatchBlips.ClearDispatchBlips

-- NUI Callbacks
RegisterNUICallback('hideUI', function(_, cb)
    toggleUI(false)
    cb(1)
end)

RegisterNUICallback('attachUnit', function(data, cb)
    TriggerServerEvent('ps-dispatch:server:attach', data.id)
    SetNewWaypoint(data.coords.x, data.coords.y)
    cb(1)
end)

RegisterNUICallback('detachUnit', function(data, cb)
    TriggerServerEvent('ps-dispatch:server:detach', data.id)
    DeleteWaypoint()
    cb(1)
end)

RegisterNUICallback('toggleMute', function(data, cb)
    local status = data.boolean and locale('muted') or locale('unmuted')
    lib.notify({ description = locale('alerts') .. status, position = 'top', type = 'warning' })
    SetBlipsMuted(data.boolean)
    cb(1)
end)

RegisterNUICallback('toggleAlerts', function(data, cb)
    local status = data.boolean and locale('disabled') or locale('enabled')
    lib.notify({ description = locale('alerts') .. status, position = 'top', type = 'warning' })
    alertsDisabled = data.boolean
    cb(1)
end)

RegisterNUICallback('clearBlips', function(_, cb)
    lib.notify({ description = locale('blips_cleared'), position = 'top', type = 'success' })
    ClearDispatchBlips()
    cb(1)
end)

RegisterNUICallback('refreshAlerts', function(_, cb)
    lib.notify({ description = locale('alerts_refreshed'), position = 'top', type = 'success' })
    local calls = lib.callback.await('ps-dispatch:callback:getCalls', false)
    SendNUIMessage({ action = 'setDispatchs', data = calls })
    cb(1)
end)
