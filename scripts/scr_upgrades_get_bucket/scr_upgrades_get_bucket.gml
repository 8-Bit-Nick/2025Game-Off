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
            "Increase Spotlight damage by +5%. (Common)",
            "Increase Spotlight damage by +10%. (Rare)",
            "Increase Spotlight damage by +20%. (Epic)"
        ]
    });

    //Wide Lens (Radius up)
    array_push(bucket, {
        id: "wl",
        name: "Wider Lens",
        icon: spr_icon_wl,
        tiers: [
            { radius_mul: 1.08 },
            { radius_mul: 1.15 },
            { radius_mul: 1.25 }
        ],
        desc_fmt: [
            "Increase Spotlight radius by +8%. (Common)",
            "Increase Spotlight radius by +15%. (Rare)",
            "Increase Spotlight radius by +25%. (Epic)"
        ]
    });

    //Focused Beam (Crit chance up; ensure crit_mult set elsewhere if missing
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
            "Gain +3% critical chance. (Common)",
            "Gain +6% critical chance. (Rare)",
            "Gain +10% critical chance. (Epic)."
        ]
    });

    // Dazzle (Stronger slow + longer linger)
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
            "Spotlight inflicts a stronger slow (+10%). (Common)",
            "Spotlight inflicts a stronger slow (+15%). (Rare)",
            "Spotlight inflicts a stronger slow (+20%). (Epic)."
        ]
    });

    // Scholar (XP gain multiplier)
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
            "Gain +5% XP from kills. (Common)",
            "Gain +10% XP from kills. (Rare)",
            "Gain +20% XP from kills. (Epic)"
        ]
    });

    // Fresh Coat (Tower max HP up + heal same %)
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
            "Boats Max HP +10% and heal 10%. (Common)",
            "Boats Max HP +20% and heal 20%. (Rare)",
            "Boats Max HP +30% and heal 30%. (Epic)"
        ]
    });


    return bucket;
}
