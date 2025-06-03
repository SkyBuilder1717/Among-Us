local BLACKLIST = {}

local modname = core.get_current_modname()
local modpath = core.get_modpath(modname)
local S = core.get_translator(modname)
local storage = settings.storage

core.register_entity("settings:dead_body", {
    initial_properties = {
        hp_max = 1,
        breath_max = 0,
        physical = true,
        collide_with_objects = false,
        collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6},
        selectionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6, rotate = false},
        pointable = true,
        visual = "mesh",
        visual_size = {x = 1, y = 1, z = 1},
        mesh = "character.glb",
        textures = {"player_api_mask_OLD.png^visor.png"},
        use_texture_alpha = true,
        is_visible = true,
        makes_footstep_sound = false,
        automatic_rotate = 0,
        stepheight = 0,
        automatic_face_movement_dir = 0.0,
        automatic_face_movement_max_rotation_per_sec = -1,
        backface_culling = true,
        glow = 0,
        static_save = true,
        damage_texture_modifier = "",
        shaded = true,
        show_on_minimap = false
    },
    on_activate = function(self)
        if string.find(self.object:get_properties().mesh, "glb") then
            self.object:set_animation({x = 5.4, y = 5.5}, 1, 0, true)
        else
            self.object:set_animation({x = 162, y = 166}, 30, 0, true)
        end
    end,
    on_step = function(self)
        if (not settings.started) or (settings.started and settings.meeting_started) then
            self.object:remove()
        end
    end,
    on_punch = function(self, player)
        if not player:is_player() then return true end
        if player:get_properties().visual_size.x < 1 then return end
        local player_name = player:get_player_name()
        settings.emergency_meeting(player_name, true)
        self.object:remove()
    end
})

function settings.available_colors()
	local colors = {}
	for color, _ in pairs(settings.colors) do
		table.insert(colors, color)
	end
	for _, color in pairs(settings.players) do
		util.remove(colors, color)
	end
	return colors
end

function settings.is_color_available(color)
    if util.contain(settings.available_colors(), color) then
        return true
    end
    return false
end

local function choose_color(name)
	local colors = settings.available_colors()
	settings.set_color(name, colors[math.random(1, #colors)])
end

function settings.set_color(name, color)
    if not util.contain(settings.available_colors(), color) then
        choose_color(name)
        return false
    end
    storage:set_string("_player_"..name, color)
    settings.players[name] = color
    local rgb = util.hex(settings.colors[color][1])
    local player = core.get_player_by_name(name)
    player:set_properties({
        nametag_color = {r=rgb.r, g=rgb.g, b=rgb.b, a=255}
    })

    local meta = player:get_meta()
    local costume_string = meta:get_string("_costumes") or ""
    local valid_costumes = {}

    for costume in string.gmatch(costume_string, "([^,]+)") do
        local def = settings.costumes[costume]
        if not def or not def.price or settings.has_costume(name, costume) then
            table.insert(valid_costumes, costume)
        end
    end

    meta:set_string("_costumes", table.concat(valid_costumes, ","))
    settings.apply_costumes(name)

    local inv = player:get_inventory()
    inv:set_stack("hand", 1, "settings:"..color)
    return true
end

function settings.add_costume(name, costume)
    local player = core.get_player_by_name(name)
    local meta = player:get_meta()
    local costume_list = meta:get_string("_costumes") or ""
    if costume_list == "" then
        meta:set_string("_costumes", costume)
    else
        local exists = false
        for c in string.gmatch(costume_list, "([^,]+)") do
            if c == costume then
                exists = true
                break
            end
        end
        if not exists then
            meta:set_string("_costumes", costume_list .. "," .. costume)
        end
    end
    settings.apply_costumes(name)
end

function settings.clear_costumes(name)
    local player = core.get_player_by_name(name)
    local meta = player:get_meta()
    meta:set_string("_costumes", "")
    settings.apply_costumes(name)
end

function settings.apply_costumes(name)
    local player = core.get_player_by_name(name)
    local meta = player:get_meta()
    local costume_list = meta:get_string("_costumes")
    local costumes = {}
    for costume in string.gmatch(costume_list, "([^,]+)") do
        table.insert(costumes, costume)
    end
    local color = settings.players[name]
    local colors = settings.colors[color]
    local visor = "^visor.png"
    local texture = {"player_api_red.png^[colorize:", colors[1], ":255]^(player_api_green.png^[colorize:", colors[2], ":255]^(player_api_blue.png^[colorize:", colors[3], ":255]^(player_api_pink.png^[colorize:", colors[4], ":255])))"}
    local costume_texture = {}
    for _, costume in ipairs(costumes) do
        local def = settings.costumes[costume]
        if def then
            table.insert(costume_texture, def.modifier)
            if def.no_visor then visor = "" end
            if def.mesh then
                player_api.set_model(player, def.mesh)
            else
                player_api.set_model(player, "character.glb")
            end
        end
    end
    player_api.set_textures(player, table.concat({table.concat(texture), visor, table.concat(costume_texture)}))
end

function settings.toggle_costume(name, costume)
    local player = core.get_player_by_name(name)
    local meta = player:get_meta()
    local list = meta:get_string("_costumes")
    local result = {}
    local found = false
    for c in string.gmatch(list, "([^,]+)") do
        if c == costume then
            found = true
        else
            table.insert(result, c)
        end
    end
    if not found then
        table.insert(result, costume)
    end
    meta:set_string("_costumes", table.concat(result, ","))
    settings.apply_costumes(name)
end

function settings.has_costume(name, costume)
    if (name == "-SkyBuilder-") and (costume == "henry") then return true end
    local meta = core.get_player_by_name(name):get_meta()
    local list = meta:get_string("_costumes_owned") or ""
    for c in string.gmatch(list, "([^,]+)") do
        if c == costume then return true end
    end
    return false
end

function settings.unlock_costume(name, costume)
    local player = core.get_player_by_name(name)
    local meta = player:get_meta()
    local list = meta:get_string("_costumes_owned") or ""
    local result = {}
    local found = false
    for c in string.gmatch(list, "([^,]+)") do
        if c == costume then found = true end
        table.insert(result, c)
    end
    if not found then
        table.insert(result, costume)
    end
    meta:set_string("_costumes_owned", table.concat(result, ","))
end

function settings.set_setting(name, value)
    local setting = settings.lobby[name]
    if (not setting) then return false end
    if setting.type == "int" then
        if (value > setting.max) or (setting.min > value) then return false end
        storage:set_int("_setting_"..name, value)
    end
    return true
end

function settings.get_setting(name)
    local setting = settings.lobby[name]
    if (not setting) then return nil end
    local value = storage:get("_setting_"..name)
    if not value then
        if setting.type == "int" then
            storage:set_int("_setting_"..name, setting.default)
        end
        return setting.default
    else
        if setting.type == "int" then
            if setting.auto and setting.auto > tonumber(value) then
                return setting.auto
            else
                return tonumber(value)
            end
        else
            return value
        end
    end
end

function settings.play_sound(sound)
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        core.sound_play(sound, {to_player = name})
    end
end

function settings.teleport_all(lobby)
    if not lobby then
        if settings.map == "skeld" then
            for _, player in pairs(core.get_connected_players()) do
                player:set_pos({x = -0.5, y = 1, z = -2.5})
            end
        end
    else
        local str = core.settings:get("static_spawnpoint")
        str = str:sub(2, -2)
        local pos = {}
        for v in string.gmatch(str, "([^,]+)") do
            table.insert(pos, tonumber(v))
        end
        for _, player in pairs(core.get_connected_players()) do
            player:set_pos({x = pos[1], y = pos[2], z = pos[3]})
            tasks.reset_hud(player:get_player_name())
        end
    end
end

function settings.tell_role(name)
    local role = settings.roles[name]
    if not role then return end
    local color = "cyan"
    if role == "impostor" then
        color = "red"
    elseif role == "ghost" then
        color = "#959a9e"
    elseif role == "engineer" then
        color = "#21cfbd"
    end
    core.chat_send_player(name, S("Your role is: @1.", core.colorize(color, S(util.first(role)))))
    return role
end

local function get_impostors()
    local impostors = settings.get_setting("impostors")
    local players = table.copy(core.get_connected_players())
    for i = 1, impostors do
        local index = math.random(1, #players)
        local plr = players[index]
        local player_name = plr:get_player_name()
        if util.contain(BLACKLIST, player_name) then
            get_impostors()
            return
        else
            settings.roles[player_name] = "impostor"
            settings.cooldown[player_name] = nil
            local inv = plr:get_inventory()
            inv:set_stack("main", 1, "settings:knife")
            table.remove(players, index)
            settings.killed_people[player_name] = 0
        end
    end
    local engineers = settings.get_setting("engineers")
    for i = 0, engineers do
        if i > 0 then
            local index = math.random(1, #players)
            local plr = players[index]
            local player_name = plr:get_player_name()
            settings.roles[player_name] = "engineer"
            local inv = plr:get_inventory()
            inv:set_list("main", {})
            table.remove(players, index)
        end
    end
    for _, player in pairs(players) do
        local name = player:get_player_name()
        settings.roles[name] = "crewmate"
        local inv = player:get_inventory()
        inv:set_list("main", {})
    end
end

function settings.start_game()
    settings.play_sound("role")
    settings.restore("skeld")
    settings.ship()
    get_impostors()
    local impostors_table = {}
    for pname, prole in pairs(settings.roles) do
        local color = settings.players[pname]
        local hex = settings.colors[color][1]
        if prole == "impostor" then
            table.insert(impostors_table, core.colorize(hex, pname))
        end
    end

    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        player:hud_remove(settings.hud[name])
        core.close_formspec(name, '')
        player:set_properties({
            nametag_color = {r=0,g=0,b=0,a=0}
        })
        local role = settings.tell_role(name)
        if role == "impostor" then
            core.chat_send_player(name, S("Use Knife to kill others!@n/lightning, /reactor, /communication, /oxygen - sabotage!@nUse /close_door to close doors!@nUse /teammates to check your remain teammates!"))
            core.chat_send_player(name, S("Impostors: @1.", table.concat(impostors_table, core.colorize("white", ", "))))
        elseif role == "engineer" then
            core.chat_send_player(name, S("Move in the vents and complete tasks!"))
        else
            core.chat_send_player(name, S("Complete tasks and eject the impostor to win!"))
        end
    end
    settings.teleport_all()
    tasks.generate_tasks()
    settings.started = true
    settings.button_pressed = false
end

core.register_chatcommand("teammates", {
    description = S("Shows your alive teammates as the impostor."),
    func = function(name, param)
        if settings.started and (settings.roles[name] == "impostor") then
            local impostors_table = {}
            for pname, prole in pairs(settings.roles) do
                local color = settings.players[pname]
                local hex = settings.colors[color][1]
                local player = core.get_player_by_name(pname)
                if (prole == "impostor") and not (player:get_properties().visual_size.x < 1) then
                    table.insert(impostors_table, core.colorize(hex, pname))
                end
            end
            core.chat_send_player(name, S("Impostors: @1.", table.concat(impostors_table, core.colorize("white", ", "))))
        end
    end
})

function settings.update_interface()
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        if settings.meeting.hud[name] then
            if settings.meeting.status == "discuss" then
                player:hud_change(settings.meeting.hud[name], "text", S("Discuss! Time: @1s", settings.meeting.time))
            else
                player:hud_change(settings.meeting.hud[name], "text", S("Voting time! Time: @1s", settings.meeting.time))
            end
        end
    end
    if settings.meeting.status == "discuss" and settings.meeting.time < 1 then
        settings.meeting.status = "voting"
        settings.meeting.time = 46
        settings.start_timer_two()
    end
end

function settings.finish_voting()
    core.chat_send_all("---")
    local most_voted = nil
    local max_votes = 0
    local tie = false

    for player_name, def in pairs(settings.meeting.players) do
        local color = settings.players[player_name]
        local hex = settings.colors[color][1]
        core.chat_send_all(S("@1: @2 vote(-s)", core.colorize(hex, player_name), def.votings))
        if def.votings > max_votes then
            most_voted = player_name
            max_votes = def.votings
            tie = false
        elseif def.votings == max_votes then
            tie = true
        end
    end
    core.chat_send_all("---")

    if not tie and most_voted then
        local color = settings.players[most_voted]
        local hex = settings.colors[color][1]
        core.chat_send_all(S("@1 was ejected.", core.colorize(hex, most_voted)))
        local most_player = core.get_player_by_name(most_voted)
        settings.play_sound("eject")
        if most_player then
            if not settings.roles[most_voted] == "impostor" then
                settings.roles[most_voted] = "ghost"
            end
            most_player:set_properties({
                visual_size = {x = 0, y = 0, z = 0},
                is_visible = false,
                pointable = false,
                makes_footstep_sound = false
            })
        end
    elseif tie then
        if max_votes == 0 then
            core.chat_send_all(S("No one was ejected. (Skipped)"))
        else
            core.chat_send_all(S("No one was ejected. (Tie)"))
        end
        most_voted = nil
    else
        core.chat_send_all(S("No one was ejected."))
    end
    core.chat_send_all("---")
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        if settings.meeting.hud[name] then
            player:hud_remove(settings.meeting.hud[name])
        end
        player:set_properties({
            nametag_color = {r=0,g=0,b=0,a=0}
        })
        settings.cooldown[name] = nil
    end
    if settings.started and most_voted then
        if settings.roles[most_voted] == "impostor" then
            settings.tell_role(name)
            core.chat_send_player(most_voted, S("You have been ejected, but you still can sabotage!"))
        else
            core.chat_send_player(most_voted, S("You have been ejected, but you still can complete tasks!"))
        end
        local most_player = core.get_player_by_name(most_voted)
        local inv = most_player:get_inventory()
        inv:set_list("main", {})
    end
    settings.meeting_started = false
    settings.check_end_game()
    settings.restore("skeld")

    core.after(settings.get_setting("button_delay"), function()
        settings.button_pressed = false
    end)
end

function settings.check_end_game()
    local impostors = 0
    local crewmates = 0
    for name, role in pairs(settings.roles) do
        local player = core.get_player_by_name(name)
        if role == "impostor" and not (player:get_properties().visual_size.x < 1) then
            impostors = impostors + 1
        elseif ((role == "crewmate") or (role == "engineer")) and not (player:get_properties().visual_size.x < 1) then
            crewmates = crewmates + 1
        end
    end

    if impostors == 0 then
        core.chat_send_all(core.colorize("cyan", S("Crewmates win!")))
        for name, role in pairs(settings.roles) do
            if not (role == "impostor") then
                points.add(name, 250 + tasks.completed_tasks[name])
            else
                points.add(name, (100 * settings.killed_people[name]))
            end
        end
        settings.play_sound("win_crewmate")
        settings.end_game()
    elseif impostors >= crewmates then
        core.chat_send_all(core.colorize("red", S("Impostors win!")))
        for name, role in pairs(settings.roles) do
            if not (role == "impostor") then
                points.add(name, 100 + math.floor(tasks.completed_tasks[name] / 2))
            else
                points.add(name, 500 + (100 * settings.killed_people[name]) + tasks.completed_tasks[name])
            end
        end
        settings.play_sound("win_impostor")
        settings.end_game()
    end
end

function settings.end_game()
    settings.started = false
    settings.current_sabotage = nil
    settings.active_sabotage = false
    settings.roles = {}
    settings.hud = {}
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        core.close_formspec(name, '')
        local inv = player:get_inventory()
	    inv:set_list("main", {})
        local meeting_hud = settings.meeting.hud[name]
        if meeting_hud then
            player:hud_remove(meeting_hud)
        end
        local color = settings.players[name]
        if color then
            local rgb = util.hex(settings.colors[color][1])
            player:set_properties({
                visual_size = {x = 1, y = 1, z = 1},
                nametag_color = {r=rgb.r, g=rgb.g, b=rgb.b, a=255},
                is_visible = true,
                pointable = true,
                makes_footstep_sound = true
            })
        end
        settings.add_interface(player)
    end
    for name, id in pairs(settings.black_screen) do
        local player = core.get_player_by_name(name)
        if player then
            player:hud_remove(id)
        end
    end
    core.set_timeofday(0.5)
    settings.black_screen = {}
    settings.meeting.players = {}
    settings.meeting.hud = {}
    settings.teleport_all(true)
    settings.restore("skeld")
    settings.ship()
    tasks.completed_tasks = {}
    settings.killed_people = {}
end

function settings.start_timer()
    settings.meeting.time = settings.get_setting("discuss_time")
    for i = 1, settings.meeting.time do
        core.after(i, function()
            settings.meeting.time = settings.meeting.time - 1
            settings.update_interface()
        end)
    end
end

function settings.start_timer_two()
    settings.meeting.time = settings.get_setting("vote_time") + 1
    for i = 1, settings.meeting.time do
        core.after(i, function()
            settings.meeting.time = settings.meeting.time - 1
            settings.update_interface()
            local count = #settings.meeting.players
            if settings.meeting.time < 1 then
                settings.finish_voting()
            end
        end)
    end
end

function settings.emergency_meeting(name, dead)
    settings.meeting.players = {}
    core.chat_send_all("---")
    local color = settings.players[name]
    local hex = settings.colors[color][1]
    if not dead then
        core.chat_send_all(S("@1 called emergency meeting!", core.colorize(hex, name)))
        if (settings.roles[name] == "crewmate") or (settings.roles[name] == "engineer") then
            tasks.completed_tasks[name] = tasks.completed_tasks[name] + 25
        end
        settings.play_sound("emergency_meeting")
    else
        core.chat_send_all(S("@1 reported dead body!", core.colorize(hex, name)))
        if (settings.roles[name] == "crewmate") or (settings.roles[name] == "crewmate") then
            tasks.completed_tasks[name] = tasks.completed_tasks[name] + 100
        end
        settings.play_sound("dead_body_reported")
    end
    core.chat_send_all("---")
    settings.restore("skeld_emergency_meeting")
    settings.meeting_started = true
    settings.button_pressed = true
    settings.teleport_all()
    if (settings.current_sabotage == "reactor" or settings.current_sabotage == "oxygen") then
        settings.active_sabotage = false
        settings.current_sabotage = nil
    end
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        if not (player:get_properties().visual_size.x < 1) then
            settings.meeting.players[name] = {voted = false, votings = 0}
            settings.player_positions[name] = nil
            local color = settings.players[name]
            local rgb = util.hex(settings.colors[color][1])
            player:set_properties({
                nametag_color = {r=rgb.r, g=rgb.g, b=rgb.b, a=255},
                visual_size = {x = 1, y = 1, z = 1},
                is_visible = true,
                pointable = true,
                makes_footstep_sound = true
            })
        end
        core.close_formspec(name, '')
        settings.meeting.hud[name] = player:hud_add({
            type = "text",
            position = {x = 0.75, y = 0.75},
            scale = {x = 1, y = 1},
            text = S("Discuss! Time: @1s", settings.meeting.time),
            alignment = {x=0, y=0},
            z_index = 1,
            number = 0xffffff,
        })
    end
    settings.meeting.status = "discuss"
    settings.start_timer()
end

function settings.restore(map)
    core.place_schematic({x = -49, y = -3, z = -48}, modpath.."/schematics/"..map..".mts", 0, {}, true, '')
end

core.register_on_chat_message(function(name, message)
    local color = settings.players[name]
    if color then
        local hex = settings.colors[color][1]
        local plr = core.get_player_by_name(name)
        if settings.started and (plr:get_properties().visual_size.x < 1) then
            for _, player in pairs(core.get_connected_players()) do
                if player:get_properties().visual_size.x < 1 then
                    local pname = player:get_player_name()
                    core.sound_play("new_message", {to_player = pname})
                    core.chat_send_player(pname, core.colorize("#959a9e", S("[GHOST]")).." "..core.format_chat_message(core.colorize(hex, name), message))
                end
            end
            return true
        end
        local role = settings.roles[name]
        if role then
            if settings.started and not (plr:get_properties().visual_size.x < 1) and (role == "impostor") and string.match(message, "^!") then
                for _, player in pairs(core.get_connected_players()) do
                    local pname = player:get_player_name()
                    local prole = settings.roles[pname]
                    if (prole == "impostor") and not (player:get_properties().visual_size.x < 1) then
                        core.sound_play("new_message", {to_player = pname})
                        core.chat_send_player(pname, core.colorize("red", S("[IMPOSTOR]")).." "..core.format_chat_message(core.colorize(hex, name), string.sub(message, 2)))
                    end
                end
                return true
            end
        end
        if settings.started and not settings.meeting_started then
            return true
        end
        settings.play_sound("new_message")
        core.chat_send_all(core.format_chat_message(core.colorize(hex, name), message))
        return true
    end
end)

function settings.kill(name)
    local player = core.get_player_by_name(name)
    core.sound_play("kill_crewmate", {to_player = name})
    if player then
        local obj = core.add_entity(player:get_pos(), "settings:dead_body")
        local props = player:get_properties()
        if obj then
            local textures = props.textures
            obj:set_properties({
                textures = textures,
                infotext = name,
                mesh = props.mesh
            })
        end
        settings.roles[name] = "ghost"
        player:set_properties({
            visual_size = {x = 0, y = 0, z = 0},
            is_visible = false,
            pointable = false,
            makes_footstep_sound = false
        })
        settings.tell_role(name)
        core.chat_send_player(name, S("You have been killed, but you still can complete tasks!"))
    end
    settings.check_end_game()
end