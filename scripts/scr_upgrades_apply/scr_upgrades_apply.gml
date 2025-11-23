

function scr_upgrades_apply(_id, _tier)
{
    // --- 1) Find the upgrade entry by id ---
    var bucket = scr_upgrades_get_bucket();
    var entry  = undefined;
    for (var i = 0; i < array_length(bucket); i++) {
        if (bucket[i].id == _id) { entry = bucket[i]; break; }
    }
    if (is_undefined(entry)) return false;

    // Clamp tier to available range
    var t = clamp(_tier, 0, max(0, array_length(entry.tiers) - 1));
    var eff = entry.tiers[t]; // struct of fields like dps_mul, radius_mul, etc.

    // --- 2) Grab key instances / ensure sensible defaults ---
    var spot  = instance_exists(o_Spotlight) ? instance_find(o_Spotlight, 0) : noone;
    var tower = instance_exists(o_Boat_Parent)     ? instance_find(o_Boat_Parent, 0)     : noone;

    if (!variable_global_exists("xp_mult")) global.xp_mult = 1.0;

    if (instance_exists(spot)) {
        if (!variable_instance_exists(spot, "ef_crit_chance"))          spot.ef_crit_chance = 0;
        if (!variable_instance_exists(spot, "crit_mult"))            spot.crit_mult   = 1.6;
        if (!variable_instance_exists(spot, "burn_mult"))            spot.burn_mult   = 0.0;
        if (!variable_instance_exists(spot, "blind_slow_base"))      spot.blind_slow_base = 0.80; // 20% slow base
        if (!variable_instance_exists(spot, "blind_power_bonus"))    spot.blind_power_bonus = 0.0; // extra slow amount
        if (!variable_instance_exists(spot, "blind_linger_mult"))    spot.blind_linger_mult = 1.0;
    }
    if (instance_exists(tower)) {
        if (!variable_instance_exists(tower, "contact_mult")) tower.contact_mult = 1.0;
        if (!variable_instance_exists(tower, "max_hp"))       tower.max_hp       = 100;
        if (!variable_instance_exists(tower, "hp"))           tower.hp           = tower.max_hp;
    }

    // --- 3) Apply effects based on provided fields (multiplicative where appropriate) ---
    // Spotlight stat changes
    if (instance_exists(spot)) {
        if (variable_instance_exists(eff, "dps_mul"))        spot.dps        *= eff.dps_mul;
        if (variable_instance_exists(eff, "radius_mul"))     spot.radius_px  *= eff.radius_mul;

        if (variable_instance_exists(eff, "crit_add"))       spot.ef_crit_chance = clamp(spot.ef_crit_chance + eff.crit_add, 0, 0.60);
        if (variable_instance_exists(eff, "crit_mult"))      spot.crit_mult   = eff.crit_mult; // keep latest specified

        // Dazzle knobs
        if (variable_instance_exists(eff, "blind_power_add")) spot.blind_power_bonus  = clamp(spot.blind_power_bonus + eff.blind_power_add, 0, 0.40);
        if (variable_instance_exists(eff, "blind_linger_mul")) spot.blind_linger_mult *= eff.blind_linger_mul;

        // Burn (kept for future if you revive Scorch)
        if (variable_instance_exists(eff, "burn_add"))        spot.burn_mult += eff.burn_add;
    }

    // Global XP multiplier
    if (variable_instance_exists(eff, "xp_mul")) {
        global.xp_mult *= eff.xp_mul;
    }

    // Tower durability / heal
    if (instance_exists(tower)) {
        if (variable_instance_exists(eff, "tower_hp_mul")) {
            var old_max = tower.max_hp;
            tower.max_hp = round(tower.max_hp * eff.tower_hp_mul);
            // keep current hp ratio unless a heal field also applies
            tower.hp = round(tower.hp * (tower.max_hp / max(1, old_max)));
        }
        if (variable_instance_exists(eff, "tower_heal_mul")) {
            tower.hp = min(tower.max_hp, tower.hp + round(tower.max_hp * eff.tower_heal_mul));
        }
        if (variable_instance_exists(eff, "contact_mul")) {
            tower.contact_mult *= eff.contact_mul; // e.g., 0.9, 0.8, 0.7
        }
    }

    return true;
}
