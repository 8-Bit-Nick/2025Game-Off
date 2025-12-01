function scr_intensity_scaler(){
    var fps_local = (variable_global_exists("FPS") && global.FPS > 0)
    ? global.FPS : game_get_speed(gamespeed_fps);

// minutes survived this run
var secs   = (variable_global_exists("survive_frames") ? global.survive_frames : 0) / max(1, fps_local);
var mins   = secs / 60;

// Tunable growth: every X minutes ≈ +100% intensity.

var MIN_PER_STEP = 7;     // +100% per Xmin
var growth       = (mins / MIN_PER_STEP) * 1; // scaling speed

return 1.0 + max(0, growth);   // 1.0 = 100%, 2.0 = 200%, no cap

}