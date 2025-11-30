if (room = rm_Main){
    switch (state) {
        case "fade_in":
            alpha = min(1, alpha - fade_speed);
            if (alpha <= 0){
                instance_destroy();
                }
            break;
    }
}
