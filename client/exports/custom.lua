local Utils = require 'client.modules.utils'

local GetPlayerGender = Utils.GetPlayerGender
local GetStreetAndZone = Utils.GetStreetAndZone

local function CustomAlert(data)
    local coords = data.coords or vec3(0.0, 0.0, 0.0)
    local gender = data.gender and GetPlayerGender() or nil


    local dispatchData = {
        message = data.message or "",                          -- Title of the alert
        codeName = data.dispatchCode or "NONE",                -- Unique name for each alert
        code = data.code or '10-80',                           -- Code that is displayed before the title
        icon = data.icon or 'fas fa-question',                 -- Icon that is displaed after the title
        priority = data.priority or 2,                         -- Changes color of the alert ( 1 = red, 2 = default )
        coords = coords,                                       -- Coords of the player
        gender = gender,                                       -- Gender of the player
        street = GetStreetAndZone(coords),                     -- Street of the player
        camId = data.camId or nil,                             -- Cam ID ( for heists )
        color = data.firstColor or nil,                        -- Color of the vehicle
        callsign = data.callsign or nil,                       -- Callsigns
        name = data.name or nil,                               -- Name of either officer/ems or a player
        vehicle = data.model or nil,                           -- Vehicle name
        plate = data.plate or nil,                             -- Vehicle plate
        alertTime = data.alertTime or nil,                     -- How long it stays on the screen in seconds
        doorCount = data.doorCount or nil,                     -- How many doors on vehicle
        automaticGunfire = data.automaticGunfire or false,     -- Automatic Gun or not
        alert = {
            radius = data.radius or 0,                         -- Radius around the blip
            sprite = data.sprite or 1,                         -- Sprite of the blip
            color = data.color or 1,                           -- Color of the blip
            scale = data.scale or 0.5,                         -- Scale of the blip
            length = data.length or 2,                         -- How long it stays on the map
            sound = data.sound or "Lose_1st",                  -- Alert sound
            sound2 = data.sound2 or "GTAO_FM_Events_Soundset", -- Alert sound
            offset = data.offset or false,                     -- Blip / radius offset
            flash = data.flash or false                        -- Blip flash
        },
        jobs = data.jobs or { 'leo' },
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('CustomAlert', CustomAlert)
