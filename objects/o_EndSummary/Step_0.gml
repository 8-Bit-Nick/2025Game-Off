if (room = rm_GameOver && keyboard_check_pressed(ord("R"))){
    room_goto(rm_Title);
}
if (room = rm_GameOver && keyboard_check_pressed(vk_escape)){
    game_end();
}