local modname = core.get_current_modname()
local S = core.get_translator(modname)
local insert = table.insert
local FORMNAME = "settings:laptop_skins"

function settings.show_skins_menu(name)
    local player = core.get_player_by_name(name)
    if not player then return end
    local meta = player:get_meta()
    local colors = settings.colors[settings.players[name]]
    local props = player:get_properties()
    local formspec = {
        "formspec_version[7]",
        "size[8,8]"
    }
    if string.find(props.mesh, "glb") then
        insert(formspec, "model[0,2;4,5;preview;")
        insert(formspec, props.mesh)
        insert(formspec, ";")
        insert(formspec, core.formspec_escape(table.concat(player_api.get_textures(player), ",")))
        insert(formspec, ";0,180;false;true;0,2.66;1]")
    else
        insert(formspec, "model[0,2;4,5;preview;")
        insert(formspec, props.mesh)
        insert(formspec, ";")
        insert(formspec, core.formspec_escape(table.concat(player_api.get_textures(player), ",")))
        insert(formspec, ";0,180;false;true;0,79;30]")
    end
    
    local i = 0
    local ypos
    insert(formspec, "label[4,1.5;Colors]")
    for color, hex in pairs(settings.colors) do
        i = i + 1
        local x_pos = 4 + ((i - 1) % 4) * 0.85
        local row_number = math.floor((i - 1) / 4)
        local y_pos = 1.75 + (row_number * 0.85)
        ypos = y_pos
        local texture = "settings_color.png^[colorize:"..hex[1]..":255"
        if settings.is_color_available(color) then
            insert(formspec, "image_button[")
            insert(formspec, x_pos)
            insert(formspec, ",")
            insert(formspec, y_pos)
            insert(formspec, ";0.75,0.75;")
            insert(formspec, texture)
            insert(formspec, "^gui_overlay.png")
            insert(formspec, ";")
            insert(formspec, color)
            insert(formspec, ";;true;false;")
            insert(formspec, texture)
            insert(formspec, "^settings_color_hover.png^gui_overlay.png")
            insert(formspec, "]")
            insert(formspec, "tooltip[")
            insert(formspec, color)
            insert(formspec, ";")
            insert(formspec, S(util.first(color:gsub("_", " "))))
            insert(formspec, "]")
        else
            insert(formspec, "image[")
            insert(formspec, x_pos)
            insert(formspec, ",")
            insert(formspec, y_pos)
            insert(formspec, ";0.75,0.75;")
            insert(formspec, texture)
            if settings.players[name] == color then
                insert(formspec, "^settings_color_pressed.png")
            else
                insert(formspec, "^settings_color_chosen.png")
            end
            insert(formspec, "^gui_overlay.png")
            insert(formspec, "]")
        end
    end

    i = 0
    for name, def in pairs(settings.costumes) do
        if i == 0 then
            insert(formspec, "label[4,")
            insert(formspec, ypos + 1.05)
            insert(formspec, ";Costumes]")
        end
        i = i + 1
        local x_pos = 4 + ((i - 1) % 4) * 0.85
        local row_number = math.floor((i - 1) / 4)
        local y_pos = ypos + ((row_number + 1.5) * 0.85)
        local texture = def.icon
        
        if (meta:get_string("_costume") == "" and name == "none") or (meta:get_string("_costume") == name) then
            insert(formspec, "image[")
            insert(formspec, x_pos)
            insert(formspec, ",")
            insert(formspec, y_pos)
            insert(formspec, ";0.75,0.75;")
            insert(formspec, texture)
            insert(formspec, "^settings_color_pressed.png^gui_overlay.png]")
        else
            insert(formspec, "image_button[")
            insert(formspec, x_pos)
            insert(formspec, ",")
            insert(formspec, y_pos)
            insert(formspec, ";0.75,0.75;")
            insert(formspec, texture)
            insert(formspec, ";")
            insert(formspec, name)
            insert(formspec, ";;true;false;")
            insert(formspec, texture)
            insert(formspec, "^settings_color_hover.png^gui_overlay.png]tooltip[")
            insert(formspec, name)
            insert(formspec, ";")
            insert(formspec, S(util.first(name:gsub("_", " "))))
            insert(formspec, "]")
        end
    end
    insert(formspec, "image_button[1,0.45;2.75,0.75;gui_buttonbg_pressed.png;skins;Player;true;true;gui_buttonbg_hover.png]")
    if util.admin(name) then
        insert(formspec, "image_button[4.25,0.45;2.75,0.75;gui_buttonbg.png;customization;Game;true;true;gui_buttonbg_hover.png]")
    end
    core.show_formspec(name, FORMNAME, table.concat(formspec))
    settings.formspec[name] = true
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= FORMNAME then
        return
    end
    local name = player:get_player_name()
    for color, _ in pairs(settings.colors) do
        if fields[color] and settings.is_color_available(color) then
            settings.set_color(name, color)
            core.sound_play("selected", {to_player = name})
        end
    end
    for costume, _ in pairs(settings.costumes) do
        if fields[costume] then
            settings.set_costume(name, costume)
            core.sound_play("selected", {to_player = name})
        end
    end
    if fields.skins then
        core.sound_play("selected", {to_player = name})
    end
    if fields.customization and util.admin(name) then
        core.sound_play("selected", {to_player = name})
        settings.show_customization_menu(name)
    end
    if fields.quit then
        settings.formspec[name] = nil
        return
    end
    for player_name, value in pairs(settings.formspec) do
        if value then
            settings.show_skins_menu(player_name)
        end
    end
end)