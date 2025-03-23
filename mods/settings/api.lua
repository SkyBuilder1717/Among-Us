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