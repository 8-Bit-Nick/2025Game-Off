function scr_intensity_scaler(){
    var fps_local = (variable_global_exists("FPS") && global.FPS > 0)
    ? global.FPS : game_get_speed(gamespeed_fps);

// minutes survived this run
var secs   = (variable_global_exists("survive_frames") ? global.survive_frames : 0) / max(1, fps_local);
var mins   = secs / 60;

// Tunable growth: every X minutes ≈ +100% intensity.
// If you previously reached 200% around 3:00, keep 3.0 and add *1.10 for +10% faster.
var MIN_PER_STEP = 3.50;     // +100% per 3 minutes (baseline)
var growth       = (mins / MIN_PER_STEP) * 1.10; // +faster scaling

return 1.0 + max(0, growth);   // 1.0 = 100%, 2.0 = 200%, no cap

}