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
if (room = rm_Main){
g_tower_pos = {x:400 , y:438};
instance_create_layer(g_tower_pos.x,g_tower_pos.y,"Instances",o_Tower);
}

if (room = rm_Title){
g_tower_pos = {x:400 , y:470};
instance_create_layer(g_tower_pos.x,g_tower_pos.y,"Instances",o_Tower);
}

if (!layer_exists("LightFX")) {
    layer_create(0, "LightFX");
}
//XP / Leveling
global.level     = 1;
global.xp        = 0;
global.xp_next   = 25;  // XP needed for next level 
global.leveling  = false;  // when true, show upgrade picker & pause 
global.points = 0;
global.survive_frames = 0;
global.crit_chance_total = 0;



//Gameover / Summary
if (!variable_global_exists("run_stats") || !is_struct(global.run_stats)) {
    global.run_stats = {
        time_frames: 0, 
        score_final: 0, 
        kills: 0,
        dmg_total: 0,
        hits_total: 0, 
        crit_hits: 0,
        intensity_peak: 0, 
        level_peak: global.level,

        // upgrade mirrors for the end card
        bulb_mult:    1.0,   // Brighter Bulb (DPS total multiplier)
        lens_mult:    1.0,   // Wide Lens (radius total multiplier)
        scholar_mult: 1.0,   // Scholar (XP total multiplier)
        crit_chance_total: 0.0, // total additive crit chance from upgrades (0..1)
        crit_mult: 1.5       // current crit damage multiplier (optional display)
    };
} else {
    if (!variable_struct_exists(global.run_stats, "bulb_mult"))         global.run_stats.bulb_mult = 1.0;
    if (!variable_struct_exists(global.run_stats, "lens_mult"))         global.run_stats.lens_mult = 1.0;
    if (!variable_struct_exists(global.run_stats, "scholar_mult"))      global.run_stats.scholar_mult = 1.0;
    if (!variable_struct_exists(global.run_stats, "crit_chance_total")) global.run_stats.crit_chance_total = 0.0;
    if (!variable_struct_exists(global.run_stats, "crit_mult"))         global.run_stats.crit_mult = 1.5;
}

#endregion
//Game over triggers
game_over   = false;




// XP and Points popups
popups = []; // each popup will be a small struct we push here

#region Active's
//Active Abilities 
ability_fps = 60;

// Overcharge (Q) 
oc_active = false; // true while Overcharge is running
oc_time = 0; // frames remaining while active
oc_time_max = 5 * ability_fps; // s duration
oc_cd = 0; // frames remaining on cooldown
oc_cd_max = 15 * ability_fps;// s cooldown

// Lens Flare (W) 
flare_cd = 0; // frames remaining on cooldown
flare_cd_max = 18 * ability_fps; // s cooldown
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

#region Score/Time saving.
//High score/time persistence
global.best_score = 0;
global.best_time_frames = 0;
global.new_best_score = false;
global.new_best_time  = false;

var save_file = "save.ini";
if(file_exists(save_file)) {
    ini_open(save_file);
    global.best_score = ini_read_real("Highscores", "Bestscore", 0);
    global.best_time_frames = ini_read_real("Highscores", "BestTimeFrames", 0);
    ini_close();
} else{
    //create file with defaults
    ini_open(save_file);
    ini_write_real("Highscores", "BestScore", 0);
    ini_write_real("Highscores", "BestTimeFrames", 0);
    ini_close();
}


#endregion
