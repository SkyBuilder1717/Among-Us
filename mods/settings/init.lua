settings = {
    storage = core.get_mod_storage(),
    map = "skeld",
    started = false,
    meeting_started = false,
    meeting = {
        status = "discuss",
        time = 30,
        players = {},
        hud = {}
    },
    lobby = {
        impostors = {
            title = "Impostors",
            type = "int",
            default = 1,
            auto = 0,
            min = 1, 
            max = 3
        },
        tasks = {
            title = "Tasks",
            type = "int",
            default = 4,
            min = 1, 
            max = 8
        },
        kill_cooldown = {
            title = "Kill cooldown",
            type = "int",
            default = 45,
            min = 1, 
            max = 60,
            subfix = "second(-s)"
        }
    },
    colors = {
        red = {
            "#db0707",
            "#a60d0d",
            "#5c0303",
            "#bd0f0f"
        },
        orange = {
            "#db6307",
            "#a6570d",
            "#5c2103",
            "#bd4c0f"
        },
        yellow = {
            "#db9f07",
            "#a6760d",
            "#543006",
            "#bd770f"
        },
        green = {
            "#36c612",
            "#0da615",
            "#035c09",
            "#15b90f"
        },
        cyan = {
            "#1ab1d3",
            "#1c72ac",
            "#034f5c",
            "#2270b5"
        },
        blue = {
            "#1a45d3",
            "#1c34ac",
            "#031e5c",
            "#171e98"
        },
        pink = {
            "#dc30d6",
            "#a21f8a",
            "#791b62",
            "#981778"
        },
        purple = {
            "#a81ad3",
            "#92199d",
            "#5d075a",
            "#891798"
        },
        black = {
            "#393939",
            "#2a2a2a",
            "#1e1e1e",
            "#2d2d2d"
        },
        white = {
            "#cde1e8",
            "#9aafb9",
            "#6c7579",
            "#8799a2"
        }
    },
    players = {},
    roles = {},
    hud = {},
    formspec = {}
}
local modname = core.get_current_modname()
local modpath = core.get_modpath(modname)

util = dofile(modpath.."/util.lua")

local S = core.get_translator(modname)

for color, def in pairs(settings.colors) do
    core.register_item("settings:"..color, {
        type = "none",
        wield_image = "wield_hand_fill.png^[colorize:"..def[1]..":255]^(wield_hand_outline.png^[colorize:"..def[2]..":255])",
        groups = {not_in_creative_inventory=1},
        range = 1
    })
end

dofile(modpath.."/api.lua")
dofile(modpath.."/vents.lua")
dofile(modpath.."/skins.lua")
dofile(modpath.."/customization.lua")
dofile(modpath.."/button.lua")
dofile(modpath.."/sabotage.lua")

core.register_node("settings:laptop", {
	drawtype = "mesh",
	tiles = {"settings_laptop.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "settings_laptop.obj",
	paramtype = "light",
	paramtype2 = "facedir",
    on_rightclick = function(_, _, player)
        local name = player:get_player_name()
        settings.show_skins_menu(name)
    end
})

function update_settings_ui(player)
    if settings.started then return end
    local players = #core.get_connected_players()
    if players < 4 then
        settings.lobby.impostors.auto = 0
    elseif players >= 4 and players < 7 then
        settings.lobby.impostors.auto = 1
    elseif players >= 7 and players < 9 then
        settings.lobby.impostors.auto = 2
    elseif players >= 9 then
        settings.lobby.impostors.auto = 3
    end

    local text = ""
    for name, setting in pairs(settings.lobby) do
        local value = settings.get_setting(name)
        text = text .. setting.title..": " .. value
        local subfix = setting.subfix
        if subfix then
            text = text.." "..subfix
        end
        local auto = setting.auto
        if auto and (auto < value) then
            text = text.." (Auto: " .. auto .. ")"
        end
        text = text.."\n"
    end
	local name = player:get_player_name()
    player:hud_change(settings.hud[name], "text", text)
end

function settings.add_interface(player)
	local name = player:get_player_name()
    settings.hud[name] = player:hud_add({
        position = {x=0.075, y=0.6},
        scale = {x = 1, y = 1},
        text = "",
        number = 0xFFFFFF,
        item = 0,
        direction = 0,
        alignment = {x=1, y=0},
        offset = {x=0, y=0},
        world_pos = {x=0, y=0, z=0},
        size = {x=1, y=1},
        style = 0,
    })
    update_settings_ui(player)
end

core.register_on_joinplayer(function(player)
    local formspec = [[
        bgcolor[#080808BB;true]
        listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]
    ]]
	local name = player:get_player_name()
	local info = core.get_player_information(name)
	if info.formspec_version > 1 then
		formspec = formspec .. "background9[5,5;1,1;gui_formbg.png;true;10]"
	else
		formspec = formspec .. "background[5,5;1,1;gui_formbg.png;true]"
	end
	player:set_formspec_prepend(formspec)

	player:hud_set_hotbar_image("gui_hotbar.png")
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
    player:hud_set_flags({minimap = false, minimap_radar = false})

	settings.add_interface(player)
    for _, player in pairs(core.get_connected_players()) do
        update_settings_ui(player)
    end
end)

core.register_on_leaveplayer(function(_)
    for _, player in pairs(core.get_connected_players()) do
        update_settings_ui(player)
    end
end)

core.after(0, function()
    core.set_timeofday(0.5)
    core.place_schematic({x = -70, y = 0, z = -25}, modpath.."/schematics/ship.mts", 0, {}, true, '')
    settings.restore("skeld")
end)

core.register_chatcommand("vote", {
    description = "Vote, while meetings!",
    func = function(name, param)
        local plr = core.get_player_by_name(name)
        if settings.started and settings.meeting_started and not (plr:get_properties().visual_size.x < 1) then
            if settings.meeting.status ~= "voting" then
                return false, S("Wait until Voting time!")
            else
                if not settings.meeting.players[param] then return false, S("Player not found!") end
                if settings.meeting.players[name].voted then return false, S("You already voted!") end
                settings.meeting.players[name].voted = true
                local color = settings.players[name]
                local hex = settings.colors[color][1]
                settings.meeting.players[param].votings = settings.meeting.players[param].votings + 1
                settings.play_sound("voted")
                core.chat_send_all(S("@1 voted!", core.colorize(hex, name)))
                return true
            end
        end
    end
})

core.register_tool("settings:knife", {
    description = S("Knife (Punch to Kill)"),
    inventory_image = "settings_knife.png",
    on_use = function(itemstack, player, pointed_thing)
        local player_name = player:get_player_name()
        local meta = player:get_meta()
        if meta:get_int("among_us_cooldown") < 0 then
            core.chat_send_player(player_name, "Wait for cooldown!")
        elseif settings.started and not settings.meeting_started then
            if pointed_thing.type == "object" and pointed_thing.ref:is_player() then
                local victim = pointed_thing.ref
                settings.kill(victim:get_player_name())
                core.sound_play("kill", {to_player = player_name})
                meta:set_int("among_us_cooldown", -1)
                core.after(settings.get_setting("kill_cooldown"), function()
                    meta:set_int("among_us_cooldown", 0)
                    if settings.started and not settings.meeting_started then
                        core.chat_send_player(player_name, "You can kill again.")
                    end
                end)
            end
        end
    end,
    on_drop = function(itemstack, dropper, pos) return itemstack end
})