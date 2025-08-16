function update_over()
    if btnp(4) or btnp(5) then
        start_game()
    end
end



function update_start()
    if btnp(4) or btnp(5) then
        start_game()
    end
end

function start_game()
    mode = "wave_text"

    wave = 1

    ship = {}
    ship.x = 64
    ship.y = 64
    ship.xspeed = 0
    ship.yspeed = 0
    ship.spr = 64
    ship.spx = -4
    ship.spy = -5
    ship.w = 2
    ship.h = 2
    ship.flame = 6
    ship.xb = 2
    ship.yb = 2

    speed_bul = 5

    score = 69
    lives = 3
    bombs = 2

    invul = 0

    t = 0

    stars = {}
    for i = 0, 80 do
        local star = {}
        local color

        star.x = flr(rnd(128))
        star.y = flr(rnd(128))
        star.speed = rnd(2)

        if star.speed <= 0.3 then
            color = 1
        end
        if star.speed > 0.3 and star.speed < 1 then
            color = 6
        elseif star.speed >= 1 then
            color = 7
        end
        star.color = color
        add(stars, star)
    end

    asteroids = {}
    for i = 1, 3 do
        local asteroid = { x = rnd(127), y = -30, spx = 0, spy = 0, w = 1, h = 1, speed = rnd(0.5)+0.05, spr = 48 }
        add(asteroids, asteroid)
    end

    bullets = {}
    fire_rate = 3
    delay_next_shot = 0

    enemies = {}
    for i = 1, 9 do
        local en = {}
        en.x = i * 10 + 5
        en.y = 20
        en.spx = 0
        en.spy = 0
        en.spr = 35 + flr(rnd(2))
        en.w = 1
        en.h = 1
        en.hp = 10
        en.xb = 8
        en.yb = 8
        add(enemies, en)
    end

    particles = {}
    shocks = {}
    impacts = {}
    sparks = {}
end