

/// oLightBeam — Step (instant rotation + length; no smoothing)

if (!instance_exists(tower))     tower     = instance_exists(o_Tower)     ? instance_find(o_Tower, 0)     : noone;
if (!instance_exists(spotlight)) spotlight = instance_exists(o_Spotlight) ? instance_find(o_Spotlight, 0) : noone;
if (!instance_exists(tower) || !instance_exists(spotlight)) exit;

// Anchor to the lighthouse (plus optional offsets on the tower)
x = tower.x;
y = tower.y-125;
if (variable_instance_exists(tower, "anchor_off_x")) x += tower.anchor_off_x;
if (variable_instance_exists(tower, "anchor_off_y")) y += tower.anchor_off_y;

// SNAP rotation directly toward the spotlight (no max turn rate)
cur_dir_deg = point_direction(x, y, spotlight.x, spotlight.y);

// SNAP length directly to spotlight distance (no extend/retract animation)
cur_len_px = point_distance(x, y, spotlight.x-5, spotlight.y);


// 4) Extend/retract the beam length toward the cursor distance
var want_len   = point_distance(x, y, spotlight.x, spotlight.y);
var step_grow  = extend_pps  / fps_local;
var step_shrink= retract_pps / fps_local;

if (cur_len_px < want_len) {
    cur_len_px = min(want_len, cur_len_px + step_grow);
} else if (cur_len_px > want_len) {
    cur_len_px = max(want_len, cur_len_px - step_shrink);
}

