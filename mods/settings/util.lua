local funcs = {}

function funcs.fill_area(pos1, pos2, nodename)
    local minp = vector.new(math.min(pos1.x, pos2.x), math.min(pos1.y, pos2.y), math.min(pos1.z, pos2.z))
    local maxp = vector.new(math.max(pos1.x, pos2.x), math.max(pos1.y, pos2.y), math.max(pos1.z, pos2.z))
    local vm = VoxelManip()
    local emin, emax = vm:read_from_map(minp, maxp)
    local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
    local data = vm:get_data()
    local c_id = core.get_content_id(nodename)
    for z = minp.z, maxp.z do
        for y = minp.y, maxp.y do
            for x = minp.x, maxp.x do
                local i = area:index(x, y, z)
                data[i] = c_id
            end
        end
    end
    vm:set_data(data)
    vm:write_to_map()
    vm:update_map()
end

function funcs.contain(t, v)
    for _, k in pairs(t) do
        if k == v then return true end
    end
    return false
end

function funcs.containk(t, v)
    for k, _ in pairs(t) do
        if k == v then return true end
    end
    return false
end

function funcs.first(str)
    if str == nil or str == "" then return str end
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

function funcs.play_sound(sounds, open)
    for _, pos in pairs(sounds) do
        local spec = {pos = pos, max_hear_distance = 16}
        if open then
            core.sound_play("door_open", spec)
        else
            core.sound_play("door_close", spec)
        end
    end
end

function funcs.remove(t, val)
    for i, v in ipairs(t) do
        if v == val then
            return table.remove(t, i)
        end
    end
end

function funcs.starts(text, start)
    return string.find(text, start, 1, true) == 1
end

function funcs.admin(name)
    local sname = core.settings:get("name")
    return (name == sname) or core.check_player_privs(name, "server")
end

return funcs