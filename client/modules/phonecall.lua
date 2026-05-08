local Utils = require('client.modules.utils')

local IsCallAllowed = Utils.IsCallAllowed
local PhoneAnimation = Utils.PhoneAnimation
local GetStreetAndZone = Utils.GetStreetAndZone

local function PhoneCall(message, anonymous, job, type)
    local coords = GetEntityCoords(cache.ped)

    if IsCallAllowed(message) then
        PhoneAnimation()

        local dispatchData = {
            message = anonymous and locale('anon_call') or locale('call'),
            codeName = type == '311' and '311call' or '911call',
            code = type,
            icon = 'fas fa-phone',
            priority = 2,
            coords = coords,
            name = anonymous and locale('anon') or (PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname),
            number = anonymous and locale('hidden_number') or PlayerData.charinfo.phone,
            information = message,
            street = GetStreetAndZone(coords),
            alertTime = nil,
            jobs = job
        }

        TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
    end
end

return PhoneCall
