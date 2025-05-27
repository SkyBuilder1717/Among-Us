dofile(core.get_modpath("player_api") .. "/api.lua")

-- Default player appearance
player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"player_api_mask_OLD.png^visor.png"},
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
	stepheight = 1,
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
	inv:set_size("hand", 1)
	inv:set_stack("main", 1, "")
	player_api.set_model(player, "character.b3d")
	player:set_properties({show_on_minimap = false})
	-- player:set_physics_override({
	-- 	speed_climb = 0,
	-- 	speed_crouch = 0,
	-- 	speed_fast = 0,
	-- 	jump = 0,
	-- 	liquid_fluidity = 0,
	-- 	liquid_fluidity_smooth = 0,
	-- 	liquid_sink = 0,
	-- 	acceleration_air = 0,
	-- 	acceleration_fast = 0,
	-- 	sneak = false,
	-- 	sneak_glitch = false,
	-- 	new_move = false,
	-- })
	local name = player:get_player_name()
	local color = storage:get("_player_"..name)
	if color then
		settings.set_color(name, color)
	else
		choose_color(name)
	end
end)

core.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	settings.players[name] = nil
    settings.roles[name] = nil
    settings.hud[name] = nil
	settings.meeting.players[name] = nil
	settings.play_sound("leaving")
end)

core.register_on_prejoinplayer(function(name)
	if settings.started then
		return "Game is already started! Please, join later!"
	end
end)