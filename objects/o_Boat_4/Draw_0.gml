draw_self();
// (hit flash overlay)
draw_self();

if (hit_flash > 0 && sprite_exists(sprite_index)) {
    var t = hit_flash / 8.0; // 0..1 over our 8-frame timer
    var glow_col = make_color_rgb(244, 200, 251); // warm-ish/pink you picked

    gpu_set_blendmode(bm_add);   // additive = visible even over white sprites
    draw_set_alpha(0.7 * t);

    // gentle halo so it “bleeds” around edges
    draw_sprite_ext(
        sprite_index, image_index,
        x, y,
        image_xscale * 1.06, image_yscale * 1.06,
        image_angle,
        glow_col, 1
    );

    draw_set_alpha(1);
    gpu_set_blendmode(bm_normal);
}

// draw centered rectangle (placeholder)
var left   = x - body_w * 0.5;
var right  = x + body_w * 0.5;
var top    = y - body_h * 0.5;
var bottom = y + body_h * 0.5;

// small HP bar above the tower
var bar_w = body_w - 20 ;
var bar_h = 6;
var bar_x = x - bar_w * 0.5;
var bar_y = top + 46;


var hp_ratio = clamp(hp / max_hp, 0, 1);

// bar background
draw_set_color(make_color_rgb(40, 40, 40));
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

// bar fill
draw_set_color(make_color_rgb(80,220,90));
draw_rectangle(bar_x,bar_y, bar_x + bar_w * hp_ratio, bar_y + bar_h,false);