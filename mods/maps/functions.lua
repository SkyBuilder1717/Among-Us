function maps.node_sound_defaults(tbl)
	tbl = tbl or {}
	tbl.footstep = tbl.footstep or
			{name = "", gain = 1.0}
	tbl.dug = tbl.dug or
			{name = "default_dug_node", gain = 0.25}
	tbl.place = tbl.place or
			{name = "default_place_node_hard", gain = 1.0}
	return tbl
end

function maps.node_sound_wood(tbl)
	tbl = tbl or {}
	tbl.footstep = tbl.footstep or
			{name = "default_wood_footstep", gain = 0.15}
	tbl.dig = tbl.dig or
			{name = "default_dig_choppy", gain = 0.4}
	tbl.dug = tbl.dug or
			{name = "default_wood_footstep", gain = 1.0}
	maps.node_sound_defaults(tbl)
	return tbl
end

function maps.node_sound_metal(tbl)
	tbl = tbl or {}
	tbl.footstep = tbl.footstep or
			{name = "metal_footstep", gain = 1.0}
	tbl.dug = tbl.dug or
			{name = "metal_footstep", gain = 1.0}
	maps.node_sound_defaults(tbl)
	return tbl
end

function maps.node_sound_tile(tbl)
	tbl = tbl or {}
	tbl.footstep = tbl.footstep or
			{name = "tile_footstep", gain = 1.0}
	tbl.dug = tbl.dug or
			{name = "tile_footstep", gain = 1.0}
	maps.node_sound_defaults(tbl)
	return tbl
end

function maps.node_sound_carpet(tbl)
	tbl = tbl or {}
	tbl.footstep = tbl.footstep or
			{name = "carpet_footstep", gain = 1.0}
	tbl.dug = tbl.dug or
			{name = "carpet_footstep", gain = 1.0}
	maps.node_sound_defaults(tbl)
	return tbl
end

local fence_collision_extra = 4/8

function maps.register_fence(name, def)
	local default_fields = {
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {-1/8, -1/2, -1/8, 1/8, 1/2, 1/8},
			connect_front = {{-1/16,  3/16, -1/2,   1/16,  5/16, -1/8 },
				         {-1/16, -5/16, -1/2,   1/16, -3/16, -1/8 }},
			connect_left =  {{-1/2,   3/16, -1/16, -1/8,   5/16,  1/16},
				         {-1/2,  -5/16, -1/16, -1/8,  -3/16,  1/16}},
			connect_back =  {{-1/16,  3/16,  1/8,   1/16,  5/16,  1/2 },
				         {-1/16, -5/16,  1/8,   1/16, -3/16,  1/2 }},
			connect_right = {{ 1/8,   3/16, -1/16,  1/2,   5/16,  1/16},
				         { 1/8,  -5/16, -1/16,  1/2,  -3/16,  1/16}}
		},
		collision_box = {
			type = "connected",
			fixed = {-1/8, -1/2, -1/8, 1/8, 1/2 + fence_collision_extra, 1/8},
			connect_front = {-1/8, -1/2, -1/2,  1/8, 1/2 + fence_collision_extra, -1/8},
			connect_left =  {-1/2, -1/2, -1/8, -1/8, 1/2 + fence_collision_extra,  1/8},
			connect_back =  {-1/8, -1/2,  1/8,  1/8, 1/2 + fence_collision_extra,  1/2},
			connect_right = { 1/8, -1/2, -1/8,  1/2, 1/2 + fence_collision_extra,  1/8}
		},
		connects_to = {"group:fence", "group:wood", "group:tree", "group:wall"},
		tiles = {def.texture},
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {},
	}
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end

	def.groups.fence = 1
	local material = def.material
	def.texture = nil
	def.material = nil

	minetest.register_node(name, def)
end