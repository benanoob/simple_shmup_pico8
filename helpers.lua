truth_rnd = {true,false}
expl_particle_colors = {8,9}

function draw_hb(obj, color)
    color = color or 5
    rect(obj.x, obj.y, obj.x + obj.xb, obj.y + obj.yb, color)
end

function mod(a, n, d)
    -- a modulo n offset d
    return a - n * flr((a - d) / n)
end

function col(a, b)
    local a_left = a.x
    local a_right = a.x + a.xb
    local a_top = a.y
    local a_bottom = a.y + a.yb

    local b_left = b.x
    local b_right = b.x + b.xb
    local b_top = b.y
    local b_bottom = b.y + b.yb

    if a_right < b_left then return false end
    if a_left > b_right then return false end
    if a_top > b_bottom then return false end
    if a_bottom < b_top then return false end

    return true
end

function blink()
    local banim = { 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 1, 1, 2, 2, 3 }
    if blinkt > #banim then
        blinkt = 1
    end
    return banim[blinkt]
end

function lerp(a, b, t)
    local ret
    if t == 1 then
        ret = b
    else
        ret = a + (b - a) * t
    end
    return ret
end

function get_angle_player(x,y)
    -- get the angle towards the player, cos and sine to get the carthesian vectors pointing that direction
    return atan2(ship.x - x, ship.y - y)
end

function linspace(num_points)
    local array = {}
    for i = 1, num_points do
        array[i] = i / num_points
    end
    -- fixme doesnt start at 0
    return array
end

function easeoutquad(t)
    t -= 1
    return 1 - t * t
end

-- pq by pancelor: lexaloffle.com/bbs/?tid=42367
function pq(...) printh(qq(...)) return ... end
function qq(...)
    local r = ""
    for i = 1, select("#", ...) do
        r ..= _q(select(i, ...), 4) .. " "
    end
    return r
end
function _q(t, d)
    if (type(t) ~= "table" or d <= 0) return tostr(t)
    local r = "{"
    for k, v in next, t do
        r ..= tostr(k) .. "=" .. _q(v, d - 1) .. ","
    end
    return r .. "}"
end