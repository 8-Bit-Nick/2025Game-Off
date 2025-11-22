draw_self();
//
//// draw centered rectangle (placeholder)
//var left   = x - body_w * 0.5;
//var right  = x + body_w * 0.5;
//var top    = y - body_h * 0.5;
//var bottom = y + body_h * 0.5;
//
//// small HP bar above the tower
//var bar_w = body_w + 6;
//var bar_h = 6;
//var bar_x = x - bar_w * 0.5;
//var bar_y = top - 82;
//
//
//var hp_ratio = clamp(hp / max_hp, 0, 1);
//
//// bar background
//draw_set_color(make_color_rgb(40, 40, 40));
//draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
//
//// bar fill
//draw_set_color(make_color_rgb(80,220,90));
//draw_rectangle(bar_x,bar_y, bar_x + bar_w * hp_ratio, bar_y + bar_h,false);