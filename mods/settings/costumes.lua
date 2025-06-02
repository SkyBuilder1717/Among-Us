local modname = core.get_current_modname()
local S = core.get_translator(modname)
local insert = table.insert
local FORMNAME = "settings:laptop_costumes"

function settings.show_costumes_menu(name)
    local player = core.get_player_by_name(name)
    if not player then return end
    local meta = player:get_meta()
    local costume_string = meta:get_string("_costumes")
    local worn = {}
    for costume in string.gmatch(costume_string, "([^,]+)") do
        worn[costume] = true
    end
    local colors = settings.colors[settings.players[name]]
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
    for name, def in pairs(settings.costumes) do
        i = i + 1
        local x_pos = 5 + ((i - 1) % 5) * 1.25
        local row_number = math.floor((i - 1) / 5)
        local y_pos = 1.5 + (row_number * 1.25)
        local texture = def.icon
        
        if (name == "none" and next(worn) == nil) or worn[name] then
            insert(formspec, "image_button[")
            insert(formspec, x_pos)
            insert(formspec, ",")
            insert(formspec, y_pos)
            insert(formspec, ";1.1,1.1;")
            insert(formspec, texture)
            insert(formspec, "^settings_color_hover.png^gui_overlay.png")
            insert(formspec, ";")
            insert(formspec, name)
            insert(formspec, ";;true;false;")
            insert(formspec, texture)
            insert(formspec, "^settings_color_pressed.png^gui_overlay.png]tooltip[")
            insert(formspec, name)
            insert(formspec, ";")
            insert(formspec, S(util.first(name:gsub("_", " "))))
            insert(formspec, "]")
        else
            insert(formspec, "image_button[")
            insert(formspec, x_pos)
            insert(formspec, ",")
            insert(formspec, y_pos)
            insert(formspec, ";1.1,1.1;")
            insert(formspec, texture)
            insert(formspec, ";")
            insert(formspec, name)
            insert(formspec, ";;true;false;")
            insert(formspec, texture)
            insert(formspec, "^settings_color_pressed.png^gui_overlay.png]tooltip[")
            insert(formspec, name)
            insert(formspec, ";")
            insert(formspec, S(util.first(name:gsub("_", " "))))
            insert(formspec, "]")
        end
    end
    insert(formspec, "image_button[1.35,0.45;2.75,0.75;gui_buttonbg.png;colors;Color;true;true;gui_buttonbg_hover.png]")
    insert(formspec, "image_button[4.6,0.45;2.75,0.75;gui_buttonbg_pressed.png;costumes;Costumes;true;true;gui_buttonbg_hover.png]")
    if util.admin(name) then
        insert(formspec, "image_button[7.85,0.45;2.75,0.75;gui_buttonbg.png;customization;Game;true;true;gui_buttonbg_hover.png]")
    end
    core.show_formspec(name, FORMNAME, table.concat(formspec))
    settings.formspec[name] = nil
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= FORMNAME then return end
    local name = player:get_player_name()
    for costume, _ in pairs(settings.costumes) do
        if fields[costume] then
            if costume == "none" then
                settings.clear_costumes(name)
            else
                settings.toggle_costume(name, costume)
            end
            core.sound_play("selected", {to_player = name})
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