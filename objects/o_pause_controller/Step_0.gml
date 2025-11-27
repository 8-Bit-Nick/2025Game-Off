if (keyboard_check_pressed(vk_escape)){
    global.paused = !global.paused;
    pause_update()
}
if (global.paused){
    cursor_sprite = spr_Spotlight;
}