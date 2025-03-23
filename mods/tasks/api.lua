local function shallow(og)
	local c = {}
	for k, v in pairs(og) do
		c[k] = v
	end
	return c
end
local function shuffle(tbl)
	local table = shallow(tbl)
	local size = #table
	for i = size, 1, -1 do
		local rand = math.random(size)
		table[i], table[rand] = table[rand], table[i]
	end
	return table
end

local modname = core.get_current_modname()
local S = core.get_translator(modname)

function tasks.register_task(name)
    table.insert(tasks.registered_tasks, {name = name, defs = {}})
end

function tasks.inspect_sample(name)
    for _, task in pairs(tasks.players[name]) do
        if task.name == "inspect_sample" then
            minetest.after(1, function()
                task.index = task.index - 1
                task.manual = true
                if task.index > #task.states then
                    tasks.inspect_sample(name)
                else
                    task.index = 0
                    task.ready = true
                    task.manual = nil
                end
                tasks.update_hud()
            end)
        end
    end
end

tasks.on_rightclick = function(pos, node, player, stack, pointed_thing)
    local name = player:get_player_name()
    if not tasks.players[name] then
        return
    end
    for _, task in pairs(tasks.players[name]) do
        if not (task.index == #task.states) and not (task.index > #task.states) then
            local index = task.index + 1
            local tpos = task.states[index].pos
            if tpos.x == pos.x and tpos.y == pos.y and tpos.z == pos.z then
                if task.name == "inspect_sample" and not task.ready then
                    task.index = 60
                    tasks.inspect_sample(name)
                else
                    task.index = task.index + 1
                end
            end
        end
    end
    tasks.update_hud()
end

function tasks.add_task(name, def)
    for i, task in pairs(tasks.registered_tasks) do
        if task.name == name then
            table.insert(tasks.registered_tasks[i].defs, def)
        end
    end
end

function tasks.show_taskbar(player)
    local name = player:get_player_name()
    local total, current = 0, 0
    for _, def in pairs(tasks.players[name]) do
        total = total + 1
        if def.index == #def.states then
            current = current + 1
        end
    end
    local width = 6 * (current / total)
    table.insert(tasks.hud[name], player:hud_add({
        type = "image",
        position = {x=0.2, y=0.025},
        name = "taskbar_bg",
        scale = {x=6, y=6},
        text = "tasks_taskbar_bg.png",
        alignment = {x=0, y=0},
        z_index = 0
    }))
    table.insert(tasks.hud[name], player:hud_add({
        type = "image",
        position = {x=0.0065, y=0.025},
        name = "taskbar_fg",
        scale = {x=width, y=6},
        text = "tasks_taskbar_fg.png",
        alignment = {x=1, y=0},
        z_index = 0
    }))
end

function tasks.update_hud()
    for name, new_tasks in pairs(tasks.players) do
        local player = core.get_player_by_name(name)
        if tasks.hud[name] then
            for _, id in pairs(tasks.hud[name]) do
                player:hud_remove(id)
            end
        end
        tasks.hud[name] = {}
        tasks.show_taskbar(player)
        for i, task in ipairs(new_tasks) do
            local index = task.index + 1
            local states = table.copy(task.states)
            local color
            if task.index > #states then
                color = 0xFFFF00
            elseif (task.index == #states) and (not task.manual) then
                color = 0x00FF00
                index = task.index
            elseif task.index > 0 then
                color = 0xFFFF00
            elseif task.ready then
                index = 1
                color = 0xFFFF00
            else
                index = 1
                color = 0xFFFFFF
            end
            if #states > 1 then
                table.insert(tasks.hud[name], player:hud_add({
                    type = "text",
                    position = {x=0.075, y=0.05 + (0.025 * i)},
                    name = task.name,
                    scale = {x = 1, y = 1},
                    text = S(states[index].title.." (@1/@2)",
                        task.index,
                        #states),
                    alignment = {x=0, y=0},
                    z_index = 1,
                    number = color,
                    style = 0
                }))
            elseif task.index > #states then
                table.insert(tasks.hud[name], player:hud_add({
                    type = "text",
                    position = {x=0.075, y=0.05 + (0.025 * i)},
                    name = task.name,
                    scale = {x = 1, y = 1},
                    text = S(states[#states].title.." (@1)",
                        task.index),
                    alignment = {x=0, y=0},
                    z_index = 1,
                    number = color,
                    style = 0
                }))
            else
                table.insert(tasks.hud[name], player:hud_add({
                    type = "text",
                    position = {x=0.075, y=0.05 + (0.025 * i)},
                    name = task.name,
                    scale = {x = 1, y = 1},
                    text = states[index].title,
                    alignment = {x=0, y=0},
                    z_index = 1,
                    number = color,
                    style = 0
                }))
            end
        end
    end
end

function tasks.generate_tasks()
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        tasks.players[name] = {}
        local defs = table.copy(tasks.registered_tasks)
        for i = 1, tasks.amount do
            local num = math.random(1, #defs)
            local task = defs[num]
            local def = task.defs[math.random(1, #task.defs)]
            local new_task = table.copy(def)
            new_task.states = def.states[math.random(1, #def.states)]
            if task.name == "fix_electro" and (settings.map == "skeld") then
                new_task.states = shuffle(new_task.states)
                for i = 1, 3 do
                    table.remove(new_task.states, math.random(1, #new_task.states))
                end
            elseif task.name == "trash" and (settings.map == "skeld") then
                table.remove(new_task.states, math.random(1, 2))
            end
            new_task.name = task.name
            new_task.index = 0
            table.insert(tasks.players[name], new_task)
            table.remove(defs, num)
        end
        tasks.update_hud()
    end
end

core.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    tasks.players[name] = nil
    tasks.hud[name] = nil
end)