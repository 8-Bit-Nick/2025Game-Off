function scr_run_reset(){
    global.level    = 1;
    global.xp       = 0;
    global.xp_next  = 30;
    global.leveling = false;

// XP multiplier 
    global.xp_mult  = 1.0;

// Survival/score counters (if you use these)
    global.survive_frames = 0;
    global.points         = 0;  

/// Run stats struct (displayed on end card)
if (!variable_global_exists("run_stats") || !is_struct(global.run_stats)) {
    global.run_stats = {};
}
with (global.run_stats) {
    // core counters
    dmg_total   = 0;
    hits_total  = 0;
    crit_hits   = 0;
    kills       = 0;

    // peaks & snapshots
    intensity_peak = 0;
    level_peak     = global.level; // 1

    // end snapshots
    score_final = 0;
    time_frames = 0;

    // upgrade mirrors (these are what the end card reads)
    bulb_mult       = 1.0;  // Brighter Bulb mult
    lens_mult       = 1.0;  // Wide Lens mult
    scholar_mult    = 1.0;  // Scholar mult
    crit_chance_total = 0.0; // chance from upgrades
}

/// --- Spotlight base stats (so upgrades start fresh) ---
    if (instance_exists(o_Spotlight)) with (o_Spotlight) {
    // Use *your* base fields here:
    if (variable_instance_exists(id, "base_dps"))           dps           = base_dps;
    if (variable_instance_exists(id, "base_radius_px"))     radius_px     = base_radius_px;
    if (variable_instance_exists(id, "base_crit_chance"))   crit_chance   = base_crit_chance;

    // Common misc reset
    ef_crit_chance       = 0;
    crit_mult            = 1.6;
    blind_power_bonus    = 0.0;
    blind_linger_mult    = 1.0;
    hit_flash            = 0;
    }
}