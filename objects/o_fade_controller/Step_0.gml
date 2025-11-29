if (room = rm_Title){
    switch (state) {
        case "fade_out":
            alpha = min(1, alpha + fade_speed);
            if (alpha >= 1) {state = "hold"; hold = hold_frames;
                }
            break;
        case "hold":
            hold -= 1;
            if (hold <= 0) {
                audio_stop_all();
                room_goto(rm_Main);
            }
            break;
    }
}

if (room = rm_Main){
    switch (state) {
        case "fade_out":
            alpha = min(1, alpha + fade_speed);
            if (alpha >= 1) {state = "hold"; hold = hold_frames;
                }
            break;
        case "hold":
            hold -= 1;
            if (hold <= 0) {
                audio_stop_all();
                room_goto(rm_GameOver);
            }
            break;
    }
}
