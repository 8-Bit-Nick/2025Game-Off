if (variable_global_exists("leveling") && global.leveling){
    exit;
}
if (variable_global_exists("paused") && global.paused){
    exit;
}
if (!game_over && !(variable_global_exists("leveling") && global.leveling)) {
    global.survive_frames += 1;  // 1 frame per step
}else if (global.paused){
    global.survive_frames += 0;
}


#region Popus

/// Animate Popups

// Update and prune popups
for (var i = array_length(popups) - 1; i >= 0; i--) {
    var p = popups[i];

    // lifetime
    p.ttl -= 1;

    // motion (float upward a bit each frame)
    p.y += p.vy;

    // fade out linearly over its lifespan (assumes ttl started at 60)
    p.alpha = max(0, p.ttl / 60);

    // write back the modified struct
    popups[i] = p;

    // remove if expired
    if (p.ttl <= 0) {
        array_delete(popups, i, 1);
    }
}
#endregion

#region Active Abilities
//Active Abilities
var blocked = (variable_global_exists("leveling") && global.leveling);

// Tick CD's every frame
if (oc_cd > 0){
    oc_cd -=1;
}
if (flare_cd > 0){
    flare_cd -=1;
}

//overcharge
if (oc_active){
    if (oc_time>0){
        oc_time -=1;
    }else {
        //overcharge ended
        oc_active = false;
        oc_cd = oc_cd_max;
    }
}

//Input (Q/W)
if (!blocked) {
    // Q → Overcharge: only if not active and off cd
    if (keyboard_check_pressed(ord("Q"))) {
        if (!oc_active && oc_cd <= 0) {
            oc_active = true;
            oc_time   = oc_time_max;
            // (Effects come in the next steps)
        }
    }

    // W → Lens Flare: instant
    if (keyboard_check_pressed(ord("W"))) {
        if (flare_cd <= 0) {
            flare_cd   = flare_cd_max;
            flare_cast = true;     // one-frame pulse request; we’ll handle it next
            
            var spot = instance_exists(o_Spotlight) ? instance_find(o_Spotlight, 0) : noone;
            if (instance_exists(spot)) {
            with (instance_create_layer(spot.x, spot.y, "Instances", o_fx_LensFlare)) {
                caster      = spot;      // <— store the spotlight instance to read ef_radius LIVE
                mult        = 3.0;       // 3× the current radius
                base_radius = spot.ef_radius; // fallback if caster disappears mid-fx
                
                }
            }
        }
    }
}

// Reset one-frame trigger
if (flare_cast) {
    // Find spotlight and its effective radius (so Overcharge affects pulse size)
    var spot_obj = asset_get_index("o_Spotlight");
    var spot     = (spot_obj != -1 && instance_exists(spot_obj)) ? instance_find(spot_obj, 0) : noone;

    if (instance_exists(spot)) {
        // Pulse center = spotlight/cursor position
        var cx = spot.x;
        var cy = spot.y;

        // Pulse radius = 6× current spotlight effective radius
        var pulse_r = (variable_instance_exists(spot, "ef_radius") ? spot.ef_radius : spot.radius_px) * 3;

        // Stun duration 60= 1s
        var stun_frames = 120;

        // Apply to all enemies within the pulse
        with (o_EnemyParent) {
            if (point_distance(x, y, cx, cy) <= pulse_r) {
                // (Re)apply stun; take the longer if already stunned
                if (!variable_instance_exists(id, "stun_timer")) stun_timer = 0;
                stun_timer = max(stun_timer, stun_frames);
            }
        }
    }

    // Optional: fire a simple VFX/screen flash here (we can add later)
    // Optional: play a whoosh SFX here

    
}
    flare_cast = false;

#endregion

#region Death and game end sequence

if (!instance_exists(o_Boat_Parent)){
    game_over = true;
}
if (game_over=true){
    if (variable_global_exists("run_stats") && is_struct(global.run_stats)){
        global.run_stats.score_final = (variable_global_exists("points") ? global.points: 0);
        global.run_stats.time_frames = (variable_global_exists("survive_frames") ? global.survive_frames: 0);
    }
    
 // High score/time update and persist

var cur_score = (variable_global_exists("points") ? global.points : 0);
var cur_timef = (variable_global_exists("survive_frames") ? global.survive_frames : 0);

//Flag for end screen
global.new_best_score = false;
global.new_best_time = false;

//Compare and update globals
if (cur_score > global.best_score){
    global.best_score = cur_score;
    global.new_best_score = true;
}
if (cur_timef > global.best_time_frames){
    global.best_time_frames = cur_timef;
    global.new_best_time = true;
}

//Update Ini save
ini_open("save.ini");
ini_write_real("Highscores", "Bestscore", global.best_score);
ini_write_real("Highscores", "BestTimeFrames", global.best_time_frames);
ini_close();
    instance_create_layer(0,0,"Instances", o_fade_controller);
}
#endregion
