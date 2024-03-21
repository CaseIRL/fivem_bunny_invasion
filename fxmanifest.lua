--[[
     ____    _    ____  _____ 
    / ___|  / \  / ___|| ____|
    | |    / _ \ \___ \|  _|  
    | |___/ ___ \ ___) | |___ 
    \____/_/   \_|____/|_____|
                           
         BUNNY INVASION
]]

fx_version 'cerulean'
games { 'gta5', 'rdr3' }

name 'bunny_invasion'
version '1.0.0'
description 'FiveM - Bunny Invasion'
author 'caseirl'
repository 'https://github.com/caseirl'
lua54 'yes'

ui_page 'html/index.html'

files {
    'html/**/*',
}

server_script 'server.lua'
client_script 'client.lua'