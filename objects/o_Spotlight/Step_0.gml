if (variable_global_exists("leveling") && global.leveling){
    exit;
}
#region Overcharge
//Find Game controller
var gc = instance_exists(o_game_controller) ? instance_find(o_game_controller,0): noone;
var oc_on = (instance_exists(gc) && gc.oc_active);

//Multiplier
var oc_mult = oc_on ? 2 : 1;

//Effective stats
ef_dps = dps * oc_mult;
ef_crit_chance = clamp(crit_chance * oc_mult,0,1);
ef_radius = radius_px * oc_mult;


ef_alpha = oc_on ? min(1, spotlight_alpha + 0.35) : spotlight_alpha;


#endregion


#region Mouse tracking and damage

// Follow the mouse in ROOM space
x = mouse_x;
y = mouse_y;

// Convert DPS 
var fps_local = variable_global_exists("FPS") ? max(1, global.FPS) : 60;


spot_radius = ef_radius;                    
dmg_tick = ef_dps / fps_local;             
blind_linger_frames_i = round(0.30 * fps_local);      

// Apply damage + blind to enemies inside the spotlight (circle–circle test)
with (o_EnemyParent) {
    // Small default hit radius if this enemy hasn't defined one
    var r_enemy = variable_instance_exists(id, "hit_radius") ? hit_radius : 10;

    // distance^2 to spotlight center (other = oSpotlight)
    var dx = x - other.x;
    var dy = y - other.y;

    // Effective collision radius 
    var r_eff = r_enemy + other.spot_radius;

    // Circle–circle overlap 
    if (dx*dx + dy*dy <= r_eff * r_eff) {
        if (other.dmg_tick > 0) {
            hp -= other.dmg_tick; // continuous tick
            blind_t = max(blind_timer,2)
        }
        if (!variable_instance_exists(other, "hit_flash")) other.hit_flash = 0;
        other.hit_flash = max(other.hit_flash, 6);
        hurt_timer  = 10;// brief hit flash
        blind_timer = max(blind_t, other.blind_linger_frames_i);// slow linger
    }
}
#endregion

