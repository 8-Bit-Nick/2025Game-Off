function scr_get_spawn_boatsafe(){
    var _margin_top    = (argument_count > 0) ? max(1, argument0) : 12;
    var _margin_side   = (argument_count > 1) ? max(1, argument1) : 12;
    var _min_boat_dist = (argument_count > 2) ? argument2        : 96;

    // recent-spawn separation 
    static _recent = [];           // array of {x,y}
    static _recent_max = 130;        // remember last few spawns across bursts
    var _min_sep_recent = 225;      // minimum distance from recent points

    // View (room space)
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam);
    var vy  = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam);
    var vh  = camera_get_view_height(cam);

    var top_third_y2 = vy + (vh / 3);

    var boat_obj = asset_get_index("o_Boat_Parent");

    var tries = 100;  // a bit more generous for spread
    var bestx = vx;  // fallback seeds
    var besty = vy;

    for (var t = 0; t < tries; t++) {
        // 0 = TOP (above), 1 = LEFT (just beyond), 2 = RIGHT (just beyond)
        var band = irandom(2);

        var px, py;

        if (band == 0) {
            // TOP: across the width; a few px above top edge
            px = random_range(vx, vx + vw);
            py = vy - random_range(1, _margin_top);
        } else if (band == 1) {
            // LEFT: just beyond left edge; y restricted to top third
            px = vx - random_range(1, _margin_side);
            py = random_range(vy, top_third_y2);
        } else {
            // RIGHT: just beyond right edge; y restricted to top third
            px = vx + vw + random_range(1, _margin_side);
            py = random_range(vy, top_third_y2);
        }

        // Boat distance check 
        var ok = true;
        if (boat_obj != -1) {
            var n = instance_number(boat_obj);
            for (var i = 0; i < n; i++) {
                var b = instance_find(boat_obj, i);
                if (instance_exists(b)) {
                    if (point_distance(px, py, b.x, b.y) < _min_boat_dist) {
                        ok = false; break;
                    }
                }
            }
        }

        // recent-spawn separation check (avoid clustering within bursts)
        if (ok) {
            var rlen = array_length(_recent);
            for (var j = 0; j < rlen; j++) {
                var q = _recent[j];
                if (point_distance(px, py, q.x, q.y) < _min_sep_recent) {
                    ok = false; break;
                }
            }
        }

        if (ok) {
            // remember this point for subsequent spawns
            array_push(_recent, { x: px, y: py });
            if (array_length(_recent) > _recent_max) array_delete(_recent, 0, 1);
            return { x: px, y: py };
        }

        bestx = px; besty = py;
    }

    // Fallback: slight jitter so we don't return an identical spot
    bestx += irandom_range(-46, 46);
    besty += irandom_range(-46, 46);

    // remember fallback too
    array_push(_recent, { x: bestx, y: besty });
    if (array_length(_recent) > _recent_max) array_delete(_recent, 0, 1);

    return { x: bestx, y: besty };
}