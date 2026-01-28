function update_over()
    if btnp(4) or btnp(5) then
        start_game()
    end
end

function update_start()
    animate_stars()
    if btnp(4) or btnp(5) then
        start_game()
    end
end

function start_game()
    wave = 0
    max_num_wave = 4
    next_wave()

    ang = 0

    ship = {}
    ship.x = 50
    ship.y = 50
    ship.xb = 2
    ship.yb = 2
    ship.xspeed = 0
    ship.yspeed = 0
    ship.spr_settings = {
        ship = {
            frames = { { 20, 32 }, { 11, 32 }, { 0, 32 }, { 11, 32 }, { 20, 32 } },
            flips_x = { false, false, false, true, true },
            frame = 3,
            start = 3,
            stop = 3,
            speed = 0.15,
            loop = false,
            dir = 1,
            sprs_x = { -1, -2, -4, -4, -2 },
            spry = -5,
            sws = { 6, 9, 11, 9, 6 },
            sh = 11
        },
        flame = {
            frames = { 5, 6, 7, 8 },
            frame = 1,
            start = 1,
            stop = 4,
            frame = 1,
            loop = true,
            speed = 0.12,
            sprx = 4 - 6,
            spry = 10 - 5,
            w = 1,
            h = 1,
            dir = 1
        }
    }

    laser = {
        on = false,
        x = 0,
        y = ship.y,
        xb = 0,
        yb = 0,
        dmg = 0.5,
        height = 0,
        off_timer = 0,
        collide = false,
        meter = 100,
        spr_settings = {
            laser_end = {
                frames = { 133, 136 },
                frame = 1,
                start = 1,
                stop = 2,
                frame = 1,
                dir = 1,
                speed = 0.6,
                loop = true,
                sprx = -6,
                spry = -10,
                w = 3,
                h = 3
            }
        }
    }
    laser_spr_ind = 0
    laser_spr_num = { 128, 144, 160, 176 }
    laser_start = {
        x = 0,
        y = 0,
        spr_settings = {
            {
                spr = 130,
                frames = { 130, 162 },
                frame = 1,
                start = 1,
                stop = 2,
                dir = 1,
                sprx = -12,
                spry = -18,
                speed = 0.6,
                loop = true,
                w = 3,
                h = 2
            }
        }
    }

    speed_bul = 5

    score = 69
    lives = 3
    bombs = 1

    invul = 0

    t = 0
    blinkt = 0

    create_stars()

    asteroids = {}
    for i = 1, 3 do
        local asteroid = {
            x = rnd(127),
            y = -30,
            spr_settings = {
                {
                    spr = 48,
                    w = 1,
                    h = 1,
                    flip_x = rnd(truth_rnd),
                    flip_y = rnd(truth_rnd)
                }
            },
            speed = rnd(0.5) + 0.05
        }
        add(asteroids, asteroid)
    end

    bullets = {}
    fire_rate = 3
    delay_next_shot = 0

    enemies = {}
    enemy_bullets = {}

    smart_enemies = {
        -- { { "beetle, 10,-30,150", "mv,60,30", "st,2000" }, { "st, 60", "fire, 0" } },
        { { "square, 10,-30,150", "track,-1" }, {} },
        { { "popcorn, 100, -20,30", "mv,90,40", "st,2000" }, { "st, 20", "fire, 0" } }
    }
    spawn_list = {}
    for en_descr in all(smart_enemies) do
        load_enemy(en_descr)
    end

    particles = {}
    shocks = {}
    impacts = {}
    sparks = {}
end