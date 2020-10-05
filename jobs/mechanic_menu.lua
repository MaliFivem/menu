local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isDead, isBusy = false, false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('st:hijack')
AddEventHandler('st:hijack', function()
    local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				--ESX.ShowNotification(_U('inside_vehicle'))
				exports['mythic_notify']:SendAlert('error', 'Bu işlemi aracın içerisinde yapamazsın')
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					TriggerServerEvent('cylex:AddInLog', "mechanic", "hijack_vehicle", GetPlayerName(PlayerId()))
					--ESX.ShowNotification(_U('vehicle_unlocked'))
					exports['mythic_notify']:SendAlert('inform', 'Araç kilidi açıldı')
					isBusy = false
				end)
			else
				--ESX.ShowNotification(_U('no_vehicle_nearby'))
				exports['mythic_notify']:SendAlert('error', 'Yakınında araç yok')
			end
end)

RegisterNetEvent('st:mechimpound')
AddEventHandler('st:mechimpound', function()
    local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					--ESX.ShowNotification(_U('vehicle_impounded'))
					exports['mythic_notify']:SendAlert('inform', 'Araç haczedildi')
					ESX.Game.DeleteVehicle(vehicle)
					TriggerServerEvent('fizzfau-impound')
					exports['mythic_notify']:SendAlert('success', '25$ kazandın!')
				else
					--ESX.ShowNotification(_U('must_seat_driver'))
					exports['mythic_notify']:SendAlert('error', 'Bu işlemi yapabilmek için sürücü koltuğunda olmalısın')
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					--ESX.ShowNotification(_U('vehicle_impounded'))
					exports['mythic_notify']:SendAlert('inform', 'Araç haczedildi')
					ESX.Game.DeleteVehicle(vehicle)
					TriggerServerEvent('fizzfau-impound')
					exports['mythic_notify']:SendAlert('success', '25$ kazandın!')
				else
					--ESX.ShowNotification(_U('must_near'))
					exports['mythic_notify']:SendAlert('error', 'Aracın yakınında olman gerekiyor')
				end
			end
end)

RegisterNetEvent('st:mechrepair')
AddEventHandler('st:mechrepair', function()
    local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				--ESX.ShowNotification(_U('inside_vehicle'))
				exports['mythic_notify']:SendAlert('error', 'Bu işlemi aracın içerisinde yapamazsın')
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
				Citizen.CreateThread(function()
				TriggerEvent("mythic_progbar:client:progress", {
				name = "arac_tamir",
				duration = 10000,
				label = "Aracı tamir ediyorsun",
				useWhileDead = false,
				canCancel = false,
				controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
		}, function(status)
			if not status then
				-- Do Something If Event Wasn't Cancelled
			end
		end)		
					Citizen.Wait(10000)

					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)
					TriggerServerEvent('cylex:AddInLog', "mechanic", "fix_vehicle", GetPlayerName(PlayerId()))

					--ESX.ShowNotification(_U('vehicle_repaired'))
					exports['mythic_notify']:SendAlert('inform', 'Araç tamir edildi')
					isBusy = false
				end)
			else
				--ESX.ShowNotification(_U('no_vehicle_nearby'))
				exports['mythic_notify']:SendAlert('error', 'Yakınında araç yok')
			end
end)

RegisterNetEvent('st:mechclean')
AddEventHandler('st:mechclean', function()
    local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				--ESX.ShowNotification(_U('inside_vehicle'))
				exports['mythic_notify']:SendAlert('error', 'Bu işlemi aracın içerisinde yapamazsın')
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)
					TriggerServerEvent('cylex:AddInLog', "mechanic", "clean_vehicle", GetPlayerName(PlayerId()))

					--ESX.ShowNotification(_U('vehicle_cleaned'))
					exports['mythic_notify']:SendAlert('inform', 'Araç temizlendi')
					isBusy = false
				end)
			else
				--ESX.ShowNotification(_U('no_vehicle_nearby'))
				exports['mythic_notify']:SendAlert('error', 'Yakınında araç yok')
			end
end)

RegisterNetEvent('st:fatura')
AddEventHandler('st:fatura', function()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
        title = 'Miktar Girin'
    }, function(data, menu)
        local amount = tonumber(data.value)

        if amount == nil or amount < 0 then
            --ESX.ShowNotification(_U('amount_invalid'))
            exports['mythic_notify']:SendAlert('error', 'Geçersiz miktar')
        else
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                --ESX.ShowNotification(_U('no_players_nearby'))
                exports['mythic_notify']:SendAlert('error', 'Yakınında kimse yok')
            else
                menu.close()
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', 'Mekanik', amount)
                TriggerServerEvent('cylex:AddInLog', "mechanic", "sendBill", GetPlayerName(PlayerId()), GetPlayerName(closestPlayer), "Mekanik", amount)
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end)