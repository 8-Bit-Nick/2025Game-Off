// Fade Overlay for Cards

if (state == "fade_in" || state == "show" || state == "fade_out") {
    // Cover the current camera view in ROOM space
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam);
    var vy  = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam);
    var vh  = camera_get_view_height(cam);

    draw_set_alpha(clamp(fade_alpha, 0, 1));
    draw_set_color(c_black);
    draw_rectangle(vx, vy, vx + vw, vy + vh, false);
    draw_set_alpha(1);
}
