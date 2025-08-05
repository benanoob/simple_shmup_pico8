# todo
- [x] fix lag shot button
- [ ] broken asteroid ?
- [x] implement better explosions
- [x] improve basic bullet cause it sux rn
- [ ] fix invul drawing
- [x] give health to ennemies
    - [] add some hit effect
- [ ] vertical UI
- [x] polish hit effect
    - [x] add sparks (ep 16 on shockwaves) / hit + destruction
- [x] make the explosion bigger
- [x] position hit effect properly
- [x] debug draw hitbox mode
- [x] postion hit boxes properly
    - [x] size adjust
    - [x] update collision code
-[ ] integrate new ennemies types
-[ ] quick fix collision between ship and border of screen

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
- color can be as bold as the shot itself
- for laser shot ==> becomes huge/concentrated(bright, even white) at the impact point
- ennemies blink in a colored state, quite bold color again(blue in DOJ)
    - big ennemies have fire sprites spawning on them
- x shape ?

- [x] I need to know the impact bullet ennemy position to place properly my hit effect wrt to the bullet

## I just want a big laser shot mannnn

## moonshot
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