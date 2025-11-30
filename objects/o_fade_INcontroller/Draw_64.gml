var a0 = draw_get_alpha();
var c0 = draw_get_colour();

draw_set_alpha(alpha);
draw_set_colour(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), true);

draw_set_alpha(a0);
draw_set_colour(c0);
