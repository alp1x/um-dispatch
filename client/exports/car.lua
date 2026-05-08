local Utils = require 'client.modules.utils'

local GetVehicleData = Utils.GetVehicleData
local GetStreetAndZone = Utils.GetStreetAndZone
local GetPlayerHeading = Utils.GetPlayerHeading
local GetWeaponName = Utils.GetWeaponName

local function CarJacking(vehicle)
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(vehicle)

    local dispatchData = {
        message = locale('carjacking'),
        codeName = 'carjack',
        code = '10-35',
        icon = 'fas fa-car',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('CarJacking', CarJacking)

local function VehicleTheft()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(cache.vehicle)

    local dispatchData = {
        message = locale('vehicletheft'),
        codeName = 'vehicletheft',
        code = '10-35',
        icon = 'fas fa-car-burst',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('VehicleTheft', VehicleTheft)

local function VehicleShooting()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(cache.vehicle)

    local dispatchData = {
        message = locale('vehicleshots'),
        codeName = 'vehicleshots',
        code = '10-60',
        icon = 'fas fa-gun',
        priority = 2,
        coords = coords,
        weapon = GetWeaponName(),
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('VehicleShooting', VehicleShooting)

local function SpeedingVehicle()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(cache.vehicle)

    local dispatchData = {
        message = locale('speeding'),
        codeName = 'speeding',
        code = '10-11',
        icon = 'fas fa-car',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('SpeedingVehicle', SpeedingVehicle)
