fx_version 'cerulean'
game 'gta5'
description 'Advanced Crafting V2 - Qbox Native Edition'
author 'dd-dev'
version '2.1.1-qbox'

shared_scripts {
    '@ox_lib/init.lua',
    'shared.lua',
    'shared/framework.lua',
    'locales.lua', 
    'locales/*.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'shared/bridge/client/*.lua',
    'cl_utils.lua'
}

server_scripts {
    'shared/bridge/server/*.lua',
    'sv_utils.lua'
}

ui_page 'web/index.html'

files {
    'web/*.*',
}

dependencies {
    'qbx_core',
    'ox_lib',
    'ox_inventory',
    'ox_target',
    'dd-library'
}

lua54 'yes'
