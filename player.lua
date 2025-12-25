function create_player_bullet(x, y, spr)
    return {
        x = x,
        y = y,
        xb = 3,
        yb = 7,
        muz_x = x + 2,
        muz_y = y,
        muz_flash = 4,
        dmg = 0.3,
        spr_settings = {
            {
                spr = spr,
                w = 1,
                h = 1
            }
        }
    }
end

function update_bullets()
    for bullet in all(bullets) do
        bullet.y = bullet.y - speed_bul
        if bullet.y < -5 then
            del(bullets, bullet)
        end
    end
end

function update_ship_position()
    norm_speed = sqrt(ship.xspeed * ship.xspeed + ship.yspeed * ship.yspeed)
    if norm_speed != 0 then
        ship.x = ship.x + ship.xspeed / norm_speed
        ship.y = ship.y + ship.yspeed / norm_speed
    end
end

function update_collisions_edges()
    if ship.x > 125 then
        ship.x = 125
    end
    if ship.x < 25 then
        ship.x = 25
    end
    if ship.y > 122 then
        ship.y = 122
    end
    if ship.y < 0 then
        ship.y = 0
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

function update_collision_laser()
    laser.collide = false
    if laser.on then
        for en in all(enemies) do
            if col(laser, en) then
                en.hp -= laser.dmg
                en.flash = 4

                laser.collide = true
                laser.height = ship.y - 8 - (en.y + en.yb)

                add(
                    sparks,
                    {
                        x = laser.x,
                        y = laser.y,
                        sx = rnd(3) - 1.5,
                        sy = rnd(3) - 3,
                        age = 0,
                        maxage = rnd(30),
                        color = 13,
                        size = 2
                    }
                )

                if en.hp <= 0 then
                    del(enemies, en)
                    explode(en.x, en.y, en.xb / 1.5)
                    score += 1
                    sfx(1)
                    sfx(2)
                    sfx(3)
                    laser.meter += 10
                    laser.meter = min(laser.meter, 100)
                end
            end
        end
    end
end

function update_collision_bullets()
    for bul in all(bullets) do
        for en in all(enemies) do
            if col(bul, en) then
                en.hp -= bul.dmg

                en.flash = 10
                local imp = {}
                imp.x = bul.x
                imp.y = bul.y
                imp.x1 = imp.x + 5
                imp.y1 = imp.y + 2
                imp.rad = 0
                imp.rad_speed = 0.5
                add(impacts, imp)

                local p = {}
                p.x = bul.x
                p.y = bul.y
                p.sx = rnd(3) - 1.5
                p.sy = rnd(3) - 3
                p.age = 0
                p.maxage = rnd(30)
                p.color = 4
                add(sparks, p)

                if en.hp <= 0 then
                    del(enemies, en)
                    explode(en.x, en.y,en.xb / 1.5)
                    laser.meter += 10
                    laser.meter = min(laser.meter, 100)
                    score += 1
                    sfx(1)
                    sfx(2)
                    sfx(3)
                end
                del(bullets, bul)
            end
        end
    end

    if t == 9999 then
        next_wave()
    end

    for imp in all(impacts) do
        imp.rad += imp.rad_speed
        if imp.rad > 5 then
            del(impacts, imp)
        end
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

function update_collision_en_bullets()
    for bul in all(enemy_bullets) do
        if col(ship, bul) and invul == 0 then
            sfx(1)
            lives -= 1
            invul = 60
            del(bul, enemy_bullets)
        end
    end
end