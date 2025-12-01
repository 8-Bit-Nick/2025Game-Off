
// gravity
vsp += gravity;

// move
x += hsp;
y += vsp;

// spin
image_angle += spin_speed;

// compute next position
var nx = x + hsp;
var ny = y + vsp;

// no hit → move and spin
x = nx;
y = ny;
image_angle += spin_speed;


life += 1;
if (life > life_max) instance_destroy();