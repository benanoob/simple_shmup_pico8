bul_pink1 = {
    frames = { 10, 10 },
    flips_x = { false, true },
    frame = 10,
    start = 1,
    stop = 2,
    speed = 0.2,
    loop = true,
    dir = 1,
    w = 1,
    h = 1,
    sprx = -3,
    spry = -2
}
bul_green1 = {
    frames = { 11, 11 },
    flips_x = { false, true },
    frame = 10,
    start = 1,
    stop = 2,
    speed = 0.2,
    loop = true,
    dir = 1,
    w = 1,
    h = 1,
    sprx = -3,
    spry = -2
}

function update_basic_canon(en)
    local bul = {
        x = en.x,
        y = en.y + 1,
        xb = 1,
        yb = 1,
        dmg = 1,
        spr_settings = {}
    }
    add(bul.spr_settings, bul_pink1)
    local theta = get_angle_player(bul.x, bul.y)
    bul.spx = cos(theta) * 1.5
    bul.spy = sin(theta) * 1.5
    add(enemy_bullets, bul)
    en.delay_shot = 60
end

function update_tenta1_canon(en)
    -- random circular shot, occupy space
    for i = 1, 10 do
        local theta = rnd()
        for j = 1, 4 do
            local bul = {
                x = en.x + j * 2 * cos(theta),
                y = en.y + j * 2 * sin(theta),
                xb = 1,
                yb = 1,
                dmg = 1,
                spr_settings = {},
                spx = cos(theta) * 1,
                spy = sin(theta) * 1
            }
            add(bul.spr_settings, bul_pink1)
            add(enemy_bullets, bul)
        end
    end
    en.delay_shot = 100

    -- target player double shot
    local offset_theta = { 0.025, -0.025 }
    for j = 1, 2 do
        local bul = {
            x = en.x + 8,
            y = en.y + 1,
            xb = 1,
            yb = 1,
            dmg = 1,
            spr_settings = {}
        }
        add(bul.spr_settings, bul_pink1)
        local theta = get_angle_player(bul.x, bul.y)
        bul.spx = cos(theta + offset_theta[j]) * 1
        bul.spy = sin(theta + offset_theta[j]) * 1
        add(enemy_bullets, bul)
    end
end

function fire_side_beetle(can_x, can_y, en, args)
    for theta in all(args.thetas) do
        add(
            enemy_bullets,
            {
                x = can_x,
                y = can_y,
                spx = cos(theta),
                spy = sin(theta),
                xb = 1,
                yb = 1,
                dmg = 1,
                spr_settings = { bul_green1 }
            }
        )
    end
end

function fire_at_player(can_x, can_y, en, args)
    local theta = get_angle_player(can_x, can_y)
    add(
        enemy_bullets,
        {
            x = can_x,
            y = can_y,
            spx = cos(theta),
            spy = sin(theta),
            xb = 1,
            yb = 1,
            dmg = 1,
            spr_settings = { bul_pink1 }
        }
    )
end