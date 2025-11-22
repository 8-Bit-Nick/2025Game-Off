//Flash-hit timer
if (!variable_instance_exists(id,"hit_flash")){
    hit_flash = 0;
}
if(hit_flash > 0){
    hit_flash -= 1;
}

if (hurt_timer > 0) {
    draw_self();

    // 2) Additive “flash” on top (very quick & bright)
    gpu_set_blendmode(bm_add)
    draw_self();
    gpu_set_blendmode(bm_normal)
} else {
    draw_self();
}
if (blind_t > 0) {
    var t = blind_t / 2.0; // 0..1 (since we set 2 frames and refresh while lit)
    var blue_col = make_colour_rgb(252, 255, 106);
    
    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.35 * t);
    draw_sprite_ext(
        sprite_index, image_index,
        x, y,
        image_xscale, image_yscale, image_angle,
        blue_col, 1
    );
    draw_set_alpha(1);
    gpu_set_blendmode(bm_normal);
}
//Hp bar (placeholder)
if (global.DEBUG) {
    var w = 34, h = 4, ratio = clamp(hp / max_hp, 0, 1);
    draw_set_color(make_color_rgb(40,40,40));
    draw_rectangle(x - w/2, y - 12, x + w/2, y - 12 + h, false);
    draw_set_color(make_color_rgb(100,220,100));
    draw_rectangle(x - w/2, y - 12, x - w/2 + w * ratio, y - 12 + h, false);
}