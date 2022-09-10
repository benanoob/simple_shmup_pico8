function _init()
	cls(0)

	mode = "start"
end

function _update()

	if mode == "game" then
		update_game()
	elseif mode == "start" then
		update_start()
	elseif mode == "over" then
		update_over()
	end
end


function _draw()

	if mode == "game" then
		draw_game()
	elseif mode == "start" then
		draw_start()
	elseif mode == "over" then
		draw_over()
	end

end
