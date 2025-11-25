frames_per_second = variable_global_exists("FPS") ? max(1, global.FPS) : 60;
/// Toasts: a lightweight list to hold temporary UI popups
toasts = []; 

elapsed_frames = 0;

// Per 10s drip score
frames_per_second = (variable_instance_exists(id,"frames_per_second") && frames_per_second > 0) ? frames_per_second : 60;
time_drip_interval_frames = 30 * frames_per_second;
time_drip_next_frame = time_drip_interval_frames; // first award at 30s

//Per Time Bonus
next_bonus_minute = 1;
if (!variable_global_exists("points")) global.points = 0;

//Basic state machine
state = "running"; 

// Register enemy types (
//    Fields: { obj, base interval (sec), variance (sec), burst_min, burst_max, base_hp, base_spd, base_xp }
enemy_types = [
    // Tank: slower, tougher baseline trickle
    { obj:o_enemyTank,  base:9.6, variance:1.2, burst_min:1, burst_max:2, hp:48, spd:0.25, xp:9, points:10, contact_damage:8},

    // Fast: quicker cadence, smaller bursts, lower HP but more pressure
    { obj:o_enemyFast,  base:5.68, variance:.85, burst_min:1, burst_max:3, hp:18, spd:.45, xp:6, points:5, contact_damage:5},

    // Ranged: med sped, throws boulder
    { obj:o_enemyRange, base: 7.8, variance:.75, burst_min:1, burst_max:2, hp:28, spd:.32, xp:15, points:15, contact_damage:0}
];

// Per-type spawn cooldowns (FRAMES), randomized from base ± variance
spawn_cd = array_create(array_length(enemy_types));
for (var i = 0; i < array_length(enemy_types); i++) {
    var t = enemy_types[i];
    var next_seconds = t.base + random_range(-t.variance, t.variance);
    spawn_cd[i] = max(10, round(next_seconds * frames_per_second));
}

// Spawn constraints and difficulty tracker
spawn_margin  = 20; // off-screen distance for spawns
max_on_field  = 120; // enemy cap
difficulty_01 = 0; // will go 0 → 1 across the round (computed in Step)


