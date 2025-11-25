#region Globals


//Converts seconds to frames
global.FPS = max(1, game_get_speed(gamespeed_fps));

//Frame count
if (!variable_global_exists("FRAME")) {
    global.FRAME = 0;
}
// A debug flag you can toggle in code.
global.DEBUG = true;

//Tower Spawn
g_tower_pos = {x:400 , y:438};
instance_create_layer(g_tower_pos.x,g_tower_pos.y,"Instances",o_Tower)

if (!layer_exists("LightFX")) {
    layer_create(0, "LightFX");
}
// === XP / Leveling ===
global.level     = 1;
global.xp        = 0;
global.xp_next   = 35;  // XP needed for next level (grows over time)
global.leveling  = false;  // when true, show upgrade picker & pause 
global.points = 0;

//Gameover / Summary
global.run_stats = {
    // clock & scoring
    time_frames: 0, // we’ll tick this each Step (you already track survive time; we’ll sync later)
    score_final: 0, // snapshot when game_over triggers

    // performance
    kills: 0,  // increment in enemy death
    dmg_total: 0, // add every time spotlight  deals damage
    hits_total: 0, // total damage hits/ticks for crit % calc
    crit_hits: 0,  // increment when a crit occurs
    intensity_peak: 0, // max of difficulty_01 seen this run
    level_peak: 1,  // highest level reached

    // upgrade contributions 
    bulb_mult: 1.0,  // Brighter Bulb cumulative multiplier on DPS
    lens_mult : 1.0,  // Wide Lens cumulative multiplier on radius
    scholar_mult: 1.0  // Scholar cumulative multiplier on XP gain
};
game_over = false;
boats_seen = false;
#endregion

// XP and Points popups
popups = []; // each popup will be a small struct we push here

#region Active's
//Active Abilities 
ability_fps = 60;

// Overcharge (Q) 
oc_active = false; // true while Overcharge is running
oc_time = 0; // frames remaining while active
oc_time_max = 6 * ability_fps; // s duration
oc_cd = 0; // frames remaining on cooldown
oc_cd_max = 15 * ability_fps;// s cooldown

// Lens Flare (W) 
flare_cd = 0; // frames remaining on cooldown
flare_cd_max = 20 * ability_fps; // s cooldown
flare_cast = false; // one-frame trigger
#endregion

#region Ability Bar
spr_tray = asset_get_index(spr_ability_tray); 

// Dimensions
tray_w = (spr_tray != -1) ? sprite_get_width(spr_tray)  : 112;
tray_h = (spr_tray != -1) ? sprite_get_height(spr_tray) : 64;

// timer measurments
tray_top_gap = 12;       
timer_text_h = 24;      

// Slot measurements inside the art
slot_w = 32;
slot_h = 40;
slot_gap = 12; // horizontal space between slots

// Offsets from tray’s top-left to each slot
slot1_offx = 10;     // left padding to first slot
slot1_offy = 16;     // top padding to first slot
slot2_offx = slot1_offx + slot_w + slot_gap;
slot2_offy = slot1_offy;

// ability icons if we get there
//spr_icon_overcharge = asset_get_index("spr_icon_overcharge"); // -1 if not found
//spr_icon_flare      = asset_get_index("spr_icon_flare");      // -1 if not found

// Cooldown overlay color 
tray_cool_col = make_color_rgb(40, 40, 40);


#endregion