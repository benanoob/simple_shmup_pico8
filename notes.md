# todo
- [x] fix lag shot button
- [x] broken asteroid
- [x] implement better explosions
- [x] improve basic bullet cause it sux rn
- [x] fix invul drawing
- [x] give health to ennemies
    - [x] add some hit effect
    - [ ] add blink when ennemy get hit
- [ ] vertical UI
    - [x] ui feedback : I feel health is not legible
    - remaining space on top of the bar for the rest of infos
        - score
        - wave counter
- [x] polish hit effect
    - [x] add sparks (ep 16 on shockwaves) / hit + destruction
- [x] make the explosion bigger
- [x] position hit effect properly
- [x] debug draw hitbox mode
- [x] postion hit boxes properly
    - [x] size adjust
    - [x] update collision code
- [ ] integrate new ennemies types
- [ ] quick fix collision between ship and border of screen
- [x] improve main shot
    - it's too small
- [x] decide on a color palette with lizenn
- [x] get lizenn to design a player shot
- [x] teach lizenn git
- [ ] introduce weapon damage
- [ ] introduce weapon type

# implementation information
## conventions
### sprite positioning
`thing.spx` is the offset in pixel where to draw the sprite

### hitbox
the hitbox always starts at `thing.x` `thing.y`
the size is specified by `thing.xb` `thing.yb`

# visuals
## font
characters are `3x5` pixels

# ideas
- vertical hud
- animate flame for backward and forward motions (longer and shorter)

## explosions
- varied particles in size colors
- big center explosion ball that pops and shrinks ?
- particles spawning smaller particles ?
- particles type based on their speed ?
- shockwave effect (circle)
### DOJ
- 2 phases
    - big yellow blasts (few)
    - after bigs depop multiple orange to yellow blasts
    - fades to grey

## hit effect
- small oval shape where the bullet hits and disappears
    - this is read as a shielding effect and actually could mean big ennemies in doj shield the smaller side shots which could make sense
- color can be as bold as the shot itself
- ennemies blink in a colored state, quite bold color again(blue in DOJ)
    - big ennemies have fire sprites spawning on them
- x shape ?
- [x] I need to know the impact bullet ennemy position to place properly my hit effect wrt to the bullet

## I just want a big laser shot mannnn
- hit effect for laser shot ==> becomes huge/concentrated(bright, even white) at the impact point


## since the bar is the same color as the ennemy could we design a system where you go and collect sth on them ?

## moonshot (next game/out of scope)
### memorable character integration
- get a cool pilot view on screen that is animated and cool
- characters are grabbing us to games

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
- give health to ennemies
- wip hit effect
- have lizenn draw ennemies (3 to 4, varied sizes)
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
    - implement game flow
- in ep14 palette trick to make flash hit impact