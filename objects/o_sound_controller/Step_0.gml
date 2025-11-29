// If an intro just finished, start its loop counterpart
if (intro_handle != -1 && !audio_is_playing(intro_handle)) {
    intro_handle = -1;
    if (next_loop_sound != -1) {
        loop_handle = audio_play_sound(next_loop_sound, 1, true);
        audio_sound_gain(loop_handle, master_gain, 0);  // <- apply current volume
        next_loop_sound = -1;
    }
}