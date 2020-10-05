local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

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
-- kisayol = false
-- RegisterCommand('kısayol', function()
-- 	local job = ESX.GetPlayerData().job.name
-- 	if job == 'police' or job =='sheriff' then
-- 		if kisayol == false then
-- 			kisayol = true
-- 			exports['mythic_notify']:SendAlert('error', 'Kısayol açıldı!')
-- 		else
-- 			kisayol = false
-- 			exports['mythic_notify']:SendAlert('error', 'Kısayol kapandı!')
-- 		end
-- 	end
-- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		if kisayol == true then
-- 			if IsPedInAnyVehicle(PlayerPedId(), false) then
-- 				if IsControlJustPressed(0, 172)  then -- üst ok
-- 					local job = ESX.GetPlayerData().job.name
-- 					if job == 'police' or job =='sheriff' then
-- 						TriggerEvent('st:handcuff')
-- 					end
-- 				elseif IsControlJustPressed(0, 174)  then -- sol ok
-- 					local job = ESX.GetPlayerData().job.name
-- 					if job == 'police' or job =='sheriff' then
-- 						TriggerEvent('st:softhandcuff')
-- 					end
-- 				elseif IsControlJustPressed(0, 173)  then -- alt ok
-- 					local job = ESX.GetPlayerData().job.name
-- 					if job == 'police' or job =='sheriff' then
-- 						TriggerEvent('st:uncuff')
-- 					end
-- 				elseif IsControlJustPressed(0, 175)  then -- sağ ok
-- 					local job = ESX.GetPlayerData().job.name
-- 					if job == 'police' or job =='sheriff' then
-- 						TriggerEvent('st:escort')
-- 					end
-- 				end
-- 			end
-- 		else
-- 			Citizen.Wait(1000)
-- 		end
-- 	end
-- end)

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

RegisterNetEvent('st:openmdt')
AddEventHandler('st:openmdt', function()
    ExecuteCommand('mdt')
end)

RegisterNetEvent('police:eup')
AddEventHandler('police:eup', function()
	TriggerEvent('eupmenu')
end)

RegisterNetEvent('officerdown')
AddEventHandler("officerdown", function()
	local s = source
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    local street1 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
	local streetName = (GetStreetNameFromHashKey(street1))
	TriggerServerEvent('sup_alert:carJackInProgress', {
		x = ESX.Math.Round(playerCoords.x, 1),
		y = ESX.Math.Round(playerCoords.y, 1),
		z = ESX.Math.Round(playerCoords.z, 1)
	  }, streetName, playerGender,"polis")
end)

RegisterNetEvent('officerdown2')
AddEventHandler("officerdown2", function()
	local s = source
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    local street1 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
	local streetName = (GetStreetNameFromHashKey(street1))
	TriggerServerEvent('sup_alert:police10-99', {
		x = ESX.Math.Round(playerCoords.x, 1),
		y = ESX.Math.Round(playerCoords.y, 1),
		z = ESX.Math.Round(playerCoords.z, 1)
	  }, streetName, playerGender, "doktor")
end)

RegisterNetEvent('st:escort')
AddEventHandler('st:escort', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('police:billing')
AddEventHandler('police:billing', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
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
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_police', 'Polis', amount)
					TriggerServerEvent('cylex:AddInLog', "police", "sendBill", GetPlayerName(PlayerId()), GetPlayerName(closestPlayer), "Mekanik", amount)
				end
			end
		end, function(data, menu)
			menu.close()
		end)
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title    = 'Faturalar',
		align    = 'top-right',
		elements = {
			{label = _'Trafik Cezaları', value = 0},
			{label = - 'Küçük Cezalar',   value = 1},
			{label = 'Orta Cezalar', value = 2},
			{label = 'Büyük Cezalar',   value = 3}
	}}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)
		local elements = {}

		for k,fine in ipairs(fines) do
			table.insert(elements, {
				label     = ('%s <span style="color:green;">%s</span>'):format(fine.label.. 'armory_item' ..ESX.Math.GroupDigits(fine.amount)),
				value     = fine.id,
				amount    = fine.amount,
				fineLabel = fine.label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = 'Fatura',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			if Config.EnablePlayerManagement then
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', 'fine_total' ..data.current.fineLabel, data.current.amount)
			else
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', 'fine_total ' ..data.current.fineLabel, data.current.amount)
			end

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

function SendToCommunityService(player)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Community Service Menu', {
        title = "Community Service Menu",
    }, function (data2, menu)
        local community_services_count = tonumber(data2.value)

        if community_services_count == nil then
            ESX.ShowNotification('Invalid services count.')
        else
            TriggerServerEvent("esx_communityservice:sendToCommunityService", player, community_services_count)
            menu.close()
        end
    end, function (data2, menu)
        menu.close()
    end)
end

function ShowPlayerLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label and data.licenses[i].type then
					table.insert(elements, {
						label = data.licenses[i].label,
						type = data.licenses[i].type
					})
				end
			end
		end

		if Config.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license',
		{
			title    = 'Lisans İptal',
			align    = 'top-right',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), 'license_revoked' ..data.current.label)

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

function JailPlayer(player)
	TriggerEvent("esx-qalle-jail:openJailMenu")
end

RegisterNetEvent('police:checkLicenses')
AddEventHandler('police:checkLicenses', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		ShowPlayerLicense(closestPlayer)
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('st:panicTrigger')
AddEventHandler('st:panicTrigger', function()
	local playerCoords = GetEntityCoords(PlayerPedId())
	TriggerServerEvent('esx_outlawalert:1013', {
		x = ESX.Math.Round(playerCoords.x, 1),
		y = ESX.Math.Round(playerCoords.y, 1),
		z = ESX.Math.Round(playerCoords.z, 1)
	}, streetName, playerGender)
end)

-- Gets the player's current street.
-- Aaalso get the current player gender
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)

		local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

RegisterNetEvent('police:communityservice')
AddEventHandler('police:communityservice', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		SendToCommunityService(GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('police:jailmenu')
AddEventHandler('police:jailmenu', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		JailPlayer(GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('police:object')
AddEventHandler('police:object', function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
        title    = _U('traffic_interaction'),
        align    = 'top-right',
        elements = {
            --{label = _U('cone'), model = 'prop_roadcone02a'},
            {label = _U('barrier'), model = 'prop_barrier_work05'},
            {label = _U('spikestrips'), model = 'p_ld_stinger_s'}
            --{label = _U('box'), model = 'prop_boxpile_07d'},
            --{label = _U('cash'), model = 'hei_prop_cash_crate_half_full'}
    }}, function(data2, menu2)
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        local forward   = GetEntityForwardVector(playerPed)
        local x, y, z   = table.unpack(coords + forward * 1.0)

        if data2.current.model == 'prop_roadcone02a' then
            z = z - 2.0
        end

        ESX.Game.SpawnObject(data2.current.model, {x = x, y = y, z = z}, function(obj)
            SetEntityHeading(obj, GetEntityHeading(playerPed))
            PlaceObjectOnGroundProperly(obj)
        end)
    end, function(data2, menu2)
        menu2.close()
    end)
end)

RegisterNetEvent('police:checkBank')
AddEventHandler('police:checkBank', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		OpenUnpaidBillsMenu(closestPlayer)
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('st:handcuff')
AddEventHandler('st:handcuff', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if distance <= 2.0 then
			TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
			Citizen.Wait(2000)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, "handcuff", 0.2)
		else
			ESX.ShowNotification('Kelepçelemek için yeterince yakın değil')
		end
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('st:softhandcuff')
AddEventHandler('st:softhandcuff', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if distance <= 2.0 then
			TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation, "soft")
		else
			ESX.ShowNotification('Kelepçelemek için yeterince yakın değil')
		end
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('st:uncuff')
AddEventHandler('st:uncuff', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
		-- if distance <= 2.0 then
		-- 	TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
		-- else
		-- 	ESX.ShowNotification('Kelepçeyi çözmek için yeterince yakın değil')
		-- end		
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

function OpenBodySearchMenu()
	TriggerEvent('disc-inventoryhud:search')
end

RegisterNetEvent('st:search')
AddEventHandler('st:search', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('esx_policejob:message', GetPlayerServerId(closestPlayer), 'Üstün aranıyor!')
		OpenBodySearchMenu()
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('st:checkGSR')
AddEventHandler('st:checkGSR', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('GSR:Status2', GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('st:getid')
AddEventHandler('st:getid', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
      TriggerServerEvent('jsfour-idcard:open',  GetPlayerServerId(player), GetPlayerServerId(PlayerId()))
    else
    exports['mythic_notify']:SendAlert('inform', 'Yakında birisi yok', 2500)
    end
    --     exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    -- end
end)

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i=1, #bills, 1 do
			table.insert(elements, {
				label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>',
				value = bills[i].id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			title    = 'Ödenmemiş Faturalar',
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

RegisterNetEvent('st:putinvehicle')
AddEventHandler('st:putinvehicle', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)

RegisterNetEvent('st:takeoutvehicle')
AddEventHandler('st:takeoutvehicle', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Yakında oyuncu yok!')
    end
end)


----------------

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  


RegisterCommand("kod", function(source, args, rawCommand)
    local s = source
    local supkod = args[1]
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    local street1 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
	local streetName = (GetStreetNameFromHashKey(street1))
	if PlayerData.job.name ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff') then
    if not supkod then
    exports['mythic_notify']:SendAlert('inform', 'Kod seviyesini seç', 2500)
    elseif supkod == "10-48" then
    TriggerServerEvent('sup_alert:police10-48', {
      x = ESX.Math.Round(playerCoords.x, 1),
      y = ESX.Math.Round(playerCoords.y, 1),
      z = ESX.Math.Round(playerCoords.z, 1)
    }, streetName, playerGender)
    elseif supkod == "0" then
    TriggerServerEvent('sup_alert:police10-48A', {
       x = ESX.Math.Round(playerCoords.x, 1),
       y = ESX.Math.Round(playerCoords.y, 1),
       z = ESX.Math.Round(playerCoords.z, 1)
    }, streetName, playerGender)
    elseif supkod == "3" then
    TriggerServerEvent('sup_alert:police10-99', {
      x = ESX.Math.Round(playerCoords.x, 1),
      y = ESX.Math.Round(playerCoords.y, 1),
      z = ESX.Math.Round(playerCoords.z, 1)
    }, streetName, playerGender)
  elseif supkod == "2" then
    TriggerServerEvent('sup_alert:policeoffduty', {
      x = ESX.Math.Round(playerCoords.x, 1),
      y = ESX.Math.Round(playerCoords.y, 1),
      z = ESX.Math.Round(playerCoords.z, 1)
    }, streetName, playerGender)
  elseif supkod == "1" then
    TriggerServerEvent('sup_alert:policeonduty', {
      x = ESX.Math.Round(playerCoords.x, 1),
      y = ESX.Math.Round(playerCoords.y, 1),
      z = ESX.Math.Round(playerCoords.z, 1)
    }, streetName, playerGender)
    else
    exports['mythic_notify']:SendAlert('error', 'Geçersiz kod seviyesi', 2500)
	end
	else
		exports['mythic_notify']:SendAlert('error', 'Bunu kullanamazsın!', 2500)
	end
end)