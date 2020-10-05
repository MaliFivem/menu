local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local isBusy = false
local spawnedVehicles, isInShopMenu = {}, false

ESX                           = nil
local PlayerData              = {}
local streetName, playerGender

Citizen.CreateThread(function()
  while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(10)
end

TriggerEvent('skinchanger:getSkin', function(skin)
	  playerGender = skin.sex
  end)
end)

AddEventHandler('skinchanger:loadSkin', function(character)
  playerGender = character.sex
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
PlayerData.job = job
end)

RegisterNetEvent('st:emsputinveh')
AddEventHandler('st:emsputinveh', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer == -1 or closestDistance > 1.0 then
		notify('error', 'Yakında oyuncu yok!')
	else
        TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
    end
end)

function SendDistressSignal()
    exports['mythic_notify']:DoCustomHudText('error', 'Çevredekiler: Ambulans çağırıyorum!',10000)
	
	local s = source
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    local street1 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
	local streetName = (GetStreetNameFromHashKey(street1))
	TriggerServerEvent('sup_alert:911', {
		x = ESX.Math.Round(playerCoords.x, 1),
		y = ESX.Math.Round(playerCoords.y, 1),
		z = ESX.Math.Round(playerCoords.z, 1)
	  }, streetName, playerGender)
end

RegisterNetEvent('ambulance:dragfalan')
AddEventHandler('ambulance:dragfalan', function()
    ExecuteCommand('yaralıtaşı')
end)

RegisterNetEvent('st:distress')
AddEventHandler('st:distress', function()
    SendDistressSignal()
end)

RegisterNetEvent('st:emstakeoutvehicle')
AddEventHandler('st:emstakeoutvehicle', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 5.0 then
        TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
    else
        notify('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('st:emsRevive')
AddEventHandler('st:emsRevive', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local ReviveReward = 1000

	if closestPlayer == -1 or closestDistance > 1.0 then
		ESX.ShowNotification('Yakında kimse yok!')
    else
        ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
            local target, distance = ESX.Game.GetClosestPlayer()

            if quantity > 0 then
                        local closestPlayerPed = GetPlayerPed(closestPlayer)
                        --	if IsPedDeadOrDying(closestPlayerPed, 1) then
                               local target, distance = ESX.Game.GetClosestPlayer()
                               playerheading = GetEntityHeading(GetPlayerPed(-1))
                               playerlocation = GetEntityForwardVector(PlayerPedId())
                               playerCoords = GetEntityCoords(GetPlayerPed(-1))						
                               local target_id = GetPlayerServerId(target)
                               local searchPlayerPed = GetPlayerPed(target)
                               local closestPlayerPed = GetPlayerPed(closestPlayer)
                                 local health = GetEntityHealth(closestPlayerPed)


                if health > 0 or IsEntityDead(searchPlayerPed)  then

                    TriggerServerEvent('ems:nuevobb',target_id, playerheading, playerCoords, playerlocation)
                                                                    Citizen.Wait(60000)
                                TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                                TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
                       if Config.ReviveReward > 0 then							   
                       exports['mythic_notify']:DoCustomHudText('success',_U('revive_complete_award', GetPlayerName(closestPlayer), Config.ReviveReward),4500)
                                else								
                         exports['mythic_notify']:DoCustomHudText('success',_U('revive_complete', GetPlayerName(closestPlayer)),5500)
                                end
                                                            
                            else
                            exports['mythic_notify']:DoCustomHudText('nohayjugadorescerca', ' El Sujeto no esta en estado critico. ',2500)
                            end						
                        else
                         exports['mythic_notify']:DoCustomHudText('error', _U('not_enough_medikit') ,3000)	
                        end

                        IsBusy = false


                    end, 'medikit')
    end
end)

RegisterNetEvent('st:emssmallheal')
AddEventHandler('st:emssmallheal', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local ReviveReward = 1000

	if closestPlayer == -1 or closestDistance > 1.0 then
		notify('error', 'Yakında oyuncu yok!')
    else
    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
        if quantity > 0 then
            local closestPlayerPed = GetPlayerPed(closestPlayer)
            local health = GetEntityHealth(closestPlayerPed)

            if health > 0 then
                local playerPed = PlayerPedId()

                isBusy = true
                notify('error', 'İlk yardım yapılıyor!')
                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                Citizen.Wait(10000)
                ClearPedTasks(playerPed)

                TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
                TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
                notify('error', 'Kişiye yardım ettin ' ..GetPlayerName(closestPlayer))
                isBusy = false
            else
                notify('error', 'Oyuncu yaralı değil!')
            end
        else
            notify('error', 'Bandajın yok!')
        end
    end, 'bandage')
    end
end)

function notify(type, message)
    exports['mythic_notify']:SendAlert(type, message)
end

RegisterNetEvent('st:emsbigheal')
AddEventHandler('st:emsbigheal', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local ReviveReward = 1000

    if closestPlayer == -1 or closestDistance > 1.0 then
		notify('error', 'Yakında oyuncu yok!')
    else
    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
        if quantity > 0 then
            local closestPlayerPed = GetPlayerPed(closestPlayer)
            local health = GetEntityHealth(closestPlayerPed)

            if health > 0 then
                local playerPed = PlayerPedId()

                isBusy = true
                notify('error', 'İlk yardım yapılıyor!')
                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                Citizen.Wait(10000)
                ClearPedTasks(playerPed)

                TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
                TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
                notify('error', 'Kişiye yardım ettin ' ..GetPlayerName(closestPlayer))
                isBusy = false
            else
                notify('error', 'Oyuncu yaralı değil!')
            end
        else
            notify('error', 'Bandajın yok!')
        end
    end, 'medikit')
    end
end)

RegisterNetEvent('st:emsdrag')
AddEventHandler('st:emsdrag', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_policejob:drag2', GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)