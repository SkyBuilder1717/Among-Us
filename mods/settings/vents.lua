local insert_all = table.insert_all
local FORMNAME = "settings:vent"
settings.player_positions = {}
local vents = {
    ["skeld"] = {
        {
            {x = 7, y = 1, z = -4, name = "cafeteria"},
            {
                {x = 21, y = 1, z = -21, name = "coridor"},
                {x = 6, y = 1, z = -27, name = "admin"}
            }
        },
        {
            {x = 21, y = 1, z = -21, name = "coridor"},
            {
                {x = 6, y = 1, z = -27, name = "admin"},
                {x = 7, y = 1, z = -4, name = "cafeteria"}
            }
        },
        {
            {x = 6, y = 1, z = -27, name = "admin"},
            {
                {x = 21, y = 1, z = -21, name = "Coridor"},
                {x = 7, y = 1, z = -4, name = "cafeteria"}
            }
        },
        {
            {x = 22, y = 1, z = -37, name = "shields"},
            {
                {x = 41, y = 1, z = -21, name = "navigation"}
            }
        },
        {
            {x = 41, y = 1, z = -21, name = "navigation"},
            {
                {x = 22, y = 1, z = -37, name = "shields"}
            }
        },
        {
            {x = 21, y = 1, z = 3, name = "weapons"},
            {
                {x = 41, y = 1, z = -14, name = "navigation"}
            }
        },
        {
            {x = 41, y = 1, z = -14, name = "navigation"},
            {
                {x = 21, y = 1, z = 3, name = "weapons"}
            }
        },
        {
            {x = -19, y = 1, z = -25, name = "electrical"},
            {
                {x = -17, y = 1, z = -12, name = "medbay"},
                {x = -25, y = 1, z = -20, name = "security"}
            }
        },
        {
            {x = -17, y = 1, z = -12, name = "medbay"},
            {
                {x = -19, y = 1, z = -25, name = "electrical"},
                {x = -25, y = 1, z = -20, name = "security"}
            }
        },
        {
            {x = -25, y = 1, z = -20, name = "security"},
            {
                {x = -19, y = 1, z = -25, name = "electrical"},
                {x = -17, y = 1, z = -12, name = "medbay"}
            }
        },
        {
            {x = -44, y = 1, z = -20, name = "reactor"},
            {
                {x = -32, y = 1, z = -38, name = "lower_engine"}
            }
        },
        {
            {x = -32, y = 1, z = -38, name = "lower_engine"},
            {
                {x = -44, y = 1, z = -20, name = "reactor"}
            }
        },
        {
            {x = -46, y = 1, z = -14, name = "reactor"},
            {
                {x = -32, y = 1, z = 3, name = "upper_engine"}
            }
        },
        {
            {x = -32, y = 1, z = 3, name = "upper_engine"},
            {
                {x = -46, y = 1, z = -14, name = "reactor"}
            }
        }
    }
}

function settings.show_vents_menu(name, pos)
    settings.player_positions[name] = pos

    local button
    for _, def in pairs(vents[settings.map]) do
        if (pos.x == def[1].x) and (pos.y == def[1].y) and (pos.z == def[1].z) then
            button = def
        end
    end

    local player = core.get_player_by_name(name)
    player:set_properties({
        visual_size = {x = 0, y = 0, z = 0},
        is_visible = false,
        pointable = false,
        makes_footstep_sound = false
    })

    local formspec = {
        "formspec_version[6]",
        "size[10.5,11]",
        "label[0.4,0.5;Current vent location: ", util.first(button[1].name):gsub("_", " "), "]"
    }

    for i, def in pairs(button[2]) do
        insert_all(formspec, {"button[1,", 1.3 + (2.2 * (i - 1)), ";8.5,1.8;", def.name, ";", util.first(def.name):gsub("_", " "), "]"})
    end

    core.sound_play("vent", {to_player = name})
    core.show_formspec(name, FORMNAME, table.concat(formspec))
    if hide_and_seek or ((not hide_and_seek) and (settings.roles[name] and (settings.roles[name] == "engineer"))) then
        core.after(1, function()
            if settings.player_positions[name] then
                core.after(1, function()
                    if settings.player_positions[name] then
                        core.after(1, function()
                            if settings.player_positions[name] then
                                core.after(1, function()
                                    if settings.player_positions[name] then
                                        core.after(1, function()
                                            if settings.player_positions[name] then
                                                settings.player_positions[name] = nil
                                                player:set_properties({
                                                    visual_size = {x = 1, y = 1, z = 1},
                                                    is_visible = true,
                                                    pointable = true,
                                                    makes_footstep_sound = true
                                                })
                                                core.close_formspec(name, FORMNAME)
                                                core.sound_play("vent", {to_player = name})
                                            end
                                        end)
                                    end
                                end)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= FORMNAME then return end
    local name = player:get_player_name()
    if fields.quit then
        settings.player_positions[name] = nil
        player:set_properties({
            visual_size = {x = 1, y = 1, z = 1},
            is_visible = true,
            pointable = true,
            makes_footstep_sound = true
        })
        return
    end
    local button
    local pos = settings.player_positions[name]
    for _, def in pairs(vents[settings.map]) do
        if (pos.x == def[1].x) and (pos.y == def[1].y) and (pos.z == def[1].z) then
            button = def
        end
    end
    for _, def in pairs(button[2]) do
        if fields[def.name] then
            core.sound_play("vent_move", {to_player = name})
            settings.player_positions[name] = nil
            player:set_properties({
                visual_size = {x = 1, y = 1, z = 1},
                is_visible = true,
                pointable = true,
                makes_footstep_sound = true
            })
            player:set_pos({x = def.x, y = def.y, z = def.z})
            core.sound_play("vent", {to_player = name})
            core.close_formspec(name, FORMNAME)
            if settings.vents[name] then
                settings.vents[name] = settings.vents[name] - 1
            end
        end
    end
end)