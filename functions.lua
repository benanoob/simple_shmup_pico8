function draw_obj(obj)
    spr(obj.spr, obj.x, obj.y)
end

function draw_array(array)
    for obj in all(array) do
        draw_obj(obj)
    end
end

function mod(a,n,d)
-- a modulo n offset d
    return a - n * flr((a-d)/n)
end


function col(a,b)
    local a_left = a.x
    local a_right = a.x + 7
    local a_top = a.y
    local a_bottom = a.y + 7

    local b_left = b.x
    local b_right = b.x + 7
    local b_top = b.y
    local b_bottom = b.y + 7

    if a_right < b_left then return false end 
    if a_left > b_right then return false end
    if a_top > b_bottom then return false end
    if a_bottom < b_top then return false end

    return true
end
