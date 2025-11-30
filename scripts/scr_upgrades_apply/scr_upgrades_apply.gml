

function scr_upgrades_apply(_id, _tier)
{
    // Find the upgrade entry by id
    var bucket = scr_upgrades_get_bucket();
    var entry  = undefined;
    for (var i = 0; i < array_length(bucket); i++) {
        if (bucket[i].id == _id) { entry = bucket[i]; break; }
    }
    if (is_undefined(entry)) return false;

    // Clamp tier and get the effect payload 
    var t = clamp(_tier, 0, max(0, array_length(entry.tiers) - 1));
    var eff = entry.tiers[t];

    // Helpers to safely read fields whether eff is a struct or a DS map
    function _has(_s, _name) {
        return is_struct(_s) ? variable_struct_exists(_s, _name)
             : (is_ds_map(_s) ? ds_map_exists(_s, _name) : false);
    }
    function _get(_s, _name, _def) {
        if (is_struct(_s))  return _has(_s, _name) ? variable_struct_get(_s, _name) : _def;
        if (is_ds_map(_s))  return _has(_s, _name) ? ds_map_find_value(_s, _name)   : _def;
        return _def;
    }

    // Key instances / defaults
    var spot  = instance_exists(o_Spotlight) ? instance_find(o_Spotlight, 0) : noone;
    var tower = instance_exists(o_Boat_Parent) ? instance_find(o_Boat_Parent, 0) : noone;

    if (!variable_global_exists("xp_mult"))     global.xp_mult = 1.0;
    if (!variable_global_exists("run_stats"))   global.run_stats = { };

    if (instance_exists(spot)) {
        if (!variable_instance_exists(spot, "ef_crit_chance"))    spot.ef_crit_chance    = 0;
        if (!variable_instance_exists(spot, "crit_mult"))         spot.crit_mult         = 1.6;
        if (!variable_instance_exists(spot, "blind_slow_base"))   spot.blind_slow_base   = 0.80;
        if (!variable_instance_exists(spot, "blind_power_bonus")) spot.blind_power_bonus = 0.0;
        if (!variable_instance_exists(spot, "blind_linger_mult")) spot.blind_linger_mult = 1.0;
    }
    if (instance_exists(tower)) {
        if (!variable_instance_exists(tower, "contact_mult")) tower.contact_mult = 1.0;
        if (!variable_instance_exists(tower, "max_hp"))       tower.max_hp       = 100;
        if (!variable_instance_exists(tower, "hp"))           tower.hp           = tower.max_hp;
    }

    // Volatile Core toggle by ID
        if (entry.id == "volatile_core") {
            global.enemy_explode = true;   // only ever turns ON
            if (is_struct(global.run_stats)) global.run_stats.vol_core = true;
                return true;
    }

    // Generic spotlight stat changes
    if (instance_exists(spot)) {
        var dps_mul     = _get(eff, "dps_mul", 1.0);
        var radius_mul  = _get(eff, "radius_mul", 1.0);
        var crit_add    = _get(eff, "crit_add", 0.0);
        var crit_mult   = _get(eff, "crit_mult", spot.crit_mult);

        var blind_pow   = _get(eff, "blind_power_add", 0.0);
        var blind_ling  = _get(eff, "blind_linger_mul", 1.0);

        // Apply
        if (dps_mul    != 1.0) spot.dps       *= dps_mul;
        if (radius_mul != 1.0) spot.radius_px *= radius_mul;

        if (crit_add   != 0.0) spot.ef_crit_chance = clamp(spot.ef_crit_chance + crit_add, 0, 0.60);
        if (crit_mult  != spot.crit_mult) spot.crit_mult = crit_mult;

        if (blind_pow  != 0.0) spot.blind_power_bonus  = clamp(spot.blind_power_bonus + blind_pow, 0, 0.40);
        if (blind_ling != 1.0) spot.blind_linger_mult *= blind_ling;
    }

    // Global XP multiplier
    var xp_mul = _get(eff, "xp_mul", 1.0);
    if (xp_mul != 1.0) {
        global.xp_mult *= xp_mul;
        if (is_struct(global.run_stats)) {
            if (!variable_struct_exists(global.run_stats, "scholar_mult")) variable_struct_set(global.run_stats, "scholar_mult", 1.0);
            global.run_stats.scholar_mult *= xp_mul;
        }
    }

    // Tower durability / heal 
    if (instance_exists(tower)) {
        var hp_mul   = _get(eff, "tower_hp_mul", 1.0);
        var heal_mul = _get(eff, "tower_heal_mul", 0.0);
        var c_mul    = _get(eff, "contact_mul", 1.0);

        if (hp_mul != 1.0) {
            var old_max = tower.max_hp;
            tower.max_hp = round(tower.max_hp * hp_mul);
            tower.hp = round(tower.hp * (tower.max_hp / max(1, old_max)));
        }
        if (heal_mul != 0.0) {
            tower.hp = min(tower.max_hp, tower.hp + round(tower.max_hp * heal_mul));
        }
        if (c_mul != 1.0) {
            tower.contact_mult *= c_mul;
        }
    }

    // Track DPS/Radius multipliers into run_stats for summary
    if (is_struct(global.run_stats)) {
        if (!_has(global.run_stats, "bulb_mult"))   global.run_stats.bulb_mult   = 1.0;
        if (!_has(global.run_stats, "lens_mult"))   global.run_stats.lens_mult   = 1.0;
        if (!_has(global.run_stats, "crit_chance_total")) global.run_stats.crit_chance_total = 0.0;

        // If this tier provided multipliers, fold them in
        var dps_mul = _get(eff, "dps_mul", 1.0);
        var rad_mul = _get(eff, "radius_mul", 1.0);
        var crit_add = _get(eff, "crit_add", 0.0);

        if (dps_mul != 1.0) global.run_stats.bulb_mult *= dps_mul;
        if (rad_mul != 1.0) global.run_stats.lens_mult *= rad_mul;
        if (crit_add != 0.0) global.run_stats.crit_chance_total += crit_add;
    }

    return true;
}