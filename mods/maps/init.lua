maps = {}
local modname = core.get_current_modname()
local modpath = core.get_modpath(modname)

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/tools.lua")
dofile(modpath .. "/nodes.lua")

core.register_on_generated(function()
	--core.set_node({x = 0, y = 0, z = 0}, {name = "maps:metal"})
end)