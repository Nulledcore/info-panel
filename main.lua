local img = require("gamesense/images") or error("Images library is required")
local csgo_weapons = require("gamesense/csgo_weapons") or error("CS:GO weapon data is required")
local surface = require('gamesense/surface') or error("Surface is required")
local font = surface.create_font("Arial", 13, 500, {0x200})
local w, h = client.screen_size()
local enable_hud = ui.new_checkbox("visuals", "player esp", "Legit HUD")

local function localplayer()
    local real_lp = entity.get_local_player()
    if entity.is_alive(real_lp) then
        return real_lp
    else
        local obvserver = entity.get_prop(real_lp, "m_hObserverTarget")
        return obvserver ~= nil and obvserver <= 64 and obvserver or nil
    end
end

local function collect_players()
    local results = {}
    local lp_origin = {entity.get_origin(localplayer())}

    for i=1, 64 do
        if entity.is_alive(i) and entity.is_enemy(i) then
            local player_origin = {entity.get_origin(i)}
            if player_origin[1] ~= nil and lp_origin[1] ~= nil then
                table.insert(results, {i})
            end
        end
    end
    return results
end

local function team_check(enemy)
    local return_clr
    if entity.get_prop(enemy, "m_iTeamNum") == 2 then
        return_clr = {254, 183, 0}
    elseif entity.get_prop(enemy, "m_iTeamNum") == 3 then
        return_clr = {107, 160, 255}
    end

    return return_clr
end

local function main()
    if localplayer() == nil then
        return
    end
    if entity.is_alive(localplayer()) then
        local steamid3 = entity.get_steam64(localplayer())
        local avatar = img.get_steam_avatar(steamid3)
        local p = { name=entity.get_player_name(localplayer()), location=entity.get_prop(localplayer(), "m_szLastPlaceName") }
        renderer.rectangle(w/w+4, h/2-24, 22, 22, 17, 17, 17, 255)
        if avatar ~= nil then 
            avatar:draw(w/w+5, h/2-23, 20, 20, 255, 255, 255, 255, true)
        else
            renderer.text(w/w+10, h/2-19, 255, 255, 255, 255, "-", nil, "AI")
        end

        surface.draw_text(w/w+30, h/2-25, 46, 204, 113, 255, font, p.name)
        surface.draw_text(w/w+30, h/2-15, 255, 255, 255, 255, font, p.location)
    end

    local enemies = collect_players()
    for i=1, #enemies do
        local enemy = unpack(enemies[i])
        local color = entity.is_dormant(enemy) and {200, 200, 200, 255} or {255, 255, 255, 255}
        local team_color = entity.is_dormant(enemy) and {200, 200, 200, 255} or team_check(enemy)
        local p = { name=entity.get_player_name(enemy), location=entity.get_prop(enemy, "m_szLastPlaceName") }
        surface.draw_text(w/w+30, h/2-25+(i*36), team_color[1], team_color[2], team_color[3], 255, font, p.name)
        surface.draw_text(w/w+30, h/2-15+(i*36), color[1], color[2], color[3], 255, font, p.location)
        renderer.rectangle(w/w+4, h/2-24+(i*36), 22, 22, 17, 17, 17, 255)
        if avatar ~= nil then 
            avatar:draw(w/w+4, h/2-24+(i*36), 20, 20, 255, 255, 255, 255, true)
        else
            renderer.text(w/w+10, h/2-19+(i*36), 255, 255, 255, 255, "-", nil, "AI")
        end
        if entity.get_prop(entity.get_player_resource(), "m_iPlayerC4") == enemy then
            local wide, height = surface.get_text_size(font, string.format("%s", p.name))
            local color = entity.is_dormant(enemy) and {200, 200, 200, 255} or {255, 75, 75, 255}
            surface.draw_text(w/w+30+(wide+3), h/2-25+(i*36), color[1], color[2], color[3], 255, font, "C4")
        end
    end
end

local function toggle(get)
    if ui.get(get) then
        client.set_event_callback("paint", main) else client.unset_event_callback("paint", main)
    end
end

ui.set_callback(enable_hud, toggle)
