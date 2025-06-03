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
        },
        sabotage_time = {
            title = "Sabotage time",
            type = "int",
            default = 30,
            min = 15, 
            max = 45,
            subfix = "second(-s)"
        },
        button_delay = {
            title = "Emergency button delay",
            type = "int",
            default = 30,
            min = 0, 
            max = 60,
            subfix = "second(-s)"
        },
        discuss_time = {
            title = "Discuss time",
            type = "int",
            default = 30,
            min = 5, 
            max = 120,
            subfix = "second(-s)"
        },
        vote_time = {
            title = "Voting time",
            type = "int",
            default = 45,
            min = 10, 
            max = 120,
            subfix = "second(-s)"
        },
        engineers = {
            title = "Engineers",
            type = "int",
            default = 1,
            min = 0, 
            max = 3
        }
    },
    colors = {
        banana = {
            "#ffff7e",
            "#d6c06f",
            "#bda164",
            "#d1b965"
        },
        red = {
            "#db0707",
            "#a60d0d",
            "#6e0808",
            "#bd0f0f"
        },
        orange = {
            "#db6307",
            "#a6570d",
            "#84370b",
            "#bd4c0f"
        },
        yellow = {
            "#e5bd0b",
            "#bc960e",
            "#7a5a0f",
            "#bd910f"
        },
        lime = {
            "#36c612",
            "#0da615",
            "#0c7a14",
            "#15b90f"
        },
        green = {
            "#207f11",
            "#115e1a",
            "#054909",
            "#1b6b22"
        },
        cyan = {
            "#32c7e9",
            "#2095c8",
            "#2287bd",
            "#2ca0d1"
        },
        blue = {
            "#1a45d3",
            "#1c34ac",
            "#0e3988",
            "#1339b8"
        },
        dark_purple = {
            "#1c1333",
            "#150d23",
            "#0a0418",
            "#1b0d32"
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
        grey = {
            "#6c6c6c",
            "#585858",
            "#2e2e2e",
            "#454545"
        },
        white = {
            "#cde1e8",
            "#9aafb9",
            "#6c7579",
            "#8799a2"
        },
        coral = {
            "#ff6f61",
            "#d0554a",
            "#9d3e35",
            "#b54b41"
        },
        maroon = {
            "#540d0d",
            "#430a0a",
            "#320606",
            "#430b0b"
        }
    },
    costumes = {
        none = {
            modifier = "",
            icon = "settings_color_chosen.png"
        },
        bandage = {
            modifier = "^costumes_bandage.png",
            icon = "costumes_bandage_icon.png",
            price = 1000
        },
        tuxedo = {
            modifier = "^costumes_smoking.png",
            icon = "costumes_smoking_icon.png",
            price = 2000
        },
        no_signal = {
            modifier = "^costumes_glitch.png",
            icon = "costumes_glitch_icon.png",
            price = 1000
        },
        headphones = {
            modifier = "^costumes_headphones.png",
            icon = "costumes_headphones_icon.png",
            price = 1250
        },
        baby_boy = {
            modifier = "^costumes_baby.png",
            icon = "costumes_baby_icon.png",
            price = 2500
        },
        jordan = {
            modifier = "^costumes_jordan.png",
            icon = "costumes_jordan_icon.png",
            price = 1750
        },
        impostor = {
            modifier = "^costumes_red_eye.png",
            icon = "costumes_red_eye_icon.png",
            price = 500
        },
        french_toast = {
            modifier = "^costumes_bread.png",
            icon = "costumes_bread_icon.png",
            price = 10000
        },
        grey_hoodie = {
            modifier = "^costumes_hoodie.png",
            icon = "costumes_hoodie_icon.png",
            price = 6000
        },
        sunglasses = {
            modifier = "^costumes_sunglasses.png",
            icon = "costumes_sunglasses_icon.png",
            price = 4000
        },
        skull = {
            modifier = "^costumes_inside.png",
            icon = "costumes_inside_icon.png",
            price = 5000,
            no_visor = true
        },
        henry = {
            modifier = "^costumes_henry.png",
            icon = "costumes_henry_icon.png",
            dev_only = true
        },
        astley = {
            modifier = "^costumes_rickroll.png",
            icon = "costumes_rickroll_icon.png",
            price = 3000
        },
        mini_amogus = {
            modifier = "",
            mesh = "character_hat.glb",
            icon = "costumes_miniamogus_icon.png",
            price = 15000
        },
        cap = {
            modifier = "",
            mesh = "character_cap.glb",
            icon = "costumes_cap_icon.png",
            material = {"costumes_cap.png"},
            price = 2000
        }
    },
    killed_people = {},
    players = {},
    roles = {},
    hud = {},
    formspec = {},
    cooldown = {}
}
local modname = core.get_current_modname()
local modpath = core.get_modpath(modname)
util = dofile(modpath.."/util.lua")
local S = core.get_translator(modname)

core.register_privilege("start", {
    description = S("Can start the game"),
    give_to_admin = true,
    give_to_singleplayer = true
})

for color, def in pairs(settings.colors) do
    core.register_item("settings:"..color, {
        type = "none",
        wield_image = "wield_hand_fill.png^[colorize:"..def[1]..":255]^(wield_hand_outline.png^[colorize:"..def[2]..":255])",
        groups = {not_in_creative_inventory=1},
        range = 2
    })
end

dofile(modpath.."/points.lua")
dofile(modpath.."/api.lua")
dofile(modpath.."/vents.lua")
dofile(modpath.."/colors.lua")
dofile(modpath.."/costumes.lua")
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
        settings.show_colors_menu(name)
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

function settings.ship()
    core.place_schematic({x = -70, y = 0, z = -25}, modpath.."/schematics/ship.mts", 0, {}, true, '')
end

core.after(0, function()
    core.set_timeofday(0.5)
    settings.restore("skeld")
    settings.ship()
end)

core.register_chatcommand("vote", {
    description = S("Vote, while meetings!"),
    params = S("<player>"),
    func = function(name, param)
        local plr = core.get_player_by_name(name)
        if (settings.started and settings.meeting_started) and not (plr:get_properties().visual_size.x < 1) then
            if settings.meeting.status ~= "voting" then
                return false, S("Wait until Voting time!")
            else
                if settings.meeting.players[name].voted then return false, S("You have already voted!") end
                if not settings.meeting.players[param] then return false, S("Player not found!") end
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
        local killed = settings.killed_people[player_name] or 0
        if settings.cooldown[player_name] then
            core.chat_send_player(player_name, S("Wait for cooldown!"))
        elseif settings.started and not settings.meeting_started then
            if pointed_thing.type == "object" and pointed_thing.ref:is_player() then
                local victim = pointed_thing.ref
                local vname = victim:get_player_name()
                if settings.roles[vname] == "impostor" then return end
                settings.kill(vname)
                core.sound_play("kill", {to_player = player_name})
                killed = killed + 1
                settings.cooldown[player_name] = true
                core.after(settings.get_setting("kill_cooldown"), function()
                    settings.cooldown[player_name] = nil
                    local plr = core.get_player_by_name(player_name)
                    if settings.started and not settings.meeting_started and plr and not (plr:get_properties().visual_size.x < 1) and (settings.roles[player_name] == "impostor") then
                        core.chat_send_player(player_name, S("You can kill again."))
                    end
                end)
            end
        end
    end,
    on_drop = function(itemstack, dropper, pos) return itemstack end
})