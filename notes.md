# todo
- [ ] have movement defined by a timer rather than speed to guarantee you know the enemy will arrive at some point ?
    - check if traditional shmup have enemy movement speed consistency or not
    -  better for timeline anticipation
- [ ] add big laser hitbox with higher damage at start
- [ ] fix hit impact stop animating on wave screen
- [ ] manage player ship states with a state machine
    - [ ] lock main shot when laser
- [ ] on hit blink of ship should be palette swap instead of disappearing
- [ ] implement player tracking pop corn (kamikaze)

## polish
- [ ] animate flame for backward and forward motions (longer and shorter) ?
- [ ] flame tweak ?
    - https://saint11.art/img/pixel-tutorials/RocketTrail.gif
- improve ship animation
    - we probably shouldn’t de full bank turn, doesnt look that good
- [ ] program particles for ship engine
- [ ] improve muzzle flash
    - see lizenn proposal, I can maybe program sth similar with a bunch of shrinking ovals
    - could add some particle
- [ ] fix big ass laser start
- [ ] laser end when not hitting an enemy

## probably not ?
- ~~reduce ship speed when laser ??~~
    - may be incompatible with a meter/resource gated laser, let’s keep this simple

## done
- [x] awkward flame on turns
    - [x] awkmard ship on turns (linked)
- [x] fix asteroid init (not drawn rn)
- [x] bigger particle for laser impact
- [x] add a parameter for explosion size linked to enemy size
- [x] popcorn bullet sprite
- [x] design 1 major enemy pattern
- [x] manage fire state evolution in time
- [x] delay shot is attached to the whole enemy, pb for different file rates/patterns on one enemy
- [x] add enemy bullet collisions
- [x] use only one frame for enemy bullet (use symmetries)
- [x] normalize diagonal ship speed
- [x] fix order of drawing for the elements (ui on top, etc...)
- [x] implement ui skin
- [x] 2 frames turn animation for the ship
    - [x] in game implementation
- [x] change hit impact
- [x] recheck hitbox matching
- [x] update ship sprite
- [x] laser meter system
- [x] introduce weapon damage
- [x] win screen
    - button lockout to avoid skipping it
- [x] quick fix collision between ship and border of screen
- [x] laser shot v1
- [x] fix lag shot button
- [x] broken asteroid
- [x] implement better explosions
- [x] improve basic bullet cause it sux rn
- [x] fix invul drawing
- [x] give health to enemies
    - [x] add some hit effect
    - [x] add blink when enemy get hit
- [x] polish hit effect
    - [x] add sparks (ep 16 on shockwaves) / hit + destruction
- [x] make the explosion bigger
- [x] position hit effect properly
- [x] debug draw hitbox mode
- [x] postion hit boxes properly
    - [x] size adjust
    - [x] update collision code
- [x] improve main shot
    - it's too small
- [x] decide on a color palette with lizenn
- [x] get lizenn to design a player shot
- [x] teach lizenn git
- [x] make enemy sprite shake when they get hit
- [x] fix diagonal movement of the ship
    - https://www.youtube.com/watch?v=oBjZ1W50brM&list=PLea8cjCua_P1o-xiQRf_QzqS2pMVlGnse&index=5
- [x] laser improvements
    - [x] build up in size
    - [x] stop on enemies
    - [x] concentrated laser at origin
        - [x] and end
    - [x] particle effect to give movement to the chunk of the laser
        - did an animated moving sprite column
    - tested lizenn ring laser and spiral, doesnt work in our technical limits
    - [x] particles/sprite at begining and end
- [x] load enemy sequence
    - [x] then sort it wrt to timer entry
- [x] vertical UI
    - [x] ui feedback : I feel health is not legible
    - remaining space on top of the bar for the rest of infos
        - score
        - wave counter
    - [x] implement ui prototype (functionnal)
- [x] conceive enemy management system
    - first draft done
    - [ ] ~~ease the spawn of a formation of enemy maybe ?~~
    - to be improved after enemies attacks
    - [x] enemy types system
    - [x] fix system
        - each state routine is responsible for state transition, time is local to a state and not local
- [x] prevent enemies from dying off screen where I spawn them
    - despawn player bullet offscreen (check if it’s already done ?)
- [x] delete enemy bullets offscreen

# game design
## play area
- x start at 26 pixel (end of gui)
- ship movement blocked at 25

# implementation information
## conventions
### sprite positioning
`thing.sprx` is the offset in pixel where to draw the sprite

### hitbox
the hitbox always starts at `thing.x` `thing.y`
the size is specified by `thing.xb` `thing.yb`

# visuals
## font
characters are `3x5` pixels

# ideas
- vertical hud DONE

## enemy system
- spawn 2 enemy type multiple time
- information for position idea from A.
    - give an array of offsets from 1 enemy to the next
- enemy type should contain
    - hp
    - attack type
    - movement speed
###
- one update function per enemy type for their shot and movement if necessary
- store speed in enemy type

## enemy design
- snail shape shot for a boss ?
- to create emerging bullet patterns with openings appearing and disappearing we can play on
    - spawn positions of the bullets
    - funky trajectories
    - **varied bullet speeds between rounds of fire !**

### wave shaped shot shot concept
```lua
fire_prop.x_spawn = fire_prop.radius * cos(fire_prop.thet_bul)
fire_prop.y_spawn = fire_prop.radius * sin(fire_prop.thet_bul)

prop.thet_bul += prop.thet_speed
if prop.thet_bul >= 1 then
    prop.thet_speed *= -1
end
if prop.thet_bul <= 0.5 then
    prop.thet_speed *= -1
end
prop.x_spawn = prop.radius * cos(prop.thet_bul)
prop.y_spawn = prop.radius * sin(prop.thet_bul)
```

## explosions DONE
- varied particles in size colors
- big center explosion ball that pops and shrinks ?
- [x] particles spawning smaller particles
- particles type based on their speed
- shockwave effect (circle)
### DOJ
- 2 phases
    - big yellow blasts (few)
    - after bigs depop multiple orange to yellow blasts
    - fades to grey

## hit effect DONE
- small oval shape where the bullet hits and disappears
    - this is read as a shielding effect and actually could mean big enemies in doj shield the smaller side shots which could make sense
- color can be as bold as the shot itself
- enemies blink in a colored state, quite bold color again(blue in DOJ)
    - big enemies have fire sprites spawning on them
- x shape ?
- [x] I need to know the impact bullet enemy position to place properly my hit effect wrt to the bullet

## I just want a big laser shot mannnn
- hit effect for laser shot ==> becomes huge/concentrated(bright, even white) at the impact point DONE

## since the bar is the same color as the enemy could we design a system where you go and collect sth on them ?

## moonshot (next game/out of scope)
### memorable character integration
- get a cool pilot view on screen that is animated and cool
- characters are grabbing us to games

# concepts
## easing function to smooth out movement (variable evolution)
- `x+=(x-target_x)/n`
    - some number n (2 is fast)
    - this does not attain the exact target
    - snap them in position when they get close !

# Resources
- debug print method and helper with better output: https://www.lexaloffle.com/bbs/?tid=42367
- easing functions : https://www.lexaloffle.com/bbs/?tid=40577


# log
## 31/07/2025
- implem lizenn sprite
- use custom color palette
## 01/08/2025
- watch lazy shmup ep 15 better explosions
## 02/08/2025
- shot lag fixed
## 03/08/2025
- finish explosions + shockwave
## 04/08/2025
- give health to enemies
- wip hit effect
- have lizenn draw enemies (3 to 4, varied sizes)
- improve sfx
## 05/08/2025
- fix hitbox
- fix sprite draw positions
- fix and improve explosions
## 16/08/2025
- migrate code out of pico8
- study ui from lizenn
- take ui and palette decisions w/ Lizenn
- rework bullet system and improve it
- shmup tutorial ep17
- in ep14 palette trick to make flash hit impact
## 17/08/2025
- implement hit impact
- implement game flow
    - wave management
    - win screen
- [x] send pico8 to lizenn
- implement new palette
## 18/08/2025
- v1 laser
- fix hitboxes
## 19/08/2025
- laser update
## 21/08/2025
- laser height animation adjustment
- proto laser meter
- proto ui
## 22/08/2025
- shmup tutorial ep 18
    - enemy types
- shmup tutorial ep 19/20
    - skipped most of it cause already done or my enemies needs are more complex
- think about enemy design on paper
## 23/08/2025
- shmup tutorial ep 21 on enemy movement
## 26/08/2025
- still working on enemy spawn system
    - specify speed of enemy instead of arrival timer for moves
## 27/08/2205
- finish lerp implementation
## 07/09/2025
- enemy shake
- uncover movement problem with float speed (diagonal normalization !)
## 27/09/2025
## 28/09/2025
- fix diagonal cobblestoning problem and normalize diagonal ship speed
## 01/10/2025
- work on enemy system
## 11/10/2025
- continue enemy canon update functions
- implement base of enemy fire system
- implement a big enemy
## 12/10/2025
- separate state update with execution to allow changing fire state mid movement/hold
## 22/10/2025
## 07/11/2025
## 17/11/2025
## 14/12/2025
- fix enenmy sequencing system
- animate enemy bullets
- add enemy bullets collisions
## 15/12/2025
- draw frames start laser
- implementation
## 19/12/2025
- add hit sparks for laser
- 2 basic enemies, one non shooting one shooting at players rapidly
- draw in between frame ship turn
- state machine is still broken, think of fix
- add separate timeline for fire
## 21/12/2025
- rewrite all sprite drawing and animation
- state machine fixed
## 24/12/2025
- fix draw order
- start implementing proper ui elements
## 25/12/2025
- implement ui
- fix enemy movement computation for subsequent move order
- study doj patterns
    - importance of bullet speed to break up clusters shot very packed in time
    - use time to split bullets or create nice walls of course
    - shoot interesting shapes (V for instance) from different places at the player, they will break up nicely
    - canon position that shoots the pattern can create a distinct challenge
    - make canon rotate
    - TODO: implement code by canon, not sure how to generalize more at this point, will see after a few enemy implemented
## 26/12/2025
    - start implementing new fire system
    - design new turn animation ship
    - todo
        - [ ] check if bullets 8x8 need 1 x offset when flipped to maintain position
        - [x] ship definitely needs this offset for the cockpit to stay in position
## 28/12/2025
- fix animation