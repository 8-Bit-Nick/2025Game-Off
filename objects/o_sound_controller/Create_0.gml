if (instance_exists(o_sound_controller) && instance_find(o_sound_controller,0) != id) {
    instance_destroy(); exit;
}
persistent = true;
// Master volume 
master_gain = 0.2;  // start quieter than 1.0

/// Apply gain to any currently playing handles (with optional fade seconds)
function _apply_gain(_gain, _fade_sec) {
    if (audio_is_playing(intro_handle)) audio_sound_gain(intro_handle, _gain, _fade_sec);
    if (audio_is_playing(loop_handle))  audio_sound_gain(loop_handle,  _gain, _fade_sec);
}

/// Public: set music volume, 0..1 (optional fade seconds)
function music_set_volume(_gain, _fade_sec) {
    master_gain = clamp(_gain, 0, 1);
    _apply_gain(master_gain, max(0, _fade_sec));
}



// handles
intro_handle = -1;
loop_handle  = -1;
next_loop_sound = -1;  // sound asset to start after intro ends

// simple API
function music_stop_all() {
    if (audio_is_playing(intro_handle)) audio_stop_sound(intro_handle);
    if (audio_is_playing(loop_handle))  audio_stop_sound(loop_handle);
    intro_handle = -1; loop_handle = -1;
}
// Play a single looping track (for Title / GameOver)
function music_play_loop(_snd_loop) {
    music_stop_all();
    loop_handle = audio_play_sound(_snd_loop, 1, true);
    audio_sound_gain(loop_handle, master_gain, 0);
}

// Play intro once, then loop forever (for Main)
function music_play_intro_then_loop(_snd_intro, _snd_loop) {
    music_stop_all();
    next_loop_sound = _snd_loop;
    intro_handle    = audio_play_sound(_snd_intro, 1, false);
    audio_sound_gain(intro_handle, master_gain, 0);
    if (ev_room_end){
        audio_stop_all();
    }
}
