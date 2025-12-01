caster = noone;
base_radius = 55;    // will be overwritten
mult        = 3.0;   // 3x current spotlight radius
// lifetime 
var fps_local = variable_global_exists("FPS") ? max(1, global.FPS) : game_get_speed(gamespeed_fps);
grow_frames = max(1, round(1.25 * fps_local));  // time to reach full size
hold_frames = max(0, round(0.75 * fps_local));  // linger at full size
fade_frames = max(1, round(1.25 * fps_local));  // fade out

life_frames  = (grow_frames + hold_frames + fade_frames);
age = 0;

// look
start_alpha  = 1;   // initial brightness
overshoot    = 0.25;   // expands a bit past 3x before fading
spr_flash = spr_Spotlight;
