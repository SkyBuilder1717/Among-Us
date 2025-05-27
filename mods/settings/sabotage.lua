tasks.closed_doors = {}

local allowed_rooms = {
    "cafeteria",
    "medbay",
    "upper_engine",
    "lower_engine",
    "security",
    "storage",
    "electrical"
}

core.register_chatcommand("close_door", {
    description = "Close doors as an impostor!",
    params = "<room>",
    func = function(name, param)
        if settings.started and (not settings.meeting_started) and (settings.roles[name] == "impostor") then
            if param == "" then
                return false, "Enter the correct room!"
            end
        end
    end
})