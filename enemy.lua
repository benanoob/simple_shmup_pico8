function spawn_wave()
end

function load_enemy(enemy_table)
    local en = {}
    local action_table = enemy_table[1]
    local fire_table = enemy_table[2]
    local spawn = split(action_table[1])

    local seq = {}
    local fire_seq = {}

    add(seq, { type = "standby", duration = spawn[4], func = standby })
    en.type = spawn[1]
    en.x = spawn[2]
    en.y = spawn[3]
    en.spawn_timer = spawn[4]
    en.flash = 0
    en.i = 1
    en.t = 0
    en.seq_len = #action_table - 1
    en.t_fire = 0
    en.i_fire = 1
    en.delay_shot = 0
    en.fire_state = "stop_fire"

    if en.type == "popcorn" then
        en.spd = 0.15
        en.hp = 20
        en.xb = 8
        en.yb = 8
        en.update_canon = nil
        en.spr_settings = {
            {
                spr = 35,
                speed = 0.6,
                w = 1,
                h = 1,
                sprx = 0,
                spry = 0
            }
        }
    elseif en.type == "basic" then
        en.spr_settings = {
            {
                spr = 36,
                frame = 1,
                w = 1,
                h = 1,
                sprx = 0,
                spry = 0
            }
        }
        en.spd = 0.20
        en.hp = 10
        en.xb = 8
        en.yb = 8
        en.update_canon = update_basic_canon
    elseif en.type == "tenta1" then
        en.spr_settings = {
            {
                spr = 37,
                frame = 1,
                sprx = 0,
                spry = 0,
                w = 2,
                h = 2,
                sprx = 0,
                spry = 0
            }
        }
        en.spd = 0.08
        en.hp = 40
        en.xb = 13
        en.yb = 13
        en.update_canon = update_tenta1_canon
    elseif en.type == "beetle" then
        en.spr_settings = {
            {
                spr = 39,
                frame = 1,
                sprx = 0,
                spry = 0,
                w = 2,
                h = 2,
                sprx = 0,
                spry = 0
            }
        }
        en.spd = 0.4
        en.hp = 40
        en.xb = 15
        en.yb = 15
        en.update_canon = nil
        en.canons = {
            {
                off_x = 0,
                off_y = 6,
                fire_rate = 12,
                cooldown = 40,
                num_fire = 3,
                current_fire = 3,
                t = 10,
                fire_func = fire_side_beetle,
                args_func = {
                    thetas = { 0.3, 0.4, 0.5, 0.6, 0.7 }
                }
            },
            {
                off_x = 13,
                off_y = 6,
                fire_rate = 12,
                cooldown = 60,
                num_fire = 3,
                current_fire = 3,
                t = 10,
                fire_func = fire_side_beetle,
                args_func = {
                    thetas = { 0.8, 0.9, 1, 0.1, 0.2, 0.3 }
                }
            },
            {
                off_x = 6,
                off_y = 15,
                fire_rate = 10,
                cooldown = 60,
                num_fire = 2,
                current_fire = 2,
                t = 5,
                fire_func = fire_at_player
            }
        }
    elseif en.type == "doublob" then
        en.spr_settings = {
            {
                frames = { 34, 34 },
                flips_x = { false, true },
                frame = 1,
                start = 1,
                stop = 2,
                dir = 1,
                loop = true,
                speed = 0.1,
                w = 1,
                h = 1,
                sprx = 0,
                spry = 0
            }
        }
        en.spd = 0.20
        en.hp = 10
        en.xb = 8
        en.yb = 8
        en.update_canon = update_basic_canon
    end

    for i = 2, #action_table do
        local action = split(action_table[i])
        if action[1] == "mv" then
            add(
                seq, {
                    type = "move",
                    start_x = 0,
                    start_y = 0,
                    dest_x = action[2],
                    dest_y = action[3],
                    func = lerp_enemy
                }
            )
        elseif action[1] == "st" then
            add(seq, { type = "standby", duration = action[2] - 1, func = standby })
        end
    end
    add(
        seq, {
            type = "despawn",
            func = despawn_enemy
        }
    )

    for i = 1, #fire_table do
        local action = split(fire_table[i])
        if action[1] == "st" then
            add(fire_seq, { type = "standby", duration = action[2] - 1, func = standby_fire })
        elseif action[1] == "fire" or action[1] == "stop_fire" then
            add(
                fire_seq, {
                    fire_state = action[1],
                    func = change_fire_state
                }
            )
            add(fire_seq, { type = "standby", duration = action[2] - 1, func = standby_fire })
        end
    end

    en.seq = seq
    en.fire_seq = fire_seq
    add(enemies, en)
end

function lerp_enemy(en, command)
    if en.t == 0 then
        command.start_x = en.x
        command.start_y = en.y
        local spx = command.dest_x - en.x
        local spy = command.dest_y - en.y
        command.last_t = flr(sqrt(spx * spx + spy + spy) / en.spd)
        command.t = linspace(command.last_t)
    end
    if en.t < command.last_t then
        en.x = lerp(
            command.start_x,
            command.dest_x,
            command.t[en.t + 1]
        )
        en.y = lerp(
            command.start_y,
            command.dest_y,
            command.t[en.t + 1]
        )
    else
        return true
    end
    return false
end

function standby(en, command)
    return standby_helper(en.t, command.duration)
end

function standby_fire(en, command)
    return standby_helper(en.t_fire, command.duration)
end

function standby_helper(t, duration)
    if t == duration then
        return true
    end
    return false
end

function change_fire_state(en, command)
    en.fire_state = command.fire_state
    return true
end

function despawn_enemy(en, command)
    del(enemies, en)
end

function update_enemy_bullets()
    for en_bul in all(enemy_bullets) do
        en_bul.x += en_bul.spx
        en_bul.y += en_bul.spy

        if en_bul.x < 0 or en_bul.x > 135 or en_bul.y < 0 or en_bul.y > 135 then
            del(enemy_bullets, en_bul)
        end
    end
end