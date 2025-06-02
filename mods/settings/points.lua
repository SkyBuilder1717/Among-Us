local modname = core.get_current_modname()
local S = core.get_translator(modname)

points = {
    players = {}
}

local modname = core.get_current_modname()
local worldpath = core.get_worldpath() .. "/"
local file = "among_us_points.json"

local function read_file(path)
    local f = io.open(path, "r")
    if not f then
        return nil
    end
    local txt = f:read("*all")
    f:close()
    return txt
end

local function write_file(path, content)
    local f = io.open(path, "w")
    f:write(content)
    f:close()
end

function points.save()
    local content = core.write_json(points.players)
    local path = worldpath .. file
    write_file(path, content)
end

function points.load()
    local content = read_file(worldpath .. file)
    if not content then
        return false
    end
    local tbl = core.parse_json(content)
    if not tbl then
        return false
    end
    points.players = tbl
    return true
end

function points.get(name)
    return points.players[name] or 0
end

function points.set(name, count)
    count = math.floor(count)
    points.players[name] = count
    points.save()
end

function points.add(name, count)
    count = math.floor(count)
    local bal = points.get(name)
    points.players[name] = bal + count
    core.chat_send_player(name, S("Got @1 points!", count))
    points.save()
end

function points.remove(name, count)
    count = math.floor(count)
    local bal = points.get(name)
    points.players[name] = bal - count
    points.save()
end

core.register_on_mods_loaded(function() points.load() end)