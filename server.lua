--[[
     ____    _    ____  _____ 
    / ___|  / \  / ___|| ____|
    | |    / _ \ \___ \|  _|  
    | |___/ ___ \ ___) | |___ 
    \____/_/   \_|____/|_____|
                           
         BUNNY INVASION
]]

--- @section Constants

--- The time the event should run for in mins (minutes)
local EVENT_TIME = 1 

--- @section Tables

local player_scores = {}

--- @section Variables
local event_active = false

--- @section Local functions

--- Ends the event and announces the top three winners
local function end_bunny_event()
    event_active = false
    table.sort(player_scores, function(a, b)
        return a.score > b.score
    end)
    local winners = {}
    for i = 1, math.min(3, #player_scores) do
        winners[#winners + 1] = {
            _src = player_scores[i].source,
            name = player_scores[i].name,
            score = player_scores[i].score
        }
    end
    player_scores = {}
    TriggerClientEvent('bunny_invasion:end_event', -1, winners)
end

--- Starts the event
local function start_bunny_event()
    if not event_active then
        event_active = true
        TriggerClientEvent('bunny_invasion:start_event', -1, EVENT_TIME)
        SetTimeout(60000 * EVENT_TIME, function()
            end_bunny_event()
        end)
    else
        print('Event not started. Conditions not met or event is already active.')
    end
end 

--- @section Events

--- Requests player scores to add to leaderboard UI 
RegisterServerEvent('bunny_invasion:request_scores', function()
    local _src = source
    TriggerClientEvent('bunny_invasion:update_leaderboard', _src, player_scores)
end)

RegisterServerEvent('bunny_invasion:bunny_caught', function()
    local _src = source
    local player_name = GetPlayerName(_src) -- If you want to show player character names you could add in my boii_utils resource (https://github.com/boiidevelopment/boii_utils/tree/main) and use utils.fw.get_player_name(_src) 
    if not player_scores[_src] then
        player_scores[_src] = { source = _src, name = player_name, score = 0 }
    end
    player_scores[_src].score = player_scores[_src].score + 1
    TriggerClientEvent('bunny_invasion:update_leaderboard', -1, player_scores)
end)

--- @section Test

RegisterCommand('bunny_invasion:start', function(source, args, raw_command)
     start_bunny_event()
end, true)