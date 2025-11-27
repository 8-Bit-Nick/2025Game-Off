// If an intro just finished, start its loop counterpart
if (intro_handle != -1 && !audio_is_playing(intro_handle)) {
    intro_handle = -1;
    if (next_loop_sound != -1) {
        loop_handle = audio_play_sound(next_loop_sound, 1, true, 0.4); // start the loop
        next_loop_sound = -1;
    }
}