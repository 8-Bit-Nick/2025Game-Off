
var saved_alpha = draw_get_alpha();
var saved_col   = draw_get_colour();

// Backdrop
draw_set_alpha(0.85);
draw_set_colour(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
draw_set_colour(c_black);

// Draw the 9-slice panel centered
if (sprite_exists(spr_end_panel)) {
    var sx = panel_w / sprite_get_width(spr_end_panel);
    var sy = panel_h / sprite_get_height(spr_end_panel);
    draw_sprite_ext(spr_end_panel, 0, panel_x, panel_y, sx, sy, 0, c_white, 1);
} else {
    draw_set_colour(make_color_rgb(24, 44, 52));
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
    draw_set_colour(c_white);
}
//borders for sprite
border_l = 10;
border_r = 10;
border_t = 10;
border_b = 10;
// Compute an inner “safe” rect inside the teal border + our padding
var inner_x = panel_x + pad + border_l;
var inner_y = panel_y + pad + border_t;
var inner_w = panel_w - (pad * 2) - (border_l + border_r);
var inner_h = panel_h - (pad * 2) - (border_t + border_b);

// Choose font and set colours
if (summary_font != -1) draw_set_font(summary_font);
draw_set_colour(c_black);

// Pull run stats safely
var rs = (variable_global_exists("run_stats") && is_struct(global.run_stats)) ? global.run_stats : noone;

// Time format
var frames_per_sec = max(1, game_get_speed(gamespeed_fps));
var frames_total   = (rs != noone) ? rs.time_frames : 0;
var secs_total     = floor(frames_total / frames_per_sec);
var mins_part      = secs_total div 60;
var secs_part      = secs_total mod 60;
var time_txt       = string_format(mins_part, 2, 0) + ":" + string_format(secs_part, 2, 0);

// Other values
var score_txt     = (rs != noone) ? string(rs.score_final) : "0";
var kills_txt     = (rs != noone) ? string(rs.kills)       : "0";
var intensity_pct = (rs != noone) ? round(clamp(rs.intensity_peak, 0, 1) * 100) : 0;
var level_peak    = (rs != noone) ? rs.level_peak : 1;
var dmg_total     = (rs != noone) ? rs.dmg_total  : 0;

// Crit %
var crit_pct = 0;
if (rs != noone && rs.hits_total > 0) crit_pct = round((rs.crit_hits / rs.hits_total) * 100);

// Upgrade contribution %
var bulb_pct    = (rs != noone) ? round(max(0, (rs.bulb_mult    - 1.0) * 100)) : 0;
var lens_pct    = (rs != noone) ? round(max(0, (rs.lens_mult    - 1.0) * 100)) : 0;
var scholar_pct = (rs != noone) ? round(max(0, (rs.scholar_mult - 1.0) * 100)) : 0;

// Text layout inside inner rect
var tpos_x  = inner_x + 8;
var tpos_y  = inner_y + 6;
var value_x = inner_x + inner_w - 8;  // right-aligned values

// Helper to draw one label/value row
function _row(_label, _value) {
    draw_set_halign(fa_left);
    draw_text(tpos_x, tpos_y, _label);
    draw_set_halign(fa_right);
    draw_text(value_x, tpos_y, _value);
    tpos_y += lineh;
}

// Title
draw_set_halign(fa_left);
draw_text(tpos_x, tpos_y, "Run Summary");
tpos_y += lineh + title_gap;

// Stats (left labels, right values)
_row("Time Survived:",     time_txt);
_row("Total Score:",       score_txt);
_row("Enemies Defeated:",  kills_txt);
_row("Peak Intensity:",    string(intensity_pct) + "%");
_row("Highest Level:",     string(level_peak));
_row("Total Damage Done:", string(dmg_total));

tpos_y += 6;
draw_set_halign(fa_left);
draw_text(tpos_x, tpos_y, "Bonuses:");
tpos_y += lineh;

_row("Crit Chance:",           string(crit_pct) + "%");
_row("Brighter Bulb (+DPS):",  string(bulb_pct) + "%");
_row("Wide Lens (+Radius):",   string(lens_pct) + "%");
_row("Scholar (+XP):",         string(scholar_pct) + "%");

// Footer (hint)
draw_set_halign(fa_left);
draw_set_colour(make_color_rgb(70, 90, 110));
draw_text(panel_x + pad, panel_y + panel_h - pad - lineh, "Press R to Retry  |  Esc to Menu");

// Restore state
draw_set_alpha(saved_alpha);
draw_set_colour(saved_col);