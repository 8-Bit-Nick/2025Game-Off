if (!sprite_exists(sprite_index)) exit;

// scale so visual matches effective radius
var s = (base_radius_px > 0) ? (ef_radius / base_radius_px) : 1;

var prev_alpha = draw_get_alpha();
draw_set_alpha(ef_alpha);   // brighter during Overcharge

draw_sprite_ext(
    sprite_index, image_index,
    x, y,
    s, s,
    0,
    c_white, 1
);

draw_set_alpha(prev_alpha);