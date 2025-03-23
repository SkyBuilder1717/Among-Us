local FORMNAME = "settings:laptop_custom"
local admin = core.settings:get("name")

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
        local y_pos, size = 1.35 + (i * 0.5), 0.625
        local plus, minus = "^gui_overlay_plus.png", "^gui_overlay_minus.png"

        table.insert(formspec, "label[1.25,")
        table.insert(formspec, y_pos)
        table.insert(formspec, ";")
        table.insert(formspec, def.title)
        table.insert(formspec, "]")

        table.insert(formspec, "image_button[4,")
        table.insert(formspec, y_pos - (size / 1.75))
        table.insert(formspec, ";")
        table.insert(formspec, size)
        table.insert(formspec, ",")
        table.insert(formspec, size)
        table.insert(formspec, ";gui_buttonbg_small.png")
        table.insert(formspec, minus)
        table.insert(formspec, ";")
        table.insert(formspec, name)
        table.insert(formspec, "_minus;;true;false;gui_buttonbg_small_hover.png")
        table.insert(formspec, minus)
        table.insert(formspec, "]")

        table.insert(formspec, "label[5.2475,")
        table.insert(formspec, y_pos)
        table.insert(formspec, ";")
        table.insert(formspec, settings.get_setting(name))
        table.insert(formspec, "]")

        table.insert(formspec, "image_button[6,")
        table.insert(formspec, y_pos - (size / 1.75))
        table.insert(formspec, ";")
        table.insert(formspec, size)
        table.insert(formspec, ",")
        table.insert(formspec, size)
        table.insert(formspec, ";gui_buttonbg_small.png")
        table.insert(formspec, plus)
        table.insert(formspec, ";")
        table.insert(formspec, name)
        table.insert(formspec, "_plus;;true;false;gui_buttonbg_small_hover.png")
        table.insert(formspec, plus)
        table.insert(formspec, "]")

        table.insert(formspec, "image_button[1,5;5.75,3;settings_start.png;start;;true;false]")
    end
    core.show_formspec(name, FORMNAME, table.concat(formspec))
    settings.formspec[name] = nil
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= FORMNAME then return end
    local player_name = player:get_player_name()
    core.sound_play("selected", {to_player = player_name})
    if player_name ~= admin then return end
    if fields.quit then
        return
    end
    if fields.start then
        if #core.get_connected_players() >= 4 then
            settings.start_game()
        else
            core.chat_send_player(player_name, "Not enough players!")
        end
        return
    end
    if fields.skins then
        settings.show_skins_menu(player_name)
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
    end
end)