
function scr_diff_from_d01() {
    // Read input from argument0 (safe in all setups)
    var _d = (argument_count > 0) ? argument0 : 0;
    var d  = clamp(_d, 0, 1);

    // Soft non-linear ramps
    var hp_mult_base = 1 + 0.78 * power(d, 1.55);
    var spd_mult_tank = 1 + 0.25 * power(d, 1.4);
    var spd_mult_fast = 1 + 0.37 * power(d, 1.25);
    var xp_mult_base = 1 + 2.25 * d;
    var dmg_mult = 1 + .8 *power(d,1.55)

    // Spawn cadence ramps (lower = faster)
    var cadence_tank = lerp(1.0, 0.65, d);
    var cadence_fast = lerp(1.0, 0.42, d);
    var cadence_range = lerp(1.0, 0.75,d);

    // Burst growth
    var burst_bonus_t  = floor(lerp(0, 1.75, d));
    var burst_bonus_f  = (d >= 0.5) ? 1 : 0;

    return {
        hp_mult: hp_mult_base,
        spd_mult_t: spd_mult_tank,
        spd_mult_f: spd_mult_fast,
        xp_mult: xp_mult_base,
        cadence_tank: cadence_tank,
        cadence_fast: cadence_fast,
        cadence_range: cadence_range,
        burst_tank: burst_bonus_t,
        burst_fast: burst_bonus_f,
        damage_mult: dmg_mult
    };
}
