frames_per_second = variable_global_exists("FPS") ? max(1, global.FPS) : 60;
/// Toasts: a lightweight list to hold temporary UI popups
toasts = []; 

elapsed_frames = 0;

// Per 10s drip score
frames_per_second = (variable_instance_exists(id,"frames_per_second") && frames_per_second > 0) ? frames_per_second : 60;
time_drip_interval_frames = 30 * frames_per_second;
time_drip_next_frame = time_drip_interval_frames; // first award at 30s
next_bonus_delay = 0;
//Per Time Bonus
next_bonus_minute = 1;
if (!variable_global_exists("points")) global.points = 0;

//Basic state machine
state = "running"; 

// Register enemy types (
//    Fields: { obj, base interval (sec), variance (sec), burst_min, burst_max, base_hp, base_spd, base_xp }
enemy_types = [
    // Tank: slower, tougher baseline trickle
    { obj:o_enemyTank,  base:10.2, variance:.24, burst_min:2, burst_max:3, hp:55, spd:0.25, xp:18, points:20, contact_damage:14},

    // Fast: quicker cadence, smaller bursts, lower HP but more pressure
    { obj:o_enemyFast,  base:4.2, variance:.22, burst_min:2, burst_max:4, hp:20, spd:.5, xp:6, points:10, contact_damage:5},

    // Ranged: med sped, throws boulder
    { obj:o_enemyRange, base: 8.5, variance:.4, burst_min:1, burst_max:3, hp:35, spd:.33, xp:12, points:15, contact_damage:10}
];

// Per-type spawn cooldowns (FRAMES), randomized from base ± variance
spawn_cd = array_create(array_length(enemy_types));
for (var i = 0; i < array_length(enemy_types); i++) {
    var t = enemy_types[i];
    var next_seconds = t.base + random_range(-t.variance, t.variance);
    spawn_cd[i] = max(10, round(next_seconds * frames_per_second));
}

// Spawn constraints and difficulty tracker
spawn_margin  = 18; // off-screen distance for spawns
max_on_field  = 120; // enemy cap
difficulty_01 = 0; // will go 0 → 1 across the round (computed in Step)


