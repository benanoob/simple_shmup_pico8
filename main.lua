show_hb_flag = false

function _init()
    -- code to change palette
    -- see https://nerdyteachers.com/PICO-8/Guide/?HIDDEN_PALETTE
    -- and https://www.lexaloffle.com/bbs/?tid=35462
    poke(0x5f2e, 1)
    pal({ [0] = 0, 133, 134, 135, 7, 14, 8, 136, 9, 10, 138, 139, 140, 12, 1 }, 1)

    create_stars()
    mode = "start"
end

function _update60()
    if mode == "game" then
        update_game()
    elseif mode == "start" then
        update_start()
    elseif mode == "wave_text" then
        update_wave_text()
    elseif mode == "win" then
        update_win()
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
    elseif mode == "win" then
        draw_win()
    elseif mode == "over" then
        draw_over()
    end
end