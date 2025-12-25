function draw_start()
    cls(0)
    starfield()

    print("bark bark", 50, 40, 3)
    print("press action button to start", 15, 60, 10)
end

function draw_over()
    cls(2)

    print("game over", 20, 40, 6)
    print("press action button to start again", 15, 60, 5)
end

function draw_wave_text()
    draw_game()
    print("wave " .. wave, 54, 40, blink())
end

function draw_win()
    cls(2)
    print("victiore ", 54, 40, 15)
end

function draw_game()
    cls(0)

    for asteroid in all(asteroids) do
        draw_obj(asteroid)
    end

    starfield()

    animate_obj(ship)
    if invul <= 0 then
        draw_obj(ship)
    else
        if sin(t / 10) < -0.2 then
            draw_obj(ship)
        end
    end

    for en in all(enemies) do
        animate_obj(en)
        local shakx = 0
        local shaky = 0
        if en.flash > 0 then
            shakx = rnd(2) - 1
            shaky = rnd(2) - 1
            en.flash -= 1
            pal(7, 6)
            pal(11, 12)
            pal(10, 13)
        end

        en.spr_settings[1].sprx += shakx
        en.spr_settings[1].spry += shaky
        draw_obj(en)
        en.spr_settings[1].sprx -= shakx
        en.spr_settings[1].spry -= shaky

        pal(0)
    end

    update_expl()
    -- draw particles
    for p in all(particles) do
        circfill(p.x, p.y, p.size, p.color)
    end
    for s in all(shocks) do
        circ(s.x, s.y, s.size, 4)
        s.size += s.rate
        s.age += 1
        if s.age >= s.maxage then
            del(shocks, s)
        end
    end

    for imp in all(impacts) do
        circ(imp.x, imp.y, imp.rad - 1, 3)
    end

    for sp in all(sparks) do
        if sp.size then
            circfill(sp.x, sp.y, sp.size, sp.color)
        else
            pset(sp.x, sp.y, sp.color)
        end
        sp.x += sp.sx
        sp.y += sp.sy
        sp.age += 1
        if sp.age >= sp.maxage then
            del(sparks, sp)
        end
    end

    draw_laser()

    for bul in all(bullets) do
        draw_obj(bul)
        if bul.muz_flash > 0 then
            circfill(bul.muz_x, bul.muz_y, bul.muz_flash, 8)
        end
        bul.muz_flash -= 1.4
    end

    for en_bul in all(enemy_bullets) do
        animate_obj(en_bul)
        draw_obj(en_bul)
    end

    draw_ui()

    draw_all_hitbox()

    -- circle experimentation
    -- x_circ = cos(ang) * 15 + 60
    -- y_circ = sin(ang) * 15 + 60
    -- pset(x_circ, y_circ, 13)
    -- print(ang, 80,80)
    -- ang += 0.001
    -- if ang > 1 then
    --     ang = 0
    -- end
    -- print(atantruc,50,120)
end

function draw_ui()
    -- score screen
    line(4, 3, 24, 3, 1)
    line(4, 15, 24, 15, 1)
    line(3, 4, 3, 14, 1)
    line(25, 4, 25, 14, 1)
    rect(4, 4, 24, 14, 2)
    rect(5, 5, 23, 13, 1)
    rectfill(6, 6, 22, 12, 14)
    pset(20, 14, 10)
    pset(22, 14, 6)

    line(6, 0, 6, 2, 1)
    pset(8, 2, 1)
    line(0, 8, 2, 8, 1)
    line(0, 9, 2, 9, 2)
    line(0, 10, 2, 10, 1)

    print(score, 7, 7, 3)

    -- wave screen
    line(4, 18, 22, 18, 1)
    line(4, 30, 22, 30, 1)
    line(3, 19, 3, 29, 1)
    line(23, 19, 23, 29, 1)
    rect(4, 19, 22, 29, 2)
    rect(5, 20, 21, 28, 1)
    rectfill(6, 21, 20, 27, 14)

    line(7, 31, 19, 31, 2)
    line(7, 32, 19, 32, 1)
    pset(6, 31, 1)
    pset(20, 31, 1)

    line(0, 23, 2, 23, 1)
    line(0, 24, 2, 24, 2)
    line(0, 25, 2, 25, 1)

    print(wave .. "/" .. max_num_wave - 1, 7, 22, 11)
    -- wave timer debug
    print(t, 115, 10, 4)

    -- cables
    line(26, 11, 28, 13, 1)
    pset(28, 14, 1)
    line(27, 15, 24, 20, 1)

    line(1, 13, 2, 13, 1)
    line(0, 14, 0, 18, 1)
    line(0, 19, 2, 21, 1)

    -- laser meter debug
    print(laser.meter, 115, 2, 13)
    -- laser meter
    local norm_meter = laser.meter / 100
    line(6, 99, 6, 99 - norm_meter * 60, 4)
    line(7, 100, 7, 100 - norm_meter * 60, 13)
    line(8, 101, 8, 101 - norm_meter * 60, 12)
    line(9, 102, 9, 102 - norm_meter * 60, 14)

    line(3, 34, 9, 40, 1)
    line(3, 35, 9, 41, 1)
    pset(4, 37, 10)
    pset(4, 38, 1)
    line(3, 36, 3, 122, 1)
    line(5, 38, 5, 98, 1)
    line(4, 39, 4, 121, 2)

    rectfill(5, 103, 8, 123, 2)
    line(5, 100, 8, 103, 2)
    line(5, 101, 7, 103, 2)

    line(5, 99, 8, 102, 1)
    line(9, 103, 9, 123, 1)
    line(5, 124, 8, 124, 1)
    line(4, 122, 4, 123, 1)

    -- lives and bombs
    for i = 0, 2 do
        line(5, 102 + i * 7, 7, 104 + i * 7, 1)
        if lives > 2 - i then
            pal(1, 10)
        end
        spr(9, 5, i * 7 + 103)
        pal(0)
    end

    if bombs == 1 then
        line(10, 113, 16, 113, 1)
        line(10, 122, 16, 122, 1)
        line(17, 114, 17, 121, 1)
        rectfill(10, 114, 16, 121, 2)
        circ(13, 118, 2, 1)
        circfill(13, 117, 2, 6)
    end
end

function starfield()
    for star in all(stars) do
        if star.speed < 0.9 then
            pset(star.x, star.y, star.color)
        else
            line(star.x, star.y, star.x, star.y - 2, star.color)
        end
    end
end

function create_stars()
    stars = {}
    for i = 0, 80 do
        local star = {}
        local color

        star.x = flr(rnd(128))
        star.y = flr(rnd(128))
        star.speed = rnd(1)

        if star.speed <= 0.15 then
            color = 1
        end
        if star.speed > 0.15 and star.speed < 0.5 then
            color = 2
        elseif star.speed >= 0.5 then
            color = 15
        end
        star.color = color
        add(stars, star)
    end
end

function draw_all_hitbox()
    if show_hb_flag then
        draw_hb(ship)
        print(ship.x .. "  " .. ship.y, 60, 100)

        if laser.on then
            draw_hb(laser)
        end

        for en in all(enemies) do
            draw_hb(en)
        end
        for b in all(bullets) do
            draw_hb(b)
        end
        for b in all(enemy_bullets) do
            draw_hb(b, 3)
        end
    end
end

function animate_stars()
    for star in all(stars) do
        star.y = (star.y + star.speed) % 127
    end
end

function update_asteroids()
    for asteroid in all(asteroids) do
        asteroid.y = asteroid.y + asteroid.speed
        if asteroid.y > 127 then
            asteroid.y = rnd(40) - 40
            asteroid.speed = rnd(0.5)
            asteroid.x = rnd(127)
        end
    end
end

function create_expl_particle(x, y, base_size)
    local p = {
        x = x + rnd(10) - 5,
        y = y + rnd(10) - 5,
        sx = rnd(1) - 0.5,
        sy = rnd(1) - 0.5,
        size = base_size + rnd(1.5 * base_size),
        rate = 0.15 + rnd(0.25),
        age = 0,
        maxage = 20 + rnd(60),
        color = rnd(expl_particle_colors)
    }
    p.fission = p.size / 2
    return p
end

function explode(x, y, base_size)
    for i = 1, 4 do
        add(particles, create_expl_particle(x, y, base_size))
    end
    for i = 1, 20 do
        local p = {}
        p.x = x
        p.y = y
        p.sx = rnd(4) - 2
        p.sy = rnd(4) - 2
        p.age = 0
        p.maxage = 10 + rnd(40)
        p.color = 4
        add(sparks, p)
    end

    local s = {}
    s.x = x
    s.y = y
    s.size = 0
    s.age = 0
    s.maxage = 10 + rnd(20)
    s.rate = 0.25 + rnd(0.25)
    add(shocks, s)
end

function draw_laser()
    if laser.on then
        max_num_sprite = flr(laser.height / 8)
        incomplete_sprite = laser.height % 8

        laser_spr_ind = mod(laser_spr_ind + 0.25, 4, 1)
        local floored = flr(laser_spr_ind)
        for i = 0, max_num_sprite - 1 do
            spr(laser_spr_num[mod(floored + i, 4, 1)], laser.x - 3, laser.y + 8 * i, 2, 1)
        end
        clip(laser.x - 3, laser.y + 8 * max_num_sprite, 30, incomplete_sprite)
        spr(laser_spr_num[mod(floored + max_num_sprite, 4, 1)], laser.x - 3, laser.y + 8 * max_num_sprite, 2, 1)
        clip()

        laser_start.x = ship.x
        laser_start.y = ship.y
        animate_obj(laser_start)
        draw_obj(laser_start)
        if laser.collide then
            animate_obj(laser)
            draw_obj(laser)
        end
    end
end

function update_expl()
    for p in all(particles) do
        p.x += p.sx
        p.y += p.sy
        p.age += 1

        local newsize = p.size - p.rate
        if p.fission >= 3 and p.size >= p.fission and newsize <= p.fission then
            for i = 1, 8 do
                local pc = create_expl_particle(p.x, p.y, 0)
                pc.size = rnd(p.size)
                pc.rate = 0.05 + rnd(0.2)
                pc.fission = pc.size / 1.5
                pc.color = 1
                add(particles, pc)
            end
        end

        p.size = newsize
        if p.age > p.maxage or p.size < 1 then
            del(particles, p)
        end
    end
end

function animate(setting)
    if setting.frames then
        setting.frame += setting.speed * setting.dir
        local stop_cond
        if setting.dir == 1 then
            stop_cond = flr(setting.frame) > setting.stop
        else
            stop_cond = flr(setting.frame) < setting.stop
        end
        if stop_cond then
            if setting.loop then
                setting.frame = setting.start
            else
                setting.frame = setting.stop
            end
        end

        setting.spr = setting.frames[flr(setting.frame)]

        if setting.flips_x then
            setting.flip_x = setting.flips_x[flr(setting.frame)]
        end
        if setting.flips_y then
            setting.flip_y = setting.flips_y[flr(setting.frame)]
        end
    end
end

function animate_obj(obj)
    for key, setting in pairs(obj.spr_settings) do
        animate(setting)
    end
end

function draw_obj(obj)
    for key, setting in pairs(obj.spr_settings) do
        spr(
            setting.spr,
            obj.x + (setting.sprx or 0),
            obj.y + (setting.spry or 0),
            setting.w,
            setting.h,
            setting.flip_x,
            setting.flip_y
        )
    end
end