local modname = core.get_current_modname()
local S = core.get_translator(modname)

settings.black_screen = {}

local timer = 0
settings.reactor_hands = 0
settings.closed_doors = {}
settings.current_sabotage = nil
settings.active_sabotage = false

local closed_rooms = {}

settings.allowed_rooms = {
    ["skeld"] = {
        ["cafeteria"] = {
            positions = {
                {
                    {x = -11, y = 1, z = 1},
                    {x = -11, y = 3, z = -2}
                },
                {
                    {x = -2, y = 1, z = -11},
                    {x = 1, y = 3, z = -11}
                },
                {
                    {x = 10, y = 1, z = -2},
                    {x = 10, y = 3, z = 1}
                }
            },
            sounds = {
                {x = -11, y = 1, z = -0.5},
                {x = -0.5, y = 1, z = -11},
                {x = 10, y = 1, z = -0.5}
            }
        },
        ["medbay"] = {
            positions = {
                {
                    {x = -15, y = 1, z = -5},
                    {x = -17, y = 3, z = -5}
                }
            },
            sounds = {
                {x = -16, y = 1, z = -5}
            }
        },
        ["upper_engine"] = {
            positions = {
                {
                    {x = -35, y = 3, z = -6},
                    {x = -33, y = 1, z = -6}
                },
                {
                    {x = -30, y = 1, z = 1},
                    {x = -30, y = 3, z = -2}
                }
            },
            sounds = {
                {x = -30, y = 1, z = -0.5},
                {x = -34, y = 1, z = -6}
            }
        },
        ["lower_engine"] = {
            positions = {
                {
                    {x = -30, y = 1, z = -33},
                    {x = -30, y = 3, z = -36}
                },
                {
                    {x = -35, y = 1, z = -29},
                    {x = -33, y = 3, z = -29}
                }
            },
            sounds = {
                {x = -30, y = 3, z = -34.5},
                {x = -32, y = 1, z = -29}
            }
        },
        ["security"] = {
            positions = {
                {
                    {x = -29, y = 1, z = -17},
                    {x = -29, y = 3, z = -18}
                }
            },
            sounds = {
                {x = -29, y = 1, z = -17.5}
            }
        },
        ["storage"] = {
            positions = {
                {
                    {x = -11, y = 1, z = -42},
                    {x = -11, y = 3, z = -39}
                },
                {
                    {x = -2, y = 1, z = -26},
                    {x = 1, y = 3, z = -26}
                },
                {
                    {x = 3, y = 1, z = -32},
                    {x = 3, y = 3, z = -35}
                }
            },
            sounds = {
                {x = -11, y = 1, z = -40.5},
                {x = -0.5, y = 1, z = -26},
                {x = 3, y = 1, z = -33.5}
            }
        },
        ["electrical"] = {
            positions = {
                {
                    {x = -18, y = 1, z = -38},
                    {x = -20, y = 3, z = -38}
                }
            },
            sounds = {
                {x = -19, y = 1, z = -38}
            }
        }
    }
}

core.register_on_mods_loaded(function()
    settings.sabotage()
end)

function settings.sabotage()
    if settings.active_sabotage and (settings.current_sabotage == "reactor" or settings.current_sabotage == "oxygen") then
        settings.play_sound("sabotage")
    end
    core.after(1, function()
        settings.sabotage()
        if settings.active_sabotage and (settings.current_sabotage == "reactor" or settings.current_sabotage == "oxygen") then
            timer = timer - 1
            if timer < 1 then
                if settings.current_sabotage == "reactor" then
                    core.chat_send_all(S("Reactor melted!").." "..core.colorize("red", S("Impostors win!")))
                elseif settings.current_sabotage == "oxygen" then
                    core.chat_send_all(S("No oxygen!").." "..core.colorize("red", S("Impostors win!")))
                end
                settings.current_sabotage = nil
                settings.active_sabotage = false
                settings.play_sound("win_impostor")
                settings.end_game()
                return
            end
        end
    end)
end

core.register_chatcommand("close_door", {
    description = "Close doors as an impostor!",
    params = "<room>",
    func = function(name, param)
        if settings.started and not settings.meeting_started and (settings.roles[name] == "impostor") and not settings.current_sabotage then
            local allowed_rooms = settings.allowed_rooms[settings.map]
            if param == "" or not util.containk(allowed_rooms, param) then
                local available_rooms = {}
                for room, _ in pairs(allowed_rooms) do
                    if not util.contain(closed_rooms, room) then
                        table.insert(available_rooms, room)
                    end
                end
                if #available_rooms > 0 then
                    return false, "Available rooms: "..table.concat(available_rooms, ", ").."."
                else
                    return false, "No available rooms right now!"
                end
            end
            if util.contain(closed_rooms, param) then return false, "Unable to close this room!" end
            local def = allowed_rooms[param]
            util.play_sound(def.sounds, false)
            if not settings.meeting_started then
                for _, d in pairs(def.positions) do
                    local pos1 = d[1]
                    local pos2 = d[2]
                    util.fill_area(pos1, pos2, "maps:metal")
                end
            end
            table.insert(closed_rooms, param)
            core.after(10, function()
                if not settings.meeting_started then
                    for _, d in pairs(def.positions) do
                        local pos1 = d[1]
                        local pos2 = d[2]
                        util.fill_area(pos1, pos2, "air")
                    end
                end
                util.play_sound(def.sounds, true)
                core.after(15, function()
                    util.remove(closed_rooms, param)
                end)
            end)
            settings.active_sabotage = true
            core.after(15, function()
                settings.active_sabotage = false
            end)
            return true, S("Closed door in @1.", S(util.first(param:gsub("_", " "))))
        end
    end
})

core.register_chatcommand("lightning", {
    description = "Sabotages light",
    func = function(name, param)
        if settings.started and not settings.meeting_started and (settings.roles[name] == "impostor") and not settings.current_sabotage then
            core.set_timeofday(0)
            settings.current_sabotage = "light"
            for _, player in pairs(core.get_connected_players()) do
                local pname = player:get_player_name()
                settings.black_screen[pname] = player:hud_add({
                    type = "image",
                    position = {x=0.5, y=0.5},
                    name = "black_screen",
                    scale = {x = 15, y = 15},
                    text = "[fill:128x128:0,0:#000000a0",
                    alignment = {x=0, y=0},
                    offset = {x=0, y=0},
                    z_index = 5000
                })
            end
            core.chat_send_all(core.colorize("yellow", "Light malfunction!"))
        end
    end
})

core.register_chatcommand("reactor", {
    description = "Sabotages reactor",
    func = function(name, param)
        if settings.started and not settings.meeting_started and (settings.roles[name] == "impostor") and not settings.current_sabotage and not settings.active_sabotage then
            timer = 30
            settings.current_sabotage = "reactor"
            settings.active_sabotage = true
            settings.reactor_hands = 0
            core.chat_send_all(core.colorize("yellow", "Reactor melting! 30 seconds until game over!"))
            core.chat_send_all(S("@1 of @2!", settings.reactor_hands, 2))
        end
    end
})

core.register_chatcommand("oxygen", {
    description = "Sabotages oxygen",
    func = function(name, param)
        if settings.started and not settings.meeting_started and (settings.roles[name] == "impostor") and not settings.current_sabotage and not settings.active_sabotage then
            timer = 30
            settings.current_sabotage = "oxygen"
            settings.active_sabotage = true
            settings.reactor_hands = 0
            core.chat_send_all(core.colorize("yellow", "Oxygen leaking! 30 seconds until game over!"))
            core.chat_send_all(S("@1 of @2!", settings.reactor_hands, 2))
        end
    end
})

core.register_chatcommand("communication", {
    description = "Sabotages communications",
    func = function(name, param)
        if settings.started and not settings.meeting_started and (settings.roles[name] == "impostor") and not settings.current_sabotage and not settings.active_sabotage then
            settings.current_sabotage = "communication"
            settings.active_sabotage = true
            core.chat_send_all(core.colorize("yellow", "Communications disabled!"))
            tasks.update_hud()
        end
    end
})