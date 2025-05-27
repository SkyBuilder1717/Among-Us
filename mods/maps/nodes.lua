-- Map Decoration

core.register_node("maps:metal", {
	tiles = {"maps_metal_floor.png"},
	sounds = maps.node_sound_metal(),
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:reactor_road", {
	tiles = {"maps_reactor_road.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:medbed_bottom", {
	tiles = {
		"maps_medbed_bottom.png", "maps_medbed_bottom.png",
		"maps_medbed_bottom.png", "maps_medbed_bottom.png",
		"maps_medbed_bottom.png", "maps_medbed_bottom.png"
	},
	sounds = maps.node_sound_defaults(),
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:medbed_top", {
	tiles = {
		"maps_medbed_top.png", "maps_medbed_bottom.png",
		"maps_medbed_bottom.png", "maps_medbed_bottom.png",
		"maps_medbed_bottom.png", "maps_medbed_bottom.png"
	},
	sounds = maps.node_sound_defaults(),
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:acid", {
	tiles = {"maps_acid.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light",
	light_source = 10,
	walkable = false
})

core.register_node("maps:tile", {
	tiles = {"maps_tile.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:reactor_tile", {
	tiles = {"maps_reactor_tile.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:reactor_floor", {
	tiles = {"maps_reactor_floor.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:security_tile", {
	tiles = {"maps_security_tile.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:med_tile", {
	tiles = {"maps_med_tile.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:storage_tile", {
	tiles = {"maps_storage_floor.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:oxygen_tile", {
	tiles = {"maps_oxygen_tile.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:table_tile", {
	tiles = {"maps_table_tile.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:shields_wall", {
	tiles = {"maps_shields_wall.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:reactor_wall", {
	tiles = {"maps_reactor_wall.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:cyan_concrete", {
	tiles = {"maps_cyan_concrete.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:red_concrete", {
	tiles = {"maps_red_concrete.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:white_concrete", {
	tiles = {"maps_white_wall.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:electrocity_wall", {
	tiles = {"maps_electrocity_wall.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:electrocity_floor", {
	tiles = {"maps_electrocity_floor.png"},
	sounds = maps.node_sound_tile(),
	paramtype = "light"
})

core.register_node("maps:white_med", {
	tiles = {"maps_white_wall_med.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:grey_concrete", {
	tiles = {"maps_grey_concrete.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:comms_server", {
	tiles = {
		"maps_comms_side.png", "maps_comms_side.png",
		"maps_comms_side.png", "maps_comms_side.png",
		"maps_comms_side.png", "maps_comms_servers.png"
	},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:comms_top", {
	tiles = {
		"maps_comms_side.png", "maps_comms_side.png",
		"maps_comms_side.png", "maps_comms_side.png",
		"maps_comms_side.png", "maps_comms_top.png"
	},
	sounds = maps.node_sound_defaults(),
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:comms_bottom", {
	tiles = {
		"maps_comms_side.png", "maps_comms_side.png",
		"maps_comms_side.png", "maps_comms_side.png",
		"maps_comms_side.png", "maps_comms_bottom.png"
	},
	sounds = maps.node_sound_defaults(),
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:cyan_glass", {
	drawtype = "glasslike_framed_optional",
	tiles = {"maps_glass_cyan.png", "maps_glass_cyan_detail.png"},
	use_texture_alpha = "blend",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = maps.node_sound_defaults(),
})

core.register_node("maps:green_glass", {
	drawtype = "glasslike_framed_optional",
	tiles = {"maps_glass_green.png", "maps_glass_green_detail.png"},
	use_texture_alpha = "blend",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = maps.node_sound_defaults(),
})

core.register_node("maps:comms_wall", {
	tiles = {"maps_communication_wallpaper.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light",
})

core.register_node("maps:engine", {
	tiles = {"maps_engine.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light",
})

core.register_node("maps:reactor", {
	tiles = {"maps_reactor.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light",
})

core.register_node("maps:wall", {
	tiles = {"maps_wall.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:wall_bottom", {
	tiles = {"maps_wall_bottom.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:nav_top", {
	tiles = {"maps_nav_top.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:nav_bottom", {
	tiles = {"maps_nav_bottom.png"},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:carpet", {
	tiles = {"maps_carpet.png"},
	sounds = maps.node_sound_carpet(),
	paramtype = "light"
})

core.register_node("maps:cyan_carpet", {
	tiles = {"maps_cyan_carpet.png"},
	sounds = maps.node_sound_carpet(),
	paramtype = "light"
})

maps.register_fence("maps:red_fence", {
	texture = "maps_red_fence.png",
	sounds = maps.node_sound_defaults()
})

maps.register_fence("maps:orange_fence", {
	texture = "maps_orange_fence.png",
	sounds = maps.node_sound_defaults()
})

-- Tasks and Sabotage Fixes

core.register_node("maps:shields", {
	drawtype = "mesh",
	tiles = {"maps_shields.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_shields.obj",
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 1.15, 0.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:swipe_card", {
	drawtype = "mesh",
	tiles = {"maps_swipe_card.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_swipe_card.obj",
	selection_box = {
		type = "fixed",
		fixed = {-0.925, -0.775, 0.1, 0.925, -0.25, 0.7}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.925, -0.775, 0.1, 0.925, -0.25, 0.7}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:data", {
	drawtype = "signlike",
	tiles = {"maps_wifi.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:filter", {
	drawtype = "signlike",
	tiles = {"maps_filter.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:reactor_task", {
	drawtype = "mesh",
	mesh = "maps_reactor_task.obj",
	tiles = {"maps_reactor_task.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:electro", {
	drawtype = "signlike",
	tiles = {"maps_electro.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:trash", {
	drawtype = "signlike",
	tiles = {"maps_trash.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:numpad", {
	drawtype = "signlike",
	tiles = {"maps_numpad.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:electro_timing", {
	drawtype = "signlike",
	tiles = {"maps_electro_timing.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:transfer", {
	drawtype = "signlike",
	tiles = {"maps_transfer.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:canister", {
	drawtype = "mesh",
	tiles = {"maps_canister.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_canister.obj",
	paramtype = "light",
	paramtype2 = "facedir",
	selection_box = {
		type = "fixed",
		fixed = {-0.425, -0.5, -0.15, 0.375, 0.5, 0.15}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.425, -0.5, -0.15, 0.375, 0.5, 0.15}
	},
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:engine_fuel", {
	drawtype = "mesh",
	tiles = {"maps_black.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_engine_fuel.obj",
	paramtype = "light",
	walkable = false,
	paramtype2 = "facedir",
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:med_scan", {
	drawtype = "mesh",
	tiles = {"maps_medbay_scan.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_medbay_scan.obj",
	paramtype = "light",
	paramtype2 = "facedir",
	selection_box = {
		type = "fixed",
		fixed = {
			{-1.45, -0.5, -1.45, 1.45, 0, 1.45}
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-1.0, -0.5, -1.0, 1.0, 0, 1.0}
		}
	},
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:engine_correct", {
	drawtype = "mesh",
	tiles = {"maps_engine_correct.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_engine_correct.obj",
	paramtype = "light",
	paramtype2 = "facedir",
	selection_box = {
		type = "fixed",
		fixed = {0, -0.35, -0.5, 0.5, 0.5, 0.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {0, -0.35, -0.5, 0.5, 0.5, 0.5}
	},
	on_rightclick = tasks.on_rightclick
})

core.register_node("maps:monitor", {
	drawtype = "mesh",
	tiles = {"maps_cams.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_monitor.obj",
	paramtype = "light",
	paramtype2 = "facedir",
	on_rightclick = tasks.on_rightclick
})

-- Decorations

core.register_node("maps:engine_lamp", {
	drawtype = "signlike",
	tiles = {"maps_engine_lamp.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true
})

core.register_node("maps:reactor_beacon", {
	drawtype = "signlike",
	tiles = {"maps_reactor_beacon.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true
})

core.register_node("maps:reactor_tube", {
	drawtype = "signlike",
	tiles = {"maps_reactor_tube.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
})

core.register_node("maps:reactor_hand", {
	drawtype = "signlike",
	tiles = {"maps_reactor_hand.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true
})

core.register_node("maps:locker", {
	drawtype = "nodebox",
	tiles = {
		"maps_locker_bottom.png", "maps_locker_bottom.png",
		"maps_locker_side.png", "maps_locker_side.png",
		"maps_locker_side.png", "maps_locker_front.png"
	},
	sounds = maps.node_sound_defaults(),
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.0625, 0.5, 1.5, 0.5}
	},
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:server", {
	drawtype = "nodebox",
	tiles = {
		"maps_locker_bottom.png", "maps_locker_bottom.png",
		"maps_locker_side.png", "maps_locker_side.png",
		"maps_locker_side.png", "maps_server_front.png"
	},
	sounds = maps.node_sound_defaults(),
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0.0625, 0.5, 1.5, 0.5}
	},
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:button", {
	drawtype = "mesh",
	tiles = {"maps_button.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_button.obj",
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "facedir",
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 1.5, 0.5, 1.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 1.5, 0.5, 1.5}
	},
	on_rightclick = function(_, _, player)
		local name = player:get_player_name()
		if not settings.meeting_started then
			settings.show_button_menu(name)
		end
	end
})

core.register_node("maps:communication", {
	drawtype = "mesh",
	tiles = {"maps_communication.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_communication.obj",
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:oxygen_title", {
	drawtype = "signlike",
	tiles = {"maps_oxygen_title.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true
})

core.register_node("maps:vent", {
	drawtype = "signlike",
	tiles = {"maps_vent.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
	on_rightclick = function(pos, node, player, stack, pointed_thing)
		local name = player:get_player_name()
		if settings.roles[name] == "impostor" then

		else
			tasks.on_rightclick(pos, node, player, stack, pointed_thing)
		end
	end
})

core.register_node("maps:wires", {
	drawtype = "signlike",
	tiles = {"maps_wires.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
})

core.register_node("maps:wires2", {
	drawtype = "signlike",
	tiles = {"maps_wires.png^[transformR90"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	legacy_wallmounted = true,
})

core.register_node("maps:metal_cylinder", {
	drawtype = "mesh",
	tiles = {"maps_metal_floor.png"},
	sounds = maps.node_sound_metal(),
	mesh = "maps_cylinder.obj",
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:shields_lamp", {
	drawtype = "mesh",
	tiles = {"maps_lamp.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_cylinder.obj",
	light_source = 7,
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:metal_tube", {
	drawtype = "mesh",
	tiles = {"maps_metal_floor.png"},
	sounds = maps.node_sound_metal(),
	mesh = "maps_cylinder_side.obj",
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:big_box", {
	drawtype = "mesh",
	tiles = {"maps_big_box.png"},
	selection_box = {
		type = "fixed",
		fixed = {-1.5, -0.5, -1.5, 1.5, 2.5, 1.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-1.5, -0.5, -1.5, 1.5, 2.5, 1.5}
	},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_big_box.obj",
	paramtype = "light",
	paramtype2 = "facedir"
})

core.register_node("maps:box", {
	tiles = {
		"maps_box_top.png", "maps_box_top.png",
		"maps_box_side.png", "maps_box_side.png",
		"maps_box_side.png", "maps_box_side.png"
	},
	sounds = maps.node_sound_defaults(),
	paramtype = "light"
})

core.register_node("maps:cams", {
	drawtype = "mesh",
	tiles = {"maps_cams.png"},
	sounds = maps.node_sound_defaults(),
	mesh = "maps_cams.obj",
	paramtype = "light",
	paramtype2 = "facedir",
	selection_box = {
		type = "fixed",
		fixed = {-1.5, -0.5, -0.5, 1.5, 1.5, 0.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-1.5, -0.5, -0.5, 1.5, 1.5, 0.5}
	}
})

core.register_node("maps:cylinder_glass", {
	drawtype = "mesh",
	tiles = {"maps_glass_cyan.png"},
	mesh = "maps_cylinder.obj",
	use_texture_alpha = "blend",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = maps.node_sound_defaults(),
})

core.register_node("maps:barrel", {
	drawtype = "mesh",
	tiles = {"maps_barrel.png"},
	mesh = "maps_barrel.obj",
	paramtype = "light",
	sounds = maps.node_sound_defaults(),
	paramtype2 = "facedir"
})