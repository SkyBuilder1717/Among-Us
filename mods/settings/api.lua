local modname = core.get_current_modname()
local modpath = core.get_modpath(modname)
local S = core.get_translator(modname)
local storage = settings.storage

local function contain(t, vl)
	for _, v in pairs(t) do if v == vl then return true end end return false
end

local function remove(t, val)
    for i, v in ipairs(t) do
        if v == val then
            return table.remove(t, i)
        end
    end
end

function settings.available_colors()
	local colors = {}
	for color, _ in pairs(settings.colors) do
		table.insert(colors, color)
	end
	for _, color in pairs(settings.players) do
		remove(colors, color)
	end
	return colors
end

function settings.is_color_available(color)
    if contain(settings.available_colors(), color) then
        return true
    end
    return false
end

function settings.set_color(name, color)
    if not contain(settings.available_colors(), color) then
        return false
    end
    storage:set_string("_player_"..name, color)
    settings.players[name] = color
    local colors = settings.colors[color]
    local player = core.get_player_by_name(name)
	player_api.set_textures(player, {"player_api_red.png^[colorize:"..colors[1]..":255]^(player_api_green.png^[colorize:"..colors[2]..":255]^(player_api_blue.png^[colorize:"..colors[3]..":255]^(player_api_pink.png^[colorize:"..colors[4]..":255])))^visor.png"})
	local inv = player:get_inventory()
    inv:set_stack("hand", 1, "settings:"..color)
    return true
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
            return tonumber(value)
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
        player:set_pos({x = pos[1], y = pos[2], z = pos[3]})
    end
end

function settings.start_game()
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        player:hud_remove(settings.hud[name])
        core.close_formspec(name, '')
    end
    settings.teleport_all()
    settings.started = true
end

function settings.update_interface()
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        if settings.meeting.status == "discuss" then
            player:hud_change(settings.meeting.hud[name], "text", S("Discuss! Time: @1s", settings.meeting.time))
        else
            player:hud_change(settings.meeting.hud[name], "text", S("Voting time! Time: @1s", settings.meeting.time))
        end
    end
    if settings.meeting.status == "discuss" and settings.meeting.time < 1 then
        settings.meeting.status = "voting"
        settings.meeting.time = 45
        settings.start_timer_two()
    end
end

function settings.finish_voting()
    core.chat_send_all("---")
    for player_name, def in pairs(settings.meeting.players) do
        core.chat_send_all(S("@1: @2 vote(-s)", player_name, def.votings))
    end
    core.chat_send_all("---")
    settings.meeting_started = false
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        player:hud_remove(settings.meeting.hud[name])
    end
    settings.restore("skeld")
end

function settings.start_timer()
    settings.meeting.time = 30
    for i = 1, settings.meeting.time do
        core.after(i, function()
            settings.meeting.time = settings.meeting.time - 1
            settings.update_interface()
        end)
    end
end

function settings.start_timer_two()
    settings.meeting.time = 45
    for i = 1, settings.meeting.time do
        core.after(i, function()
            settings.meeting.time = settings.meeting.time - 1
            settings.update_interface()
            if settings.meeting.time < 1 then
                settings.finish_voting()
            end
        end)
    end
end

function settings.emergency_meeting(name, dead)
    core.chat_send_all("---")
    if not dead then
        local color = settings.players[name]
        local hex = settings.colors[color][1]
        core.chat_send_all(S("@1 called emergency meeting!", core.colorize(hex, name)))
    else
        core.chat_send_all(S("@1 reported dead body!", core.colorize(hex, name)))
    end
    core.chat_send_all("---")
    settings.restore("skeld_emergency_meeting")
    if not dead then
        settings.play_sound("emergency_meeting")
    else
        settings.play_sound("dead_body_reported")
    end
    settings.meeting_started = true
    settings.teleport_all()
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        settings.meeting.players[name] = {voted = false, votings = 0}
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
    if not subfix then subfix = '' end
    core.place_schematic({x = -49, y = 0, z = -48}, modpath.."/schematics/"..map..subfix..".mts", 0, {}, true, '')
end

core.register_on_chat_message(function(name, message)
    if settings.started and not settings.meeting_started then
        return true
    end
    settings.play_sound("new_message")
    local color = settings.players[name]
    local hex = settings.colors[color][1]
    core.chat_send_all(core.format_chat_message(core.colorize(hex, name), message))
    return true
end)