
local QT = exports["dd-library"]:Load()
local WorkShops = {}
local Recipes = {}

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        LoadData()
    end
end)

LoadData = function()
    -- # jobs data

    local jobs = Core.GetJobs()
    GlobalState.Jobs = jobs
    
    if Shared.Framework == "qb" or Shared.Framework == "qbox" then 
        local gangs = Core.GetGangs()
        GlobalState.Gangs = gangs
    end

    -- # main data 

    local jsondata = LoadResourceFile(GetCurrentResourceName(), "data/tables.json")
    if jsondata then
        WorkShops = json.decode(jsondata)
        if jsondata ~= nil then 
          GlobalState.WorkShops = json.decode(jsondata)
        end
        if not WorkShops then
            WorkShops = {}
        end
    end

    -- # items cook data 

    local jsondata2 = LoadResourceFile(GetCurrentResourceName(), "data/items.json")
    if jsondata2 then
        Recipes = json.decode(jsondata2)
        if jsondata2 ~= nil then 
          GlobalState.Recipes = json.decode(jsondata2)
        end
        if not Recipes then
            Recipes = {}
        end
    end

    -- #

end

QT.RegisterServerCall("qt_crafting-CheckPerm", function(source, cb, perm)
    local identifier = QT.GetIdentifier(Shared.PlayersLicense, source)
    if Shared.Commands.perms[perm][identifier] then 
        cb(true) 
    else
        cb(false)
    end
end)

local function hasCommandPermission(src, permission)
    local identifier = QT.GetIdentifier(Shared.PlayersLicense, src)
    return Shared.Commands.perms[permission] and Shared.Commands.perms[permission][identifier] == true
end

local function findRecipe(tableId, itemName, itemLabel)
    local tableRecipes = Recipes[tostring(tableId)] or Recipes[tableId]
    if type(tableRecipes) ~= 'table' then return nil end

    for _, recipe in pairs(tableRecipes) do
        if recipe.item == itemName and (not itemLabel or recipe.label == itemLabel) then
            return recipe
        end
    end
end

local function GenerateTableID()
    local digits = '0123456789'
    local idLength = 8
    local uniqueId = ''
    for i = 1, idLength do
        local randomIndex = math.random(1, #digits)
        uniqueId = uniqueId .. digits:sub(randomIndex, randomIndex)
    end
    return uniqueId
end

RegisterNetEvent("qt_crafting-SetupCraft", function(data)
    if not hasCommandPermission(source, 'create') then return end
    local identifier = QT.GetIdentifier(Shared.PlayersLicense, source)
    local id

    repeat
        id = GenerateTableID()
    until WorkShops[id] == nil

    local new_craftable = {
        id = id, 
        name = data.name, 
        model = data.model, 
        coords = data.coords, 
        blip = data.blip,
        jobs = data.jobs,
        gangs = data.gangs
    }

    WorkShops[id] = new_craftable
    Recipes[id] = {}

    UpdateJSON('workshop')
    UpdateJSON("items")
    
    TriggerClientEvent("qt-sendNotify", source, {
        title = L("main_title"), 
        msg = L("success_create"):format(data.name),
        type = "success"
    })

    LoadData()

    Wait(500)

    TriggerClientEvent("dd-crafting:Re:Sync", -1)
    
    discord_logs(L('server_name'), L("updated_table3"):format(identifier, id))

end)

RegisterNetEvent("qt_crafting-EditActions", function(data)
    if not hasCommandPermission(source, 'edit') then return end
    local identifier = QT.GetIdentifier(Shared.PlayersLicense, source)

    if data.action == "delete" then 

        if GlobalState.WorkShops ~= nil and GlobalState.WorkShops[data.id] ~= nil then 
            WorkShops[data.id] = nil 
            GlobalState.WorkShops = WorkShops 
        end
        if GlobalState.Recipes ~= nil and GlobalState.Recipes[data.id] ~= nil then 
            Recipes[data.id] = nil 
            GlobalState.Recipes = Recipes
        end
        UpdateJSON('workshop')
        UpdateJSON('items')

        discord_logs(L('server_name'), L("updated_table2"):format(identifier, data.action))

    elseif data.action == "add_item" then 
            
        local new_item = {
                item = data.item, 
                recipe = data.recipe,
                label = data.label,
                amount = tonumber(data.amount), 
                craft_time = data.craft_time
        }

        table.insert(Recipes[data.id], new_item)

        GlobalState.Recipes = Recipes

        UpdateJSON('items')

        discord_logs(L('server_name'), L("updated_table2"):format(identifier, data.action))

    elseif data.action == "removeItem" then 

        if GlobalState.Recipes ~= nil and GlobalState.Recipes[data.id] ~= nil then 
            local recipes = Recipes[data.id]
            for key, recipe in pairs(recipes) do
                if recipe.item == data.item and recipe.label == data.label then
                    recipes[key] = nil  
                    break
                end
            end
            for i = #recipes, 1, -1 do
                if recipes[i] == nil then
                    table.remove(recipes, i)
                end
            end

            GlobalState.Recipes = Recipes

            UpdateJSON('items')

            discord_logs(L('server_name'), L("updated_table2"):format(identifier, data.action))

        end

    elseif data.action == "ChangeLabelItem" then 

        if GlobalState.Recipes ~= nil and GlobalState.Recipes[data.id] ~= nil then 
            local recipes = Recipes[data.id]
            for key, recipe in pairs(recipes) do
                if recipe.item == data.item and recipe.label == data.label then
                    recipe.label = data.new_label 
                end
            end
             
            GlobalState.Recipes = Recipes

            UpdateJSON('items')

            discord_logs(L('server_name'), L("updated_table2"):format(identifier, data.action))
        
        end
    
    elseif data.action == "ChangeCraftTime" then 

        if GlobalState.Recipes ~= nil and GlobalState.Recipes[data.id] ~= nil then 
            local recipes = Recipes[data.id]
            for key, recipe in pairs(recipes) do
                if recipe.item == data.item and recipe.label == data.label then
                    recipe.craft_time = tonumber(data.new_time)  
                end
            end

            GlobalState.Recipes = Recipes

            UpdateJSON('items')

            discord_logs(L('server_name'), L("updated_table2"):format(identifier, data.action))

        end

    elseif data.action == "ChangeRecipeItem" then 

        if GlobalState.Recipes ~= nil and GlobalState.Recipes[data.id] ~= nil then 
            local recipes = Recipes[data.id]
            for key, recipe in pairs(recipes) do
                if recipe.item == data.item and recipe.label == data.label then
                    recipe.recipe = data.recipe  
                end
            end

            GlobalState.Recipes = Recipes

            UpdateJSON('items')

            discord_logs(L('server_name'), L("updated_table2"):format(identifier, data.action))

        end

    elseif data.action == "ChangeReward" then

        if GlobalState.Recipes ~= nil and GlobalState.Recipes[data.id] ~= nil then 
            local recipes = Recipes[data.id]
            for key, recipe in pairs(recipes) do
                if recipe.item == data.item and recipe.label == data.label then
                    recipe.amount = data.amount  
                end
            end

            GlobalState.Recipes = Recipes

            UpdateJSON('items')


            discord_logs(L('server_name'), L("updated_table2"):format(identifier, data.action))
            
        end

    elseif data.action == "ModifyApp" then 

        if data.section == "change_prop" then 

            if GlobalState.WorkShops ~= nil and GlobalState.WorkShops[data.id] ~= nil then 
                WorkShops[data.id].model = data.model
                GlobalState.WorkShops = WorkShops 
            end

            discord_logs(L('server_name'), L("updated_table"):format(identifier, data.action, data.section))

        elseif data.section == "change_blip" then 

            if GlobalState.WorkShops ~= nil and GlobalState.WorkShops[data.id] ~= nil then 
                WorkShops[data.id].blip = data.blipData
                GlobalState.WorkShops = WorkShops 
            end

            discord_logs(L('server_name'), L("updated_table"):format(identifier, data.action, data.section))

        elseif data.section == "new_pos" then 

            if GlobalState.WorkShops ~= nil and GlobalState.WorkShops[data.id] ~= nil then 
                WorkShops[data.id].coords = data.pos
                GlobalState.WorkShops = WorkShops 
            end

            discord_logs(L('server_name'), L("updated_table"):format(identifier, data.action, data.section))

        elseif data.section == "new_name" then 

            if GlobalState.WorkShops ~= nil and GlobalState.WorkShops[data.id] ~= nil then 
                WorkShops[data.id].name = data.name
                GlobalState.WorkShops = WorkShops 
            end

            discord_logs(L('server_name'), L("updated_table"):format(identifier, data.action, data.section))

        elseif data.section == "new_jobs" then 

            if GlobalState.WorkShops ~= nil and GlobalState.WorkShops[data.id] ~= nil then 
                WorkShops[data.id].jobs = data.jobs
                GlobalState.WorkShops = WorkShops 
            end

            discord_logs(L('server_name'), L("updated_table"):format(identifier, data.action, data.section))

        elseif data.section == "new_gangs" then 

            if GlobalState.WorkShops ~= nil and GlobalState.WorkShops[data.id] ~= nil then 
                WorkShops[data.id].gangs = data.gangs
                GlobalState.WorkShops = WorkShops 
            end

            discord_logs(L('server_name'), L("updated_table"):format(identifier, data.action, data.section))

        elseif data.section == "reload_defaults" then 

            if GlobalState.WorkShops ~= nil and GlobalState.WorkShops[data.id] ~= nil then 
                WorkShops[data.id].jobs = {}
                WorkShops[data.id].gangs = {}
                WorkShops[data.id].blip = {}
                GlobalState.WorkShops = WorkShops 
            end

            discord_logs(L('server_name'), L("updated_table"):format(identifier, data.action, data.section))

        end

        UpdateJSON('workshop')
        
    end

    Wait(500)
    TriggerClientEvent("dd-crafting:Re:Sync", -1)

end)

UpdateJSON = function(action)
    local fileName, fileContent
    if action == "workshop" then
        fileName = "data/tables.json"
        fileContent = json.encode(WorkShops, { indent = true })
    elseif action == 'items' then
        fileName = "data/items.json"
        fileContent = json.encode(Recipes, { indent = true })
    end

    if fileName and fileContent then
        local success, err = pcall(function()
            SaveResourceFile(GetCurrentResourceName(), fileName, fileContent, -1)
        end)
        if not success then
            print("Error saving file: " .. err)
        end
    end
end

QT.RegisterServerCall("dd-crafting-CheckItems", function(source, cb, request)
    if type(request) ~= 'table' then return cb(false) end
    local selectedRecipe = findRecipe(request.tableId, request.item, request.label)
    if not selectedRecipe or type(selectedRecipe.recipe) ~= 'table' then return cb(false) end

    local totalItems = #selectedRecipe.recipe
    local itemsChecked = 0
    
    for _, data in ipairs(selectedRecipe.recipe) do
        local amount = tonumber(data.amount)
        local check = Core.HasItem(source, data.item, amount)
        if not check then 
            break  
        else
            itemsChecked = itemsChecked + 1
        end
    end
    
    if itemsChecked == totalItems then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent("dd-crafting-GiveItem", function(data)
    local source = source 

    if not source or not GetPlayerName(source) then
        print("Invalid source:", source)
        return
    end

    if type(data) ~= "table" or not data.item or not data.index then
        print("Invalid data format:", data)
        return
    end

    local selectedRecipe = findRecipe(data.index, data.item, data.label)
    if not selectedRecipe then
        print("Invalid crafting recipe:", data.item, data.index)
        return
    end

    local rewardAmount = tonumber(selectedRecipe.amount)
    if not rewardAmount or rewardAmount <= 0 or type(selectedRecipe.recipe) ~= 'table' then
        print("Invalid server recipe:", data.item)
        return
    end

    local hasItems = true
    for _, itemData in pairs(selectedRecipe.recipe) do
        if not itemData.item or not tonumber(itemData.amount) or tonumber(itemData.amount) <= 0 then
            print("Invalid recipe item or amount:", itemData.item, itemData.amount)
            hasItems = false
            break
        end

        if not Core.HasItem(source, itemData.item, tonumber(itemData.amount)) then
            hasItems = false
            break
        end
    end

    if not hasItems then
        TriggerClientEvent('qt-sendNotify', source, {
            title = L('main_title'),
            msg = L('not_enough_to_craft'),
            type = 'system'
        })
        return
    end

    local removedIngredients = {}

    local function restoreIngredients()
        for _, ingredient in ipairs(removedIngredients) do
            local restored, restoreError = Core.AddItem(source, ingredient.item, ingredient.amount)
            if not restored then
                print(('dd-crafting: gagal mengembalikan %sx %s: %s'):format(ingredient.amount, ingredient.item, restoreError or 'unknown'))
            end
        end
    end

    for _, itemData in pairs(selectedRecipe.recipe) do
        if Shared.ConsumeAllIngredients or itemData.removable then
            local ingredientAmount = tonumber(itemData.amount)
            local removed, removeError = Core.RemoveItem(source, itemData.item, ingredientAmount)

            if not removed then
                restoreIngredients()
                print(('dd-crafting: gagal mengambil %sx %s: %s'):format(ingredientAmount, itemData.item, removeError or 'unknown'))
                TriggerClientEvent('qt-sendNotify', source, {
                    title = L('main_title'),
                    msg = L('not_enough_to_craft'),
                    type = 'system'
                })
                return
            end

            removedIngredients[#removedIngredients + 1] = {
                item = itemData.item,
                amount = ingredientAmount
            }
        end
    end

    if not Core.CanCarryItem(source, selectedRecipe.item, rewardAmount) then
        restoreIngredients()
        TriggerClientEvent('qt-sendNotify', source, {
            title = L('main_title'),
            msg = 'Inventory kamu tidak cukup untuk hasil crafting.',
            type = 'system'
        })
        return
    end

    local added, addError = Core.AddItem(source, selectedRecipe.item, rewardAmount)
    if not added then
        restoreIngredients()
        print(('dd-crafting: gagal memberikan %s: %s'):format(selectedRecipe.item, addError or 'unknown'))
        TriggerClientEvent('qt-sendNotify', source, {
            title = L('main_title'),
            msg = 'Hasil crafting gagal diberikan.',
            type = 'system'
        })
        return
    end

    discord_logs(L('server_name'), L("crafted_item"):format(Core.GetName(source), selectedRecipe.item, rewardAmount, data.index))
    
end)
