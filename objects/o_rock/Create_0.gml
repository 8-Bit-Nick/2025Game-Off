
// if spawner set "direction" and "speed", convert to hsp/vsp and clear built-ins
var _spd = (variable_instance_exists(id, "speed"))     ? speed     : 0;
var _dir = (variable_instance_exists(id, "direction")) ? direction : 0;
hsp = lengthdir_x(_spd, _dir);
vsp = (variable_instance_exists(id, "vsp")) ? vsp : -(_spd * 0.0); // initial upward tug
speed = 0;

// spin 
image_xscale = 1.5;
image_yscale = 1.5;
spin_speed = irandom_range(8, 16) * choose(-1, 1); // deg/frame
image_angle = irandom(359);
// lifetime safety 
life_max = 8 * 60; // 6s 
life     = 0;
