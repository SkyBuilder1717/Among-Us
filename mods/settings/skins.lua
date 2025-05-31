local FORMNAME = "settings:laptop_skins"


function settings.show_skins_menu(name)
    local player = core.get_player_by_name(name)
    if not player then return end
    local colors = settings.colors[settings.players[name]]
    local formspec = {
        "formspec_version[7]",
        "size[8,8]",
        "model[0,2;4,5;preview;character.b3d;", core.formspec_escape(table.concat(player_api.get_textures(player), ",")), ";0,180;false;true;0,79;30]"
    }
    local i = 0
    for color, hex in pairs(settings.colors) do
        i = i + 1
        local x_pos = 4 + ((i - 1) % 3) * 1.1
        local row_number = math.floor((i - 1) / 3)
        local y_pos = 1.5 + (row_number * 1.1)
        local texture = "settings_color.png^[colorize:"..hex[1]..":255"
        if settings.is_color_available(color) then
            table.insert(formspec, "image_button[")
            table.insert(formspec, x_pos)
            table.insert(formspec, ",")
            table.insert(formspec, y_pos)
            table.insert(formspec, ";1,1;")
            table.insert(formspec, texture)
            table.insert(formspec, "^gui_overlay.png")
            table.insert(formspec, ";")
            table.insert(formspec, color)
            table.insert(formspec, ";;true;false;")
            table.insert(formspec, texture)
            table.insert(formspec, "^settings_color_hover.png^gui_overlay.png")
            table.insert(formspec, "]")
        else
            table.insert(formspec, "image[")
            table.insert(formspec, x_pos)
            table.insert(formspec, ",")
            table.insert(formspec, y_pos)
            table.insert(formspec, ";1,1;")
            table.insert(formspec, texture)
            if settings.players[name] == color then
                table.insert(formspec, "^settings_color_pressed.png")
            else
                table.insert(formspec, "^settings_color_chosen.png")
            end
            table.insert(formspec, "^gui_overlay.png")
            table.insert(formspec, "]")
        end
    end
    table.insert(formspec, "image_button[1,0.45;2.75,0.75;gui_buttonbg_pressed.png;skins;Player;true;true;gui_buttonbg_hover.png]")
    if util.admin(name) then
        table.insert(formspec, "image_button[4.25,0.45;2.75,0.75;gui_buttonbg.png;customization;Game;true;true;gui_buttonbg_hover.png]")
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