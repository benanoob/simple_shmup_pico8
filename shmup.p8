pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- #include main.lua
-- #include game.lua
-- #include start_over.lua
-- #include functions.lua

draw_hitbox = false

function update_over()
	if btnp(4) or btnp(5) then
		start_game()
	end
end

function update_start()
	if btnp(4) or btnp(5) then
		start_game()
	end
end

function start_game()
	mode = "game"

	ship = {}
	ship.x = 64
	ship.y = 64
	ship.xspeed = 0
	ship.yspeed = 0
	ship.spr = 64
	ship.spx = -4
	ship.spy = -5
	ship.w = 2
	ship.h = 2
	ship.flame = 0
	ship.xb = 2
	ship.yb = 2


 x_bul = 64
 y_bul = -10
	speed_bul = 5
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
		local asteroid = {x=rnd(127),y=-40,spx=0,spy=0,speed=rnd(0.8),spr=48}
	end

	bullets = {}
	fire_rate = 3
	delay_next_shot = 0

	enemies = {}
	for i=1,12 do
		local en = {}
		en.x = i*8 + 10
		en.y = 20
		en.spx = 0
		en.spy = 0
		en.spr = 34
		en.w = 1
		en.h = 1
		en.hp = 10
		en.xb = 8
		en.yb = 8
		add(enemies, en)
	end

	particles = {}
	shocks = {}
	impacts = {}
	sparks = {}
end

function _init()
	-- code to change palette
	-- see https://nerdyteachers.com/PICO-8/Guide/?HIDDEN_PALETTE
	-- and https://www.lexaloffle.com/bbs/?tid=35462
	poke(0x5f2e, 1)
	pal({[0]=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,141},1)

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
	
	update_expl()

	if lives <= 0 then mode = "over" end

	animate_stars()

	update_asteroids()
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
			local bullet = {x=ship.x+ship.spx+4, y=ship.y+ship.spy-2,xb=3,yb=6,spx=0,spy=0,w=1,h=1, spr=16}
			add(bullets, bullet)
			sfx(0)
			muzzle_flash = 4
			delay_next_shot = fire_rate
		end
    end
end


-->8
-- utils
function draw_obj(obj)
    spr(obj.spr,obj.x + obj.spx, obj.y+obj.spy, obj.w, obj.h)
end

function draw_array(array)
    for obj in all(array) do
        draw_obj(obj)
    end
end

function draw_hb(obj)
	rect(obj.x, obj.y, obj.x+obj.xb, obj.y+obj.yb,5)
end

function mod(a,n,d)
-- a modulo n offset d
    return a - n * flr((a-d)/n)
end


function col(a,b)
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

-->8
-- drawing

function _draw()

	if mode == "game" then
		draw_game()
	elseif mode == "start" then
		draw_start()
	elseif mode == "over" then
		draw_over()
	end

end

function draw_start()
	cls(0)

	print("shmup 1", 20,40, 2)
	print("press any button to start", 15,60, 5)
end

function draw_over()
	cls(2)

	print("game over", 20,40, 6)
	print("press action button to start again", 15,60, 5)
end

function draw_game()
	cls(0)

	draw_asteroids()
	starfield()

	if invul <= 0 then
		draw_obj(ship)
		spr(flr(ship.flame), ship.x+ship.spx+2, ship.y+ship.spy+10)
	else
		if sin(t/10) < -0.2 then
			draw_obj(ship)
			spr(ship.flame, ship.x, ship.y)
		end
	end

	draw_array(enemies)

	draw_array(bullets)

	if draw_hitbox then
		draw_hitb()
	end
	
	if muzzle_flash > 0 then
		circfill(ship.x + ship.spx+5,ship.y+ship.spy-2, muzzle_flash, 9)
	end

	-- draw particles
	for p in all(particles) do
		circfill(p.x, p.y, p.size, p.color)
	end
	for s in all(shocks) do
		circ(s.x, s.y, s.size, 7)
		s.size += s.rate
		s.age += 1 
		if s.age >= s.maxage then
			del(shocks, s)
		end
	end
	
	for imp in all(impacts) do
		if imp.age <3 then
			oval(imp.x,imp.y, imp.x1, imp.y1, 9)
		elseif imp.age < 4 then
			oval(imp.x,imp.y, imp.x1, imp.y1, 9)
			oval(imp.x-1,imp.y-1, imp.x1+1, imp.y1-1, 10)
		else
			oval(imp.x-1,imp.y-1, imp.x1+1, imp.y1-1, 10)
		end
	end
	
	for sp in all(sparks) do
		pset(sp.x,sp.y,7)
		sp.x +=sp.sx
		sp.y +=sp.sy
		sp.age += 1
		if sp.age >= sp.maxage then
			del(sparks,sp)
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

function draw_hitb()
	draw_hb(ship)
	for en in all(enemies) do
		draw_hb(en)
	end
	for b in all(bullets) do
		draw_hb(b)	
	end
end




-->8
function animate_stars()
	for star in all(stars) do
		star.y = (star.y + star.speed) % 127
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
    if ship.y > 120 then
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
		for en in all(enemies) do
			if col(bullet,en) then				
				en.hp -=1
				local imp = {}
				imp.x = bullet.x
				imp.y = bullet.y
				imp.x1 = imp.x + 5
				imp.y1 = imp.y + 2
				imp.age = 0
				add(impacts, imp) 
				
				local p = {}
				p.x = bullet.x
				p.y = bullet.y
				p.sx = rnd(3) - 1.5 
				p.sy = rnd(3) - 3
				p.age = 0
				p.maxage = rnd(30)
				add(sparks,p)
				
				if en.hp <=0 then
					del(enemies,en)
					explode(en.x,en.y)
					score += 1
					sfx(1)
					sfx(2)
					sfx(3)
				end
				del(bullets, bullet)				
			end
		end
	end
	for imp in all(impacts) do
		imp.age += 1
		if imp.age > 10 then
			del(impacts, imp)
		end
	end
end

function explode(x,y)
	for i=1,4 do
			add(particles,create_p(x,y))
	end
	for i=1,20 do
		local p = {}
		p.x = x
		p.y = y
		p.sx = rnd(4) - 2 
		p.sy = rnd(4) - 2
		p.age = 0
		p.maxage = 5 + rnd(20)
		add(sparks,p)
	end
	
	local s={}
	s.x = x
	s.y = y 
	s.size = 0
	s.age = 0
	s.maxage = 10 + rnd(20)
	s.rate = 0.5 + rnd(0.5)
	add(shocks, s)
end

function create_p(x, y)
	local p={}
	p.x = x + rnd(10) - 5
	p.y = y + rnd(10) - 5
	p.sx = rnd(1) - 0.5
	p.sy = rnd(1) - 0.5
	p.size = 5 + rnd(10)
	p.rate = 0.3+ rnd(0.5)
	p.age = 0
	p.maxage = 10 + rnd(30)
	p.fission = p.size / 2
	rndc = rnd(2)
	if rndc < 1 then
		p.color = 10		
	else 
		p.color = 9	
	end
	
	return p
end

function update_expl()
	for p in all(particles) do
		p.x += p.sx
		p.y += p.sy
		p.age += 1
		
		local newsize = p.size - p.rate
		if p.fission>=3 and p.size >= p.fission and newsize <= p.fission then
			for i=1,8 do
				local pc = create_p(p.x, p.y)
				pc.size = rnd(p.size)
				pc.rate = 0.1 + rnd(0.4)
				pc.fission = pc.size / 1.5
				pc.color = 5
				add(particles, pc)
			end
		end		
		
		p.size = newsize
		if p.age > p.maxage or p.size < 1 then
			del(particles,p)
		end	
	end
end

__gfx__
00000000000000000000000000000000000000000009000000080000000800000008000088800888888008880000000000000000000000000000000000000000
000000000000000000000000000000000000000000a9a0000a989a000a989a000a888a0080800808888008870000000000000000000000000000000000000000
00700700000220000002200000022000000aa000000a000000a9a0000a989a000a989a0080888808888888770000000000000000000000000000000000000000
00077000000ee000000ee000000ee000000aa000000a0000000a000000a9a00000a9a00080000008888888880000000000000000000000000000000000000000
0007700000cce00000ecce00000ecc0000aaaa000000000000000000000a0000000a000088000088888888880000000000000000000000000000000000000000
007007000011e00000e11e00000e110000aaaa00000000000000000000000000000a000008800880088888800000000000000000000000000000000000000000
0000000000222e002e2222e200e22200aaaaaaaa0000000000000000000000000000000000888800008888000000000000000000000000000000000000000000
00000000002992009029920900299200a0aaaa0a0000000000000000000000000000000000088000000880000000000000000000000000000000000000000000
11100000000000000000000000000000000000000000000000000000000000000000000000077780000000000000000000000000000000000000000000000000
19100000007997000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000
9aa00000079979900000000000000000000000000000000000000000000000000000000007777770077777700000000000000000000000000000000000000000
aa900000099799900000000000000000000000000000000000000000000000000000000077777777770000770000000000000000000000000000000000000000
a9900000097999700000000000000000000000000000000000000000000000000000000077777777700000070000000000000000000000000000000000000000
11100000079997900000000000000000000000000000000000000000000000000000000077777777700000070000000000000000000000000000000000000000
00000000007979000000000000000000000000000000000000000000000000000000000077777777770000770000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000007777770077777700000000000000000000000000000000000000000
0009700000077000000790000555555000000000000000000a000a00000000000000000000000000000000000000000000000000000000000000000000000000
00999700009779000079990053333a35000003333300000003003000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000005a322335000033aaaa33000000355000000000000000000000000000000000000000000000000000000000000000000000000000
00333300003333000033330053222235000d3aaaaaaa33003052e503000000000000000000000000000000000000000000000000000000000000000000000000
0031130000311300003113005322223500d5aaa2222aa3303a522530000000000000000000000000000000000000000000000000000000000000000000000000
003c730000387300003c730053a22335003aaaa2a2aaaa3000355000000000000000000000000000000000000000000000000000000000000000000000000000
033333300333333003333330533333a5003aaaa2222aaa3000a00a00000000000000000000000000000000000000000000000000000000000000000000000000
030000300300003003000030055555500033aaa2222aaa3003000330000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000033d535d95de3000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000003333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000
00155500000000000000000000000000000003d00300033000000000000000000000000000000000000000000000000000000000000000000000000000000000
00155550000000000000000000000000000003000300003000000000000000000000000000000000000000000000000000000000000000000000000000000000
01155557000000000000000000000000000333000300005000000000000000000000000000000000000000000000000000000000000000000000000000000000
0155555600000000000000000000000000dd00000500050000000000000000000000000000000000000000000000000000000000000000000000000000000000
055555550000000000000000000000000d500000d5000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000100000000000009010000000000000001080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00900100800000000001010000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00101710100000000001171000000000000017110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00101710100000000000171000000000000017100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001717100000000000171c1000000000001c1710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01171c1711000000001771c1000000000001c1771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17991c19971000000199911000000000000011999100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01779197710000000017797100000000000179771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00119791100000000001191000000000000019110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001110000000000000111000000000000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011011000000000000101000000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002a750297502775024750207501d7501c7501b7501a7501875009400064000330002300013000130001300003000030000300003000030000300003000000000000000000000000000000000000000000
000100000475003750037500275002750027500175001750017500175001750017500075000750007500075000750007500350003500035000350003500035000350003500035000150000500005000000000000
00010000125501b550265502d550295502755025550245502055020550235502655010550295502c5502d5502d5502c550295502655022550215502255027550295500a5500e55012550125500c5500b55019550
0001000010650106500f6500f6500e6500e6500d6500d6500c6500b6500b6500b6500a6500a6500a6500b6500b6500b6500b6500b6500b6500b6500b6500c6500c6500c6500c6500c6500c6500c6500000000000
