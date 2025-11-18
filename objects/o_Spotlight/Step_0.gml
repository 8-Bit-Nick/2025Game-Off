if (variable_global_exists("leveling") && global.leveling){
    exit;
}

// Follow the mouse in ROOM space
x = mouse_x;
y = mouse_y;

// Convert DPS → per-frame damage using your configured FPS
var fps_local = variable_global_exists("FPS") ? max(1, global.FPS) : 60;


spot_radius            = radius_px;                    
dmg_tick               = dps / fps_local;             
blind_linger_frames_i  = round(0.30 * fps_local);      

// Apply damage + blind to enemies inside the spotlight (circle–circle test)
with (o_EnemyParent) {
    // Small default hit radius if this enemy hasn't defined one
    var r_enemy = variable_instance_exists(id, "hit_radius") ? hit_radius : 10;

    // distance^2 to spotlight center (other = oSpotlight)
    var dx = x - other.x;
    var dy = y - other.y;

    // Effective collision radius 
    var r_eff = r_enemy + other.spot_radius;

    // Circle–circle overlap test 
    if (dx*dx + dy*dy <= r_eff * r_eff) {
        if (other.dmg_tick > 0) hp -= other.dmg_tick;              // continuous tick
        hurt_timer  = 3;                                            // brief hit flash
        blind_timer = max(blind_timer, other.blind_linger_frames_i);// slow linger
    }
}
