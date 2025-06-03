local FORMNAME = "settings:laptop_custom"
local t = table.insert

function settings.show_customization_menu(player_name)
    local player = core.get_player_by_name(player_name)
    if not player then return end
    if not (util.admin(player_name) or util.starting(player_name)) then return end
    local formspec = {
        "formspec_version[7]",
        "size[12,8]"
    }
    local i = 0
    for name, def in pairs(settings.lobby) do
        i = i + 1
        local y_pos, size = 1.35 + (i * 0.75), 0.625
        local plus, minus = "^gui_overlay_plus.png", "^gui_overlay_minus.png"

        t(formspec, "label[1.15,")
        t(formspec, y_pos)
        t(formspec, ";")
        t(formspec, def.title)
        t(formspec, "]")

        if util.admin(player_name) then
            t(formspec, "image_button[8,")
            t(formspec, y_pos - (size / 1.75))
            t(formspec, ";")
            t(formspec, size)
            t(formspec, ",")
            t(formspec, size)
            t(formspec, ";gui_buttonbg_small.png")
            t(formspec, minus)
            t(formspec, ";")
            t(formspec, name)
            t(formspec, "_minus;;true;false;gui_buttonbg_small_hover.png")
            t(formspec, minus)
            t(formspec, "]")
        end

        t(formspec, "label[9.2475,")
        t(formspec, y_pos)
        t(formspec, ";")
        t(formspec, settings.get_setting(name))
        t(formspec, "]")

        if util.admin(player_name) then
            t(formspec, "image_button[10,")
            t(formspec, y_pos - (size / 1.75))
            t(formspec, ";")
            t(formspec, size)
            t(formspec, ",")
            t(formspec, size)
            t(formspec, ";gui_buttonbg_small.png")
            t(formspec, plus)
            t(formspec, ";")
            t(formspec, name)
            t(formspec, "_plus;;true;false;gui_buttonbg_small_hover.png")
            t(formspec, plus)
            t(formspec, "]")
        end

        t(formspec, "image_button[3.5,8.5;5.75,3;settings_start.png;start;;true;false]")
    end

    t(formspec, "image_button[1.35,0.45;2.75,0.75;gui_buttonbg.png;colors;Color;true;true;gui_buttonbg_hover.png]")
    t(formspec, "image_button[4.6,0.45;2.75,0.75;gui_buttonbg.png;costumes;Costumes;true;true;gui_buttonbg_hover.png]")
    if util.admin(name) or util.starting(name) then
        t(formspec, "image_button[7.85,0.45;2.75,0.75;gui_buttonbg_pressed.png;customization;Game;true;true;gui_buttonbg_hover.png]")
    end

    core.show_formspec(name, FORMNAME, table.concat(formspec))
    settings.formspec[name] = nil
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= FORMNAME then return end
    local player_name = player:get_player_name()
    if not (util.admin(player_name) or util.starting(player_name)) then return end
    if fields.quit then
        return
    end
    if fields.start then
        core.sound_play("selected", {to_player = player_name})
        if #core.get_connected_players() >= 4 then
            settings.start_game()
            return
        end
        core.chat_send_player(player_name, "Not enough players!")
        return
    end
    if fields.customization then
        core.sound_play("selected", {to_player = player_name})
        return
    end
    if fields.colors then
        settings.show_colors_menu(player_name)
        core.sound_play("selected", {to_player = player_name})
        return
    end
    if fields.costumes then
        settings.show_costumes_menu(player_name)
        core.sound_play("selected", {to_player = player_name})
        return
    end
    for name, def in pairs(settings.lobby) do
        local value = settings.get_setting(name)
        if fields[name.."_minus"] then
            settings.set_setting(name, value - 1)
            settings.play_sound("setting")
        elseif fields[name.."_plus"] then
            settings.set_setting(name, value + 1)
            settings.play_sound("setting")
        end
        for _, player in pairs(core.get_connected_players()) do
            update_settings_ui(player)
        end
        settings.show_customization_menu(player_name)
    end
end)