if (instance_exists(o_game_controller) && o_game_controller.game_over) exit;
if (variable_global_exists("leveling") && global.leveling){
    exit;
}
var g_w = display_get_width();
var g_h = display_get_height();




#region Overcharge
//Find Game controller
var gc = instance_exists(o_game_controller) ? instance_find(o_game_controller,0): noone;
var oc_on = (instance_exists(gc) && gc.oc_active);

//Multiplier
var oc_mult = oc_on ? 2 : 1;

//Effective stats
crit_chance = max(crit_chance, global.crit_chance_total);
ef_dps = dps * oc_mult;
ef_crit_chance = clamp(crit_chance * oc_mult,0,1);
ef_radius = radius_px * oc_mult;


ef_alpha = oc_on ? min(1, spotlight_alpha + 0.35) : spotlight_alpha;


#endregion


#region Mouse tracking and damage

// Follow the mouse in ROOM space
var mx = mouse_x;
var my = mouse_y;

var cam = view_camera[0];
var vx  = camera_get_view_x(cam);
var vy  = camera_get_view_y(cam);
var vw  = camera_get_view_width(cam);
var vh  = camera_get_view_height(cam);

// keep the entire light circle on-screen, even when radius changes
var pad = ef_radius; // 

x = clamp(mx, vx + pad, vx + vw - pad);
y = clamp(my, vy + pad, vy + vh - pad);
global.mouse_room_x = x;
global.mouse_room_y = y;

// Convert DPS 
var fps_local = variable_global_exists("FPS") ? max(1, global.FPS) : 60;

spot_radius = ef_radius;                    
dmg_tick = ef_dps / fps_local;             
blind_linger_frames_i = round(0.30 * fps_local);      

// Apply damage + slow to enemies 
with (o_EnemyParent) {
    var dx = x - other.x;
    var dy = y - other.y;

    // ADD THIS:
    var r_enemy = variable_instance_exists(id, "hit_radius") ? hit_radius : 16;

    var r_eff = r_enemy + other.spot_radius;

    if (dx*dx + dy*dy <= r_eff * r_eff) {

        //  Damage tick + crit + run stats
        if (other.dmg_tick > 0) {
            var dmg = other.dmg_tick;
            var did_crit = false;

            // roll crit if spotlight exposes it
            if (variable_instance_exists(other, "ef_crit_chance") && other.ef_crit_chance > 0) {
                if (random(1) < other.ef_crit_chance) {
                    did_crit = true;
                    var mult = (variable_instance_exists(other, "crit_mult") && other.crit_mult > 0) ? other.crit_mult : 1.5;
                    dmg = ceil(dmg * mult);
                }
            }

            // apply damage
            hp -= dmg;

            // update run stats safely (only if the struct exists)
            if (variable_global_exists("run_stats") && is_struct(global.run_stats)) {
                global.run_stats.dmg_total  += dmg;
                global.run_stats.hits_total += 1;
                if (did_crit) global.run_stats.crit_hits += 1;
            }
        }

        // Spotlight feedback (flash the cursor/light)
        if (!variable_instance_exists(other, "hit_flash")) other.hit_flash = 0;
        other.hit_flash = max(other.hit_flash, 6);

        // Enemy feedback (brief hit flash)
        hurt_timer = 10;

        // SLOW: state used by movement (no colour/tint)
        if (!variable_instance_exists(id, "slow_t")) slow_t = 0;
        if (!variable_instance_exists(id, "slow_factor")) slow_factor = 1.0;

        // Keep slow alive while lit; 
        slow_t = max(slow_t, 2);
        slow_factor = min(slow_factor, 0.75);

        // visual tint blind timer
        if (!variable_instance_exists(id, "blind_timer")) blind_timer = 0;
        blind_timer = max(blind_timer, other.blind_linger_frames_i);
    }
}



#endregion

