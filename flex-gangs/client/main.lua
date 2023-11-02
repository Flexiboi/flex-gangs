local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local PlayerGang = {}
local GangArea = {}
local Flags = {}
local CurrenrtZone, CurrentZoneId, CurrentGang = nil, nil, nil
local FlagPos = nil
local isInGangzone = false
local alarmAlert = true

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end 
    TriggerEvent('flex-gangs:client:createZones')
    PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData then return end
    PlayerGang = PlayerData.gang
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() 
    TriggerEvent('flex-gangs:client:createZones')
    PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData then return end
    PlayerGang = PlayerData.gang
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    PlayerGang = gang
end)

RegisterNetEvent('flex-gangs:client:createZones', function(z, g)
    if not Config.Debug then
        if PlayerGang.name == 'none' or PlayerGang.name == nil then return end
    end
    for k, v in pairs(Config.GangZones) do
        GangArea[k] = {}
        local color = Config.BlipConfig.unowned.color
        local opacity = Config.BlipConfig.unowned.opacity
        QBCore.Functions.TriggerCallback('flex-gangs:server:getgang', function(gang)
            if gang then
                if PlayerGang.name == gang then
                    color = Config.BlipConfig.owned.color
                    opacity = Config.BlipConfig.owned.opacity
                else
                    color = Config.BlipConfig.enemy.color
                    opacity = Config.BlipConfig.enemy.opacity
                end
            end
            GangArea[k].blip = CreateZoneBlip(color, opacity, v.zone.center.x+v.zone.boxsize.w, v.zone.center.y+v.zone.boxsize.h, v.zone.center.x-v.zone.boxsize.w, v.zone.center.y-v.zone.boxsize.h, v.zone.center.w)
        if Config.Debug then
            if DoesBlipExist(GangArea[k].blip) then
                print('zoneblip created')
            end
        end

        GangArea[k].boxzone = BoxZone:Create(vec3(v.zone.center.x, v.zone.center.y, v.zone.center.z), v.zone.boxsize.w, v.zone.boxsize.h, {
            name = 'gangzone'..k,
            useZ = true,
            debugPoly = Config.Debug,
            heading = v.zone.center.w,
        })
        GangArea[k].boxzone:onPlayerInOut(function(isPointInside, point)
            isInGangzone = isPointInside
            if isPointInside then
                CurrenrtZone = 'gangzone'..k
                CurrentZoneId = k
                QBCore.Functions.TriggerCallback('flex-gangs:server:getgang', function(gang)
                    if gang then
                        CurrentGang = 'olympus'
                        if gang ~= 'none' then
                            CurrentGang = gang
                        end
                        QBCore.Functions.TriggerCallback('flex-gangs:server:getflagpos', function(pos)
                            if pos then
                                FlagPos = pos
                                Flags['gangzone'..k] = CreateObjectNoOffset(Config.Flag.prop, pos.x, pos.y, pos.z, 1, 0, 1)
                                SetEntityHeading(Flags['gangzone'..k], GetEntityHeading(ped))
                                FreezeEntityPosition(Flags['gangzone'..k], true)
                                PlaceObjectOnGroundProperly(Flags['gangzone'..k])
                            end
                        end, 'gangzone'..k)
                    end
                end, 'gangzone'..k)
            else
                CurrenrtZone = nil
                DeleteObject(Flags['gangzone'..k])
                exports['qb-core']:HideText()
            end
        end)
        end, 'gangzone'..k)
    end
    if z ~= nil and g ~= nil then
        CurrenrtZone = z
        CurrentGang = g
    end
    exports['qb-target']:AddTargetModel(Config.Flag.prop, {
        options = {
            {
                type = "client",
                event = "flex-gangs:client:removeflag",
                icon = "fa fa-flag",
                label = Lang:t("target.takeflag"),
                item = Config.Flag.removetool,
            },
        },
        distance = 1.5
    })
end)

RegisterNetEvent('flex-gangs:client:deleteZones', function()
    exports['qb-target']:RemoveTargetModel(Config.Flag.prop)
    for k, v in pairs(GangArea) do
        GangArea[k].boxzone:destroy()
        if DoesBlipExist(GangArea[k].blip) then
            RemoveBlip(GangArea[k].blip)
        end
    end
    for k, v in pairs(Flags) do
        DeleteObject(v)
    end
    CurrenrtZone, CurrentGang = nil, nil
    FlagPos = nil
    isInGangzone = false
end)

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
    TriggerEvent('flex-gangs:client:deleteZones')
end)

RegisterNetEvent('flex-gangs:client:placeflag', function()
    local ped = PlayerPedId()
    QBCore.Functions.TriggerCallback('flex-gangs:server:getgang', function(owned)
        if not owned then
            QBCore.Functions.Progressbar('place_flag', Lang:t("progressbar.placeflag"), Config.Flag.removetime * 1000, false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                }, {}, {}, function() -- Success
                    local coords = GetEntityCoords(ped)
                    Flags[CurrenrtZone] = CreateObjectNoOffset(Config.Flag.prop, coords.x, coords.y, coords.z, 1, 0, 1)
                    SetEntityHeading(Flags[CurrenrtZone], GetEntityHeading(ped))
                    FreezeEntityPosition(Flags[CurrenrtZone], true)
                    PlaceObjectOnGroundProperly(Flags[CurrenrtZone])
                    TriggerServerEvent('flex-gangs:server:placeflag', CurrenrtZone, PlayerGang.name, coords)
                    ClearPedTasks(ped)
            end, function() -- Cancel
                ClearPedTasks(ped)
                QBCore.Functions.Notify(Lang:t("error.canceled"), 'error', 5000)
            end)
        else
        end
    end, CurrenrtZone)
end)

RegisterNetEvent('flex-gangs:client:removeflag', function()
    local ped = PlayerPedId()
    TriggerServerEvent('flex-gangs:server:blipstate', CurrentZoneId, CurrentGang, Config.BlipConfig.capturing.color)
    QBCore.Functions.Progressbar('remove_flag', Lang:t("progressbar.removeflag"), Config.Flag.removetime * 1000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        }, {}, {}, function() -- Success
            DeleteObject(Flags[CurrenrtZone])
            Flags[CurrenrtZone] = nil
            FlagPos = nil
            CurrentGang = nil
            TriggerServerEvent('flex-gangs:server:removeflag', CurrenrtZone)
            ClearPedTasks(ped)
    end, function() -- Cancel
        ClearPedTasks(ped)
        QBCore.Functions.Notify(Lang:t("error.canceled"), 'error', 5000)
        TriggerServerEvent('flex-gangs:client:blipstate', CurrentZoneId, CurrentGang, Config.BlipConfig.owned.color)
    end)
end)

RegisterNetEvent('flex-gangs:client:blipstate', function(id, color)
    SetBlipColour(GangArea[id].blip, color)
end)

RegisterNetEvent('flex-gangs:client:playsound', function()
    alarmAlert = true
    local alarmtime = Config.AlarTime
    Citizen.CreateThread(function()
        while alarmAlert do
            PlaySound(-1, "5_SECOND_TIMER", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
            Wait(1000)
            alarmtime = alarmtime - 1
            if alarmtime <= 0 then
                alarmAlert = false
            end
        end
    end)
end)

local waittime = 1
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(waittime)
        if isInGangzone then
            waittime = 1
            if not HasStreamedTextureDictLoaded("gangs") then
                    RequestStreamedTextureDict("gangs", true)
                    while not HasStreamedTextureDictLoaded("gangs") do
                        Wait(1)
                    end
            elseif FlagPos and CurrentGang then
                local pos = GetEntityCoords(PlayerPedId())
                local dist = #(pos - vec3(FlagPos.x, FlagPos.y, FlagPos.z))
                if dist < 1.3 then
                    DrawMarker(9, FlagPos.x+0.05, FlagPos.y+0.09, FlagPos.z+0.525, 0.0, 0.0, 0.0, 90.0, 90.0, 0.0, 0.2, 0.2, 0.2, 255, 255, 255, 255,false, false, 2, false, "gangs", Config.GangLogos[CurrentGang] or Config.DefaultLogo, false)       
                end
            end
        else
            waittime = 1000
        end
    end
end)