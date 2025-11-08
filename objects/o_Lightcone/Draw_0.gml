// Draw the cone only if effect is visible
if (!visible_fx) exit;

// Compute the two edge angles and their endpoints
var a1 = dir - half_angle;
var a2 = dir + half_angle;

var x1 = x + lengthdir_x(length, a1);
var y1 = y + lengthdir_y(length, a1);
var x2 = x + lengthdir_x(length, a2);
var y2 = y + lengthdir_y(length, a2);

// Draw a soft translucent triangle as the light cone
draw_set_alpha(0.12);
draw_set_color(c_white);
draw_triangle_color(x, y, x1, y1, x2, y2, c_white, c_white, c_white, false);
draw_set_alpha(1);

draw_set_alpha(0.04);
draw_set_color(c_white);
draw_triangle_color(x, y, x1, y1, x2, y2, c_yellow, c_yellow, c_yellow, false);
draw_set_alpha(1);
