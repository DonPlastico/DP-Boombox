fx_version "cerulean"
description "Un script de altavoz musical que reproduce música de YouTube"
lua54 'yes'
games {"gta5"}

ui_page 'web/build/index.html'

-- shared_script '@es_extended/imports.lua' -- Importa esto si estás usando es_extended

client_scripts {'Config.lua', "client/**/*"}
server_script {"@oxmysql/lib/MySQL.lua", 'Config.lua', "server/**/*"}

files {'web/build/index.html', 'web/build/**/*'}

dependencies {'oxmysql'}
