ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('meka_drugphone:deliverys', function()
    lib.registerContext({
        title = Lang['ACTIONS_TEXT'],
        id = 'drugphone_leveringer',
        onExit = function()
            local playerPed = PlayerPedId()
            DeleteObject(phoneObject)
            phoneObject = nil
            StopAnimTask(playerPed, "cellphone@", "cellphone_text_read_base", 1.0)
        end,
        options = {
            {
                title = Lang['CONTACTS_TXT'],
                description = Lang['CONTACTS_DESC'] .. " " .. #Config.DrugLocations,
                icon = 'fa-solid fa-address-book',
            },
            {
                title = activeText,
                description = Lang['TOGGLE_STATUS_TXT'],
                onSelect = function()
                    if activeStatus then
                        activeStatus = false
                        activeText = '🔴 ' .. Lang['ACTIVE_TEXT_OFF']
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
                    else
                        activeStatus = true
                        activeText = '🟢 ' .. Lang['ACTIVE_TEXT_ON']
                        drugsneeded = Config.DrugsNeeded
                        utils.showNotification(Lang['STARTED_RECEVING_CALLS'], 'inform')
                    end
                    TriggerEvent('meka_drugphone:deliverys')
                end
            },
            {
                title = Lang['TURN_OFF_PHONE_TXT'], 
                description = Lang['TURN_OFF_PHONE_DESC'],
                icon = 'fa-solid fa-mobile-retro',
                onSelect = function()
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
                end
            }
        }
    })
    lib.showContext('drugphone_leveringer')
end)