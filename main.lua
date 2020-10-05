--[[
    credits: kopretinka, Aviarita, estk, user64, rave1337, sapphyrus
    Wrote this 2AM and I feel like dying, if there's some stupid stuff, make a pull request or post in *issues* on my git.
]]

local img = require("gamesense/images") or error("Images library is required")
local csgo_weapons = require("gamesense/csgo_weapons") or error("CS:GO weapon data is required")
local w, h = client.screen_size()
local force_left = ui.new_checkbox("lua", "a", "force_left")
local locations = ui.new_checkbox("visuals", "player esp", "Locations")
local display_items = ui.new_checkbox("visuals", "player esp", "Kit/Bomb check")

local function draw_slider(x, y, w, name, perc, te, t_add, show, clr, clr2)
    local off_ = name ~= "" and name ~= " " and name ~= nil and 15 or 0
    local ba = clr[4]-90
    ba = ba >= 0 and ba or 0
    if name ~= "" and name ~= " " and name ~= nil then
        local flags = ui.get(force_left) and "r-" or "-"
        local ladd = ui.get(force_left) and 100-2 or 0
        renderer.text(x+ladd, y, 220, 220, 220, clr[4], flags, 0, string.upper(name))
    end
    renderer.rectangle(x, y+15, w, 7, 0, 0, 0, clr[4])
    renderer.gradient(x+1, y+16, w-2, 5, 70, 70, 70, 255, 50, 50, 50, clr[4], false)
    renderer.gradient(x+1, y+16, w*(perc), 5, clr[1], clr[2], clr[3], clr[4], clr2[1], clr2[2], clr2[3], clr2[4], false)
    if te < 99 then
        renderer.text(x+1+w*(perc), y+21, 220, 220, 220, clr[4], "c-", 0, te .. t_add)
    end
end

client.set_event_callback("paint", function()
    local player_resource = entity.get_all("CCSPlayerResource")[1]
    if player_resource == nil then end
    local c4_holder = entity.get_prop(player_resource, "m_iPlayerC4")
    local players = entity.get_players(true)
    for i=1, #players do
        local player = players[i]
        local steamid3 = entity.get_steam64(player)
        local avatar = img.get_steam_avatar(steamid3)
        local p = { name=entity.get_player_name(player):upper():sub(0, 10), hp=entity.get_prop(player, "m_iHealth"), location=entity.get_prop(player, "m_szLastPlaceName") }
        if entity.get_prop(player, "m_iTeamNum") == 3 then r,g,b = 65, 123, 240
        elseif entity.get_prop(player, "m_iTeamNum") == 2 then r,g,b = 221, 189, 42
        end
        if avatar ~= nil then 
            avatar:draw((ui.get(force_left) and w/w+5 or w-35), h/2-25+(i*36), 20, 20, 255, 255, 255, 255, true)
        else
            renderer.rectangle((ui.get(force_left) and w/w+4 or w-34), h/2-23+(i*36), 20, 20, 17, 17, 17, 255)
            renderer.rectangle((ui.get(force_left) and w/w+5 or w-35), h/2-22+(i*36), 18, 18, 0, 0, 0, 155)
            renderer.text((ui.get(force_left) and w/w+9 or w-31), h/2-19+(i*36), 255, 255, 255, 255, "-", nil, "AI")
        end
        if ui.get(display_items) then
            if entity.get_prop(player, "m_bHasDefuser") == 1 then
                local defuser = img.get_weapon_icon("item_defuser")
                defuser:draw((ui.get(force_left) and w/w+150 or w-170), h/2-25+(i*36), 18, 26, 15, 15, 15, 255, true)
                defuser:draw((ui.get(force_left) and w/w+150 or w-170), h/2-25+(i*36), 17, 25, 255, 255, 255, 255, true)
            end
            if c4_holder == player then
                local bomb = img.get_weapon_icon("weapon_c4")
                bomb:draw((ui.get(force_left) and w/w+150 or w-170), h/2-25+(i*36), 18, 26, 15, 15, 15, 255, true)
                bomb:draw((ui.get(force_left) and w/w+150 or w-170), h/2-25+(i*36), 17, 25, 255, 255, 255, 255, true)
            end
        end
        renderer.text((ui.get(force_left) and w/w+35 or w-47), h/2-25+(i*36), r,g,b, 255, ui.get(force_left) and "-" or "-r", 0, p.name)
        draw_slider((ui.get(force_left) and w/w+35 or w-145),  h/2-25+(i*36), 100, ui.get(locations) and p.location or "", math.min(1, p.hp/100-0.02), p.hp, "", true, {148, 184, 6, 255}, {98, 134, 0, 255})
    end

    if entity.get_local_player() then
        local steamid3 = entity.get_steam64(entity.get_local_player())
        local avatar = img.get_steam_avatar(steamid3)
        local p = { name=entity.get_player_name(entity.get_local_player()):upper():sub(0, 10), hp=entity.get_prop(entity.get_local_player(), "m_iHealth"), location=entity.get_prop(entity.get_local_player(), "m_szLastPlaceName") }

        if ui.get(display_items) then
            if entity.get_prop(entity.get_local_player(), "m_bHasDefuser") == 1 then
                local defuser = img.get_weapon_icon("item_defuser")
                defuser:draw((ui.get(force_left) and w/w+150 or w-170), h/2-25, 18, 26, 15, 15, 15, 255, true)
                defuser:draw((ui.get(force_left) and w/w+150 or w-170), h/2-25, 17, 25, 255, 255, 255, 255, true)
            end
            if c4_holder == entity.get_local_player() then
                local bomb = img.get_weapon_icon("weapon_c4")
                bomb:draw((ui.get(force_left) and w/w+150 or w-170), h/2-25, 18, 26, 15, 15, 15, 255, true)
                bomb:draw((ui.get(force_left) and w/w+150 or w-170), h/2-25, 17, 25, 255, 255, 255, 255, true)
            end
        end
        
        avatar:draw((ui.get(force_left) and w/w+5 or w-35), h/2-23, 20, 20, 255, 255, 255, 255, true)
        renderer.text((ui.get(force_left) and w/w+35 or w-47), h/2-25, 46, 204, 113, 255, ui.get(force_left) and "-" or "-r", 0, p.name)
        draw_slider((ui.get(force_left) and w/w+35 or w-145), h/2-25, 100, ui.get(locations) and p.location or "", math.min(1, p.hp/100-0.02), p.hp, "", true, {148, 184, 6, 255}, {98, 134, 0, 255})
    end
end)
