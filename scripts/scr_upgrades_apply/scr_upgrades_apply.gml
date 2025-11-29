

function scr_upgrades_apply(_id, _tier){
     //Look up the upgrade entry by id
    var bucket = scr_upgrades_get_bucket();
    var entry  = undefined;
    var i_len  = array_length(bucket);
    for (var i = 0; i < i_len; i++) {
        if (bucket[i].id == _id) { entry = bucket[i]; break; }
    }
    if (is_undefined(entry)) return false;

    //Clamp tier and fetch effect struct
    var tiers_len = array_length(entry.tiers);
    if (tiers_len <= 0) return false;
    var t   = clamp(_tier, 0, tiers_len - 1);
    var eff = entry.tiers[t];

    // Ensure globals/structs exist
    if (!variable_global_exists("xp_mult")) global.xp_mult = 1.0;
    if (!variable_global_exists("run_stats") || !is_struct(global.run_stats)) {
        global.run_stats = {
            time_frames: 0, 
            score_final: 0, 
            kills: 0, 
            dmg_total: 0,
            hits_total: 0, 
            crit_hits: 0, 
            intensity_peak: 0, 
            level_peak: 1,
            bulb_mult: 1.0, 
            lens_mult: 1.0, 
            scholar_mult: 1.0
        };
    }

    // Key instances
    var spot  = instance_exists(o_Spotlight)   ? instance_find(o_Spotlight, 0)   : noone;
    var tower = instance_exists(o_Boat_Parent) ? instance_find(o_Boat_Parent, 0) : noone;

    //  Defaults (spotlight)
    if (instance_exists(spot)) {
        if (!variable_instance_exists(spot, "dps"))              spot.dps              = 20;
        if (!variable_instance_exists(spot, "radius_px"))        spot.radius_px        = 20;
        if (!variable_instance_exists(spot, "ef_crit_chance"))   spot.ef_crit_chance   = 0.0;
        if (!variable_instance_exists(spot, "crit_mult"))        spot.crit_mult        = 1.6;
        if (!variable_instance_exists(spot, "blind_slow_base"))  spot.blind_slow_base  = 0.80;
        if (!variable_instance_exists(spot, "blind_power_bonus"))spot.blind_power_bonus= 0.0;
        if (!variable_instance_exists(spot, "blind_linger_mult"))spot.blind_linger_mult= 1.0;
        if (!variable_instance_exists(spot, "burn_mult"))        spot.burn_mult        = 0.0;
    }

    //Defaults (boats/tower proxy)
    if (instance_exists(tower)) {
        if (!variable_instance_exists(tower, "contact_mult")) tower.contact_mult = 1.0;
        if (!variable_instance_exists(tower, "max_hp"))       tower.max_hp       = 100;
        if (!variable_instance_exists(tower, "hp"))           tower.hp           = tower.max_hp;
    }

    // Spotlight: DPS / Radius 
    if (instance_exists(spot)) {
        if (variable_struct_exists(eff, "dps_mul")) {
            spot.dps *= eff.dps_mul;
            global.run_stats.bulb_mult *= eff.dps_mul;
        }
        if (variable_struct_exists(eff, "radius_mul")) {
            spot.radius_px *= eff.radius_mul;
            global.run_stats.lens_mult *= eff.radius_mul;
        }
    }

    // Spotlight: Crit
   var _crit_add = 0.0;

// accept either field name (bucket safety)
if (variable_struct_exists(eff, "crit_add"))         _crit_add += eff.crit_add;
if (variable_struct_exists(eff, "crit_chance_add"))  _crit_add += eff.crit_chance_add;

if (_crit_add != 0) {
    // accumulate a global total
    if (!variable_global_exists("crit_chance_total")) global.crit_chance_total = 0.0;
    global.crit_chance_total = clamp(global.crit_chance_total + _crit_add, 0, 0.60);

    // apply to spotlight if it exists
    if (instance_exists(spot)) {
        if (!variable_instance_exists(spot, "ef_crit_chance")) spot.ef_crit_chance = 0.0;
        spot.ef_crit_chance = global.crit_chance_total;
    }

    // mirror for end screen
    if (variable_global_exists("run_stats") && is_struct(global.run_stats)) {
        global.run_stats.crit_chance_total = global.crit_chance_total;
    }
}

    // Spotlight: Dazzle (slow power / linger)
    if (instance_exists(spot)) {
        if (variable_struct_exists(eff, "blind_power_add")) {
            spot.blind_power_bonus = clamp(spot.blind_power_bonus + eff.blind_power_add, 0, 0.40);
        }
        if (variable_struct_exists(eff, "blind_linger_mul")) {
            spot.blind_linger_mult *= eff.blind_linger_mul;
        }
    }

    // Spotlight: Burn (future)
    if (instance_exists(spot) && variable_struct_exists(eff, "burn_add")) {
        spot.burn_mult += eff.burn_add;
    }

    // Global: Scholar XP multiplier (+ mirror total for summary)
    if (variable_struct_exists(eff, "xp_mul")) {
        if (!variable_global_exists("xp_mult")){
            global.xp_mult = 1.0;}
        global.xp_mult *= eff.xp_mul;
        global.run_stats.scholar_mult = global.xp_mult; //mirror total xp_mp
}

    // Tower/Boats: durability, heal, contact damage scale
    if (instance_exists(tower)) {
        if (variable_struct_exists(eff, "tower_hp_mul")) {
            var prev_max = tower.max_hp;
            tower.max_hp = round(tower.max_hp * eff.tower_hp_mul);
            tower.hp = round(tower.hp * (tower.max_hp / max(1, prev_max))); // preserve ratio
        }
        if (variable_struct_exists(eff, "tower_heal_mul")) {
            tower.hp = min(tower.max_hp, tower.hp + round(tower.max_hp * eff.tower_heal_mul));
        }
        if (variable_struct_exists(eff, "contact_mul")) {
            tower.contact_mult *= eff.contact_mul; // e.g., 0.9 / 0.8 / 0.7
        }
    }

    return true;
}