Shared = {}
Shared.Locale = "en"
Shared.Framework = "qbox" -- Qbox native + ox_inventory
Shared.Target = "ox_target" -- # supports qb-target and ox_target
Shared.LIBRARY_NOTIFY = true 
Shared.ImagePath = "ox_inventory/web/images/" -- # where images for items will display
Shared.DefaultModel = "gr_prop_gr_bench_02a" -- # if you dont want other prop or just dont want to fulfil prop field into creation menu 

-- true: semua bahan resep selalu dikurangi setelah crafting.
-- false: hanya bahan dengan opsi "Removable" yang dikurangi.
Shared.ConsumeAllIngredients = true

-- # DISCORD LOGS shared/bridge/server/editable.lua 

-- # inventory paths 
--[[
    "qb-inventory/html/images/"
    "lj-inventory/html/images/"
    "ox_inventory/web/images/"
    "qs-inventory/html/images/"
    "ps-inventory/html/images/"
]]

Shared.FrameworkNames = {
    esx = "es_extended",
    qb = "qb-core",
    qbox = "qbx_core"
}

Shared.PlayersLicense = "license" -- # steam, license, discord, IP adress
Shared.Commands = {
    prefix = "craft:",
    perms = {
        ["create"] = {
            ["license:0220b485234c1c55c406fa23024a962052dda556"] = true, -- # steam or rockstar license ( its from server to server )
        },
        ["edit"] = {
            ["license:0220b485234c1c55c406fa23024a962052dda556"] = true, -- # steam or rockstar license ( its from server to server )
        },
    },
}


