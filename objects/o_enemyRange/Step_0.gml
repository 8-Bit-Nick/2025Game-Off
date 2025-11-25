// Inherit the parent event
event_inherited();
if (stun_timer > 0) {
    stun_timer -= 1;
    image_speed = 0;
    stun_orbit_ang = (stun_orbit_ang + stun_orbit_speed) mod 360;
    if (hp <= 0) {
        scr_xp_add(xp_value);// Set by spawner
        scr_add_Highscore(points);// set by spawner
        instance_destroy();
        instance_create_layer(x, y, "Enemies", o_Enemy_Die)
}
    
exit;
} else {
    image_speed = base_anim_speed;
}
if (variable_global_exists("leveling") && global.leveling){
    exit;
}
// safety
if (!instance_exists(target_boat)) exit;

var bx = target_boat.x;
var by = target_boat.y;
var dist = point_distance(x, y, bx, by);

// range to hover around
var min_range = 180;
var max_range = 220;

// Camera/on-screen check
var cam = view_camera[0];
var vx  = camera_get_view_x(cam);
var vy  = camera_get_view_y(cam);
var vw  = camera_get_view_width(cam);
var vh  = camera_get_view_height(cam);
var margin = 16;

var in_view = (x >= vx - margin) && (x <= vx + vw + margin)
           && (y >= vy - margin) && (y <= vy + vh + margin);

// Grace period before ranged attacks begin
if (engage_delay > 0) engage_delay -= 1;

// We can throw only if grace is over AND we’re visible
var can_throw = (engage_delay <= 0) && in_view;

//Move to maintain the band
if (dist < min_range) {
    // back off
    var away = point_direction(bx, by, x, y);
    var step = min((base_spd*slow_factor) * 0.9, (min_range - dist));
    x += lengthdir_x(step, away);
    y += lengthdir_y(step, away);
} else if (dist > max_range) {
    // approach
    var toward = point_direction(x, y, bx, by);
    var step = min((base_spd*slow_factor) * 0.8, (dist - max_range));
    x += lengthdir_x(step, toward);
    y += lengthdir_y(step, toward);
} else {
    // in the band: no radial move (optional strafe could go here)
}

// Throw cadence
if (throw_timer > 0) {
    throw_timer -= 1;

    // Windup finished? spawn now then start cooldown
    if (throw_timer <= 0 && instance_exists(target_boat)) {

        
        aim_dir = point_direction(x, y, target_boat.x, target_boat.y)
                + irandom_range(-rock_spread, rock_spread);

        // spawn near front tentacle (rotated toward target)
        var sx = x + lengthdir_x(rock_offx, aim_dir) - lengthdir_y(rock_offy, aim_dir);
        var sy = y + lengthdir_y(rock_offx, aim_dir) + lengthdir_x(rock_offy, aim_dir);

        var r = instance_create_layer(sx, sy, "Instances", o_rock);

        with (r) {
            damage  = other.rock_damage;
            gravity = other.rock_gravity;

            // Compute launch from the saved angle on the octopus
            var spd = other.rock_speed;
            hsp = lengthdir_x(spd, other.aim_dir);
            vsp = lengthdir_y(spd, other.aim_dir) - (spd * 1.75); // little upward lob
            speed = 0; // we move via hsp/vsp
        }

        // start cooldown and clear windup so we don't double-throw
        attack_cooldown = attack_rate_frames;
        throw_timer     = 0;
    }

    exit; 
}

// Attack countdown
if (attack_cooldown > 0) {
    attack_cooldown -= 1;
} else if (can_throw) {
    // begin a fresh windup (
    throw_timer = throw_windup_frames;
}