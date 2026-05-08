local Config = require 'shared.config'
local WeaponWhitelist = require 'shared.whitelist'

local timer = {}
local whitelistedWeapons = {}

for i = 1, #WeaponWhitelist do
    whitelistedWeapons[joaat(WeaponWhitelist[i])] = true
end

---@param name string
---@param action function
---@vararg any
local function WaitTimer(name, action, ...)
    if not Config.DefaultAlerts[name] then return end
    if timer[name] then return end

    timer[name] = true
    action(...)
    Wait(Config.DefaultAlertsDelay * 1000)
    timer[name] = false
end

---@param witnesses table
---@param ped number
---@return boolean
local function isPedAWitness(witnesses, ped)
    for i = 1, #witnesses do
        if witnesses[i] == ped then return true end
    end
    return false
end

---@param ped number
---@return boolean
local function isWhitelistedWeapon(ped)
    return whitelistedWeapons[GetSelectedPedWeapon(ped)] == true
end

if Config.DefaultAlerts.Shooting then
    AddEventHandler('CEventGunShot', function(witnesses, ped)
        if cache.ped ~= ped then return end
        if IsPedCurrentWeaponSilenced(cache.ped) then return end
        if isWhitelistedWeapon(cache.ped) then return end

        if PlayerData.job and PlayerData.job.type == 'leo' and not Config.Debug then return end

        if witnesses and not isPedAWitness(witnesses, ped) then return end

        WaitTimer('Shooting', function()
            if cache.vehicle then
                exports['um-dispatch']:VehicleShooting()
            else
                exports['um-dispatch']:Shooting()
            end
        end)
    end)
end

if Config.DefaultAlerts.Melee then
    AddEventHandler('CEventShockingSeenMeleeAction', function(witnesses, ped)
        if cache.ped ~= ped then return end
        if witnesses and not isPedAWitness(witnesses, ped) then return end
        if not IsPedInMeleeCombat(ped) then return end

        WaitTimer('Melee', function()
            exports['um-dispatch']:Fight()
        end)
    end)
end

if Config.DefaultAlerts.Autotheft then
    AddEventHandler('CEventPedJackingMyVehicle', function(_, ped)
        if cache.ped ~= ped then return end

        WaitTimer('Autotheft', function()
            local vehicle = GetVehiclePedIsUsing(ped)
            exports['um-dispatch']:CarJacking(vehicle)
        end)
    end)

    AddEventHandler('CEventShockingCarAlarm', function(_, ped)
        if cache.ped ~= ped then return end

        WaitTimer('Autotheft', function()
            local vehicle = GetVehiclePedIsUsing(ped)
            exports['um-dispatch']:VehicleTheft(vehicle)
        end)
    end)
end

if Config.DefaultAlerts.Explosion then
    AddEventHandler('CEventExplosionHeard', function(witnesses, ped)
        if witnesses and not isPedAWitness(witnesses, ped) then return end

        WaitTimer('Explosion', function()
            exports['um-dispatch']:Explosion()
        end)
    end)
end

if Config.DefaultAlerts.PlayerDowned then
    AddEventHandler('gameEventTriggered', function(name, args)
        if name ~= 'CEventNetworkEntityDamage' then return end

        local victim = args[1]
        if not victim or victim ~= cache.ped then return end
        if args[6] ~= 1 then return end

        WaitTimer('PlayerDowned', function()
            local jobType = PlayerData.job and PlayerData.job.type
            if jobType == 'leo' then
                exports['um-dispatch']:OfficerDown()
            elseif jobType == 'ems' then
                exports['um-dispatch']:EmsDown()
            else
                exports['um-dispatch']:InjuriedPerson()
            end
        end)
    end)
end


if Config.DefaultAlerts.Speeding then
    local SpeedingEvents = {
        'CEventShockingCarChase',
        'CEventShockingDrivingOnPavement',
        'CEventShockingBicycleOnPavement',
        'CEventShockingMadDriverBicycle',
        'CEventShockingMadDriverExtreme',
        'CEventShockingEngineRevved',
        'CEventShockingInDangerousVehicle',
    }

    local exemptVehicleClass = {
        [15] = true, -- Helicopters
        [16] = true, -- Planes
    }

    local SpeedTrigger = 0
    for i = 1, #SpeedingEvents do
        AddEventHandler(SpeedingEvents[i], function(_, ped)
            if cache.ped ~= ped then return end
            if not cache.vehicle then return end
            if GetGameTimer() - SpeedTrigger < 10000 then return end
            if PlayerData.job and PlayerData.job.type == 'leo' and not Config.Debug then return end
            if exemptVehicleClass[GetVehicleClass(cache.vehicle)] then return end
            if GetEntitySpeed(cache.vehicle) * 3.6 < (80 + math.random(0, 20)) then return end
            if cache.ped ~= GetPedInVehicleSeat(cache.vehicle, -1) then return end

            WaitTimer('Speeding', function()
                exports['um-dispatch']:SpeedingVehicle()
                SpeedTrigger = GetGameTimer()
            end)
        end)
    end
end
