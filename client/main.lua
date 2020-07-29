local PlayerData                = {}
ESX                             = nil

local domatesAktif = false
local washingActive = false
local firstspawn = false
local impacts = 0
local timer = 0
local locations = {
    { x = 2127.427, y = 5151.475, z = 50.977},
    { x = 2119.457, y = 5156.023, z = 51.377},
    { x = 2127.264, y = 5157.350, z = 51.864},
    { x = 2133.878, y = 5153.258, z = 51.416},
}

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
end)  

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent("brky:ketcap")
AddEventHandler("brky:ketcap", function()
    Washing()
end)

RegisterNetEvent('brky:timer')
AddEventHandler('brky:timer', function()
    local timer = 0
    local ped = PlayerPedId()
    
    Citizen.CreateThread(function()
		while timer > -1 do
			Citizen.Wait(150)

			if timer > -1 then
				timer = timer + 1
            end
            if timer == 100 then
                break
            end
		end
    end) 

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 5 then
                Draw3DText( Config.WashingX, Config.WashingY, Config.WashingZ+0.5 -1.400, ('Domatesler isleniyor ' .. timer .. '%'), 4, 0.1, 0.1)
            end
            if timer == 100 then
                timer = 0
                break
            end
        end
    end)
end)



Citizen.CreateThread(function()
	Citizen.Wait(500)
    blip2 = AddBlipForCoord(Config.WashingX, Config.WashingY, Config.WashingZ)

    SetBlipSprite(blip2, 57)
    SetBlipColour(blip2, 1)
    SetBlipScale(blip2, 0.5)
    SetBlipAsShortRange(blip2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Ketçap Fabrikası")
    EndTextCommandSetBlipName(blip2)   
end)


Citizen.CreateThread(function()
	Citizen.Wait(500)
    blip5 = AddBlipForCoord(2130.071, 5155.169, 51.648)
    SetBlipSprite(blip5, 57)
    SetBlipColour(blip5, 1)
    SetBlipScale(blip5, 0.5)
    SetBlipAsShortRange(blip5, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Domates Tarlası")
    EndTextCommandSetBlipName(blip5)
end)


Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
            for i=1, #locations, 1 do
            if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 100 and domatesAktif == false then
                DrawMarker(20, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 100.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                    if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 1 then
                        ESX.ShowHelpNotification("Domates toplamaya başla ~INPUT_CONTEXT~")
                            if IsControlJustReleased(1, 51) then
                                Citizen.Wait(1)
                                Animation()
                                domatesAktif = true
                            end
                        end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 100 and washingActive == false then
            DrawMarker(20, Config.WashingX, Config.WashingY, Config.WashingZ, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 1 then
                    ESX.ShowHelpNotification("Ketçap Üret ~INPUT_CONTEXT~")
                        if IsControlJustReleased(1, 51) then
                            Citizen.Wait(1)
                            TriggerServerEvent("brky:ketcap")
                end
            end
        end
    end
end)


function Washing()
    local ped = PlayerPedId()
    RequestAnimDict("amb@prop_human_bum_bin@idle_a")
    washingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
    TriggerEvent("esx_miner:timer")
    Citizen.Wait(15900)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    washingActive = false
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100 
    SetTextScale(0.35, 0.35)
    SetTextFont(fontId)
    SetTextProportional(0)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()   
end

function Animation()
    Citizen.CreateThread(function()
        while impacts < 5 do
            Citizen.Wait(1)
		local ped = PlayerPedId()	
                RequestAnimDict("amb@prop_human_bum_bin@idle_a")
                Citizen.Wait(100)
                FreezeEntityPosition(ped, true)
                TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
                SetEntityHeading(ped, 270.0)
                Citizen.Wait(2500)
                ClearPedTasks(ped)
                Citizen.Wait(1)
                impacts = impacts+1
                if impacts == 5 then
                    FreezeEntityPosition(ped, false)
                    domatesAktif = false
                    impacts = 0
                    Citizen.Wait(1)
                    TriggerServerEvent("brky:domatesal")
                    break
                end        
        end
    end)
end