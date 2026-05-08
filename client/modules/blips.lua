local Config = require 'shared.config'

local Blips = {}

local DECAY_INTERVAL = 2000
local RADIUS_BASE_ALPHA = 128
local DEFAULT_ALERT_SOUND = 'Lose_1st'
local DEFAULT_ALERT_SOUNDSET = 'GTAO_FM_Events_Soundset'

local activeBlips = {}
local decayRunning = false
local alertsMuted = false

local function randomOffset(baseX, baseY, offset)
    return baseX + math.random(-offset, offset), baseY + math.random(-offset, offset)
end

---Single shared thread that ticks every `DECAY_INTERVAL` ms,
---fades the radius alpha, and removes expired blips.
---Exits cleanly when there are no more active blips.
local function startDecayThread()
    if decayRunning then return end
    decayRunning = true

    CreateThread(function()
        while next(activeBlips) do
            local now = GetGameTimer()

            for id, entry in pairs(activeBlips) do
                local remaining = entry.expireAt - now

                if remaining <= 0 then
                    RemoveBlip(entry.blip)
                    RemoveBlip(entry.radius)
                    activeBlips[id] = nil
                else
                    SetBlipAlpha(entry.radius, math.floor(RADIUS_BASE_ALPHA * remaining / entry.lifetime))
                end
            end

            Wait(DECAY_INTERVAL)
        end

        decayRunning = false
    end)
end

local function spawnBlips(coords, radius, sprite, color, scale, flash)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local radiusBlip = AddBlipForRadius(coords.x, coords.y, coords.z, radius)

    SetBlipFlashes(blip, flash)
    SetBlipSprite(blip, sprite)
    SetBlipHighDetail(blip, true)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, 255)
    SetBlipAsShortRange(blip, false)
    SetBlipCategory(blip, 2)
    SetBlipColour(radiusBlip, color)
    SetBlipAlpha(radiusBlip, RADIUS_BASE_ALPHA)

    return blip, radiusBlip
end

function Blips.AddDispatchBlip(data, blipData)
    blipData = blipData or {}
    local alert = blipData.alert or {}

    local sprite = blipData.sprite or alert.sprite or 280
    local color = blipData.color or alert.color or 1
    local scale = blipData.scale or alert.scale or 1.0
    local flash = blipData.flash or false
    local lifetime = (blipData.length or alert.length or 2) * 60000
    local radius = blipData.radius or 0

    local coords = data.coords
    if blipData.offset then
        local offsetX, offsetY = randomOffset(coords.x, coords.y, Config.MaxOffset)
        coords = { x = offsetX, y = offsetY, z = coords.z }
    end

    local blip, radiusBlip = spawnBlips(coords, radius, sprite, color, scale, flash)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.code .. ' - ' .. data.message)
    EndTextCommandSetBlipName(blip)

    activeBlips[data.id] = {
        blip = blip,
        radius = radiusBlip,
        expireAt = GetGameTimer() + lifetime,
        lifetime = lifetime,
    }

    startDecayThread()

    if alertsMuted then return end

    local alertSound = blipData.sound or alert.sound or DEFAULT_ALERT_SOUND
    local alertSoundSet = blipData.sound2 or alert.sound2 or DEFAULT_ALERT_SOUNDSET

    if alertSound == DEFAULT_ALERT_SOUND then
        PlaySound(-1, alertSound, alertSoundSet, false, false, true)
    end
end

function Blips.ClearDispatchBlips()
    for _, entry in pairs(activeBlips) do
        RemoveBlip(entry.blip)
        RemoveBlip(entry.radius)
    end
    activeBlips = {}
end

function Blips.SetBlipsMuted(state)
    alertsMuted = state
end

return Blips
