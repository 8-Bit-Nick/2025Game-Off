
function scr_get_spawn_2(spawn_pad)
{
    var pad = spawn_pad;

    // Camera (view) rectangle in ROOM space
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam);
    var vy  = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam);
    var vh  = camera_get_view_height(cam);

    // Weighted edge pick without ternary
    var r = random(1);
    var edge; // 0=TOP, 1=LEFT, 2=RIGHT
    if (r < 0.50) {
        edge = 0;
    } else if (r < 0.75) {
        edge = 1;
    } else {
        edge = 2;
    }

    var px, py;

    if (edge == 0) {
        // TOP edge: span whole width (small corner inset)
        var inset = min(64, vw * 0.08);
        px = random_range(vx + inset, vx + vw - inset);
        py = vy - pad;
    }
    else if (edge == 1) {
        // LEFT edge: only top half vertically
        px = vx - pad;
        py = random_range(vy, vy + vh * 0.5);
    }
    else {
        // RIGHT edge: only top half vertically
        px = vx + vw + pad;
        py = random_range(vy, vy + vh * 0.5);
    }

    // Tiny jitter so burst spawns don't stack exactly
    px += random_range(-20 , 20);
    py += random_range(-20, 20);

    return { x: px, y: py };
}