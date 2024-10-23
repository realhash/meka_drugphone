ESX = exports["es_extended"]:getSharedObject()
Lang = locales[Config.Locale]

activeText = '🔴 ' .. Lang['ACTIVE_TEXT_OFF'] -- 🟢
activeStatus = false
activeMethod = 0
activeopkald = nil
delivertarget = nil
drugtype = {}
drugsneeded = nil
drugPed = nil
drugBox = nil

phoneObject = nil

local CreatePed                       = CreatePed
local FreezeEntityPosition            = FreezeEntityPosition
local SetEntityInvincible             = SetEntityInvincible
local SetBlockingOfNonTemporaryEvents = SetBlockingOfNonTemporaryEvents
local SetModelAsNoLongerNeeded        = SetModelAsNoLongerNeeded
local RegisterNetEvent                = RegisterNetEvent
local AddBlipForCoord                 = AddBlipForCoord
local SetBlipSprite                   = SetBlipSprite
local SetBlipDisplay                  = SetBlipDisplay
local SetBlipScale                    = SetBlipScale
local SetBlipColour                   = SetBlipColour
local SetBlipAsShortRange             = SetBlipAsShortRange
local BeginTextCommandSetBlipName     = BeginTextCommandSetBlipName
local AddTextComponentString          = AddTextComponentString
local EndTextCommandSetBlipName       = EndTextCommandSetBlipName


utils = {}
peds = {}


function utils.createPed(name, coords)
    local model = lib.requestModel(name)

    if not model then return end

    local ped = CreatePed(0, model, coords, false, false)

    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetModelAsNoLongerNeeded(model)

    table.insert(peds, ped)

    return ped
end

function utils.showNotification(msg, type)
    lib.notify({
        title = Lang['DEALER_NAME'],
        description = msg,
        type = type and type or 'info'
    })
end

function utils.debug(msg)
    if Config.Debug then
        print(("^3DEBUG: %s ^7"):format(msg))
    end
end

function utils.getCurrentLocation()
    local playerPed = cache.coords and cache.coords or cache.ped
    local playerCoords = cache.coords or GetEntityCoords(playerPed)
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    local currentArea = GetLabelText(tostring(GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)))
    local currentLocation = currentArea
    if not zone then zone = "UNKNOWN" end

    if currentStreetName and currentStreetName ~= "" then
        currentLocation = currentLocation .. ", " .. currentArea
    end

    return currentLocation
end

function utils.createBlip(data)
    local blip = AddBlipForCoord(data.pos)
    SetBlipSprite(blip, data.type)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, data.scale)
    SetBlipColour(blip, data.colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(blip)

    return blip
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    for k, v in pairs(peds) do
        if DoesEntityExist(v) then
            DeletePed(v)
        end
    end
    activeMethod = 0
    phoneactive = false
    activeStatus = false
    local playerPed = PlayerPedId()
    DeleteWaypoint()
    DeleteObject(phoneObject)
    phoneObject = nil
    StopAnimTask(playerPed, "cellphone@", "cellphone_text_read_base", 1.0)
    if DoesEntityExist(drugPed) then
        DeletePed(drugPed)
    end
    if DoesEntityExist(drugBox) then
        DeleteObject(drugBox)
    end
end)

function debugPrint(...)
    if not Config.Debug then return end
    local args <const> = { ... }
  
    local appendStr = ''
    for _, v in ipairs(args) do
      appendStr = appendStr .. ' ' .. tostring(v)
    end
    local msgTemplate = '^3[%s]^0%s'
    local finalMsg = msgTemplate:format(GetCurrentResourceName(), appendStr)
    print(finalMsg)
end

function errorPrint(...)
    if not Config.Debug then return end
    local args <const> = { ... }
  
    local appendStr = ''
    for _, v in ipairs(args) do
      appendStr = appendStr .. ' ' .. tostring(v)
    end
    local msgTemplate = '^1[%s]^8%s'
    local finalMsg = msgTemplate:format(GetCurrentResourceName(), appendStr)
    print(finalMsg)
end


RegisterNetEvent('meka_drugphone:start', function()
    local playerPed = PlayerPedId()

    RequestAnimDict("cellphone@")
    while not HasAnimDictLoaded("cellphone@") do
        Wait(100)
    end

    phoneObject = CreateObject(GetHashKey("prop_phone_ing"), 0, 0, 0, true, true, true)

    if phoneObject then
        local boneIndex = GetPedBoneIndex(playerPed, 28422)
        AttachEntityToEntity(phoneObject, playerPed, boneIndex, 0.0, 0.015, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

        TaskPlayAnim(playerPed, "cellphone@", "cellphone_text_in", 8.0, -8.0, -1, 49, 0, false, false, false)
        Citizen.Wait(850)

        TaskPlayAnim(playerPed, "cellphone@", "cellphone_text_read_base", 8.0, -8.0, -1, 49, 0, false, false, false)

        if activeMethod == 1 then
            TriggerEvent('meka_drugphone:deliverys')
        else
            lib.showContext('drugphone_main')
        end
    else
        debugPrint("Failed to create phone object.")
    end
end)


lib.registerContext({
    title = Lang['PHONE_SIMCARD1_TITLE'],
    id = 'drugphone_main',
    onExit = function()
        local playerPed = PlayerPedId()
        DeleteObject(phoneObject)
        phoneObject = nil
        StopAnimTask(playerPed, "cellphone@", "cellphone_text_read_base", 1.0)
    end,
    options = {
        {
            title = Lang['PHONE_SIMCARD1_TXT'],
            description = Lang['PHONE_SIMCARD1_DESC'],
            icon = 'fa-solid fa-mobile-retro',
            onSelect = function()
                local drugOptions = {}
                for k,v in pairs(Config.DrugTypes) do
                    table.insert(drugOptions, { label = v.name, value = tostring(k), item = v.item})
                end 
                local input = lib.inputDialog(Lang['TYPE_DRUG'], {
                    {type = 'select', label = 'Drug', options = drugOptions},
                })
 
                if not input then return end
                drugtype = Config.DrugTypes[tonumber(input[1])]

                phoneactive = true
                if lib.progressCircle({
                    duration = 2000,
                    position = 'center',
                    useWhileDead = false,
                    label = Lang['TURN_ON_PHONE_TXT'],
                    canCancel = false,
                }) then
                    activeMethod = 1
                    TriggerEvent('meka_drugphone:deliverys')
                else return end
            end
        }
    }
})

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if activeStatus then
            if not activeOpkald then
                ESX.ShowHelpNotification(Lang['AWAITING_CALL'], true, false, 1)
                local opkaldarg = math.random(1, 250)
                if opkaldarg == 57 then
                    activeOpkald = true
                    ESX.ShowAdvancedNotification(Lang['CUSTOMER'], Lang['CALL_HEADER'], Lang['CUSTOMER_MESSAGE'] .. " " .. drugsneeded .. "x " .. drugtype.name, 'CHAR_DEFAULT', 1)
                    ESX.ShowHelpNotification(Lang['CALL_RECIEVED'], true, false, 2500)
                    local DeliveryLOC = Config.DrugLocations[math.random(1, #Config.DrugLocations)]
                    debugPrint(DeliveryLOC.loc)
                    utils.showNotification(Lang['CUSTOMER_WANTS'] .. drugsneeded .. 'x ' .. drugtype.name, 'inform')
                    if Config.Delivery.Type == "ped" then
                        local pedModel = Config.Delivery.Peds[math.random(1, #Config.Delivery.Peds)]
                        drugPed = utils.createPed(pedModel, DeliveryLOC.loc)
                        SetNewWaypoint(DeliveryLOC.loc.x, DeliveryLOC.loc.y)
                    elseif Config.Delivery.Type == "box" then
                        drugBox = CreateObject(1302435108, DeliveryLOC.loc.x, DeliveryLOC.loc.y, DeliveryLOC.loc.z, true)
                        SetNewWaypoint(DeliveryLOC.loc.x, DeliveryLOC.loc.y)
                    else
                        errorPrint("NO DELIVERY TYPE SET!!!")
                    end

                    if Config.Delivery.Method == 'target' then
                        deliveryTarget = exports.ox_target:addBoxZone({
                            coords = vec3(DeliveryLOC.loc.x, DeliveryLOC.loc.y, DeliveryLOC.loc.z),
                            options = {
                                {
                                    icon = 'fa-solid fa-plant-wilt',
                                    label = Lang['DELIVER'] .. ' ' .. drugtype.name .. ' ' .. Lang['TO_CUSTOMER'],
                                    onSelect = function()

                                        ESX.TriggerServerCallback('meka_drugphone:checkDrug', function(data)
                                            if data then
                                                if Config.Delivery.Type == "ped" then
                                                    local playerPed = PlayerPedId()

                                                    TaskTurnPedToFaceEntity(drugPed, playerPed, -1)
                                                    TaskTurnPedToFaceEntity(playerPed, drugPed, -1)

                                                    Citizen.Wait(500)

                                                    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_MOBILE", 0, true)
                                                    TaskStartScenarioInPlace(drugPed, "WORLD_HUMAN_STAND_MOBILE", 0, true)

                                                    Citizen.Wait(3000)

                                                    ClearPedTasks(playerPed)
                                                    ClearPedTasks(drugPed)
                                                elseif Config.Delivery.Type == "box" then
                                                    local playerPed = PlayerPedId()

                                                    TaskTurnPedToFaceEntity(playerPed, drugBox, -1)

                                                    Citizen.Wait(500)

                                                    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_MOBILE", 0, true)

                                                    Citizen.Wait(3000)

                                                    ClearPedTasks(playerPed)
                                                end
                                                exports.ox_target:removeZone(deliveryTarget)
                                                ESX.ShowAdvancedNotification(Lang['CUSTOMER'], Lang['CALL_HEADER'], Lang['CUSTOMER_THANKS_MSG'], 'CHAR_DEFAULT', 1)
                                                utils.showNotification(Lang['REWARD_MSG'] .. " " .. drugtype.reward .. " " .. Lang['CASH_NAME'], "success")
                                                TriggerServerEvent('meka_drugphone:giveCash', drugtype.reward)
                                                activeOpkald = false
                                                if Config.Delivery.Type == "box" then DeleteObject(drugBox) elseif Config.Delivery.Type == "ped" then DeletePed(drugPed) end
                                            else
                                                exports.ox_target:removeZone(deliveryTarget)
                                                ESX.ShowAdvancedNotification(Lang['CUSTOMER'], Lang['CALL_HEADER'], Lang['CUSTOMER_ANGRY_MSG'], 'CHAR_DEFAULT', 1)
                                                if Config.Delivery.Punishment then
                                                    if Config.Delivery.Chance then
                                                        local randomNum = math.random(1, 2)
                                                        if randomNum == 1 then
                                                            TriggerServerEvent('meka_drugphone:removeCash', Config.Delivery.PunishCost)
                                                            utils.showNotification(Lang['ANGRY_MSG'], "warning")
                                                        end
                                                    else
                                                        utils.showNotification(Lang['ANGRY_MSG'], "warning")
                                                        TriggerServerEvent('meka_drugphone:removeCash', Config.Delivery.PunishCost)
                                                        utils.showNotification(Lang['ANGRY_MSG_LOSE'] .. " " .. Config.Delivery.PunishCost , "warning")
                                                    end
                                                end
                                                activeOpkald = false
                                                if Config.Delivery.Type == "box" then DeleteObject(drugBox) elseif Config.Delivery.Type == "ped" then DeletePed(drugPed) end
                                            end
                                        end, drugtype.item, Config.DrugsNeeded)

                                        opkaldarg = math.random(1, 250)
                                    end
                                }
                            }
                        })
                    elseif Config.Delivery.Method == 'bind' then
                        while true do
                            Citizen.Wait(1)
                            local playerPed = PlayerPedId()
                            local playerCoords = GetEntityCoords(playerPed)
                            local locationCoords = vector3(DeliveryLOC.loc.x, DeliveryLOC.loc.y, DeliveryLOC.loc.z)
                    
                            local distance = #(playerCoords - locationCoords)

                            if distance > Config.Delivery.BindDistance then
                                local isOpen, text = lib.isTextUIOpen()
                                if isOpen then
                                    if text == '[' .. Config.Delivery.Bind .. '] - ' .. Lang['DELIVER'] .. ' ' .. drugtype.name .. ' ' .. Lang['TO_CUSTOMER'] then
                                        lib.hideTextUI()
                                    end
                                end
                            end

                            if activeOpkald then
                                if distance < Config.Delivery.BindDistance then
                                    lib.showTextUI('[' .. Config.Delivery.Bind .. '] - ' .. Lang['DELIVER'] .. ' ' .. drugtype.name .. ' ' .. Lang['TO_CUSTOMER'], {
                                        position = 'right-center',
                                        icon = 'fa-solid fa-plant-wilt'
                                    })
                                    
                                    if IsControlJustPressed(0, Keys[Config.Delivery.Bind]) then
                                        debugPrint("Key Pressed: " .. Config.Delivery.Bind)
                                        ESX.TriggerServerCallback('meka_drugphone:checkDrug', function(data)
                                            if data then
                                                if Config.Delivery.Type == "ped" then
                                                    local playerPed = PlayerPedId()

                                                    TaskTurnPedToFaceEntity(drugPed, playerPed, -1)
                                                    TaskTurnPedToFaceEntity(playerPed, drugPed, -1)

                                                    Citizen.Wait(500)

                                                    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_MOBILE", 0, true)
                                                    TaskStartScenarioInPlace(drugPed, "WORLD_HUMAN_STAND_MOBILE", 0, true)

                                                    Citizen.Wait(3000)

                                                    ClearPedTasks(playerPed)
                                                    ClearPedTasks(drugPed)
                                                elseif Config.Delivery.Type == "box" then
                                                    local playerPed = PlayerPedId()

                                                    TaskTurnPedToFaceEntity(playerPed, drugBox, -1)

                                                    Citizen.Wait(500)

                                                    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_MOBILE", 0, true)

                                                    Citizen.Wait(3000)

                                                    ClearPedTasks(playerPed)
                                                end
                                                exports.ox_target:removeZone(deliveryTarget)
                                                ESX.ShowAdvancedNotification(Lang['CUSTOMER'], Lang['CALL_HEADER'], Lang['CUSTOMER_THANKS_MSG'], 'CHAR_DEFAULT', 1)
                                                utils.showNotification(Lang['REWARD_MSG'] .. " " .. drugtype.reward .. " " .. Lang['CASH_NAME'], "success")
                                                TriggerServerEvent('meka_drugphone:giveCash', drugtype.reward)
                                                activeOpkald = false
                                                if Config.Delivery.Type == "box" then DeleteObject(drugBox) elseif Config.Delivery.Type == "ped" then DeletePed(drugPed) end
                                            else
                                                exports.ox_target:removeZone(deliveryTarget)
                                                ESX.ShowAdvancedNotification(Lang['CUSTOMER'], Lang['CALL_HEADER'], Lang['CUSTOMER_ANGRY_MSG'], 'CHAR_DEFAULT', 1)
                                                if Config.Delivery.Punishment then
                                                    if Config.Delivery.Chance then
                                                        local randomNum = math.random(1, 2)
                                                        if randomNum == 1 then
                                                            TriggerServerEvent('meka_drugphone:removeCash', Config.Delivery.PunishCost)
                                                            utils.showNotification(Lang['ANGRY_MSG'], "warning")
                                                        end
                                                    else
                                                        utils.showNotification(Lang['ANGRY_MSG'], "warning")
                                                        TriggerServerEvent('meka_drugphone:removeCash', Config.Delivery.PunishCost)
                                                        utils.showNotification(Lang['ANGRY_MSG_LOSE'] .. " " .. Config.Delivery.PunishCost , "warning")
                                                    end
                                                end
                                                activeOpkald = false
                                                if Config.Delivery.Type == "box" then DeleteObject(drugBox) elseif Config.Delivery.Type == "ped" then DeletePed(drugPed) end
                                            end
                                        end, drugtype.item, Config.DrugsNeeded)

                                        opkaldarg = math.random(1, 250)
                                        lib.hideTextUI()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            activeOpkald = false
        end
    end
end)