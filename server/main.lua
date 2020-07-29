ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("brky:domatesal")
AddEventHandler("brky:domatesal", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('domates').count < 40 then
                xPlayer.addInventoryItem('domates', math.random(1,5))
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Domates Topladın!' })
            end
        end
    end)

    
RegisterNetEvent("brky:ketcap")
AddEventHandler("brky:ketcap", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('domates').count > 4 then
                TriggerClientEvent("brky:ketcap", source)
                Citizen.Wait(16000)
                xPlayer.addInventoryItem('ketcap', math.random(1,5))
                xPlayer.removeInventoryItem("domates", 5)
            elseif xPlayer.getInventoryItem('domates').count < 5 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Üzerinde yeterli domates yok!' })
            end
        end
    end)