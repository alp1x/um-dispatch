fx_version 'cerulean'

game 'gta5'

author 'um-dispatch forked from (Project Sloth & OK1ez)'
version '2.5.0'

lua54 'yes'
use_experimental_fxv2_oal 'yes'
nui_callback_strict_mode 'true'

ui_page 'html/index.html'
-- ui_page 'http://localhost:5173/' --for dev

files {
    'html/**',
    'locales/*.json',
    'shared/**',
    'bridge/*.lua',
    'client/modules/**',
}

shared_script {
    '@ox_lib/init.lua',
    'bridge/loader.lua',
}

client_script {
    'client/main.lua',
    'client/handlers.lua',
    'client/nuicallback.lua',
    'client/compat.lua',
    'client/exports/**',
}

server_script {
    'server/**',
}

ox_lib 'locale'

provides {
    'ps-dispatch',
    'tgiann-policealert',
}
