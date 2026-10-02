local oxInventory = exports.ox_inventory

Core = {
    GetFromId = function(src)
        return exports.qbx_core:GetPlayer(tonumber(src))
    end,

    GetJobs = function()
        return exports.qbx_core:GetJobs()
    end,

    GetGangs = function()
        return exports.qbx_core:GetGangs()
    end,

    GetInventory = function(src)
        local inventory = oxInventory:GetInventoryItems(tonumber(src)) or {}
        local result = {}

        for _, item in pairs(inventory) do
            if item and (item.count or 0) > 0 then
                result[#result + 1] = {
                    name = item.name,
                    label = item.label,
                    count = item.count,
                    info = item.metadata or false,
                    slot = item.slot
                }
            end
        end

        return result
    end,

    CanCarryItem = function(src, item, amount)
        return oxInventory:CanCarryItem(tonumber(src), item, tonumber(amount))
    end,

    AddItem = function(src, item, amount)
        return oxInventory:AddItem(tonumber(src), item, tonumber(amount))
    end,

    RemoveItem = function(src, item, amount)
        return oxInventory:RemoveItem(tonumber(src), item, tonumber(amount))
    end,

    HasItem = function(src, item, amount)
        local count = oxInventory:GetItemCount(tonumber(src), item)
        amount = tonumber(amount) or 1
        return count >= amount, count
    end,

    GetItem = function(src, item)
        local itemData = oxInventory:GetItem(tonumber(src), item, nil, false)
        if not itemData or (itemData.count or 0) < 1 then return nil end

        return {
            name = itemData.name,
            label = itemData.label,
            count = itemData.count
        }
    end,

    GetFromIdentifier = function(identifier)
        return exports.qbx_core:GetPlayerByCitizenId(identifier)
    end,

    GetSource = function(src)
        local player = exports.qbx_core:GetPlayer(tonumber(src))
        return player and player.PlayerData.source or nil
    end,

    GetIdentifier = function(src)
        local player = exports.qbx_core:GetPlayer(tonumber(src))
        return player and player.PlayerData.citizenid or nil
    end,

    GetName = function(src)
        local player = exports.qbx_core:GetPlayer(tonumber(src))
        if not player then return GetPlayerName(tonumber(src)) or 'Unknown' end

        local charinfo = player.PlayerData.charinfo or {}
        local fullName = (('%s %s'):format(charinfo.firstname or '', charinfo.lastname or '')):gsub('^%s*(.-)%s*$', '%1')
        return fullName ~= '' and fullName or (GetPlayerName(tonumber(src)) or 'Unknown')
    end
}
