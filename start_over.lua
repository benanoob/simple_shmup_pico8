function update_over()
	if btnp(4) or btnp(5) then
		start_game()
	end
end

function draw_over()
	cls(2)

	print("game over", 20,40, 6)
	print("press action button to start again", 15,60, 5)
end

function update_start()
	if btnp(4) or btnp(5) then
		start_game()
	end
end

function draw_start()
	cls(0)

	print("shmup et non pas meuporg", 20,40, 2)
	print("press action button to start", 15,60, 5)

end

function start_game()
	mode = "game"


	ship = {}
	ship.x = 64
	ship.y = 64
	ship.xspeed = 0
	ship.yspeed = 0
	ship.spr = 64
	ship.flame = 0


    x_bul = 64
    y_bul = -10
	speed_bul = 3
	muzzle_flash = 0


	score = 69
	lives = 3
	bombs = 2

	invul = 0

	t = 0


	stars={}
	for i=0, 80 do
		local star={}
		local color

		star.x = flr(rnd(128))
		star.y = flr(rnd(128))
		star.speed = rnd(2)

		if star.speed <= 0.3 then
			color = 1
		end
		if star.speed > 0.3  and star.speed < 1 then
			color = 6
		elseif star.speed >= 1 then
			color = 7
		end
		star.color = color
		add(stars, star)
	end


	asteroids = {}
	asteroids_x = {}
	asteroids_y = {}
	asteroids_speed = {}
	for i=1,3 do
		local asteroid = {x=rnd(127),y=-40,speed=rnd(0.8),spr=48}
	end

	bullets = {}
	fire_rate = 3
	delay_next_shot = 0

	enemies = {}
	for i=1,12 do
		add(enemies, {x=i*8 + 10,y=20,spr=34})

	end

	particles = {}

end
