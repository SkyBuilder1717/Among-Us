tasks = {
    amount = 4,

    registered_tasks = {},
    players = {},
    hud = {},
    formspec = {}
}
local modname = core.get_current_modname()
local modpath = core.get_modpath(modname)

dofile(modpath.."/api.lua")

tasks.register_task("upload_data")
tasks.add_task("upload_data", {
    map = "skeld",
    states = {
        {
            {pos = {x = 6, y = 2, z = 8}, title = "Cafeteria: Download Data"},
            {pos = {x = 6, y = 2, z = -19}, title = "Admin: Upload Data"},
        },
        {
            {pos = {x = -20, y = 2, z = -24}, title = "Electrical: Download Data"},
            {pos = {x = 6, y = 2, z = -19}, title = "Admin: Upload Data"},
        },
        {
            {pos = {x = 21, y = 2, z = 4}, title = "Weapons: Download Data"},
            {pos = {x = 6, y = 2, z = -19}, title = "Admin: Upload Data"},
        },
        {
            {pos = {x = 43, y = 2, z = -13}, title = "Navigation: Download Data"},
            {pos = {x = 6, y = 2, z = -19}, title = "Admin: Upload Data"},
        }
    }
})

tasks.register_task("fix_electro")
tasks.add_task("fix_electro", {
    map = "skeld",
    states = {
        {
            {pos = {x = 3, y = 2, z = -20}, title = "Admin: Fix Wiring"},
            {pos = {x = -8, y = 2, z = 7}, title = "Cafeteria: Fix Wiring"},
            {pos = {x = 37, y = 2, z = -16}, title = "Navigation: Fix Wiring"},
            {pos = {x = -15, y = 1, z = -25}, title = "Electrical: Fix Wiring"},
            {pos = {x = -31, y = 2, z = -17}, title = "Security: Fix Wiring"},
            {pos = {x = -4, y = 2, z = -27}, title = "Storage: Fix Wiring"},
        }
    }
})

tasks.register_task("trash")
tasks.add_task("trash", {
    map = "skeld",
    states = {
        {
            {pos = {x = 8, y = 2, z = 6}, title = "Cafeteria: Empty Garbage"},
            {pos = {x = 11, y = 2, z = -14}, title = "O2: Empty Garbage"},
            {pos = {x = 2, y = 2, z = -46}, title = "Storage: Empty Garbage"},
        }
    }
})

tasks.register_task("fuel_engine")
tasks.add_task("fuel_engine", {
    map = "skeld",
    states = {
        {
            {pos = {x = -6, y = 1, z = -40}, title = "Storage: Fuel Engines"},
            {pos = {x = -37, y = 1, z = -4}, title = "Upper Engine: Fuel Engines"},
            {pos = {x = -6, y = 1, z = -40}, title = "Storage: Fuel Engines"},
            {pos = {x = -37, y = 1, z = -37}, title = "Lower Engine: Fuel Engines"},
        }
    }
})

tasks.register_task("inspect_sample")
tasks.add_task("inspect_sample", {
    map = "skeld",
    states = {
        {
            {pos = {x = -11, y = 2, z = -12}, title = "MedBay: Inspect Sample"},
        }
    }
})

core.register_chatcommand("task", {
    func = function(name, param)
        tasks.generate_tasks()
    end
})