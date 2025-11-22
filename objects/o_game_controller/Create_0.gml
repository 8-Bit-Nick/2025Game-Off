//Store your target FPS once.

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
global.xp_next   = 30;  // XP needed for next level (grows over time)
global.leveling  = false;  // when true, show upgrade picker & pause 
global.points = 0;


// Purpose: hold and manage temporary UI popups (xp/points near cursor)
popups = [];   // each popup will be a small struct we push here
