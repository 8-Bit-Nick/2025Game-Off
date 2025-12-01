scr_run_reset_stats();

with (o_sound_controller) music_set_volume(0.40, 0.25);
with (o_sound_controller) music_play_loop(snd_title_loop);
    
//layer_set_visible("Title_UI",true);

cursor_sprite = spr_Spotlight;