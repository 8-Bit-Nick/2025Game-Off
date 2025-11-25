switch (state) {
    case "fade_out":
        alpha = min(1, alpha + fade_speed);
        if (alpha >= 1) {state = "hold"; hold = hold_frames;
            }
        break;
    
    case "hold":
        hold -= 1;
        if (hold <= 0) {
            room_goto(target_room);
            // NOTE: if you want a fade-in in rm_End, make a matching o_FadeFromBlack there
        }
    break;
}
