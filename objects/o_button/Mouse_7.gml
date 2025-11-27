switch (button_id) {
    // resume
    case 0:
        o_pause_controller.paused = false;
        o_pause_controller.pause_update();
        break;
    
    // controls
    case 1:
        layer_set_visible("Controls_UI",true)
        break;
    
    // menu /quit
    case 2:
        o_pause_controller.paused = false;
        o_pause_controller.pause_update();
        room_goto(rm_Title);
        layer_set_visible("Pause_Menu",false);
        audio_stop_all();
        break;
    
    //quit
    case 3:
        game_end();
        break;
    
    //start game
    case 4:
        room_goto(rm_Main);
        layer_set_visible("Title_UI",false);
        break;
    
    //back
    case 5:
        layer_set_visible("Controls_UI",false);
        break;
	
}