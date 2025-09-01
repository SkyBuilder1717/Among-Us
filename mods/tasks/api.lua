tasks.completed_tasks = {}

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
    if tasks.players[name] then
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
end

tasks.on_rightclick = function(pos, node, player, stack, pointed_thing)
    local name = player:get_player_name()
    if not tasks.players[name] then
        return
    end
    if settings.roles[name] == "impostor" then return end
    if hide_and_seek and (settings.roles[name] == "ghost") then return end
    if settings and settings.get_setting("hide_and_seek") and (settings.hide_timer and (settings.hide_timer < 30)) then return end
    for _, task in pairs(tasks.players[name]) do
        if not (task.index >= #task.states) then
            local index = task.index + 1
            local tpos = task.states[index].pos
            if tpos.x == pos.x and tpos.y == pos.y and tpos.z == pos.z then
                if (task.name == "inspect_sample" and not task.ready) then
                    task.index = 60
                    tasks.inspect_sample(name)
                    core.sound_play("multitask", {to_player = name})
                    tasks.completed_tasks[name] = tasks.completed_tasks[name] + 10
                else
                    task.index = task.index + 1
                    if task.index < #task.states then
                        core.sound_play("multitask", {to_player = name})
                        tasks.completed_tasks[name] = tasks.completed_tasks[name] + 25
                    else
                        core.sound_play("task_completed", {to_player = name})
                        tasks.completed_tasks[name] = tasks.completed_tasks[name] + 50
                        if settings.get_setting("hide_and_seek") then
                            settings.hide_timer = math.max(0, settings.hide_timer - 15)
                        end
                    end
                end
                tasks.update_hud()
            end
        end
    end
end

function tasks.add_task(name, def)
    for i, task in pairs(tasks.registered_tasks) do
        if task.name == name then
            table.insert(tasks.registered_tasks[i].defs, def)
        end
    end
end

function tasks.show_taskbar()
    local total, current = 0, 0
    for name, taskings in pairs(tasks.players) do
        for _, def in pairs(taskings) do
            if not (settings.roles[name] == "impostor") then 
                total = total + 1
                if def.index == #def.states then
                    current = current + 1
                end
            end
        end
    end

    local percentage = current / total
    local width = 6 * percentage

    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        if not tasks.hud[name] then tasks.hud[name] = {} end
        if settings.get_setting("hide_and_seek") then
            width = 6 * (settings.hide_timer / 200)
            local fg_texture = "tasks_taskbar_fg.png"
            if settings.hide_timer <= 30 then
                fg_texture = "tasks_taskbar_red.png"
            end

            table.insert(tasks.hud[name], player:hud_add({
                type = "image",
                position = {x=0.2, y=0.025},
                name = "timer_bar_bg",
                scale = {x=6, y=6},
                text = "tasks_taskbar_bg.png",
                alignment = {x=0, y=0},
                z_index = 0
            }))
            table.insert(tasks.hud[name], player:hud_add({
                type = "image",
                position = {x=0.0065, y=0.025},
                name = "timer_bar_fg",
                scale = {x=width, y=6},
                text = fg_texture,
                alignment = {x=1, y=0},
                z_index = 1
            }))
        else
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
    end

    if (not settings.get_setting("hide_and_seek")) and (percentage == 1) then
        core.chat_send_all(S("Tasks completed!").." "..core.colorize("cyan", S("Crewmates win!")))
        settings.send_embed("Tasks completed! Crewmates win!", "#00ffff")
        for name, role in pairs(settings.roles) do
            if role ~= "impostor" then
                points.add(name, 750 + tasks.completed_tasks[name])
            else
                points.add(name, (100 * settings.killed_people[name]))
            end
        end
        settings.play_sound("win_crewmate")
        settings.end_game()
    end
end

function tasks.reset_hud(name)
    local player = core.get_player_by_name(name)
    if tasks.hud[name] then
        for _, id in pairs(tasks.hud[name]) do
            player:hud_remove(id)
        end
    end
    tasks.hud[name] = {}
end

function tasks.update_hud()
    for name, new_tasks in pairs(tasks.players) do
        if not tasks.completed_tasks[name] then
            tasks.completed_tasks[name] = 0
        end
        local player = core.get_player_by_name(name)
        tasks.reset_hud(name)
        local hide_and_seek = settings.get_setting("hide_and_seek")
        if not (settings.roles[name] == "impostor") then
            if (not hide_and_seek) or (hide_and_seek and (not (settings.roles[name] == "ghost") and (settings.hide_timer > 30))) then
                for i, task in ipairs(new_tasks) do
                    local index = task.index + 1
                    local states = table.copy(task.states)
                    local color
                    local ypos = 0.11
                    if not (settings.active_sabotage and settings.current_sabotage == "communication") then
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
                        if #states > 1 and not task.text_only then
                            table.insert(tasks.hud[name], player:hud_add({
                                type = "text",
                                position = {x=0.075, y=ypos + (0.025 * i)},
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
                            table.insert(tasks.hud[name], player:hud_add({
                                type = "waypoint",
                                name = S(states[index].title.." (@1/@2)",
                                    task.index,
                                    #states),
                                world_pos = states[index].pos,
                                z_index = 1,
                                number = color,
                            }))
                        elseif task.index > #states then
                            table.insert(tasks.hud[name], player:hud_add({
                                type = "text",
                                position = {x=0.075, y=ypos + (0.025 * i)},
                                name = task.name,
                                scale = {x = 1, y = 1},
                                text = S(states[#states].title.." (@1)",
                                    task.index),
                                alignment = {x=0, y=0},
                                z_index = 1,
                                number = color,
                                style = 0
                            }))
                            table.insert(tasks.hud[name], player:hud_add({
                                type = "waypoint",
                                name = S(states[#states].title.." (@1)",
                                    task.index),
                                world_pos = states[#states].pos,
                                z_index = 1,
                                number = color,
                            }))
                        else
                            table.insert(tasks.hud[name], player:hud_add({
                                type = "text",
                                position = {x=0.075, y=ypos + (0.025 * i)},
                                name = task.name,
                                scale = {x = 1, y = 1},
                                text = S(states[index].title),
                                alignment = {x=0, y=0},
                                z_index = 1,
                                number = color,
                                style = 0
                            }))
                            table.insert(tasks.hud[name], player:hud_add({
                                type = "waypoint",
                                name = S(states[index].title),
                                world_pos = states[index].pos,
                                z_index = 1,
                                number = color,
                            }))
                        end
                    else
                        if i == 1 then
                            table.insert(tasks.hud[name], player:hud_add({
                                type = "text",
                                position = {x=0.075, y=ypos + (0.025 * i)},
                                name = task.name,
                                scale = {x = 1, y = 1},
                                text = S("Communications disabled!"),
                                alignment = {x=0, y=0},
                                z_index = 1,
                                number = 0xffff00,
                                style = 0
                            }))
                            table.insert(tasks.hud[name], player:hud_add({
                                type = "waypoint",
                                name = S("Communications disabled!"),
                                world_pos = {x = 9, y = 2, z = -45},
                                z_index = 1,
                                number = 0xffff00,
                            }))
                        end
                    end
                end
            end
        end
    end
    tasks.show_taskbar()
end

function tasks.generate_tasks()
    for _, player in pairs(core.get_connected_players()) do
        local name = player:get_player_name()
        tasks.players[name] = {}
        local defs = table.copy(tasks.registered_tasks)
        local amount = settings.get_setting("tasks")

        for i = 1, amount do
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
    tasks.completed_tasks[name] = nil
    if settings.started then
        tasks.update_hud()
    end
end)