// Returns an array of upgrade entries. Each entry is a struct:
// { id, name, icon, tiers, desc_fmt }
// Fields:
// id       : short string used internally (e.g., "bb", "wl")
// name     : display title
// icon     : sprite resource for the card icon (use placeholders for now)
// tiers    : array of tier structs. Each tier may define any of:
// { dps_mul, radius_mul, crit_add, crit_mult, blind_power_add, blind_linger_mul,burn_add, xp_mul, tower_hp_mul, tower_heal_mul, contact_mul }
//             (We’ll interpret these when applying the upgrade.)
// - desc_fmt : array of display strings per tier (for the card text)

function scr_upgrades_get_bucket() {
    var bucket = [];

    // Brighter Bulb (DPS up)
    array_push(bucket, {
        id: "bb",
        name: "Brighter Bulb",
        icon: spr_icon_bb, 
        tiers: [
            { dps_mul: 1.05 },
            { dps_mul: 1.10 },
            { dps_mul: 1.20 }
        ],
        desc_fmt: [
            "Increase spotlight damage by +5%.(Common)",
            "Increase spotlight damage by +10%.(Rare)",
            "Increase spotlight damage by +20%.(Epic)"
        ]
    });

    // --- Wide Lens (Radius up) ---
    array_push(bucket, {
        id: "wl",
        name: "Wide Lens",
        icon: spr_icon_wl,
        tiers: [
            { radius_mul: 1.08 },
            { radius_mul: 1.15 },
            { radius_mul: 1.25 }
        ],
        desc_fmt: [
            "Increase spotlight radius by +8%.(Common)",
            "Increase spotlight radius by +15%.(Rare)",
            "Increase spotlight radius by +25%.(Epic)"
        ]
    });

    // --- Focused Beam (Crit chance up; ensure crit_mult set elsewhere if missing) ---
    array_push(bucket, {
        id: "fb",
        name: "Focused Beam",
        icon: spr_icon_fb,
        tiers: [
            { crit_add: 0.03, crit_mult: 1.6 },
            { crit_add: 0.06, crit_mult: 1.6 },
            { crit_add: 0.10, crit_mult: 1.6 }
        ],
        desc_fmt: [
            "Gain +3% critical chance (×1.6).(Common)",
            "Gain +6% critical chance (×1.6).(Rare)",
            "Gain +10% critical chance (×1.6)(Epic)."
        ]
    });

    //// --- Steady Hand (Glass cannon: DPS up, Radius down) ---
    //array_push(bucket, {
        //id: "sh",
        //name: "Steady Hand",
        //icon: spr_icon_sh,
        //tiers: [
            //{ dps_mul: 1.10, radius_mul: 0.95 },
            //{ dps_mul: 1.15, radius_mul: 0.90 },
            //{ dps_mul: 1.20, radius_mul: 0.85 }
        //],
        //desc_fmt: [
            //"+10% damage, −5% radius.",
            //"+15% damage, −10% radius.",
            //"+20% damage, −15% radius."
        //]
    //});

    // --- Dazzle (Stronger slow + longer linger) ---
    array_push(bucket, {
        id: "dz",
        name: "Dazzle",
        icon: spr_icon_dz,
        tiers: [
            { blind_power_add: 0.10, blind_linger_mul: 1.10 }, // base slow 0.80 → 0.70
            { blind_power_add: 0.15, blind_linger_mul: 1.15 }, // → 0.65
            { blind_power_add: 0.20, blind_linger_mul: 1.20 }  // → 0.60
        ],
        desc_fmt: [
            "Light inflicts a stronger slow (+10%) and lingers longer.(Common)",
            "Light inflicts a stronger slow (+15%) and lingers longer.(Rare)",
            "Light inflicts a stronger slow (+20%) and lingers longer(Epic)."
        ]
    });

    // --- Scorch (Burn DoT as % of DPS while lit) ---
    //array_push(bucket, {
        //id: "sc",
        //name: "Scorch",
        //icon: spr_icon_sc,
        //tiers: [
            //{ burn_add: 0.10 },
            //{ burn_add: 0.15 },
            //{ burn_add: 0.22 }
        //],
        //desc_fmt: [
            //"Enemies in the light also burn (+10% of DPS).",
            //"Enemies in the light also burn (+15% of DPS).",
            //"Enemies in the light also burn (+22% of DPS)."
        //]
    //});

    // --- Scholar (XP gain multiplier) ---
    array_push(bucket, {
        id: "sch",
        name: "Scholar",
        icon: spr_icon_sch,
        tiers: [
            { xp_mul: 1.05 },
            { xp_mul: 1.10 },
            { xp_mul: 1.20 }
        ],
        desc_fmt: [
            "Gain +5% XP from kills.(Common)",
            "Gain +10% XP from kills.(Rare)",
            "Gain +20% XP from kills.(Epic)"
        ]
    });

    // --- Fresh Coat (Tower max HP up + heal same %) ---
    array_push(bucket, {
        id: "fc",
        name: "Fresh Coat",
        icon: spr_icon_fc,
        tiers: [
            { tower_hp_mul: 1.10, tower_heal_mul: 0.10 },
            { tower_hp_mul: 1.20, tower_heal_mul: 0.20 },
            { tower_hp_mul: 1.30, tower_heal_mul: 0.30 }
        ],
        desc_fmt: [
            "Tower Max HP +10% and heal 10%.(Common)",
            "Tower Max HP +20% and heal 20%.(Rare)",
            "Tower Max HP +30% and heal 30%.(Epic)"
        ]
    });

    // --- Frosted Glass (reduce collision damage to tower) ---
    //array_push(bucket, {
        //id: "fg",
        //name: "Frosted Glass",
        //icon: spr_icon_fg,
        //tiers: [
            //{ contact_mul: 0.90 },
            //{ contact_mul: 0.80 },
            //{ contact_mul: 0.70 }
        //],
        //desc_fmt: [
            //"Tower takes −10% collision damage.",
            //"Tower takes −20% collision damage.",
            //"Tower takes −30% collision damage."
        //]
    //});

    return bucket;
}
