function update_game()
    t += 1

    ship.xspeed = 0
    ship.yspeed = 0
    ship.spr = 64

    if delay_next_shot > 0 then
        delay_next_shot -= 1
    end
    update_controls()

    update_ship_position()
    ship.flame = mod(ship.flame + 0.35, 3, 6)

    if invul > 0 then
        invul -= 1
    end

    update_enemies()

    update_bullets()

    update_collisions_edges()
    update_collision_ship()
    update_collision_bullets()

    update_expl()

    if lives <= 0 then mode = "over" end

    animate_stars()

    update_asteroids()
end

function update_wave_text()
    update_game()
end

function update_controls()
    if btn(0) then
        ship.xspeed = -2
        ship.spr = 68
    end
    if btn(1) then
        ship.xspeed = 2
        ship.spr = 66
    end
    if btn(2) then
        ship.yspeed = -2
    end
    if btn(3) then
        ship.yspeed = 2
    end
    if btnp(4) then
        mode = "over"
    end
    if btn(5) then
        if delay_next_shot == 0 then
            add(bullets, create_bullet(ship.x + ship.spx+ 1, ship.y + ship.spy - 3, 0))
            add(bullets, create_bullet(ship.x + ship.spx + 6, ship.y + ship.spy - 3, 1))
            sfx(0)
            delay_next_shot = fire_rate
        end
    end
end

function create_bullet(x, y, spr)
    local bul = {}
    bul.x = x
    bul.y = y
    bul.xb = 3
    bul.yb = 7
    bul.spx = 0
    bul.spy = 0
    bul.w = 1
    bul.h = 1
    bul.spr = spr
    bul.muz_x = x+1
    bul.muz_y = y
    bul.muz_flash = 4
    return bul
end

function update_bullets()
    for bullet in all(bullets) do
        bullet.y = bullet.y - speed_bul
        if bullet.y < -20 then
            del(bullets, bullet)
        end
    end
end

function update_ship_position()
    ship.x = ship.x + ship.xspeed
    ship.y = ship.y + ship.yspeed
end

function update_collisions_edges()
    if ship.x > 120 then
        ship.x = 120
    end
    if ship.x < 0 then
        ship.x = 0
    end
    if ship.y > 120 then
        ship.y = 120
    end
    if ship.y < 0 then
        ship.y = 0
    end
end

function update_enemies()
    for enemy in all(enemies) do
        -- enemy.y += 0.4
        -- enemy.spr = mod(enemy.spr + 0.1, 3, 32)
    end
end

function update_collision_ship()
    for enemy in all(enemies) do
        if col(ship, enemy) and invul == 0 then
            sfx(1)
            lives -= 1
            invul = 60
            del(enemies, enemy)
        end
    end
end

function update_collision_bullets()
    for bullet in all(bullets) do
        for en in all(enemies) do
            if col(bullet, en) then
                en.hp -= 1
                local imp = {}
                imp.x = bullet.x
                imp.y = bullet.y
                imp.x1 = imp.x + 5
                imp.y1 = imp.y + 2
                imp.age = 0
                add(impacts, imp)

                local p = {}
                p.x = bullet.x
                p.y = bullet.y
                p.sx = rnd(3) - 1.5
                p.sy = rnd(3) - 3
                p.age = 0
                p.maxage = rnd(30)
                add(sparks, p)

                if en.hp <= 0 then
                    del(enemies, en)
                    explode(en.x, en.y)
                    score += 1
                    sfx(1)
                    sfx(2)
                    sfx(3)
                end
                del(bullets, bullet)
            end
        end
    end
    for imp in all(impacts) do
        imp.age += 1
        if imp.age > 10 then
            del(impacts, imp)
        end
    end
end