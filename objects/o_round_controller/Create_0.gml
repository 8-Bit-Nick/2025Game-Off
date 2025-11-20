frames_per_second = variable_global_exists("FPS") ? max(1, global.FPS) : 60;
/// Toasts: a lightweight list to hold temporary UI popups
toasts = []; 

elapsed_frames = 0;

// Per 10s drip score
frames_per_second = (variable_instance_exists(id,"frames_per_second") && frames_per_second > 0) ? frames_per_second : 60;
time_drip_interval_frames = 30 * frames_per_second;
time_drip_next_frame      = time_drip_interval_frames; // first award at 30s

//Per Time Bonus
next_bonus_minute = 1;
if (!variable_global_exists("points")) global.points = 0;

// 3) Basic state machine
state = "running"; 

// 4) Register enemy types (
//    Fields: { obj, base interval (sec), variance (sec), burst_min, burst_max, base_hp, base_spd, base_xp }
enemy_types = [
    // Tank: slower, tougher baseline trickle
    { obj:o_enemyTank,  base:8.2, variance:.75, burst_min:1, burst_max:2, hp:45, spd:0.22, xp:8, points:10},

    // Fast: quicker cadence, smaller bursts, lower HP but more pressure
    { obj:o_enemyFast,  base:5.25, variance:.85, burst_min:1, burst_max:3, hp:20, spd:.35, xp:5, points:3}

    // Ranged:
];

// 5) Per-type spawn cooldowns (FRAMES), randomized from base ± variance
spawn_cd = array_create(array_length(enemy_types));
for (var i = 0; i < array_length(enemy_types); i++) {
    var t = enemy_types[i];
    var next_seconds = t.base + random_range(-t.variance, t.variance);
    spawn_cd[i] = max(10, round(next_seconds * frames_per_second));
}

// 6) Spawn constraints and difficulty tracker
spawn_margin  = 20; // off-screen distance for spawns
max_on_field  = 120;  // enemy cap
difficulty_01 = 0;   // will go 0 → 1 across the round (computed in Step)


