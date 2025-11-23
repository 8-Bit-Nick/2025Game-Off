function scr_get_spawn_boatsafe(){
     // Read args safely
    var _margin        = (argument_count > 0) ? argument0 : 48;   // off-screen padding
    var _min_boat_dist = (argument_count > 1) ? argument1 : 96;   // keep clear of boats
    var _top_bias      = (argument_count > 2) ? clamp(argument2, 0, 1) : 0.6;

    // Current camera / view
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam);
    var vy  = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam);
    var vh  = camera_get_view_height(cam);

    // Boat parent asset 
    var boat_parent = asset_get_index("o_Boat_Parent");

    // Helper: pick a candidate in one of 3 strips (
    function _pick_candidate() {
        var band; // 0=top, 1=left, 2=right
        if (random(1) < _top_bias) {
            band = 0;
        } else {
            band = choose(1, 2);
        }

        var cx, cy;

        if (band == 0) {
            // OP strip (bias toward top-center horizontally)
            // 70% chance: pick within the middle 40% of the view width; else anywhere
            if (random(1) < 0.7) {
                var mid  = vx + vw * 0.5;
                var half = vw * 0.20; // middle 40%
                cx = random_range(mid - half, mid + half);
            } else {
                cx = random_range(vx - _margin, vx + vw + _margin);
            }
            cy = vy - _margin - random(_margin); // off-screen above the view
        }
        else if (band == 1) {
            // LEFT strip
            cx = vx - _margin - random(_margin);
            // Prefer upper half vertically (avoid beach bottom)
            cy = random_range(vy - _margin, vy + vh * 0.6);
        }
        else {
            // RIGHT strip 
            cx = vx + vw + random(_margin);
            cy = random_range(vy - _margin, vy + vh * 0.6);
        }

        return { x: cx, y: cy };
    }

    // Validate distance from boats
    function _valid_pos(_pt) {
        if (boat_parent == -1 || !instance_exists(boat_parent)) return true;
        with (boat_parent) {
            if (point_distance(other._pt.x, other._pt.y, x, y) < _min_boat_dist) {
                return false;
            }
        }
        return true;
    }

    // Try multiple times to find a valid point
    var best = _pick_candidate();
    var tries = 24;
    for (var i = 0; i < tries; i++) {
        var pt = _pick_candidate();
        if (_valid_pos(pt)) return pt;
        // remember a candidate anyway, in case all fail
        best = pt;
    }
    return best; // fallback

}