function scr_popup_from_cursor_xp(){
    // Read amount safely even if no params are declared
    var _amount = (argument_count > 0) ? argument0 : 0;

    // Find controller & cursor
    var gc   = instance_exists(o_game_controller) ? instance_find(o_game_controller, 0) : noone;
    var spot = instance_exists(o_Spotlight)        ? instance_find(o_Spotlight, 0)        : noone;
    if (!instance_exists(gc) || !instance_exists(spot)) return;

    // ROOM → GUI conversion so popup sticks to screen
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam), vy = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam), vh = camera_get_view_height(cam);
    var gw  = display_get_gui_width(),   gh = display_get_gui_height();

    var gui_x = ((spot.x - vx) / vw) * gw;
    var gui_y = ((spot.y - vy) / vh) * gh;

    // Build popup 
    var pop = {
        text:  "+" + string(_amount) + " XP",
        x:     gui_x - 65,
        y:     gui_y + 5,
        ttl:   60,
        vy:   -0.4,
        alpha: 1,
        col:   make_colour_rgb(55, 184, 71)
    };
    array_push(gc.popups, pop);

}