ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('meka_drugphone:giveCash', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(Config.MoneyItem, amount)
end)

RegisterServerEvent('meka_drugphone:removeCash', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if amount <= 0 then return end

    local cash = xPlayer.getMoney()
    local bank = xPlayer.getAccount('bank').money

    if cash >= amount then
        xPlayer.removeMoney(amount)
    elseif bank >= (amount - cash) then
        local remainingAmount = amount - cash
        xPlayer.removeMoney(cash)
        xPlayer.removeAccountMoney('bank', remainingAmount)
    end
end)

ESX.RegisterServerCallback('meka_drugphone:checkDrug', function(source, cb, drug, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemamount = xPlayer.getInventoryItem(drug).count
    if itemamount ~= nil then
        if itemamount >= amount then
            xPlayer.removeInventoryItem(drug, amount)
            cb(true)
            return
        end
    end
    cb(false)
end)