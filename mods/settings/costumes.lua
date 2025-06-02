local modname = core.get_current_modname()
local S = core.get_translator(modname)
local insert = table.insert
local FORMNAME = "settings:laptop_costumes"

function settings.show_costumes_menu(player_name)
    local player = core.get_player_by_name(player_name)
    if not player then return end
    local meta = player:get_meta()
    local costume_string = meta:get_string("_costumes")
    local worn = {}
    for costume in string.gmatch(costume_string, "([^,]+)") do
        worn[costume] = true
    end
    local colors = settings.colors[settings.players[player_name]]
    local props = player:get_properties()
    local formspec = {
        "formspec_version[7]",
        "size[12,8]"
    }
    if string.find(props.mesh, "glb") then
        insert(formspec, "model[0,2;5,5;preview;")
        insert(formspec, props.mesh)
        insert(formspec, ";")
        insert(formspec, core.formspec_escape(table.concat(player_api.get_textures(player), ",")))
        insert(formspec, ";0,180;false;true;0,2.66;1]")
    else
        insert(formspec, "model[0,2;5,5;preview;")
        insert(formspec, props.mesh)
        insert(formspec, ";")
        insert(formspec, core.formspec_escape(table.concat(player_api.get_textures(player), ",")))
        insert(formspec, ";0,180;false;true;0,79;30]")
    end
    
    local i = 0
    insert(formspec, "label[5,1.5;")
    insert(formspec, points.get(player_name))
    insert(formspec, " points]")
    for name, def in pairs(settings.costumes) do
        i = i + 1
        local x_pos = 5 + ((i - 1) % 5) * 1.25
        local row_number = math.floor((i - 1) / 5)
        local y_pos = 1.75 + (row_number * 1.25)
        local texture = def.icon
        
        if (name == "none" and next(worn) == nil) or worn[name] then
            insert(formspec, "image_button[")
            insert(formspec, x_pos)
            insert(formspec, ",")
            insert(formspec, y_pos)
            insert(formspec, ";1.1,1.1;")
            insert(formspec, texture)
            insert(formspec, "^settings_color_hover.png^gui_overlay.png")
            if def.price and not worn[name] and not settings.has_costume(player_name, name) then
                insert(formspec, "^costumes_locked.png")
            end
            insert(formspec, ";")
            insert(formspec, name)
            insert(formspec, ";;true;false;")
            insert(formspec, texture)
            insert(formspec, "^settings_color_pressed.png^gui_overlay.png")
            if def.price and not worn[name] and not settings.has_costume(player_name, name) then
                insert(formspec, "^costumes_locked.png")
            end
            insert(formspec, "]")
        else
            insert(formspec, "image_button[")
            insert(formspec, x_pos)
            insert(formspec, ",")
            insert(formspec, y_pos)
            insert(formspec, ";1.1,1.1;")
            insert(formspec, texture)
            if def.price and not worn[name] and not settings.has_costume(player_name, name) then
                insert(formspec, "^costumes_locked.png")
            end
            insert(formspec, ";")
            insert(formspec, name)
            insert(formspec, ";;true;false;")
            insert(formspec, texture)
            insert(formspec, "^settings_color_pressed.png^gui_overlay.png")
            if def.price and not worn[name] and not settings.has_costume(player_name, name) then
                insert(formspec, "^costumes_locked.png")
            end
            insert(formspec, "]")

            if def.price and not worn[name] and not settings.has_costume(player_name, name) then
                insert(formspec, string.format("tooltip[%s;%s\n(%d points)]", name, S(util.first(name:gsub("_", " "))), def.price))
            else
                insert(formspec, string.format("tooltip[%s;%s]", name, S(util.first(name:gsub("_", " ")))))
            end
        end
    end
    insert(formspec, "image_button[1.35,0.45;2.75,0.75;gui_buttonbg.png;colors;Color;true;true;gui_buttonbg_hover.png]")
    insert(formspec, "image_button[4.6,0.45;2.75,0.75;gui_buttonbg_pressed.png;costumes;Costumes;true;true;gui_buttonbg_hover.png]")
    if util.admin(player_name) then
        insert(formspec, "image_button[7.85,0.45;2.75,0.75;gui_buttonbg.png;customization;Game;true;true;gui_buttonbg_hover.png]")
    end
    core.show_formspec(player_name, FORMNAME, table.concat(formspec))
    settings.formspec[player_name] = nil
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= FORMNAME then return end
    local name = player:get_player_name()
    for costume, _ in pairs(settings.costumes) do
        if fields[costume] then
            local def = settings.costumes[costume]
            if costume == "none" then
                settings.clear_costumes(name)
            elseif settings.has_costume(name, costume) or not def.price then
                settings.toggle_costume(name, costume)
            else
                local price = def.price
                local current = points.get(name)
                local title = util.first(costume:gsub("_", " "))
                if current >= price then
                    points.remove(name, price)
                    settings.unlock_costume(name, costume)
                    core.chat_send_player(name, S("You bought \"@1\" for @2 points!", title, price))
                    core.sound_play("unlock", {to_player = name})
                    settings.toggle_costume(name, costume)
                else
                    core.chat_send_player(name, S("Not enough points to buy \"@1\". Need @2 points.", title, price))
                    core.sound_play("buy_error", {to_player = name})
                end
            end
        end
    end
    if fields.costumes then
        core.sound_play("selected", {to_player = name})
    end
    if fields.colors then
        settings.show_colors_menu(name)
        core.sound_play("selected", {to_player = name})
        return
    end
    if fields.customization and util.admin(name) then
        settings.show_customization_menu(name)
        core.sound_play("selected", {to_player = name})
        return
    end
    if fields.quit then
        settings.formspec[name] = nil
        return
    end
    settings.show_costumes_menu(name)
end)