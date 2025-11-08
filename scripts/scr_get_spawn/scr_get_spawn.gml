
function scr_get_spawn(margin) {
    var m = max(0, margin);

    // Figure out the active view rectangle. If views/cameras aren’t enabled,
    // fall back to the whole room.
    var cam = camera_get_active();
    var vx = 0, vy = 0, vw = room_width, vh = room_height;

    if (cam != -1) {
        vx = camera_get_view_x(cam);
        vy = camera_get_view_y(cam);
        vw = camera_get_view_width(cam);
        vh = camera_get_view_height(cam);
    }

    // Define the "top-half" band in room coordinates
    var top_half_min_y = 0;
    var top_half_max_y = room_height * 0.5;

    var side = irandom(2); // 0 = above top, 1 = left side, 2 = right side

    var sx, sy;

    if (side == 0) {
        // Above the visible top edge
        sx = irandom_range(vx - m, vx + vw + m);
        sy = vy - m; // just above the view
        // Keep it in the room’s top half bounds
        sx = clamp(sx, 0, room_width);
    }
    else if (side == 1) {
        // Left side of the view, but only in top half
        sx = vx - m;
        sy = irandom_range(max(vy - m, top_half_min_y), min(vy + vh + m, top_half_max_y));
    }
    else {
        // Right side of the view, but only in top half
        sx = vx + vw + m;
        sy = irandom_range(max(vy - m, top_half_min_y), min(vy + vh + m, top_half_max_y));
    }

    // Final clamp to room and top-half just in case
    sx = clamp(sx, 0, room_width);
    sy = clamp(sy, top_half_min_y, top_half_max_y);

    return { x: sx, y: sy };
}
