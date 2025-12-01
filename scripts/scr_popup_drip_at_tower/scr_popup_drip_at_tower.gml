function scr_popup_drip_at_tower(_amount, _is_minute)
{
    // Find a room-space anchor
    var ax, ay;

    // Find tower
    if (instance_exists(o_Tower)) {
        var lh = instance_find(o_Tower, 0);
        ax = lh.x ;
        ay = lh.y - 155; // a bit above the lamp
    } else {
        // Fallback: top-center of current camera view (room space)
        var cam = view_camera[0];
        var vx  = camera_get_view_x(cam);
        var vy  = camera_get_view_y(cam);
        var vw  = camera_get_view_width(cam);
        ax = vx + vw * 0.5;
        ay = vy + 48;
    }

    // Convert to GUI space
    var g = scr_room_to_gui(ax, ay);

    // Color & text
    var col = _is_minute ? make_color_rgb(80, 220, 255) : make_color_rgb(120, 190, 255);
    var txt = "+ " + string(_amount) + "  Survival Bonus";

    //  Push popup 
    scr_popup_push_gui(g.x + random_range(-25,25), g.y + random_range(-25,25), txt, col, 60, -0.5);
}