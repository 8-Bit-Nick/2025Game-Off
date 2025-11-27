if (instance_exists(o_sound_controller) && instance_find(o_sound_controller,0) != id) {
    instance_destroy(); exit;
}
persistent = true;

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
    loop_handle = audio_play_sound(_snd_loop, 1, true,0.2);
}

// Play intro once, then loop forever (for Main)
function music_play_intro_then_loop(_snd_intro, _snd_loop) {
    music_stop_all();
    next_loop_sound = _snd_loop;                     // remember which loop to start later
    intro_handle    = audio_play_sound(_snd_intro, 1, false, 0.2); // play intro ONCE
}
