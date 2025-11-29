#region Parent paste inherit was having small bugs
if (instance_exists(o_game_controller) && o_game_controller.game_over) exit;
just_attacked = false;
//Level up pause
if (variable_global_exists("leveling") && global.leveling){
    exit;
}
if (variable_global_exists("paused") && global.paused){
    exit;
}
if (!variable_instance_exists(id, "hit_flash")) hit_flash = 0;

// decay the flash timer if active
if (hit_flash > 0){
    hit_flash -= 1;
}
if (blind_t > 0){
    blind_t -= 1;
}
//Status - Tick
if (blind_timer > 0){
    blind_timer -= 1;
}
if (hurt_timer > 0){
    hurt_timer -= 1;
}
if (slow_t > 0){
    slow_t -= 1;
} else{
    slow_factor = 1.0;
}
// Acquire / maintain a specific boat target
var boat_parent_obj = asset_get_index("o_Boat_Parent"); // adjust if your boat parent name differs
if (boat_parent_obj == -1 || !instance_exists(boat_parent_obj)) exit; // no boats = nothing to chase

// tick down re-target cooldown
if (retarget_cd > 0) retarget_cd -= 1;

// (Re)acquire if we have none, our target died, or cooldown allows a refresh
if (target_boat == noone || !instance_exists(target_boat) || retarget_cd <= 0) {
    var nearest = instance_nearest(x, y, boat_parent_obj);
    if (instance_exists(nearest)) {
        target_boat = nearest;
        retarget_cd = retarget_cooldown_frames; // lock this choice briefly
    }
}


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


#region ATTACK AND MOVE


// Move/stop using specific target_boat
if (!instance_exists(target_boat)) exit; // safety

// Default 
in_melee_range = false;

// Only do the melee approach/attack if NOT a ranged AI
//if (!variable_instance_exists(id, "ranged_ai") || !ranged_ai)  {

    var bx = target_boat.x;
    var by = target_boat.y;

    // desired facing/motion toward our OWN boat
    var dir  = point_direction(x, y, bx, by);
    var dist = point_distance(x, y, bx, by);

    // make sure the boat exposes a melee radius (fallback if not set on boat)
    if (!variable_instance_exists(target_boat, "hit_radius")) target_boat.hit_radius = 16;

    // how close we may approach before stopping
    var stop_dist = target_boat.hit_radius + enemy_radius + stop_margin_px;

    //  export a flag so other code can read it
    in_melee_range = (dist <= stop_dist + 3);

    // move until the stop ring; don’t overshoot
    if (!in_melee_range) {
        var to_cover = dist - stop_dist;
        var step_len = min(base_spd* slow_factor, to_cover);
        x += lengthdir_x(step_len, dir);
        y += lengthdir_y(step_len, dir);
    } else {
        if (attack_cooldown > 0) {
            attack_cooldown -= 1;
        } else {
            var did_hit = false;
            if (instance_exists(target_boat)) {
                // use boat-specific contact
                did_hit = scr_tower_take_contact(target_boat, contact_damage);
            }
            attack_cooldown = did_hit ? attack_rate_frames : 12;

            // one-frame “hit landed” flag
            if (did_hit) just_attacked = true;
        }
    }
if (ranged_ai){
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
#endregion
}
//}

// Anti Stack
var sep_radius = max(12, enemy_radius * 2);   // neighbors closer than this will repel slightly
push_x = 0;
push_y = 0;

// Accumulate tiny pushes away from close neighbors
with (o_EnemyParent) {
    if (id != other.id) {
        var d = point_distance(x, y, other.x, other.y);
        if (d > 0 && d < sep_radius) {
            // Strength scales with how much they overlap (closer = stronger)
            var f   = (sep_radius - d) / sep_radius;            // 0..1
            var ang = point_direction(x, y, other.x, other.y);  // from neighbor -> me
            other.push_x += lengthdir_x(f, ang);
            other.push_y += lengthdir_y(f, ang);
        }
    }
}

// Apply a clamped, very small nudge so we don't break pathing
var max_push = 0.8; // px/frame; small so it just “unclumps”
x += clamp(push_x, -max_push, max_push);
y += clamp(push_y, -max_push, max_push);





#endregion

if (hurt_timer > 0) hurt_timer -=1;
    
if (hp <= 0) {
    scr_xp_add(xp_value);// Set by spawner
    scr_add_Highscore(points);// set by spawner
    if (variable_global_exists("run_stats") && is_struct(global.run_stats)){
        global.run_stats.kills +=1;
    }
    instance_destroy();
    instance_create_layer(x, y, "Enemies", o_Enemy_Die)
    audio_play_sound(snd_enemy_death,10,false,.13,undefined,2)
}

#endregion

#region Ranged only

//// range to hover around
//var min_range = 180;
//var max_range = 220;
//
//// Camera/on-screen check
//var cam = view_camera[0];
//var vx  = camera_get_view_x(cam);
//var vy  = camera_get_view_y(cam);
//var vw  = camera_get_view_width(cam);
//var vh  = camera_get_view_height(cam);
//var margin = 16;
//
//var in_view = (x >= vx - margin) && (x <= vx + vw + margin)
           //&& (y >= vy - margin) && (y <= vy + vh + margin);
//
//// Grace period before ranged attacks begin
//if (engage_delay > 0) engage_delay -= 1;
//
//// We can throw only if grace is over AND we’re visible
//var can_throw = (engage_delay <= 0) && in_view;
//
////Move to maintain the band
//if (dist < min_range) {
    //var away = point_direction(bx, by, x, y);
    //var step = min((base_spd*slow_factor) * 0.9, (min_range - dist));
    //x += lengthdir_x(step, away);
    //y += lengthdir_y(step, away);
//} else if (dist > max_range) {
    //// approach
    //var toward = point_direction(x, y, bx, by);
    //var step = min((base_spd*slow_factor) * 0.8, (dist - max_range));
    //x += lengthdir_x(step, toward);
    //y += lengthdir_y(step, toward);
//} else {
    //// in the band: no radial move (optional strafe could go here)
//}
//
//// Throw cadence
//if (throw_timer > 0) {
    //throw_timer -= 1;
//
    //// Windup finished? spawn now then start cooldown
    //if (throw_timer <= 0 && instance_exists(target_boat)) {
//
        //
        //aim_dir = point_direction(x, y, target_boat.x, target_boat.y)
                //+ irandom_range(-rock_spread, rock_spread);
//
        //// spawn near front tentacle (rotated toward target)
        //var sx = x + lengthdir_x(rock_offx, aim_dir) - lengthdir_y(rock_offy, aim_dir);
        //var sy = y + lengthdir_y(rock_offx, aim_dir) + lengthdir_x(rock_offy, aim_dir);
//
        //var r = instance_create_layer(sx, sy, "Instances", o_rock);
//
        //with (r) {
            //damage  = other.rock_damage;
            //gravity = other.rock_gravity;
//
            //// Compute launch from the saved angle on the octopus
            //var spd = other.rock_speed;
            //hsp = lengthdir_x(spd, other.aim_dir);
            //vsp = lengthdir_y(spd, other.aim_dir) - (spd * 1.75); // little upward lob
            //speed = 0; // we move via hsp/vsp
        //}
//
        //// start cooldown and clear windup so we don't double-throw
        //attack_cooldown = attack_rate_frames;
        //throw_timer     = 0;
    //}
//
    //exit; 
//}
//
//// Attack countdown
//if (attack_cooldown > 0) {
    //attack_cooldown -= 1;
//} else if (can_throw) {
    //// begin a fresh windup (
    //throw_timer = throw_windup_frames;
//}
#endregion