core.register_tool("maps:delete_tool", {
    inventory_image = "remove_tool.png",
    on_use = function(_, _, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end
        local pos = core.get_pointed_thing_position(pointed_thing)
        core.remove_node(pos)
    end,
})