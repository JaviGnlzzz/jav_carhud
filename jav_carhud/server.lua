ESX = exports.es_extended:getSharedObject()

ESX.RegisterServerCallback('carhud:getOwnedVehicles', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)

    local vehicles = MySQL.query.await('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    })

    if vehicles == nil then
        vehicles = {}
    end

    cb(vehicles)

end)