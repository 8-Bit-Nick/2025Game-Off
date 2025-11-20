if (hurt_timer > 0) {
    draw_self();

    // 2) Additive “flash” on top (very quick & bright)
    draw_set_color(c_fuchsia)
    draw_self();
    draw_set_color(c_white)
} else {
    draw_self();
}

//Hp bar (placeholder)
if (global.DEBUG) {
    var w = 40, h = 3, ratio = clamp(hp / max_hp, 0, 1);
    draw_set_color(make_color_rgb(40,40,40));
    draw_rectangle(x - w/2, y - 12, x + w/2, y - 12 + h, false);
    draw_set_color(make_color_rgb(100,220,100));
    draw_rectangle(x - w/2, y - 12, x - w/2 + w * ratio, y - 12 + h, false);
}