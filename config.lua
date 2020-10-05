ESX = nil
Citizen.CreateThread(function()
    while true do
        Wait(5)
        if ESX ~= nil then
        else
            ESX = nil
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
    end
end)

FIZZ = {}
FIZZ.Prop = true  -- prop menüsünü kapatmak için false yapın
FIZZ.K9Enable = true -- K9'u kaldırmak için false yapın
FIZZ.Cloth = true -- Kıyafet Menüsünü kaldırmak için false yapın
FIZZ.IDCard = true -- kimlik göstermeyi kapatmak için false yapın

local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isNews = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}
 
RegisterNetEvent('idcard:gor')
AddEventHandler('idcard:gor', function()
    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('idcard:goster')
AddEventHandler('idcard:goster', function()
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
      TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
    else
    exports['mythic_notify']:SendAlert('inform', 'Yakında birisi yok', 2500)
    end
end)

RegisterNetEvent('idcard:ehliyetgor')
AddEventHandler('idcard:ehliyetgor', function()
    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
end)

RegisterNetEvent('idcard:ehliyetgoster')
AddEventHandler('idcard:ehliyetgoster', function()
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
      TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
    else
        exports['mythic_notify']:SendAlert('inform', 'Yakında birisi yok', 2500)
    end
end)

RegisterNetEvent('idcard:ruhsatgor')
AddEventHandler('idcard:ruhsatgor', function()
    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'license')
end)

RegisterNetEvent('idcard:ruhsatgoster')
AddEventHandler('idcard:ruhsatgoster', function()
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
      TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'license')
    else
        exports['mythic_notify']:SendAlert('inform', 'Yakında birisi yok', 2500)
    end
end)

RegisterNetEvent('animasyon:iptal')
AddEventHandler('animasyon:iptal', function()
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('neon:all')
AddEventHandler('neon:all', function()
   ExecuteCommand('neonai')
end)

RegisterNetEvent('neon:right')
AddEventHandler('neon:right', function()
   ExecuteCommand('neonaidesine')
end)

RegisterNetEvent('neon:back')
AddEventHandler('neon:back', function()
   ExecuteCommand('neonaigalas')
end)

RegisterNetEvent('neon:left')
AddEventHandler('neon:left', function()
   ExecuteCommand('neonaikaire')
end)

RegisterNetEvent('neon:front')
AddEventHandler('neon:front', function()
   ExecuteCommand('neonaipriekis')
end)

rootMenuConfig =  {
    -- {
    --     id = "general",
    --     displayName = "Animasyon",
    --     icon = "#anims",
    --     enableMenu = function()
    --     fuck = exports["esx_ambulancejob"]:GetDeath()
    --     if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
    --         return not fuck
    --     end        end,
    --     functionName = "dp:RecieveMenu"
    --     --subMenus = {"general:flipvehicle",  "general:checkoverself", "general:checktargetstates",  "general:emotes",  "general:checkvehicle", --[["general:apartgivekey" "general:aparttakekey"]]}
    -- },
    {
        id = "car",
        displayName = "Araç",
        icon = "#general-keys-give",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            return not fuck
        end
        end,
        subMenus = {"general:keysgive", "general:checkvehicle", "carmenu:hood","carmenu:trunk", "carmenu:camac", "carmenu:engine"}
    },
    {
        id = "neon",
        displayName = "Neon",
        icon = "#general-keys-give",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            return not fuck
        end
        end,
        subMenus = {"neon:all", "neon:right", "neon:left", "neon:front", "neon:back"}
    },
    {
        id = "fizzfaugenel",
        displayName = "Genel",
        icon = "#general",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            return not fuck
        end        end,
        --functionName = "fizzfau:clothingmenu"
        subMenus = {"cloth:open", "dp:RecieveMenu", "fizzfau:tasi","anim:cancel"}
    },
    {
        id = "id",
        displayName = "Kimlik",
        icon = "#id-card-symbol",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
        if FIZZ.IDCard then
            return not fuck
        end
        end,
        subMenus = {"idcard:goster", "idcard:gor", "idcard:ehliyetgor", "idcard:ehliyetgoster", "idcard:ruhsatgoster", "idcard:ruhsatgor"}
    },
    {
        id = "blips",
        displayName = "Blipler",
        icon = "#blips",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
        if IsPedInAnyVehicle(GetPlayerPed(-1), true) and FIZZ.Cloth then
            return not fuck
        end
        end,
        subMenus = {"blips:motel", "blips:fuelstation", --[["blips:garage",]] "blips:hospital", "blips:clear", "blips:cardealer", "blips:police"}
    },
    {
        id = "police-action",
        displayName = "Polis Eylemleri",
        icon = "#police-action",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "police" and not fuck then
                return true
            end
        end,
        subMenus = {"cuffs:cuff", "cuffs:softcuff", "cuffs:uncuff", "police:escort", "police:putinvehicle", "police:unseatnearest", "cuffs:checkinventory", --[[ "cuffs:remmask",  "police:frisk", ]]--[[ "police:removeweapons" "police:revive",]] "police:gsr", "mechanic:hijack","police:impound", "police:checklicenses", "police:checkbank", "police:communityservice", "police:jailmenu", "police:billing"}
    },
    {
        id = "police-action",
        displayName = "Şerif Eylemleri",
        icon = "#police-action",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "sheriff" and not fuck then
                return true
            end
        end,
        subMenus = {"cuffs:cuff", "cuffs:softcuff", "cuffs:uncuff", "police:escort", "police:putinvehicle", "police:unseatnearest", "cuffs:checkinventory", --[[ "cuffs:remmask",  "police:frisk", ]]--[[ "police:removeweapons" "police:revive",]] "police:gsr", "mechanic:hijack", "police:openmdt", "police:impound", "police:checklicenses", "police:checkbank", "police:communityservice", "police:jailmenu", "police:billing"}
    },
    

    -- {
    --     id = "police-vehicle",
    --     displayName = "Police Vehicle",
    --     icon = "#police-vehicle",
    --     enableMenu = function()
    --     local ped = PlayerPedId()
    --        PlayerData = ESX.GetPlayerData()
    --        fuck = exports["esx_ambulancejob"]:GetDeath()
    --         if PlayerData.job.name == "police" and not fuck and IsPedInAnyVehicle(PlayerPedId(), false) then
    --             return true
    --         end
    --     end,
    --     subMenus = {--[[ "general:unseatnearest", ]] "police:runplate", --[[ "police:toggleradar" ]]}
    -- },
    {
        id = "policeDead",
        displayName = "10-99",
        icon = "#police-dead",
        functionName = "officerdown",
        enableMenu = function()
        local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "police" and fuck then
                return true
            end
        end,
    },
    {
        id = "citizenDead",
        displayName = "911",
        icon = "#citizen-dead",
        functionName = "st:distress",
        enableMenu = function()
        local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if fuck then
                return true
            end
        end,
    },
    {
        id = "emsDead",
        displayName = "10-99B",
        icon = "#ems-dead",
        functionName = "officerdown2",
        enableMenu = function()
        local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "ambulance" and fuck then
                return true
            end
        end,
    },
    {
        id = "k9",
        displayName = "K9",
        icon = "#k9",
        enableMenu = function()
        local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if FIZZ.K9Enable and PlayerData.job.name == "police" and PlayerData.job.grade == 3 and not fuck then
                return true
            end
        end,
        subMenus = {"k9:spawn", "k9:follow", "k9:vehicle", "k9:sniffvehicle", "k9:sit", "k9:stand", "k9:sniff", "k9:lay" }
    },
    {
        id = "animations",
        displayName = "Yürüyüş Stilleri",
        icon = "#walking",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            return not fuck
        end
        end,
        subMenus = {"animations:brave", "animations:hurry", "animations:cop", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien" }
    },
    -- {
    --     id = "stopanim",
    --     displayName = "Animasyon İptali",
    --     icon = "#anims",
    --     enableMenu = function()
    --     fuck = exports["esx_ambulancejob"]:GetDeath()
    --     if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
    --         return not fuck
    --     end        end,
    --     functionName = "animasyon:iptal"
    --     --subMenus = {"general:flipvehicle",  "general:checkoverself", "general:checktargetstates",  "general:emotes",  "general:checkvehicle", --[["general:apartgivekey" "general:aparttakekey"]]}
    -- },
    {
        id = "prop",
        displayName = "Prop",
        icon = "#prop",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
        if FIZZ.Prop and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and PlayerData.job.name ~= 'police' then
            return not fuck
        end        end,
 
        subMenus = {"prop:sil", "prop:koy", "prop:briefcase", "prop:boombox", "prop:box", "prop:cashbag"}

    },
    {
        id = "prop",
        displayName = "Prop",
        icon = "#prop",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
        if FIZZ.Prop and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and PlayerData.job.name == 'police' then
            return not fuck
        end        end,
        subMenus = {"prop:sil", "prop:koy", "prop:briefcase", "prop:boombox", "prop:medkit", "prop:box", "prop:cashbag", "prop:cone", "prop:spike", "prop:barrier"}
    },
    -- {
    --     id = "clothe",
    --     displayName = "Kıyafet",
    --     icon = "#tshirt",
    --     enableMenu = function()
    --     fuck = exports["esx_ambulancejob"]:GetDeath()
    --     if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
    --         return not fuck
    --     end        end,
    --     functionName = "fizzfau:clothingmenu"
    --     --subMenus = {"cloth:Top","cloth:Shirt","cloth:Pants","cloth:Shoes","props:Glasses","cloth:Bagoff"}
    -- },
    {
        id = "expressions",
        displayName = "Ruh Hali",
        icon = "#expressions",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            return not fuck
        end
        end,
        subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        id = "judge-raid",
        displayName = "Judge Raid",
        icon = "#judge-raid",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "judge-raid:checkowner", "judge-raid:seizeall", "judge-raid:takecash", "judge-raid:takedm"}
    },
    {
        id = "judge-licenses",
        displayName = "Judge Licenses",
        icon = "#judge-licenses",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "police:checklicenses", "judge:grantDriver", "judge:grantBusiness", "judge:grantWeapon", "judge:grantHouse", "judge:grantBar", "judge:grantDA", "judge:removeDriver", "judge:removeBusiness", "judge:removeWeapon", "judge:removeHouse", "judge:removeBar", "judge:removeDA", "judge:denyWeapon", "judge:denyDriver", "judge:denyBusiness", "judge:denyHouse" }
    },
--[[     {
        id = "judge-actions",
        displayName = "Judge Actions",
        icon = "#judge-actions",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "police:cuff", "cuffs:uncuff", "general:escort", "police:frisk", "cuffs:checkinventory", "police:checkbank"}
    }, ]]
    {
        id = "judge-actions",
        displayName = "Mekanik Eylemleri",
        icon = "#police-vehicle",
        enableMenu = function()
            local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "amekanik" and not fuck then
                return true
            end
        end,
        subMenus = { "mechanic:hijack", "mechanic:repair", "mechanic:clean", "mechanic:impound", "mechanic:fatura"}
    },
    {
        id = "judge-actions",
        displayName = "Mekanik Eylemleri",
        icon = "#police-vehicle",
        enableMenu = function()
            local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "mechanic1" and not fuck then
                return true
            end
        end,
        subMenus = { "mechanic:hijack", "mechanic:repair", "mechanic:clean", "mechanic:impound", "mechanic:fatura"}
    },
    {
        id = "judge-actions",
        displayName = "Mekanik Eylemleri",
        icon = "#police-vehicle",
        enableMenu = function()
            local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "mechanic2" and not fuck then
                return true
            end
        end,
        subMenus = { "mechanic:hijack", "mechanic:repair", "mechanic:clean", "mechanic:impound", "mechanic:fatura"}
    },
    {
        id = "judge-actions",
        displayName = "Mekanik Eylemleri",
        icon = "#police-vehicle",
        enableMenu = function()
            local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "mechanic3" and not fuck then
                return true
            end
        end,
        subMenus = { "mechanic:hijack", "mechanic:repair", "mechanic:clean", "mechanic:impound", "mechanic:fatura"}
    },
    {
        id = "judge-actions",
        displayName = "Mekanik Eylemleri",
        icon = "#police-vehicle",
        enableMenu = function()
            local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "mechanic4" and not fuck then
                return true
            end
        end,
        subMenus = { "mechanic:hijack", "mechanic:repair", "mechanic:clean", "mechanic:impound", "mechanic:fatura"}
    },
    {
        id = "judge-actions",
        displayName = "Mekanik Eylemleri",
        icon = "#police-vehicle",
        enableMenu = function()
            local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "mechanic5" and not fuck then
                return true
            end
        end,
        subMenus = { "mechanic:hijack", "mechanic:repair", "mechanic:clean", "mechanic:impound", "mechanic:fatura"}
    },
    {
        id = "medic",
        displayName = "EMS",
        icon = "#medic",
        enableMenu = function()
        local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["esx_ambulancejob"]:GetDeath()
            if PlayerData.job.name == "ambulance" and not fuck then
                return true
            end
        end,
        subMenus = {"medic:revive", "medic:heal", "medic:bigheal", "medic:putinvehicle", "medic:takeoutvehicle", "medic:drag" }
    },
    {
        id = "doctor",
        displayName = "Doktor",
        icon = "#doctor",
        enableMenu = function()
            return (not isDead and isDoctor)
        end,
        subMenus = { "general:escort", "medic:revive", "general:checktargetstates", "medic:heal" }
    },
    {
        id = "news",
        displayName = "Haber",
        icon = "#news",
        enableMenu = function()
            return (not isDead and isNews)
        end,
        subMenus = { "news:setCamera", "news:setMicrophone", "news:setBoom" }
    },
--[[     {
        id = "vehicle",
        displayName = "Vehicle",
        icon = "#vehicle-options-vehicle",
        functionName = "veh:options",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
            if not fuck and IsPedInAnyVehicle(PlayerPedId(), false) then
                return true
            end
        end,
    }, ]]
    {
        id = "impound",
        displayName = "Aracı Çek",
        icon = "#impound-vehicle",
        functionName = "impoundVehicle",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
            if not fuck and myJob == "towtruck" and #(GetEntityCoords(PlayerPedId()) - vector3(549.47796630859, -55.197559356689, 71.069190979004)) < 10.599 then
                return true
            end
            return false
        end
    }, {
        id = "oxygentank",
        displayName = "Oksijen Tankı Tak",
        icon = "#oxygen-mask",
        functionName = "RemoveOxyTank",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
            return not fuck and hasOxygenTankOn
        end
    }, {
        id = "cocaine-status",
        displayName = "Talep Durumu",
        icon = "#cocaine-status",
        functionName = "cocaine:currentStatusServer",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
            if not fuck and gangNum == 2 and #(GetEntityCoords(PlayerPedId()) - vector3(1087.3937988281,-3194.2138671875,-38.993473052979)) < 0.5 then
                return true
            end
            return false
        end
    }, {
        id = "cocaine-crate",
        displayName = "Snadığı Kaldır",
        icon = "#cocaine-crate",
        functionName = "cocaine:methCrate",
        enableMenu = function()
        fuck = exports["esx_ambulancejob"]:GetDeath()
            if not fuck and gangNum == 2 and #(GetEntityCoords(PlayerPedId()) - vector3(1087.3937988281,-3194.2138671875,-38.993473052979)) < 0.5 then
                return true
            end
            return false
        end
    }
}

newSubMenus = {
    ['idcard:gor'] = {
        title = "Kimlik Gör",
        icon = "#id-card-symbol-v3",
        functionName = "idcard:gor"
    },    
    ['idcard:goster'] = {
        title = "Kimlik Göster",
        icon = "#id-card-symbol-v3",
        functionName = "idcard:goster"
    },  
    ['idcard:ehliyetgoster'] = {
        title = "Ehliyet Göster",
        icon = "#id-card-symbol-v2",
        functionName = "idcard:ehliyetgoster"
    },
    ['idcard:ehliyetgor'] = {
        title = "Ehliyet Gör",
        icon = "#id-card-symbol-v2",
        functionName = "idcard:ehliyetgor"
    },  
    ['idcard:ruhsatgor'] = {
        title = "Silah Ruhsatı Gör",
        icon = "#police-vehicle-plate",
        functionName = "idcard:ruhsatgor"
    }, 
    ['idcard:ruhsatgoster'] = {
        title = "Silah Ruhsatı Göster",
        icon = "#police-vehicle-plate",
        functionName = "idcard:ruhsatgoster"
    },
    ['general:emotes'] = {
        title = "Emotes",
        icon = "#general-emotes",
        functionName = "dp:RecieveMenu"
    },  
    ['carmenu:hood'] = {
        title = "Kaput",
        icon = "#general-keys-give",
        functionName = "fizz:hood"
    },
    ['carmenu:neon'] = {
        title = "Car Key",
        icon = "#general-keys-give",
        functionName = "fizz:carlock"
    },
    ['carmenu:trunk'] = {
        title = "Bagaj",
        icon = "#general-keys-give",
        functionName = "fizz:trunk"
    },
    ['neon:all'] = {
        title = "Neon Tüm",
        icon = "#general-keys-give",
        functionName = "neon:all"
    },
    ['neon:left'] = {
        title = "Neon Sol",
        icon = "#general-keys-give",
        functionName = "neon:left"
    },
    ['neon:right'] = {
        title = "Neon Sağ",
        icon = "#general-keys-give",
        functionName = "neon:right"
    },
    ['neon:front'] = {
        title = "Neon Ön",
        icon = "#general-keys-give",
        functionName = "neon:front"
    },
    ['neon:back'] = {
        title = "Neon Arka",
        icon = "#general-keys-give",
        functionName = "neon:back"
    },
    ['carmenu:camac'] = {
        title = "Camlar",
        icon = "#general-keys-give",
        functionName = "fizz:camac"
    },  
    ['carmenu:engine'] = {
        title = "Motor",
        icon = "#general-keys-give",
        functionName = "fizz:engine"
    },  
    ['general:keysgive'] = {
        title = "",
        icon = "#general-keys-",
        functionName = "fizzfau:givekey"
    },
    ['general:apartgivekey'] = {
        title = "Give Key",
        icon = "#general-apart-givekey",
        functionName = "menu:givekeys"
    },
    ['general:aparttakekey'] = {
        title = "Take Key",
        icon = "#general-apart-givekey",
        functionName = "menu:takekeys"
    },
--[[     ['general:checkoverself'] = {
        title = "Examine Self",
        icon = "#general-check-over-self",
        functionName = "Evidence:CurrentDamageList"
    },
    ['general:checktargetstates'] = {
        title = "Examine Target",
        icon = "#general-check-over-target",
        functionName = "requestWounds"
    }, ]]
--[[     ['general:checkvehicle'] = {
        title = "Examine Vehicle",
        icon = "#general-check-vehicle",
        functionName = "towgarage:annoyedBouce"
    }, ]]
    ['general:putinvehicle'] = {
        title = "Araç Koltuğu",
        icon = "#general-put-in-veh",
        functionName = "police:forceEnter"
    },
    ['general:unseatnearest'] = {
        title = "Yerden Kaldır",
        icon = "#general-unseat-nearest",
        functionName = "unseatPlayer"
    },    
    ['general:flipvehicle'] = {
        title = "Flip Aracı",
        icon = "#general-flip-vehicle",
        functionName = "FlipVehicle"
    },
    ['animations:brave'] = {
        title = "Cesur",
        icon = "#animation-brave",
        functionName = "AnimSet:Brave"
    },
    ['animations:cop'] = {
        title = "Polis",
        icon = "#police-action",
        functionName = "AnimSet:police"
    },
    ['animations:hurry'] = {
        title = "Acele",
        icon = "#animation-hurry",
        functionName = "AnimSet:Hurry"
    },
    ['animations:business'] = {
        title = "İş",
        icon = "#animation-business",
        functionName = "AnimSet:Business"
    },
    ['animations:tipsy'] = {
        title = "Alkollü",
        icon = "#animation-tipsy",
        functionName = "AnimSet:Tipsy"
    },
    ['animations:injured'] = {
        title = "Yaralı",
        icon = "#animation-injured",
        functionName = "AnimSet:Injured"
    },
    ['animations:tough'] = {
        title = "Zorlu",
        icon = "#animation-tough",
        functionName = "AnimSet:ToughGuy"
    },
    ['animations:sassy'] = {
        title = "Şımarık",
        icon = "#animation-sassy",
        functionName = "AnimSet:Sassy"
    },
    ['animations:sad'] = {
        title = "Üzgün",
        icon = "#animation-sad",
        functionName = "AnimSet:Sad"
    },
    ['animations:posh'] = {
        title = "Lüks",
        icon = "#animation-posh",
        functionName = "AnimSet:Posh"
    },
    ['animations:alien'] = {
        title = "Yabancı",
        icon = "#animation-alien",
        functionName = "AnimSet:Alien"
    },
    ['animations:nonchalant'] =
    {
        title = "Soğukkanlı",
        icon = "#animation-nonchalant",
        functionName = "AnimSet:NonChalant"
    },
    ['animations:hobo'] = {
        title = "Serseri",
        icon = "#animation-hobo",
        functionName = "AnimSet:Hobo"
    },
    ['animations:money'] = {
        title = "Zengin",
        icon = "#animation-money",
        functionName = "AnimSet:Money"
    },
    ['animations:swagger'] = {
        title = "Çalımlı",
        icon = "#animation-swagger",
        functionName = "AnimSet:Swagger"
    },
    ['animations:shady'] = {
        title = "Gizemli",
        icon = "#animation-shady",
        functionName = "AnimSet:Shady"
    },
    ['animations:maneater'] = {
        title = "Baştan Çıkaran",
        icon = "#animation-maneater",
        functionName = "AnimSet:ManEater"
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        functionName = "AnimSet:ChiChi"
    },
    ['animations:default'] = {
        title = "Normal",
        icon = "#animation-default",
        functionName = "AnimSet:default"
    },
    ['mechanic:hijack'] = {
        title = "Aracın Kilidini Aç",
        icon = "#open-lock",
        functionName = "st:hijack"
    },
    ['mechanic:repair'] = {
        title = "Tamir",
        icon = "#general-check-vehicle",
        functionName = "st:mechrepair"
    },
    ['mechanic:clean'] = {
        title = "Temizle",
        icon = "#broom-fizz",
        functionName = "st:mechclean"
    },
    ['mechanic:impound'] = {
        title = "El Koy",
        icon = "#police-vehicle",
        functionName = "st:mechimpound"
    },
    ['mechanic:fatura'] = {
        title = "Fatura",
        icon = "#fine-amount",
        functionName = "st:fatura"
    },
    ['k9:spawn'] = {
        title = "Çağır/Gönder",
        icon = "#k9-spawn",
        functionName = "k9:summon"
    },
    ['k9:delete'] = {
        title = "İptal",
        icon = "#k9-dismiss",
        functionName = "k9:dismiss"
    },
    ['k9:follow'] = {
        title = "Takip Et",
        icon = "#k9-follow",
        functionName = "K9:ToggleFollow"
    },
    ['k9:vehicle'] = {
        title = "Araca Bin",
        icon = "#k9-vehicle",
        functionName = "k9:vehicletoggle"
    },
    ['k9:sit'] = {
        title = "Otur",
        icon = "#k9-sit",
        functionName = "k9:sit"
    },
    ['k9:lay'] = {
        title = "Yat",
        icon = "#k9-lay",
        functionName = "k9:lay"
    },
    ['k9:stand'] = {
        title = "Kalk",
        icon = "#k9-stand",
        functionName = "k9:stand"
    },
    ['k9:sniff'] = {
        title = "Kişiyi Ara",
        icon = "#k9-sniff",
        functionName = "k9:searchplayer"
    },
    ['k9:sniffvehicle'] = {
        title = "Aracı Ara",
        icon = "#k9-sniff-vehicle",
        functionName = "k9:vehiclesearch"
    },
    ['k9:huntfind'] = {
        title = "Yakındakine Saldır",
        icon = "#k9-huntfind",
        functionName = "k9:attack"
    }, 
--[[     ['judge-raid:checkowner'] = {
        title = "Check Owner",
        icon = "#judge-raid-check-owner",
        functionName = "appartment:CheckOwner"
    },
    ['judge-raid:seizeall'] = {
        title = "Seize All Content",
        icon = "#judge-raid-seize-all",
        functionName = "appartment:SeizeAll"
    },
    ['judge-raid:takecash'] = {
        title = "Take Cash",
        icon = "#judge-raid-take-cash",
        functionName = "appartment:TakeCash"
    },
    ['judge-raid:takedm'] = {
        title = "Take Marked Bills",
        icon = "#judge-raid-take-dm",
        functionName = "appartment:TakeDM"
    }, ]]
    ['cuffs:cuff'] = {
        title = "Sert Kelepçe",
        icon = "#cuffs-cuff",
        functionName = "st:handcuff"
    }, 
    ['cuffs:softcuff'] = {
        title = "Hafif Kelepçe",
        icon = "#cuffs-cuff",
        functionName = "st:softhandcuff"
    },
    ['cuffs:uncuff'] = {
        title = "Kelepçeyi Çöz",
        icon = "#cuffs-uncuff",
        functionName = "st:uncuff"
    },
--[[     ['cuffs:remmask'] = {
        title = "Remove Mask Hat",
        icon = "#cuffs-remove-mask",
        functionName = "police:remmask"
    }, ]]
    ['cuffs:checkinventory'] = {
        title = "Kişi Ara",
        icon = "#cuffs-check-inventory",
        functionName = "st:search"
    },
    ['cuffs:unseat'] = {
        title = "Araçtan Çıkar",
        icon = "#cuffs-unseat-player",
        functionName = "esx_ambulancejob:pullOutVehicle"
    },
    ['cuffs:checkphone'] = {
        title = "Read Phone",
        icon = "#cuffs-check-phone",
        functionName = "police:checkPhone"
    },
    ['medic:revive'] = {
        title = "İlkyardım",
        icon = "#medic-revive",
        functionName = "st:emsRevive"
    },
    ['medic:heal'] = {
        title = "Hafif Müdahale",
        icon = "#medic-heal",
        functionName = "st:emssmallheal"
    },
    ['medic:bigheal'] = {
        title = "Ciddi Müdahale",
        icon = "#ciddimud",
        functionName = "st:emsbigheal"
    },
    ['medic:putinvehicle'] = {
        title = "Araça Koy",
        icon = "#general-put-in-veh",
        functionName = "st:emsputinveh"
    },
    ['medic:takeoutvehicle'] = {
        title = "Araçtan Çıkar",
        icon = "#general-unseat-nearest",
        functionName = "st:emstakeoutvehicle"
    },
    ['medic:drag'] = {
        title = "Yaralıyı Taşı / Bırak",
        icon = "#general-escort",
        functionName = "ambulance:dragfalan"
    },
    ['medic:undrag'] = {
        title = "Bırak",
        icon = "#general-escort",
        functionName = "st:emsundrag"
    },
    ['police:escort'] = {
        title = "Taşı",
        icon = "#general-escort",
        functionName = "st:escort"
    },
    -- ['police:revive'] = {
    --     title = "Revive",
    --     icon = "#medic-revive",
    --     functionName = "st:pdrevive"
    -- },
    ['police:putinvehicle'] = {
        title = "Araca Koy",
        icon = "#general-put-in-veh",
        functionName = "st:emsputinveh"
    },
    ['police:unseatnearest'] = {
        title = "Araçtan Çıkar",
        icon = "#general-unseat-nearest",
        functionName = "st:takeoutvehicle"
    },
    ['police:impound'] = {
        title = "El Koy",
        icon = "#police-vehicle",
        functionName = "st:mechimpound"
    },
    ['police:cuff'] = {
        title = "Kelepçele",
        icon = "#cuffs-cuff",
        functionName = "police:cuffFromMenu"
    },
    ['police:checkbank'] = {
        title = "Ödenmemiş Fatura",
        icon = "#check-bills",
        functionName = "police:checkBank"
    },
    ['police:billing'] = {
        title = "Fatura",
        icon = "#fine-amount",
        functionName = "police:billing"
    },
    ['police:checklicenses'] = {
        title = "Lisanslar",
        icon = "#police-check-licenses",
        functionName = "police:checkLicenses"
    },
--[[     ['police:removeweapons'] = {
        title = "Remove Weapons License",
        icon = "#police-action-remove-weapons",
        functionName = "police:removeWeapon"
    }, ]]
    ['police:gsr'] = {
        title = "GSR Test",
        icon = "#police-action-gsr",
        functionName = "st:checkGSR"
    },
    ['police:openmdt'] = {
        title = "MDT",
        icon = "#mdt-fizz",
        functionName = "st:openmdt"
    },
    ['police:getid'] = {
        title = "Kimlik",
        icon = "#id-card-symbol",
        functionName = "st:getid"
    },
--[[     ['police:toggleradar'] = {
        title = "Toggle Radar",
        icon = "#police-vehicle-radar",
        functionName = "startSpeedo"
    }, ]]
    ['police:communityservice'] = {
        title = "Kamu Hizmeti",
        icon = "#broom-fizz",
        functionName = "police:communityservice"
    },
    ['police:jailmenu'] = {
        title = "Hapis",
        icon = "#jail-fizz",
        functionName = "police:jailmenu"
    },
--[[     ['police:frisk'] = {
        title = "Frisk",
        icon = "#police-action-frisk",
        functionName = "police:frisk"
    }, ]]
    ['judge:grantDriver'] = {
        title = "Grant Drivers",
        icon = "#judge-licenses-grant-drivers",
        functionName = "police:grantDriver"
    }, 
    ['judge:grantBusiness'] = {
        title = "Grant Business",
        icon = "#judge-licenses-grant-business",
        functionName = "police:grantBusiness"
    },  
    ['judge:grantWeapon'] = {
        title = "Grant Weapon",
        icon = "#judge-licenses-grant-weapon",
        functionName = "police:grantWeapon"
    },
    ['judge:grantHouse'] = {
        title = "Grant House",
        icon = "#judge-licenses-grant-house",
        functionName = "police:grantHouse"
    },
    ['judge:grantBar'] = {
        title = "Grant BAR",
        icon = "#judge-licenses-grant-bar",
        functionName = "police:grantBar"
    },
    ['judge:grantDA'] = {
        title = "Grant DA",
        icon = "#judge-licenses-grant-da",
        functionName = "police:grantDA"
    },
    ['judge:removeDriver'] = {
        title = "Remove Drivers",
        icon = "#judge-licenses-remove-drivers",
        functionName = "police:removeDriver"
    },
    ['judge:removeBusiness'] = {
        title = "Remove Business",
        icon = "#judge-licenses-remove-business",
        functionName = "police:removeBusiness"
    },
    ['judge:removeWeapon'] = {
        title = "Remove Weapon",
        icon = "#judge-licenses-remove-weapon",
        functionName = "police:removeWeapon"
    },
    ['judge:removeHouse'] = {
        title = "Remove House",
        icon = "#judge-licenses-remove-house",
        functionName = "police:removeHouse"
    },
    ['judge:removeBar'] = {
        title = "Remove BAR",
        icon = "#judge-licenses-remove-bar",
        functionName = "police:removeBar"
    },
    ['judge:removeDA'] = {
        title = "Remove DA",
        icon = "#judge-licenses-remove-da",
        functionName = "police:removeDA"
    },
    ['police:object'] = {
        title = "Obje Menüsü",
        icon = "#judge-licenses-remove-da",
        functionName = "police:object"
    },
    ['judge:denyWeapon'] = {
        title = "Deny Weapon",
        icon = "#judge-licenses-deny-weapon",
        functionName = "police:denyWeapon"
    },
    ['judge:denyDriver'] = {
        title = "Deny Drivers",
        icon = "#judge-licenses-deny-drivers",
        functionName = "police:denyDriver"
    },
    ['judge:denyBusiness'] = {
        title = "Deny Business",
        icon = "#judge-licenses-deny-business",
        functionName = "police:denyBusiness"
    },
    ['judge:denyHouse'] = {
        title = "Deny House",
        icon = "#judge-licenses-deny-house",
        functionName = "police:denyHouse"
    },
    ['news:setCamera'] = {
        title = "Camera",
        icon = "#news-job-news-camera",
        functionName = "camera:setCamera"
    },
    ['news:setMicrophone'] = {
        title = "Microphone",
        icon = "#news-job-news-microphone",
        functionName = "camera:setMic"
    },
    ['news:setBoom'] = {
        title = "Microphone Boom",
        icon = "#news-job-news-boom",
        functionName = "camera:setBoom"
    },
    ['weed:currentStatusServer'] = {
        title = "Request Status",
        icon = "#weed-cultivation-request-status",
        functionName = "weed:currentStatusServer"
    },   
    ['weed:weedCrate'] = {
        title = "Remove A Crate",
        icon = "#weed-cultivation-remove-a-crate",
        functionName = "weed:weedCrate"
    },
    ['cocaine:currentStatusServer'] = {
        title = "Request Status",
        icon = "#meth-manufacturing-request-status",
        functionName = "cocaine:currentStatusServer"
    },
    ['cocaine:methCrate'] = {
        title = "Remove A Crate",
        icon = "#meth-manufacturing-remove-a-crate",
        functionName = "cocaine:methCrate"
    },
    ["expressions:angry"] = {
        title="Sinirli",
        icon="#expressions-angry",
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" }
    },
    ["expressions:drunk"] = {
        title="Sarhoş",
        icon="#expressions-drunk",
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" }
    },
    ["expressions:dumb"] = {
        title="Aptal",
        icon="#expressions-dumb",
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" }
    },
    ["expressions:electrocuted"] = {
        title="Şok",
        icon="#expressions-electrocuted",
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" }
    },
    ["expressions:grumpy"] = {
        title="Huysuz",
        icon="#expressions-grumpy",
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" }
    },
    ["expressions:happy"] = {
        title="Mutlu",
        icon="#expressions-happy",
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" }
    },
    ["expressions:injured"] = {
        title="Yaralı",
        icon="#expressions-injured",
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" }
    },
    ["expressions:joyful"] = {
        title="Neşeli",
        icon="#expressions-joyful",
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" }
    },
    ["expressions:mouthbreather"] = {
        title="Ağzı Açık",
        icon="#expressions-mouthbreather",
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" }
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        functionName = "expressions:clear"
    },
    ["expressions:oneeye"]  = {
        title="Tek Göz",
        icon="#expressions-oneeye",
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" }
    },
    ["expressions:shocked"]  = {
        title="Şok Olmuş",
        icon="#expressions-shocked",
        functionName = "expressions",
        functionParameters = { "shocked_1" }
    },
    ["expressions:sleeping"]  = {
        title="Uykulu",
        icon="#expressions-sleeping",
        functionName = "expressions",
        functionParameters = { "dead_1" }
    },
    ["expressions:smug"]  = {
        title="Kibirli",
        icon="#expressions-smug",
        functionName = "expressions",
        functionParameters = { "mood_smug_1" }
    },
    ["expressions:speculative"]  = {
        title="Düşündürücü",
        icon="#expressions-speculative",
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" }
    },
    ["expressions:stressed"]  = {
        title="Stresli",
        icon="#expressions-stressed",
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" }
    },
    ["expressions:sulking"]  = {
        title="Somurtgan",
        icon="#expressions-sulking",
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
    },
    ["expressions:weird"]  = {
        title="Tuhaf",
        icon="#expressions-weird",
        functionName = "expressions",
        functionParameters = { "effort_2" }
    },
    ["expressions:weird2"]  = {
        title="Tuhaf 2",
        icon="#expressions-weird2",
        functionName = "expressions",
        functionParameters = { "effort_3" }
    },
    ["t1ger:menu"]  = {
        title="Tiger Carmenu",
        icon="#expressions-weird2",
        functionName = "t1ger:carmenu"
    },
    ["blips:motel"]  = {
        title="Motel",
        icon="#motel-building",
        functionName = "blips:motel"
    },
    ["blips:fuelstation"]  = {
        title="Benzinlik",
        icon="#gas-pump",
        functionName = "blips:fuel"
    },
    ["blips:garage"]  = {
        title="Garaj",
        icon="#gas-cardealer",
        functionName = "blips:garage"
    },
    ["blips:clear"]  = {
        title="Kaldır",
        icon="#k9-dismiss",
        functionName = "blips:clear"
    },
    ["blips:hospital"]  = {
        title="Hastane",
        icon="#hospital-building",
        functionName = "blips:hospital"
    },
    ["blips:police"]  = {
        title="Karakol",
        icon="#pd-station",
        functionName = "blips:police"
    },
    ["police:eup"]  = {
        title="Kıyafet Menüsü",
        icon="#tshirt",
        functionName = "police:eup"
    },
    ["blips:cardealer"]  = {
        title="Galeri",
        icon="#cardealer",
        functionName = "blips:cardealer"
    },
    ["prop:briefcase"]  = {
        title="Çanta",
        icon="#brief-case",
        functionName = "prop:briefcase"
    },
    ["prop:cone"]  = {
        title="Koni",
        icon="#cone",
        functionName = "attach:cone"
    },
    ["prop:cashbag"]  = {
        title="Para Çantası",
        icon="#brief-case",
        functionName = "attach:cashbag"
    },
    ["prop:sil"]  = {
        title="Sil",
        icon="#delete-prop",
        functionName = "prop:sil"
    },
    ["prop:boombox"]  = {
        title="Teyip",
        icon="#boombox",
        functionName = "prop:boombox"
    },
    ["prop:koy"]  = {
        title=" Koy / Al",
        icon="#put",
        functionName = "prop:koy"
    },
    ["prop:medkit"]  = {
        title="Medkit",
        icon="#medkit",
        functionName = "attach:medkit"
    },
    ["prop:box"]  = {
        title="Kutu",
        icon="#kutu",
        functionName = "attach:box"
    },
    ["prop:spike"]  = {
        title="Diken",
        icon="#spike",
        functionName = "attach:spike"
    },
    ["prop:barrier"]  = {
        title="Bariyer",
        icon="#barrier",
        functionName = "attach:barrier"
    },
    ["cloth:Top"]  = {
        title="Kıyafetini Giy",
        icon="#tshirt",
        functionName = "clothing:Top"
    },
    ["cloth:Shirt"]  = {
        title="Kıyafetini Giy",
        icon="#tshirt",
        functionName = "clothing:Shirt"
    },
    ["cloth:Pants"]  = {
        title="Pantolon",
        icon="#pantolon",
        functionName = "clothing:Pants"
    },
    ["cloth:Bagoff"]  = {
        title="Çanta",
        icon="#bag",
        functionName = "clothing:Bagoff"
    },
    ["cloth:Shoes"]  = {
        title="Ayakkabı",
        icon="#shoes",
        functionName = "clothing:Shoes"
    },
    ["props:Glasses"]  = {
        title="Gözlük",
        icon="#glasses",
        functionName = "props:Glasses"
    },
    ["cloth:Bagoff"]  = {
        title="Çanta",
        icon="#tshirt",
        functionName = "clothing:Bagoff"
    },
    ["cloth:open"]  = {
        title="Kıyafet",
        icon="#tshirt",
        functionName = "fizzfau:clothingmenu"
    },
    ["anim:cancel"]  = {
        title="Animasyon İptali",
        icon="#anims",
        functionName = "animasyon:iptal"
    },
    ["dp:RecieveMenu"]  = {
        title="Animasyonlar",
        icon="#anims",
        functionName = "dp:RecieveMenu"
    },
    ["fizzfau:tasi"]  = {
        title="Taşı",
        icon="#lift",
        functionName = "esx_barbie_lyftupp"
    },
    ["opt:clothe"]  = {
        title="Kıyafet Aç/Kapa",
        icon="#tshirt",
        functionName = "clotheMenu"
    },
}

RegisterNetEvent("t1ger:carmenu")
AddEventHandler("t1ger:carmenu", function()
    ExecuteCommand('carmenu')
end)

RegisterNetEvent("menu:setCuffState")
AddEventHandler("menu:setCuffState", function(pTargetId, pState)
    cuffStates[pTargetId] = pState
end)


RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent("drivingInstructor:instructorToggle")
AddEventHandler("drivingInstructor:instructorToggle", function(mode)
    if myJob == "driving instructor" then
        isInstructorMode = mode
    end
end)

RegisterNetEvent("police:currentHandCuffedState")
AddEventHandler("police:currentHandCuffedState", function(pIsHandcuffed, pIsHandcuffedAndWalking)
    isHandcuffedAndWalking = pIsHandcuffedAndWalking
    isHandcuffed = pIsHandcuffed
end)

RegisterNetEvent("menu:hasOxygenTank")
AddEventHandler("menu:hasOxygenTank", function(pHasOxygenTank)
    hasOxygenTankOn = pHasOxygenTank
end)

RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(pGangNum)
    gangNum = pGangNum
end)

RegisterNetEvent('st:givekey')
AddEventHandler('st:givekey', function()
    ExecuteCommand('givekeys')
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end
