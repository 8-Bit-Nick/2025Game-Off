if (instance_exists(o_game_controller)&& o_game_controller.game_over) exit;
    
if (variable_global_exists("leveling") && global.leveling){
    exit;
}
if (variable_global_exists("paused") && global.paused){
    exit;
} 

#region Level-Up Pause/resume (Upgrade Picker)
//pause everything if level up happens
if(state == "running" && global.leveling){
    state = "levelup_pause";
    exit;
}
// resume game if player has chosen
if (state == "levelup_pause" && !global.leveling){
    state = "running";
    exit;
}
#endregion

if (state != "running") exit;

if (state == "running") {
    // Count up elapsed time (frames)
    elapsed_frames += 1;
// FPS fallback
    var fps_local = (variable_instance_exists(id, "frames_per_second") && frames_per_second > 0) ? frames_per_second : 60;
    
    //Difficulty
    difficulty_01 = clamp(elapsed_frames / (fps_local * 360), 0, 2);
    // Time-based multipliers for this frame
    var dif = scr_diff_from_d01(difficulty_01);
    //Record intensity for post game stats
    if (variable_global_exists("run_stats") && is_struct(global.run_stats)){
    global.run_stats.intensity_peak = max(global.run_stats.intensity_peak, difficulty_01);
}
    


    // Drip score: +15 points every 30 seconds
    if (elapsed_frames >= time_drip_next_frame) {
        // Catch-up friendly (in case of frame skips): award all missed ticks
        var awards = floor((elapsed_frames - time_drip_next_frame) / time_drip_interval_frames) + 1;
        global.points += 15 * awards;
        time_drip_next_frame += awards * time_drip_interval_frames;
    }

    // Minute milestones: +50 at 1:00, +100 at 2:00, +200 at 3:00, +400 at 4:00, ...
    var minutes_elapsed = floor(elapsed_frames / (fps_local * 60));
    while (next_bonus_minute <= minutes_elapsed) {
        var award = 50 * power(2, next_bonus_minute - 1);
        global.points += award;
        next_bonus_minute += 1;
    }


// Dont Spawn if over Limit
if (instance_number(o_EnemyParent) >= max_on_field) exit;

#region Tanky Enemy
// Tank CdFs
spawn_cd[0] -= 1;

// Tanks Spawn Small Burst
if (spawn_cd[0] <= 0) {
    var T = enemy_types[0];

    // Burst size
    var burst = irandom_range(T.burst_min, T.burst_max + dif.burst_tank);

    for (var k = 0; k < burst; k++) {
        if (instance_number(o_EnemyParent) >= max_on_field) break;

        // Off-screen, top-half spawn point
        var p = scr_get_spawn_boatsafe(22, 22, 96);
        // Create enemy
        var e = instance_create_layer(p.x, p.y, "Enemies", T.obj);

        // --- Apply gentle stat scaling over time --- 
        var hp_scaled  = round(T.hp  * dif.hp_mult);
        var spd_scaled =        T.spd * dif.spd_mult_t;
        var xp_scaled  = round(T.xp  * dif.xp_mult);
        var pt_scaled = round(T.points * (1 + 2.25 *difficulty_01))
        var dmg_scaled = round(T.contact_damage * dif.damage_mult)


        with(e) {
            max_hp   = hp_scaled; hp = max_hp;
            base_spd = spd_scaled;
            xp_value = xp_scaled;
            points = pt_scaled;
            contact_damage = dmg_scaled;
        }
    }

    // next spawn cd
    var next_seconds = T.base + random_range(-T.variance, T.variance);
    spawn_cd[0] = max(10, round(next_seconds * dif.cadence_tank * frames_per_second));
}
    
#endregion
#region Fast Enemy
// Fast Weak Spawn
spawn_cd[1] -= 1;


if (spawn_cd[1] <= 0) {
    var f = enemy_types[1];

    // Smaller bursts early; unlock +1 to the upper bound after mid-round
    var burstf = irandom_range(f.burst_min, f.burst_max + dif.burst_fast);

    for (var k = 0; k < burstf; k++) {
        if (instance_number(o_EnemyParent) >= max_on_field) break;

        // Off-screen, top-half spawn
        var p = scr_get_spawn_boatsafe(22, 22, 96);

        // Spawn
        var e = instance_create_layer(p.x, p.y, "Enemies", f.obj);

        // Gentle scaling over time (fast units emphasize speed more than HP)
        var hp_scaled  = round(f.hp  * dif.hp_mult);
        var spd_scaled = (f.spd * dif.spd_mult_f);
        var xp_scaled  = round(f.xp  * dif.xp_mult);
        var pt_scaled = round(f.points * (1 + 2.25 *difficulty_01));
        var dmg_scaled = round(f.contact_damage * dif.damage_mult);


        with (e) {
            max_hp   = hp_scaled; hp = max_hp;
            base_spd = spd_scaled;
            xp_value = xp_scaled;
            points = pt_scaled;
            contact_damage = dmg_scaled;
        }
    }
        // next spawn cooldown
    var next_seconds = f.base + random_range(-f.variance, f.variance);
    spawn_cd[1] = max(10, round(next_seconds * dif.cadence_fast * frames_per_second));
}
#endregion 
    #region Ranged Enemy
    spawn_cd[2] -= 1;


if (spawn_cd[2] <= 0) {
    var r = enemy_types[2];

    // burst timer
    var burstf = irandom_range(r.burst_min, r.burst_max + dif.burst_fast);

    for (var k = 0; k < burstf; k++) {
        if (instance_number(o_EnemyParent) >= max_on_field) break;

        // Off-screen, top-half spawn
        var p = scr_get_spawn_boatsafe(22, 22, 96);
        // Spawn
        var e = instance_create_layer(p.x, p.y, "Enemies", r.obj);

        // Gentle scaling over time
        var hp_scaled  = round(r.hp  * dif.hp_mult);
        var spd_scaled = (r.spd * dif.spd_mult_f);
        var xp_scaled  = round(r.xp  * dif.xp_mult);
        var pt_scaled = round(r.points * (1 + 3 *difficulty_01));
        var dmg_scaled = round(r.contact_damage * dif.damage_mult);


        with (e) {
            max_hp   = hp_scaled; hp = max_hp;
            base_spd = spd_scaled;
            xp_value = xp_scaled;
            points = pt_scaled;
            contact_damage = dmg_scaled;
        }
    }
        // next spawn cooldown
    var next_seconds = r.base + random_range(-r.variance, r.variance);
    spawn_cd[2] = max(10, round(next_seconds * dif.cadence_range * frames_per_second));
}
    
    #endregion
}

