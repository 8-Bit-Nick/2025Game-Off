if (room = rm_GameOver && keyboard_check_pressed(ord("R"))){
    game_restart();
}
if (room = rm_GameOver && keyboard_check_pressed(vk_escape)){
    game_end();
}