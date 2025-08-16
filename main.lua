draw_hitbox = false

function _init()
    -- code to change palette
    -- see https://nerdyteachers.com/PICO-8/Guide/?HIDDEN_PALETTE
    -- and https://www.lexaloffle.com/bbs/?tid=35462
    poke(0x5f2e, 1)
    pal({ [0] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 141 }, 1)

    cls(0)

    mode = "start"
end

function _update()
    if mode == "game" then
        update_game()
    elseif mode == "start" then
        update_start()
    elseif mode == "wave_text" then
        update_wave_text()
    elseif mode == "over" then
        update_over()
    end
end

function _draw()
    if mode == "game" then
        draw_game()
    elseif mode == "start" then
        draw_start()
    elseif mode == "wave_text" then
        draw_wave_text()
    elseif mode == "over" then
        draw_over()
    end
end