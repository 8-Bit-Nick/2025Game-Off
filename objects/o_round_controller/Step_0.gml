

// Hard stops
if (instance_exists(o_game_controller) && o_game_controller.game_over) exit;
if (variable_global_exists("leveling") && global.leveling) exit;
if (variable_global_exists("paused")   && global.paused)   exit;

// Level-up pause/resume gates
if (state == "running" && global.leveling) { state = "levelup_pause"; exit; }
if (state == "levelup_pause" && !global.leveling) { state = "running"; exit; }
if (state != "running") exit;

// Run clock
elapsed_frames += 1;
var fps_local = (variable_instance_exists(id,"frames_per_second") && frames_per_second > 0) ? frames_per_second
                                                                                           : 60;

// Intensity scalar (uncapped)
global.intensity_scaler = scr_intensity_scaler();
var I_scalar = max(1.0, global.intensity_scaler); // 1.0 = 100%, 2.0 = 200%, etc.
var I        = max(0, I_scalar - 1.0);            // 0 at 100%, 1 at 200%, 2 at 300%...
var I1       = clamp(I, 0, 1);                    // reuse your 0..1 tuning up to 200%
var extra    = max(0, I - 1);                      // beyond 200%
// Early-game dampener: at 0% intensity, use 50% of the ramp; 
var early_dampen = lerp(0.75, 1.00, clamp(I / 0.7, 0, 1));
// Use softened ramp for all “up to 200%” terms
var I1_soft = (I1 * (early_dampen * 1.2));


difficulty_01 = clamp(elapsed_frames / (fps_local * 360), 0, 2);
var dif = scr_diff_from_d01(difficulty_01);

//  Record intensity peak for end summary
if (variable_global_exists("run_stats") && is_struct(global.run_stats)) {
    global.run_stats.intensity_peak = max(global.run_stats.intensity_peak, I_scalar);
}

// Drip points & minute bonuses 
if (elapsed_frames >= time_drip_next_frame) {
    var awards = floor((elapsed_frames - time_drip_next_frame) / time_drip_interval_frames) + 1;
    var drip_gain =  15 * awards;
    global.points += drip_gain;
    time_drip_next_frame += awards * time_drip_interval_frames;
    var anch = scr_get_tower_anchor();
    scr_popup_from_cursor_points(drip_gain, anch.x, anch.y, make_color_rgb(120,190,255));
}
var minutes_elapsed = floor(elapsed_frames / (fps_local * 60));
while (next_bonus_minute <= minutes_elapsed) {
    var award = 50 * power(2, next_bonus_minute - 1);
    global.points += award;
    next_bonus_minute += 1;
    var anch = scr_get_tower_anchor();
    scr_popup_from_cursor_points(award, anch.x, anch.y, make_color_rgb(120,190,255));
}

// Capacity guard 
var at_cap = (instance_number(o_EnemyParent) >= max_on_field);

// Tick all CDs up front 
spawn_cd[0] -= 1;  // Tank
spawn_cd[1] -= 1;  // Fast
spawn_cd[2] -= 1;  // Ranged

#region TANK 

if (!at_cap && spawn_cd[0] <= 0) {
    var T = enemy_types[0];

    // burst growth capped to 200%; no extra after
    var burst_growth_tank = floor(I1_soft * 2.8); // +0..+2 by 200%
    var burst_t = irandom_range(T.burst_min - .5, T.burst_max + burst_growth_tank);

    for (var k = 0; k < burst_t; k++) {
        if (at_cap) break;
        if (instance_number(o_EnemyParent) >= max_on_field) { at_cap = true; break; }

        var p = scr_get_spawn_boatsafe(22, 22, 96);
        var e = instance_create_layer(p.x, p.y, "Enemies", T.obj);

        // scaling: keep your shapes; allow linear tail beyond 200%
        var hp_scaled  = round(T.hp  * (1 + 0.60 * I1_soft + 0.20 * extra));
        var spd_scaled = T.spd * (1 + 0.2 * I1_soft + 0.1 * extra);
        var xp_scaled  = round(T.xp  * (1 + 0.75 * I1_soft + 0.5 * extra));
        var pt_scaled  = round(T.points * (1 + 2.25 * difficulty_01));
        var dmg_scaled = round(T.contact_damage * dif.damage_mult);

        with (e) {
            max_hp   = hp_scaled; hp = max_hp;
            base_spd = spd_scaled;
            xp_value = xp_scaled;
            points   = pt_scaled;
            contact_damage = dmg_scaled;
        }
    }

    // cooldown: taper to 0.55 by 200%; no faster beyond
    var next_seconds = T.base + random_range(-T.variance, T.variance);
    var cadence      = lerp(1.0, 0.55, I1_soft);
    spawn_cd[0]      = max(10, round(next_seconds * cadence * fps_local));
}
#endregion

#region FAST 

if (!at_cap && spawn_cd[1] <= 0) {
    var F = enemy_types[1];

    // your fast rule: +1 to upper bound past mid-way, capped at 200%
    var burst_growth_fast = (I1_soft >= 0.6) ? 1 : 0;
    var burst_f = irandom_range(F.burst_min-.5, F.burst_max + burst_growth_fast);

    for (var k2 = 0; k2 < burst_f; k2++) {
        if (at_cap) break;
        if (instance_number(o_EnemyParent) >= max_on_field) { at_cap = true; break; }

        var p2 = scr_get_spawn_boatsafe(22, 22, 96);
        var e2 = instance_create_layer(p2.x, p2.y, "Enemies", F.obj);

        var hp_scaled2  = round(F.hp  * (1 + 1.65 * I1_soft + 0.4 * extra));
        var spd_scaled2 = F.spd * (1 + 0.25 * I1_soft + 0.10 * extra);
        var xp_scaled2  = round(F.xp  * (1 + 0.75 * I1_soft + 0.5 * extra));
        var pt_scaled2  = round(F.points * (1 + 2.25 * difficulty_01));
        var dmg_scaled2 = round(F.contact_damage * (dif.damage_mult * 2));

        with (e2) {
            max_hp   = hp_scaled2; hp = max_hp;
            base_spd = spd_scaled2;
            xp_value = xp_scaled2;
            points   = pt_scaled2;
            contact_damage = dmg_scaled2;
        }
    }

    var next_seconds_f = F.base + random_range(-F.variance, F.variance);
    var cadence_f      = lerp(1.0, 0.1, I1_soft);
    spawn_cd[1]        = max(10, round(next_seconds_f * cadence_f * fps_local));
}
#endregion

#region RANGED 

if (!at_cap && spawn_cd[2] <= 0) {
    var R = enemy_types[2];

    var burst_growth_rng = floor(I1_soft * 2.8); // 
    var burst_r = irandom_range(R.burst_min, R.burst_max + burst_growth_rng);

    for (var k3 = 0; k3 < burst_r; k3++) {
        if (at_cap) break;
        if (instance_number(o_EnemyParent) >= max_on_field) { at_cap = true; break; }

        var p3 = scr_get_spawn_boatsafe(22, 22, 96);
        var e3 = instance_create_layer(p3.x, p3.y, "Enemies", R.obj);

        var hp_scaled3  = round(R.hp  * (1 + 1.0 * I1_soft + 0.27 * extra));
        var spd_scaled3 =        R.spd * (1 + 0.22 * I1_soft + 0.15 * extra);
        var xp_scaled3  = round(R.xp  * (1 + 0.75 * I1_soft + 0.5 * extra));
        var pt_scaled3  = round(R.points * (1 + 3.00 * difficulty_01));
        var dmg_scaled3 = round(R.contact_damage * (dif.damage_mult * 1.75));

        with (e3) {
            max_hp   = hp_scaled3; hp = max_hp;
            base_spd = spd_scaled3;
            xp_value = xp_scaled3;
            points   = pt_scaled3;
            contact_damage = dmg_scaled3;
        }
    }

    var next_seconds_r = R.base + random_range(-R.variance, R.variance);
    var cadence_r      = lerp(1.0, 0.55, I1_soft);
    spawn_cd[2]        = max(10, round(next_seconds_r * cadence_r * fps_local));
}

#endregion