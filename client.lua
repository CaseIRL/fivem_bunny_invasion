--[[
     ____    _    ____  _____ 
    / ___|  / \  / ___|| ____|
    | |    / _ \ \___ \|  _|  
    | |___/ ___ \ ___) | |___ 
    \____/_/   \_|____/|_____|
                           
         BUNNY INVASION
]]

--- @section Constants

--- Distance required from a bunny to catch
local INTERACTION_DISTANCE = 3.0

--- Percentage chance to catch a bunny 50 = 50%
local CHANCE_TO_CATCH = 100

--- @section Tables

--- Stores active rabbit peds
local bunnies = {}

--- @section Variables

--- Event state
local event_active = false

--- Event timer received from server
local event_time = nil

--- Player opted in status
local opted_in = false

--- @section Local functions

--- Draw text on screen to catch
local function draw_text(text, x, y)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

--- Spawns rabbit peds
local function spawn_ped(coords)
    local x, y, z = table.unpack(coords)
    local model = GetHashKey('a_c_rabbit_01')
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    local ped = CreatePed(5, model, x, y, z - 1, 0.0, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityInvincible(ped, true)
    SetPedCanRagdoll(ped, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskWanderInArea(ped, x, y, z, 100.0, 0.0, 10.0)
    SetPedAsNoLongerNeeded(ped)
    return ped
end

--- Delete a rabbit ped
local function delete_ped(ped)
    if DoesEntityExist(ped) then
        DeleteEntity(ped)
    end
end

--- Gets a random coords within radius
local function get_random_coords(center_coords, radius)
    local x = center_coords.x or 0
    local y = center_coords.y or 0
    local z = center_coords.z or 0
    local angle = math.random() * 360.0
    local radian = math.rad(angle)
    local dx = math.cos(radian) * math.random() * radius
    local dy = math.sin(radian) * math.random() * radius
    return {x + dx, y + dy, z}
end

--- Runs catch animation and deals with catch chance
local function catch_bunny(bunny, bunny_id)
    RequestAnimDict('move_jump')
    while not HasAnimDictLoaded('move_jump') do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), 'move_jump', 'dive_start_run', 8.0, -8.0, -1, 0, 0.0, false, false, false)
    Wait(600)
    SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, false, false, false)
    Wait(1000)
    local chance = math.random(1, 100)
    if chance <= CHANCE_TO_CATCH then
        delete_ped(bunny)
        bunnies[bunny_id] = nil
        TriggerServerEvent('bunny_invasion:bunny_caught')
    else
        print('Failed to catch the bunny!')
    end
end

--- Start spawning bunnies after player opts in
local function start_bunny_spawns()
    if opted_in then
        event_active = true
        local count = math.random(100, 300)
        for i = 1, count do
            local spawn_coords = get_random_coords(GetEntityCoords(PlayerPedId()), 50.0)
            local bunny_id = #bunnies + 1
            bunnies[bunny_id] = spawn_ped(spawn_coords)
        end
    end
end

--- Opt into the bunny invasion event
local function opt_in()
    opted_in = true
    TriggerServerEvent('bunny_invasion:request_scores')    
    SendNUIMessage({ action = 'update_banner', text = 'You have ' .. event_time .. ' minutes to catch as many bunnies as you can!' })
    start_bunny_spawns()
end

--- Opt out of the bunny invasion event
local function opt_out()
    opted_in = false
    SendNUIMessage({ action = 'hide_banner' })
end

--- Inform the player that an invasion has started so they can opt in or out
local function inform_player()
    SendNUIMessage({ action = 'show_banner' })
    CreateThread(function()
        while true do
            Wait(0)
            if IsControlJustPressed(1, 246) then -- Y key
                opt_in()
                break
            elseif IsControlJustPressed(1, 249) then -- N key
                opt_out()
                break
            end
        end
    end)
end

--- @section Events

--- Starts the bunny invasion event
RegisterNetEvent('bunny_invasion:start_event', function(timer)
    event_time = tonumber(timer)
    inform_player()
end)

-- Event handler for the end of the bunny invasion event
RegisterNetEvent('bunny_invasion:end_event', function(winners)
    if opted_in and event_active then
        event_active = false
        opted_in = false
        for _, bunny in pairs(bunnies) do
            delete_ped(bunny)
        end
        bunnies = {}
        local message = "The invasion is over!<br>"
        if #winners > 0 then
            message = message .. " Winners:"
            for i, winner in ipairs(winners) do
                local emoji = ""
                if i == 1 then
                    emoji = "<br>🥇 "
                elseif i == 2 then
                    emoji = "<br>🥈 "
                elseif i == 3 then
                    emoji = "<br>🥉 "
                end
                message = message .. string.format(" %d. %s%s with %d catches!", i, emoji, winner.name, winner.score)
            end
        else
            message = message .. " No winners this time."
        end
        SendNUIMessage({ action = 'update_banner', text = message })

        Wait(20000)
        SendNUIMessage({ action = 'end_event' })
    end
end)



--- NUI message for updating the leaderboard
RegisterNetEvent('bunny_invasion:update_leaderboard', function(scores)
    SendNUIMessage({
        action = 'update_leaderboard',
        player_scores = scores
    })
end)

--- @section Threads

-- Thread for catching rabbits
CreateThread(function()
    while true do
        -- Wait for 500 milliseconds instead of 0 for less frequent checks
        Wait(500)
        if opted_in and event_active then
            local player_ped = PlayerPedId()
            local player_coords = GetEntityCoords(player_ped)
            for i = 1, #bunnies do
                local bunny = bunnies[i]
                if bunny then
                    local bunny_coords = GetEntityCoords(bunny)
                    local dist = #(player_coords - bunny_coords)
                    if dist <= INTERACTION_DISTANCE then
                        while dist <= INTERACTION_DISTANCE and opted_in and event_active do
                            Wait(0)
                            draw_text('Press E to catch the bunny', 0.5, 0.95)
                            bunny_coords = GetEntityCoords(bunny)
                            dist = #(player_coords - bunny_coords)
                            if IsControlJustPressed(0, 38) then
                                catch_bunny(bunny, i)
                                break
                            end
                        end
                        break
                    end
                end
            end
        end
    end
end)



