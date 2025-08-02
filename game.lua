function update_game()

	t+=1

	ship.xspeed = 0
	ship.yspeed = 0
	ship.spr = 64

	if delay_next_shot>0 then
		delay_next_shot -= 1
	end
	update_controls()

	update_ship_position()
	ship.flame = mod(ship.flame +0.35,3,6)

	if invul>0 then
		invul -=1
	end

	update_enemies()

	update_bullets()
	if muzzle_flash > 0 then
		muzzle_flash = muzzle_flash - 1
	end

	update_collisions_edges()
	update_collision_ship()
	update_collision_bullets()

	if lives <= 0 then mode = "over" end

	animate_stars()

	update_asteroids()
end

function draw_game()
	cls(0)

	draw_asteroids()
	starfield()

	if invul <= 0 then
		spr(ship.spr, ship.x, ship.y, 2,2)
		spr(flr(ship.flame), ship.x+2, ship.y+15)
	else
		if sin(t/10) < -0.2 then
			draw_obj(ship)
			spr(ship.flame, ship.x, ship.y)
		end
	end

	draw_array(enemies)

	draw_array(bullets)

	if muzzle_flash > 0 then
		circfill(ship.x + 4,ship.y-3, muzzle_flash, 9)
	end

	-- draw particles
	for myp in all(particles) do
		pset(myp.x,myp.y,9)
		myp.x += myp.sx
		myp.y += myp.sy
		myp.age += 1

		if myp.age > 20 + rnd(30) then
			del(particles,myp)
		end
	end


	-- UI
	print("score="..score, 30, 1, 12)

	for i=0,2 do
		if lives>i then
		spr(10,i*9+1,1)
		else
		spr(9,i*9+1,1)
		end
	end
	for i=0,2 do
		if bombs>i then
		spr(25,101 + i*9,1)
		else
		spr(26,101 + i*9,1)
		end
	end

end

function update_controls()
	if btn(0) then
		ship.xspeed = -2
		ship.spr = 68
	end
	if btn(1) then
		ship.xspeed = 2
		ship.spr = 66
	end
	if btn(2) then
		ship.yspeed = -2
	end
	if btn(3) then
		ship.yspeed = 2
	end
	if btnp(4) then
		mode = "over"
	end
    if btn(5) then
		if delay_next_shot == 0 then
			local bullet = {x=ship.x+1, y=ship.y, spr=16}
			add(bullets, bullet)
			sfx(0)
			muzzle_flash = 4
			delay_next_shot = fire_rate
		end
    end
end

function update_bullets()
	for bullet in all(bullets) do
		bullet.y = bullet.y - speed_bul
		if bullet.y < -20 then
			del(bullets, bullet)
		end
	end
end

function update_ship_position()
	ship.x = ship.x + ship.xspeed
	ship.y = ship.y + ship.yspeed
end

function update_collisions_edges()
	if ship.x >  120 then
		ship.x = 120
	end
	if ship.x < 0 then
		ship.x = 0
	end
    if ship.y >  120 then
		ship.y = 120
	end
	if ship.y < 0 then
		ship.y = 0
	end
end


function update_asteroids()
	for asteroid in all(asteroids) do
		asteroid.y = asteroid.y + asteroid.speed
		if asteroid.y > 127 then
			asteroid.y = rnd(40) - 40
			asteroid.speed = rnd(0.5)
			asteroid.x = rnd(127)
		end
	end
end

function draw_asteroids()
	for asteroid in all(asteroids) do
		draw_obj(asteroid)
	end
end


function starfield()
	for star in all(stars) do
		if star.speed < 1.8 then
			pset(star.x,star.y,star.color)
		else
			line(star.x,star.y,star.x,star.y-2, star.color)
		end
	end
end

function animate_stars()
	for star in all(stars) do
		star.y = (star.y + star.speed) % 127
	end
end

function update_enemies()
	for enemy in all(enemies) do
		-- enemy.y += 0.4
		enemy.spr = mod(enemy.spr+0.1,3,32)
	end
end

function update_collision_ship()
	for enemy in all(enemies) do
		if col(ship, enemy) and invul==0 then
			sfx(1)
			lives -= 1
			invul = 60
			del(enemies, enemy)
		end
	end
end

function update_collision_bullets()
	for bullet in all(bullets) do
		for enemy in all(enemies) do
			if col(bullet,enemy) then
				sfx(2)
				del(enemies,enemy)
				explode(enemy.x,enemy.y)
				del(bullets, bullet)
				score += 1
			end
		end
	end
end

-- function explode(x, y, num, size)
	-- explosions = {}
	-- for i=1,num
		-- rad = rnd(size)
		-- x_e =
		-- add(explosions, {})
	-- end
-- end

function explode(expx,expy)

	for i=1,20 do
		local myp={}
		myp.x = expx
		myp.y = expy
		myp.sx = rnd(8) - 4
		myp.sy = rnd(8) - 4
		myp.age = 0
		add(particles,myp)
	end
end
