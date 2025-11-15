frames_per_second = variable_global_exists("FPS") ? max(1, global.FPS) : 60;

// Round length
round_length_seconds = 180; // 3 minutes to start (tweak later)
round_timer_frames  = round_length_seconds * frames_per_second; // counts DOWN

// 3) Basic state machine
state = "running"; 

// 4) Register enemy types (
//    Fields: { obj, base interval (sec), variance (sec), burst_min, burst_max, base_hp, base_spd, base_xp }
enemy_types = [
    // Tank: slower, tougher baseline trickle
    { obj:o_enemyTank,  base:7, variance:2, burst_min:1, burst_max:2, hp:50, spd:0.33, xp:8 },

    // Fast: quicker cadence, smaller bursts, lower HP but more pressure
    { obj:o_enemyFast,  base:4, variance:1.25, burst_min:1, burst_max:3, hp:30, spd:.5, xp:4 }

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
spawn_margin  = 125; // off-screen distance for spawns
max_on_field  = 80;  // enemy cap
difficulty_01 = 0;   // will go 0 → 1 across the round (computed in Step)


