fx_version "bodacious"
game "gta5"
lua54 "yes"

author "flexiboi"
description "Flex-gangs"
version "1.0.0"

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/nl.lua',
}

client_scripts {
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/CircleZone.lua',
    'client/utils.lua',
    'client/*.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua',
}

dependencies {
	'qb-core',
}