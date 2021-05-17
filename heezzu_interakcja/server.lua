-------------------Tutaj Jeszce macz Triggery jak byś chciał tam sobię dodać przeszukiwanie <3-----------------------





ESX				= nil

local SearchTable = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_policejob:checkSearch', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if SearchTable[target] ~= nil then
        if SearchTable[target] == xPlayer.identifier then
            cb(false)
        else
            cb(true)
        end
    else
        cb(false)
    end
end)
 
ESX.RegisterServerCallback('esx_policejob:checkSearch2', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if SearchTable[target] ~= nil then
        if SearchTable[target] == xPlayer.identifier then
            cb(true)
        else
            cb(false)
        end
    else
        cb(true)
    end
end)
 
RegisterServerEvent('esx_policejob:isSearching')
AddEventHandler('esx_policejob:isSearching', function(target, boolean)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if boolean == nil then
        SearchTable[target] = xPlayer.identifier
    else
        SearchTable[target] = nil
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local realname = 'heezzu_interakcja'
    local reason = 'WYKRYTO ZMIANĘ NAZWY SKRYPTU ------> '..GetCurrentResourceName()..' Nazwa, która jest wymagana do włączenia tego skryptu to: '..realname
end)

