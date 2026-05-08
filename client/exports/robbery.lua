local Utils = require 'client.modules.utils'

local GetVehicleData = Utils.GetVehicleData
local GetStreetAndZone = Utils.GetStreetAndZone
local GetPlayerHeading = Utils.GetPlayerHeading
local GetPlayerGender = Utils.GetPlayerGender

local function ArtGalleryRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('artgalleryrobbery'),
        codeName = 'artgalleryrobbery',
        code = '10-90',
        icon = 'fas fa-brush',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('ArtGalleryRobbery', ArtGalleryRobbery)

local function HumaneRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('humanelabsrobbery'),
        codeName = 'humanelabsrobbery',
        code = '10-90',
        icon = 'fas fa-flask-vial',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('HumaneRobbery', HumaneRobbery)

local function TrainRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('trainrobbery'),
        codeName = 'trainrobbery',
        code = '10-90',
        icon = 'fas fa-train',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('TrainRobbery', TrainRobbery)

local function VanRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('vanrobbery'),
        codeName = 'vanrobbery',
        code = '10-90',
        icon = 'fas fa-van-shuttle',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('VanRobbery', VanRobbery)

local function UndergroundRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('undergroundrobbery'),
        codeName = 'undergroundrobbery',
        code = '10-90',
        icon = 'fas fa-person-rays',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('UndergroundRobbery', UndergroundRobbery)

local function DrugBoatRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('drugboatrobbery'),
        codeName = 'drugboatrobbery',
        code = '10-65',
        icon = 'fas fa-ship',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('DrugBoatRobbery', DrugBoatRobbery)

local function UnionRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('unionrobbery'),
        codeName = 'unionrobbery',
        code = '10-90',
        icon = 'fas fa-truck-field',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('UnionRobbery', UnionRobbery)

local function CarBoosting(vehicle)
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(vehicle or cache.vehicle)

    local dispatchData = {
        message = locale('carboosting'),
        codeName = 'carboosting',
        code = '10-50',
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
exports('CarBoosting', CarBoosting)

local function SignRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('signrobbery'),
        codeName = 'signrobbery',
        code = '10-10',
        icon = 'fab fa-artstation',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('SignRobbery', SignRobbery)

local function BobcatSecurityHeist()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('bobcatsecurity'),
        codeName = 'bobcatsecurityheist',
        code = '10-90',
        icon = 'fa-solid fa-building-shield',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('BobcatSecurityHeist', BobcatSecurityHeist)

local function StoreRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('storerobbery'),
        codeName = 'storerobbery',
        code = '10-90',
        icon = 'fas fa-store',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('StoreRobbery', StoreRobbery)

local function FleecaBankRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('fleecabank'),
        codeName = 'bankrobbery',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('FleecaBankRobbery', FleecaBankRobbery)

local function PaletoBankRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('paletobank'),
        codeName = 'paletobankrobbery',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('PaletoBankRobbery', PaletoBankRobbery)

local function PacificBankRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('pacificbank'),
        codeName = 'pacificbankrobbery',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('PacificBankRobbery', PacificBankRobbery)

local function VangelicoRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('vangelico'),
        codeName = 'vangelicorobbery',
        code = '10-90',
        icon = 'fas fa-gem',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('VangelicoRobbery', VangelicoRobbery)

local function HouseRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('houserobbery'),
        codeName = 'houserobbery',
        code = '10-90',
        icon = 'fas fa-house',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('HouseRobbery', HouseRobbery)

local function YachtHeist()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('yachtheist'),
        codeName = 'yachtheist',
        code = '10-65',
        icon = 'fas fa-house',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('YachtHeist', YachtHeist)
