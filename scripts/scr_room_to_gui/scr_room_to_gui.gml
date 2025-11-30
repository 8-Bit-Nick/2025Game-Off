function scr_room_to_gui(_x, _y)
{
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam);
    var vy  = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam);
    var vh  = camera_get_view_height(cam);

    var gw  = display_get_gui_width();
    var gh  = display_get_gui_height();

    var gx = ((_x - vx) / max(1, vw)) * gw;
    var gy = ((_y - vy) / max(1, vh)) * gh;
    return { x: gx, y: gy };
}
