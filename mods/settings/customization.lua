local FORMNAME = "settings:laptop_custom"
local admin = core.settings:get("name")
local t = table.insert

function settings.show_customization_menu(name)
    local player = core.get_player_by_name(name)
    if not player then return end
    if name ~= admin then return end
    local formspec = {
        "formspec_version[7]",
        "size[8,8]",
        "image_button[1,0.45;2.75,0.75;gui_buttonbg.png;skins;Player;true;false;gui_buttonbg_hover.png]",
        "image_button[4.25,0.45;2.75,0.75;gui_buttonbg_pressed.png;customization;Game;true;false;gui_buttonbg_hover.png]"
    }
    local i = 0
    for name, def in pairs(settings.lobby) do
        i = i + 1
        local y_pos, size = 1.35 + (i * 0.75), 0.625
        local plus, minus = "^gui_overlay_plus.png", "^gui_overlay_minus.png"

        t(formspec, "label[1.25,")
        t(formspec, y_pos)
        t(formspec, ";")
        t(formspec, def.title)
        t(formspec, "]")

        t(formspec, "image_button[4,")
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

        t(formspec, "label[5.2475,")
        t(formspec, y_pos)
        t(formspec, ";")
        t(formspec, settings.get_setting(name))
        t(formspec, "]")

        t(formspec, "image_button[6,")
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

        t(formspec, "image_button[1,5;5.75,3;settings_start.png;start;;true;false]")
    end
    core.show_formspec(name, FORMNAME, table.concat(formspec))
    settings.formspec[name] = nil
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= FORMNAME then return end
    local player_name = player:get_player_name()
    if player_name ~= admin then return end
    if fields.quit then
        core.sound_play("selected", {to_player = player_name})
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
    if fields.skins then
        settings.show_skins_menu(player_name)
        core.sound_play("selected", {to_player = player_name})
        return
    end
    for name, def in pairs(settings.lobby) do
        local value = settings.get_setting(name)
        if fields[name.."_minus"] then
            settings.set_setting(name, value - 1)
        elseif fields[name.."_plus"] then
            settings.set_setting(name, value + 1)
        end
        for _, player in pairs(core.get_connected_players()) do
            update_settings_ui(player)
        end
        settings.show_customization_menu(player_name)
        settings.play_sound("setting")
    end
end)