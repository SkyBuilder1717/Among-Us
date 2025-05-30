tasks = {
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
            {pos = {x = 6, y = 2, z = -19}, title = "Admin: Upload Data"}
        },
        {
            {pos = {x = -20, y = 2, z = -24}, title = "Electrical: Download Data"},
            {pos = {x = 6, y = 2, z = -19}, title = "Admin: Upload Data"}
        },
        {
            {pos = {x = 21, y = 2, z = 4}, title = "Weapons: Download Data"},
            {pos = {x = 6, y = 2, z = -19}, title = "Admin: Upload Data"}
        },
        {
            {pos = {x = 43, y = 2, z = -13}, title = "Navigation: Download Data"},
            {pos = {x = 6, y = 2, z = -19}, title = "Admin: Upload Data"}
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
            {pos = {x = -4, y = 2, z = -27}, title = "Storage: Fix Wiring"}
        }
    }
})

tasks.register_task("trash")
tasks.add_task("trash", {
    map = "skeld",
    states = {
        {
            {pos = {x = 8, y = 2, z = 6}, title = "Cafeteria: Empty Garbage"},
            {pos = {x = 2, y = 2, z = -46}, title = "Storage: Empty Garbage"}
        },
        {
            {pos = {x = 11, y = 2, z = -14}, title = "O2: Empty Garbage"},
            {pos = {x = 2, y = 2, z = -46}, title = "Storage: Empty Garbage"}
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
            {pos = {x = -37, y = 1, z = -37}, title = "Lower Engine: Fuel Engines"}
        }
    }
})

tasks.register_task("inspect_sample")
tasks.add_task("inspect_sample", {
    map = "skeld",
    states = {{{pos = {x = -11, y = 2, z = -12}, title = "Medbay: Inspect Sample"}}}
})

tasks.register_task("clean_filter")
tasks.add_task("clean_filter", {
    text_only = true,
    map = "skeld",
    states = {{{pos = {x = 13, y = 0, z = -13}, title = "O2: Clean O2 Filter"}}}
})

tasks.register_task("divert_power")
tasks.add_task("divert_power", {
    map = "skeld",
    states = {
        {
            {pos = {x = -18, y = 2, z = -24}, title = "Electrical: Divert Power"},
            {pos = {x = -36, y = 2, z = -30}, title = "Lower Engine: Divert Power"}
        },
        {
            {pos = {x = -18, y = 2, z = -24}, title = "Electrical: Divert Power"},
            {pos = {x = -35, y = 2, z = 4}, title = "Upper Engine: Divert Power"}
        },
        {
            {pos = {x = -18, y = 2, z = -24}, title = "Electrical: Divert Power"},
            {pos = {x = 18, y = 2, z = -13}, title = "O2: Divert Power"}
        },
        {
            {pos = {x = -18, y = 2, z = -24}, title = "Electrical: Divert Power"},
            {pos = {x = 41, y = 2, z = -13}, title = "O2: Divert Power"}
        },
        {
            {pos = {x = -18, y = 2, z = -24}, title = "Electrical: Divert Power"},
            {pos = {x = 25, y = 2, z = -30}, title = "Shields: Divert Power"}
        },
        {
            {pos = {x = -18, y = 2, z = -24}, title = "Electrical: Divert Power"},
            {pos = {x = 14, y = 2, z = -38}, title = "Communications: Divert Power"}
        },
        {
            {pos = {x = -18, y = 2, z = -24}, title = "Electrical: Divert Power"},
            {pos = {x = -24, y = 2, z = -14}, title = "Security: Divert Power"}
        },
        {
            {pos = {x = -18, y = 2, z = -24}, title = "Electrical: Divert Power"},
            {pos = {x = 25, y = 2, z = -2}, title = "Weapons: Divert Power"}
        }
    }
})

tasks.register_task("align_engine")
tasks.add_task("align_engine", {
    map = "skeld",
    states = {
        {
            {pos = {x = -37, y = 2, z = -4}, title = "Upper Engine: Align Engine Output"},
            {pos = {x = -37, y = 2, z = -37}, title = "Lower Engine: Align Engine Output"}
        }
    }
})

tasks.register_task("prime_shields")
tasks.add_task("prime_shields", {
    text_only = true,
    map = "skeld",
    states = {{{pos = {x = 18, y = 1, z = -37}, title = "Shields: Prime Shields"}}}
})

tasks.register_task("calibrate_distributor")
tasks.add_task("calibrate_distributor", {
    text_only = true,
    map = "skeld",
    states = {{{pos = {x = -11, y = 2, z = -25}, title = "Electrical: Calibrate Distributor"}}}
})

tasks.register_task("submit_scan")
tasks.add_task("submit_scan", {
    text_only = true,
    map = "skeld",
    states = {{{pos = {x = -14, y = 1, z = -13}, title = "Medbay: Submit Scan"}}}
})

tasks.register_task("clean_vent")
tasks.add_task("clean_vent", {
    text_only = true,
    map = "skeld",
    states = {
        {{pos = {x = -19, y = 1, z = -25}, title = "Electrical: Clean Vent"}},
        {{pos = {x = -32, y = 1, z = -38}, title = "Lower Engine: Clean Vent"}},
        {{pos = {x = -25, y = 1, z = -20}, title = "Security: Clean Vent"}},
        {{pos = {x = -44, y = 1, z = -20}, title = "Reactor: Clean Vent"}},
        {{pos = {x = -46, y = 1, z = -14}, title = "Reactor: Clean Vent"}},
        {{pos = {x = -32, y = 1, z = 3}, title = "Upper Engine: Clean Vent"}},
        {{pos = {x = -17, y = 1, z = -12}, title = "Medbay: Clean Vent"}},
        {{pos = {x = 7, y = 1, z = -4}, title = "Cafeteria: Clean Vent"}},
        {{pos = {x = 21, y = 1, z = 3}, title = "Weapons: Clean Vent"}},
        {{pos = {x = 41, y = 1, z = -14}, title = "Navigation: Clean Vent"}},
        {{pos = {x = 41, y = 1, z = -21}, title = "Navigation: Clean Vent"}},
        {{pos = {x = 21, y = 1, z = -21}, title = "Coridor: Clean Vent"}},
        {{pos = {x = 22, y = 1, z = -37}, title = "Shields: Clean Vent"}},
        {{pos = {x = 6, y = 1, z = -27}, title = "Admin: Clean Vent"}}
    }
})

tasks.register_task("start_reactor")
tasks.add_task("start_reactor", {
    text_only = true,
    map = "skeld",
    states = {{{pos = {x = -45, y = 1, z = -17}, title = "Reactor: Start Reactor"}}}
})

tasks.register_task("swipe_card")
tasks.add_task("swipe_card", {
    text_only = true,
    map = "skeld",
    states = {{{pos = {x = 12, y = 1, z = -24}, title = "Admin: Swipe Card"}}}
})

tasks.register_task("clear_asteroids")
tasks.add_task("clear_asteroids", {
    text_only = true,
    map = "skeld",
    states = {{{pos = {x = 23, y = 3, z = 0}, title = "Weapons: Clear Asteroids"}}}
})