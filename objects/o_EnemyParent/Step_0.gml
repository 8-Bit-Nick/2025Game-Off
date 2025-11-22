//Level up pause
if (variable_global_exists("leveling") && global.leveling){
    exit;
}
if (!variable_instance_exists(id, "hit_flash")) hit_flash = 0;

// decay the flash timer if active
if (hit_flash > 0) hit_flash -= 1;
    
if (blind_t > 0) blind_t -= 1;
    
//Status - Tick
if (blind_timer > 0){
    blind_timer -= 1;
}
if (hurt_timer > 0){
    hurt_timer -= 1;
}

/// Acquire / maintain a specific boat target
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

//Speed compute
var mult = 1.0
if (blind_timer > 0){
    mult *= 0.75;
}
spd = base_spd * mult;

#region ATTACK AND MOVE

// Move/stop using specific target_boat
if (!instance_exists(target_boat)) exit; // safety

var bx = target_boat.x;
var by = target_boat.y;

// desired facing/motion toward our OWN boat
var dir  = point_direction(x, y, bx, by);
var dist = point_distance(x, y, bx, by);

// make sure the boat exposes a melee radius (fallback if not set on boat)
if (!variable_instance_exists(target_boat, "hit_radius")) target_boat.hit_radius = 16;

// how close we may approach before stopping
var stop_dist = target_boat.hit_radius + enemy_radius + stop_margin_px;

// (optional) export a flag so other code can read it
in_melee_range = (dist <= stop_dist + 1);

// move until the stop ring; don’t overshoot
if (!in_melee_range) {
    var to_cover = dist - stop_dist;
    var step_len = min(base_spd, to_cover);
    x += lengthdir_x(step_len, dir);
    y += lengthdir_y(step_len, dir);
} else {
    if (attack_cooldown > 0) {
    attack_cooldown -= 1;
} else {
    var did_hit = false;
    if (instance_exists(target_boat)) {
    did_hit = scr_tower_take_contact(target_boat, contact_damage);
}
    attack_cooldown = did_hit ? attack_rate_frames : 6;

    // (Optional) tiny hit spark/VFX could be spawned here when did_hit == true
}
}

//Anti Stack
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
    instance_destroy();
    instance_create_layer(x, y, "Enemies", o_Enemy_Die)
}