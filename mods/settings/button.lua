local FORMNAME = "settings:button"

function settings.show_button_menu(name)
    core.sound_play("button_ready", {to_player = name})
    local formspec = {
        "formspec_version[7]",
        "size[11,11]",
        "background[0,0;11,11;settings_button_ui.png;true]",
        "image_button[1.95,3.1;7.1,7.1;settings_button.png;button;;true;false;settings_button_pressed.png]"
    }
    core.show_formspec(name, FORMNAME, table.concat(formspec))
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= FORMNAME then return end
    local player_name = player:get_player_name()
    if fields.button then
        settings.emergency_meeting(player_name)
    end
end)