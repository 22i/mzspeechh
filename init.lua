local mz_is_present = {}

local mz_skybox = {
    "stars.png",
    "stars.png",
    "rms.png",
    "stars.png",
    "stars.png",
    "stars.png",
}

local function summon_mz(player_name)
    mz_is_present[player_name] = minetest.sound_play("rms", {
        to_player = player_name,
        gain = 2.0
    })

    minetest.get_player_by_name(player_name):set_sky({}, "skybox", mz_skybox)
end

local function dismiss_mz(player_name)
    minetest.get_player_by_name(player_name):set_sky({}, "regular", {})

    if mz_is_present[player_name] ~= nil then
        minetest.sound_stop(mz_is_present[player_name])
    end

    mz_is_present[player_name] = nil
end


minetest.register_on_joinplayer(function(player)
        mz_is_present[player:get_player_name()] = nil
    end
)

minetest.register_chatcommand("mz", {
    func = function(name, param)

        -- Summon RMS if he isn't already present
        if mz_is_present[name] == nil then
            minetest.chat_send_player(name, "*You hear a distant voice...*")
            summon_mz(name)

            minetest.after(200, function()
                dismiss_mz(name)
            end
            )
        -- Dismiss RMS if he is present
        else
            minetest.chat_send_player(name, "May the universal Basic income be with you!")
            dismiss_mz(name)
        end
    end
})
