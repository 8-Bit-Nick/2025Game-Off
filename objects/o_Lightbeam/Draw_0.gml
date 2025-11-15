if (!instance_exists(tower) || !instance_exists(spotlight)) exit;

// 1) Read animated state from Step
var L = cur_len_px;        // current beam length (pixels)
var a = cur_dir_deg;       // current beam angle (degrees)

// 2) Set widths
var far_w   = spotlight.radius_px * 2 - 5; // far end matches the spotlight diameter
var near_w  = max(2, far_w * 0.5);    // taper near lighthouse % of larger end

// 3) Build trapezoid corners in world space
var dx = lengthdir_x(1, a);
var dy = lengthdir_y(1, a);
var nx = -dy; // perpendicular
var ny =  dx;

var cx0 = x,            cy0 = y;          // near center (tower end)
var cx1 = x + dx * L,   cy1 = y + dy * L; // far center (toward spotlight)

var hw0 = near_w * 0.5;
var hw1 = far_w  * 0.5;

var nlx = cx0 + nx * hw0, nly = cy0 + ny * hw0; // near-left
var nrx = cx0 - nx * hw0, nry = cy0 - ny * hw0; // near-right
var frx = cx1 - nx * hw1, fry = cy1 - ny * hw1; // far-right
var flx = cx1 + nx * hw1, fly = cy1 + ny * hw1; // far-left

// Sprite
draw_sprite_pos(spr_beam, 0, flx, fly, frx, fry, nrx, nry, nlx, nly, beam_alpha);

// Subtle Glow
//gpu_set_blendmode(bm_add);
//draw_sprite_pos(spr_beam, 0, nlx, nly, nrx, nry, frx, fry, flx, fly, beam_alpha * 0.35);
//gpu_set_blendmode(bm_normal);
