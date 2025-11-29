// Phase split
var a = age, phase, t;
if (a < grow_frames) { phase = 0; t = a / max(1, grow_frames); }
else if (a < grow_frames + hold_frames) { phase = 1; t = 1; }
else { phase = 2; t = (a - (grow_frames + hold_frames)) / max(1, fade_frames); }

// Easing
function ease_out_cubic(_t){ var u=1-_t; return 1 - u*u*u; }
function ease_out_quad(_t){ return 1 - (1 - _t)*(1 - _t); }

// Read current spotlight radius live
var cur_base = (instance_exists(caster) && variable_instance_exists(caster, "ef_radius"))
             ? caster.ef_radius
             : base_radius;

// Target radius at full size 
var r_target = cur_base * mult;

// Compute scale + alpha per phase
var scale_fac, alpha_fac;
if (phase == 0) { // grow
    var e = ease_out_cubic(t);
    scale_fac = (r_target / max(1, cur_base)) * (1.0 + overshoot * e);
    alpha_fac = lerp(0.0, start_alpha, e);
} else if (phase == 1) { // hold
    scale_fac = (r_target / max(1, cur_base)) * (1.0 + overshoot);
    alpha_fac = start_alpha;
} else { // fade
    var e = 1.0 - ease_out_quad(t);
    scale_fac = (r_target / max(1, cur_base)) * (1.0 + overshoot * e);
    alpha_fac = start_alpha * e;
}

// Convert to sprite scale: diameter = 2*radius
var r_vis  = cur_base * scale_fac;
var baseD  = max(1, sprite_get_width(spr_flash)); // assuming square
var spr_s  = (2.25 * r_vis) / baseD;


var a_prev = draw_get_alpha(); draw_set_alpha(alpha_fac);

// Soft disc flash at cursor
draw_sprite_ext(spr_flash, 0, x, y, spr_s*1.05, spr_s*1.05, 0, c_white, 1);

// extra ring
draw_set_alpha(alpha_fac * 0.75);
draw_circle_colour(x, y, r_vis, c_white, c_white, false);

draw_set_alpha(a_prev);
