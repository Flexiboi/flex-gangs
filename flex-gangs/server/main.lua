local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem(Config.Flag.item, function(source,item)
    TriggerClientEvent('flex-gangs:client:placeflag', source)
end)

QBCore.Functions.CreateCallback("flex-gangs:server:getgang", function(source, cb, zone)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT gang FROM gangzones WHERE zone = ?', { zone })
    if result[1] then
        if result[1].gang ~= '' then
            cb(result[1].gang)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback("flex-gangs:server:getflagpos", function(source, cb, zone)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT flag FROM gangzones WHERE zone = ?', { zone })
    if result[1] then
        cb(json.decode(result[1].flag))
    else
        cb(false)
    end
end)

RegisterNetEvent('flex-gangs:server:placeflag', function(zone, gang, coords)
    local result = MySQL.Sync.fetchAll('SELECT flag FROM gangzones WHERE zone = ?', { zone })
    if result[1] then
        MySQL.update.await("UPDATE gangzones SET gang=?, flag=? WHERE zone=?", {gang, json.encode(coords), zone})
    else
        local flag = { coords.x, coords.y, coords.z}
        MySQL.insert('INSERT INTO gangzones (zone, gang, flag, stash, furnance, wash, guards) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            zone,
            gang,
            json.encode(coords),
            0,
            0,
            0,
            0
        })
    end
    Wait(100)
    TriggerClientEvent('flex-gangs:client:deleteZones', -1)
    Wait(100)
    TriggerClientEvent('flex-gangs:client:createZones', -1, zone, gang)
end)

RegisterNetEvent('flex-gangs:server:removeflag', function(zone)
    MySQL.update.await("UPDATE gangzones SET gang=?, flag=?, stash=?, furnance=?, wash=?, guards=? WHERE zone=?", {nil, nil, 0, 0, 0, 0, zone})
    TriggerClientEvent('flex-gangs:client:deleteZones', -1)
    Wait(100)
    TriggerClientEvent('flex-gangs:client:createZones', -1)
end)

RegisterNetEvent('flex-gangs:server:blipstate', function(id, gang, color)
    local Players = QBCore.Functions.GetPlayers()
    for _, v in pairs(Players) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player.PlayerData.gang.name ~= 'none' and Player.PlayerData.gang.name == gang then
            TriggerClientEvent('flex-gangs:client:blipstate', v, id, gang, color)
            TriggerClientEvent('QBCore:Notify', v, Lang:t("error.zoneproblems"), 'error', 5000)
            TriggerClientEvent('flex-gangs:client:playsound', v)
        end
    end
end)