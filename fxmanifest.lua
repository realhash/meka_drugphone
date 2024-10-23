fx_version 'cerulean'
game 'gta5'
description 'Weapon dealer script af Fisken'
lua54 'yes'
author 'Fisken'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'locales.lua'
}

client_scripts {
    'client/*.lua'
}


server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua'
}

dependencies {
	'es_extended'
}

escrow_ignore {
    'config.lua',
    'locales.lua',
  }