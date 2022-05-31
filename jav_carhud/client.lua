ESX = exports.es_extended:getSharedObject()

local seatbeltIsOn = false

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    carHudLoop()
end)

RegisterNetEvent('esx:playerLoaded', function()
    carHudLoop()
end)

local Cores = {
    {core = 'es_extended', event = 'esx:showNotification'},
    {core = 'qb-core', event = 'QBCore:Notify'},
}

function ShowNotification(message)
    for i = 1, #Cores do
        if GetResourceState(Cores[i].core) == 'started' then
            TriggerEvent(Cores[i].event, message)
        end
    end
end

function SetSeatBeltActive(e)
    if (e) then
        SendNUIMessage({
            type = 'cinturon:toggle',
            toggle = e.active,
            checkIsVeh = e.checkIsVeh,
        })
    end
end

function SetSeatBeltActive(e)
    if (e) then
        SendNUIMessage({
            type = 'cinturon:toggle',
            toggle = e.active,
            checkIsVeh = e.checkIsVeh,
        })
    end
end

function carHudLoop()
    CreateThread(function()
        while (true) do
            local playerPed = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsIn(playerPed)
            local IsPedInAnyVehicle = IsPedInAnyVehicle(playerPed)
            local fuelLevel  = 0
            local gearLevel  = 0
            local healthCar  = 0
            local speedLevel = 0
            local sleepThread = 1000
            local damage = GetVehicleEngineHealth(vehicle)

            if (IsPedInAnyVehicle) then
                fuelLevel = GetVehicleFuelLevel(vehicle)
                gearLevel = GetVehicleCurrentGear(vehicle)
                healthCar = math.ceil(GetVehicleBodyHealth(vehicle) / 10)
                speedLevel = math.ceil(GetEntitySpeed(vehicle) * 3.6)
                sleepThread = 170
            else
                fuelLevel  = 0
                gearLevel  = 0
                healthCar  = 0
                speedLevel = 0
            end
            
            local retval , lightsOn , highbeamsOn = GetVehicleLightsState(vehicle)

            if lightsOn == 1 and highbeamsOn == 0 then
                vehicleLight = 'normal'
            elseif (lightsOn == 1 and highbeamsOn == 1) or (lightsOn == 0 and highbeamsOn == 1) then
                vehicleLight = 'high'
            else
                vehicleLight = 'off'
            end
            
            
            SendNUIMessage({
                type = 'carhud:update',
                isInVehicle = IsPedInAnyVehicle,
                speed = speedLevel,
                fuel = fuelLevel,
                gear = gearLevel,
                vidacoche = healthCar,
                luces = lightsOn,
                luceslargas = highbeamsOn,
                locked = GetVehicleDoorLockStatus(vehicle),
                damage = damage
            })
            Wait(sleepThread)
        end
    end)
end



RegisterCommand('seatbelt', function()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed)
    local IsPedInAnyVehicle = IsPedInAnyVehicle(playerPed)

    if (IsPedInAnyVehicle) then
        seatbeltIsOn = not seatbeltIsOn
        if (seatbeltIsOn) then
            ShowNotification("Te has puesto el cinturón")
        else
            ShowNotification("Te has quitado el cinturón")
        end
        SetSeatBeltActive({active = seatbeltIsOn, checkIsVeh = IsPedInAnyVehicle})
    end
end)

RegisterKeyMapping('seatbelt', 'Cinturon', 'KEYBOARD', 'G')

-- Cerrar coche

local time = 0

RegisterCommand('cerrarcoche', function()
    if (GetGameTimer() - time) > 2000 then
        time = GetGameTimer()
        local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(PlayerPedId()), 15)
        local myVehicles = nil

        ESX.TriggerServerCallback('carhud:getOwnedVehicles', function(Vehicles) 
            myVehicles = Vehicles
        end)

        while not myVehicles do
            Wait(100)
        end

        local vehicle = nil

        for i=1, #myVehicles, 1 do
            for j=1, #vehicles, 1 do
                if GetVehicleNumberPlateText(vehicles[j]):gsub(' ', '') == myVehicles[i].plate:gsub(' ', '') then
                    vehicle = vehicles[j]
                    break
                end
            end
        end

        if vehicle ~= nil then
            if (GetVehicleDoorLockStatus(vehicle) == 1) then
                SetVehicleDoorsLocked(vehicle, 2)
                ShowNotification("Vehículo ~r~cerrado")
            else
                SetVehicleDoorsLocked(vehicle, 1)
                ShowNotification("Vehículo ~g~abierto")
            end
        else
            ShowNotification("No tienes ningún vehículo tuyo cerca")
        end
    end
end)

RegisterKeyMapping('cerrarcoche', 'Cerrar coche', 'KEYBOARD', 'L')