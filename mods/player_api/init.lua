dofile(core.get_modpath("player_api") .. "/api.lua")

local player_def = {
	animation_speed = 1,
	textures = {"player_api_mask_OLD.png^visor.png"},
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 2.66},
		lay       = {x = 5.4, y = 5.5, eye_height = 0.3, override_local = true,
			collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6}},
		walk      = {x = 5.6, y = 6.27},
		mine      = {x = 6.3, y = 6.63},
		walk_mine = {x = 6.67, y = 7.33},
		sit       = {x = 2.7,  y = 5.37, eye_height = 0.8, override_local = true,
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.0, 0.3}}
	},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 1,
	eye_height = 1.47,
}

-- Default player appearance
player_api.register_model("character.glb", player_def)
player_api.register_model("character_hat.glb", player_def)
player_api.register_model("character_cap.glb", player_def)

player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"character.png"},
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 79},
		lay       = {x = 162, y = 166, eye_height = 0.3, override_local = true,
			collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6}},
		walk      = {x = 168, y = 187},
		mine      = {x = 189, y = 198},
		walk_mine = {x = 200, y = 219},
		sit       = {x = 81,  y = 160, eye_height = 0.8, override_local = true,
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.0, 0.3}}
	},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 0.6,
	eye_height = 1.47,
})

local function choose_color(name)
	local colors = settings.available_colors()
	settings.set_color(name, colors[math.random(1, #colors)])
end

local storage = settings.storage
core.register_on_joinplayer(function(player)
	settings.play_sound("joining")

	local str = core.settings:get("static_spawnpoint")
	str = str:sub(2, -2)
	local pos = {}
	for v in string.gmatch(str, "([^,]+)") do
		table.insert(pos, tonumber(v))
	end
	player:set_pos({x = pos[1], y = pos[2], z = pos[3]})

	local inv = player:get_inventory()
	inv:set_list("main", {})
	inv:set_size("hand", 1)
	player_api.set_model(player, "character.glb")
	player:set_properties({show_on_minimap = false})
	local name = player:get_player_name()
	local color = storage:get("_player_"..name)
	if color then
		settings.set_color(name, color)
	else
		choose_color(name)
	end
	
	local ver = core.get_player_information(name).version_string
	if not ((ver == "5.11.0") or (ver == "5.12.0")) then
		core.kick_player(name, "Update to version 5.11 or newer!")
	end
end)

core.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	settings.players[name] = nil
    settings.roles[name] = nil
    settings.hud[name] = nil
	settings.meeting.players[name] = nil
	settings.player_positions[name] = nil
	settings.play_sound("leaving")
	if settings.started then
		settings.check_end_game()
	end
end)

core.register_on_prejoinplayer(function(name)
	if settings.started then
		return "Game is already started! Please, join later!"
	end
end)

core.register_on_mods_loaded(function()
	core.unregister_chatcommand("msg")
	core.unregister_chatcommand("me")
	core.unregister_chatcommand("kill")
	core.unregister_chatcommand("clear_mobs")
	core.unregister_chatcommand("clearinv")
	core.unregister_chatcommand("setpassword")
	core.unregister_chatcommand("teleport")
	core.unregister_chatcommand("pulverize")
	core.unregister_chatcommand("days")
	core.unregister_chatcommand("clearpassword")
end)