function update_game()
    t += 1
    blinkt += 1
    laser.off_timer -= 1

    ship.xspeed = 0
    ship.yspeed = 0

    ship.spr_settings.ship.start = ship.spr_settings.ship.frame
    ship.spr_settings.ship.stop = 3
    if ship.spr_settings.ship.start > 3 then
        ship.spr_settings.ship.dir = -1
    else
        ship.spr_settings.ship.dir = 1
    end

    if delay_next_shot > 0 then
        delay_next_shot -= 1
    end

    if laser.off_timer <= 0 then
        laser.height = 0
        laser.on = false
    end
    update_controls()

    update_ship_position()

    if invul > 0 then
        invul -= 1
    end

    for en in all(enemies) do
        if en.seq[en.i].func(en, en.seq[en.i]) then
            -- call state routine
            en.t = 0
            en.i += 1
        else
            en.t += 1
        end

        if en.fire_seq[en.i_fire] then
            if en.fire_seq[en.i_fire].func(en, en.fire_seq[en.i_fire]) then
                en.t_fire = 0
                en.i_fire += 1
            else
                en.t_fire += 1
            end
        end
        if en.fire_state == "fire" then
            if en.update_canon and en.delay_shot <= 0 then
                en.update_canon(en)
            else
                en.delay_shot -= 1
            end

            for canon in all(en.canons) do
                if canon.t == 0 then
                    canon.fire_func(en.x + canon.off_x, en.y + canon.off_y, en, canon.args_func)
                    canon.current_fire -= 1
                    if canon.current_fire == 0 then
                        canon.t = canon.cooldown
                        canon.current_fire = canon.num_fire
                    else
                        canon.t = canon.fire_rate
                    end
                else
                    canon.t -= 1
                end
            end
        end
    end
    update_enemy_bullets()
    update_collision_en_bullets()

    update_bullets()
    update_collision_laser()

    update_collisions_edges()
    update_collision_ship()

    if mode == "game" then
        update_collision_bullets()
    end

    update_expl()

    if lives <= 0 then mode = "over" end

    animate_stars()

    update_asteroids()
end

function update_wave_text()
    update_game()
    wave_time -= 1
    if wave_time <= 0 then
        mode = "game"
        t = 0
        -- spawn_wave()
    end
end

function update_win()
    if btn(4) == false and btn(5) == false then
        btn_release = true
    end
    if btn_release then
        if btnp(4) or btnp(5) then
            mode = "start"
        end
    end
end

function next_wave()
    wave += 1
    wave_time = 30
    mode = "wave_text"

    if wave == max_num_wave then
        mode = "win"
    end
end

function update_controls()
    local dir_button = btn() & 0b1111
    if (dir_button & 0b0011) * (dir_button & 0b1100) != 0 and last_dir_button != dir_button then
        ship.x = flr(ship.x)
        ship.y = flr(ship.y)
    end

    if btn(0) then
        ship.xspeed = -1.41

        ship.spr_settings.ship.start = ship.spr_settings.ship.frame
        ship.spr_settings.ship.stop = 1
        ship.spr_settings.ship.dir = -1
    end
    if btn(1) then
        ship.xspeed = 1.41

        ship.spr_settings.ship.start = ship.spr_settings.ship.frame
        ship.spr_settings.ship.stop = 5
        ship.spr_settings.ship.dir = 1
    end
    if btn(2) then
        ship.yspeed = -1.41
    end
    if btn(3) then
        ship.yspeed = 1.41
    end
    if btn(4) then
        if laser.meter >= 0 then
            laser.on = true
            laser.meter -= 1
            laser.x = ship.x - 2
            laser.xb = 6
            if laser.collide == false then
                laser.height += 3
            end
            laser.yb = laser.height
            laser.y = ship.y - 8 - laser.height
            laser.off_timer = 8
            sfx(4)
        end
    end
    if btn(5) then
        if delay_next_shot <= 0 then
            add(bullets, create_player_bullet(ship.x - 4, ship.y - 8, 0))
            add(bullets, create_player_bullet(ship.x + 2, ship.y - 8, 1))
            sfx(0)
            delay_next_shot = fire_rate
        end
    end

    last_dir_button = dir_button
end