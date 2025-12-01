x -= 2;
y -= 4;

switch (button_id) {
    // resume
    case 0:
        audio_play_sound(snd_button,1,false,0.4)
        global.paused = false;
        o_pause_controller.pause_update();
        break;
    
    // controls
    case 1:
        audio_play_sound(snd_button,1,false,0.4)
        layer_set_visible("Controls_UI",true)
        break;
    
    // menu /quit
    case 2:
        audio_play_sound(snd_button,1,false,0.4)
        o_pause_controller.paused = false;
        o_pause_controller.pause_update();
        room_goto(rm_Title);
        layer_set_visible("Pause_Menu",false);
        audio_stop_all();
        break;
    
    //quit
    case 3:
        audio_play_sound(snd_button,1,false,0.4)
        game_end();
        break;
    
    //start game
    case 4:
        audio_play_sound(snd_button,1,false,0.4)
        layer_set_visible("Title_UI",false);
        scr_run_reset_stats();
        instance_create_layer(x,y,"Instances",o_fade_controller)
        break;
    
    //back
    case 5:
        audio_play_sound(snd_button,1,false,0.4)
        layer_set_visible("Controls_UI",false);
        break;
	
}