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

// Countdown the round (in frames)
if (round_timer_frames > 0) {
    round_timer_frames -= 1;
}

// Compute difficulty from 0 → 1 across the round
var total_frames = round_length_seconds * frames_per_second;
difficulty_01 = 1 - (round_timer_frames / max(1, total_frames)); // 0 at start, 1 at end

// Dont Spawn if over Limit
if (instance_number(o_EnemyParent) >= max_on_field) exit;

#region Tanky Enemy
// Tank CdFs
spawn_cd[0] -= 1;

// Tanks Spawn Small Burst
if (spawn_cd[0] <= 0) {
    var T = enemy_types[0];

    // Burst size
    var burst_growth = floor(difficulty_01 * 1.25); // +0 → +2 by end
    var burst = irandom_range(T.burst_min, T.burst_max + burst_growth);

    for (var k = 0; k < burst; k++) {
        if (instance_number(o_EnemyParent) >= max_on_field) break;

        // Off-screen, top-half spawn point
        var p = scr_get_spawn_2(spawn_margin);

        // Create enemy
        var e = instance_create_layer(p.x, p.y, "Enemies", T.obj);

        // --- Apply gentle stat scaling over time ---
        // HP: up to +% by end
        var hp_scaled  = round(T.hp  * (1 + 0.75 * difficulty_01));
        // SPD: up +% by end
        var spd_scaled =        T.spd * (1 + 0.15 * difficulty_01);
        // XP: up +% by end
        var xp_scaled  = round(T.xp  * (1 + 1.25 * difficulty_01));
        // points: up +% by end
        var pt_scaled = round(T.points * (1 + 2.25 * difficulty_01));

        with (e) {
            max_hp   = hp_scaled; hp = max_hp;
            base_spd = spd_scaled;
            xp_value = xp_scaled;
            points = pt_scaled;
        }
    }

    // Reset tank timer:
    var next_seconds = T.base + random_range(-T.variance, T.variance);
    var cadence_mult = lerp(1.0, 0.6, difficulty_01);
    spawn_cd[0] = max(10, round(next_seconds * cadence_mult * frames_per_second));
}
#endregion
#region Fast Enemy
// Fast Weak Spawn
spawn_cd[1] -= 1;


if (spawn_cd[1] <= 0) {
    var T = enemy_types[1];

    // Smaller bursts early; unlock +1 to the upper bound after mid-round
    var burst_growth = floor(difficulty_01 * 1.25); 
    var burst = irandom_range(T.burst_min, T.burst_max + burst_growth);

    for (var k = 0; k < burst; k++) {
        if (instance_number(o_EnemyParent) >= max_on_field) break;

        // Off-screen, top-half spawn
        var p = scr_get_spawn_2(spawn_margin);

        // Spawn
        var e = instance_create_layer(p.x, p.y, "Enemies", T.obj);

        // Gentle scaling over time (fast units emphasize speed more than HP)
        var hp_scaled  = round(T.hp  * (1 + 0.65 * difficulty_01)); // up to +4% HP
        var spd_scaled =        T.spd * (1 + 0.20 * difficulty_01); // up to +% speed
        var xp_scaled  = round(T.xp  * (1 + 1.25 * difficulty_01)); // up to +% XP
        var pt_scaled = round(T.points * (1 + 2.25 *difficulty_01));

        with (e) {
            max_hp   = hp_scaled; hp = max_hp;
            base_spd = spd_scaled;
            xp_value = xp_scaled;
            points = pt_scaled;
        }
    }
        // Reset the fast timer: base ± variance, then faster cadence over time
    var next_seconds = T.base + random_range(-T.variance, T.variance);
    var cadence_mult = lerp(1, 0.5, difficulty_01); // up % faster by end
    spawn_cd[1] = max(10, round(next_seconds * cadence_mult * frames_per_second));
}
#endregion

// 6) Finish condition: time is up AND no enemies remain
if (round_timer_frames <= 0 && instance_number(o_EnemyParent) == 0) {
    state = "finished";
}
