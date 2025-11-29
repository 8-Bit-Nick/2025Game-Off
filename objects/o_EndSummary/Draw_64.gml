
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
    draw_sprite_stretched_ext(
        spr_end_panel, 0,
        panel_x, panel_y,          // top-left in GUI space
        panel_w, panel_h,          // exact size
        c_white, 1
    );
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
var mm_str = (mins_part < 10) ? "0" + string(mins_part) : string(mins_part);
var ss_str = (secs_part < 10) ? "0" + string(secs_part) : string(secs_part);
var timer_text = mm_str + ":" + ss_str;

// Other values
var score_txt = (rs != noone) ? string(rs.score_final) : "0";
var kills_txt = (rs != noone) ? string(rs.kills)       : "0";
var intensity_pct = (rs != noone) ? round(rs.intensity_peak * 100) : 0; 
var level_peak  = (rs != noone) ? rs.level_peak : 1;
var dmg_total  = (rs != noone) ? rs.dmg_total  : 0;

var crit_pct = (rs != noone) ? round( rs.crit_chance_total * 100 ) : 0;
var bulb_pct = (rs != noone) ? round( (rs.bulb_mult    - 1.0) * 100 ) : 0;
var lens_pct = (rs != noone) ? round( (rs.lens_mult    - 1.0) * 100 ) : 0;
var scholar_pct = (rs != noone) ? round( (rs.scholar_mult - 1.0) * 100 ) : 0;


// Crit %
if (rs.hits_total > 0) crit_pct = round((rs.crit_hits / rs.hits_total) * 100);

// Upgrade contribution %

// Text layout inside inner rect
var tpos_x = inner_x + 8;
var tpos_y = inner_y + 6;
var value_x = inner_x + inner_w - 8;  // right-aligned values

// Helper to draw one label/value row
function _row_at(_label, _value, _x_label, _y, _x_value) {
    draw_set_halign(fa_left);
    draw_text(_x_label, _y, _label);
    draw_set_halign(fa_right);
    draw_text(_x_value, _y, _value);
    return _y + lineh; // hand back the advanced y
}

// Title
draw_set_font(fnt_card_title_2)
draw_text(tpos_x, tpos_y, "Run Summary: ");
tpos_y += lineh + title_gap;

// Rows (labels left, values right-aligned)
draw_set_font(summary_font)
draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Time Survived: ");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, timer_text);
tpos_y += lineh;

draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Total Score: ");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, score_txt);
tpos_y += lineh;

draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Enemies Defeated: ");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, kills_txt);
tpos_y += lineh;

draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Peak Intensity: ");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, string(intensity_pct) + "%");
tpos_y += lineh;

draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Highest Level :");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, string(level_peak));
tpos_y += lineh;

draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Total Damage Done: ");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, string(dmg_total));
tpos_y += lineh + 6;

//  Subheader 
draw_set_halign(fa_left);
draw_set_font(fnt_card_title_2)
draw_text(tpos_x, tpos_y, "Bonuses From Upgrades: ");
tpos_y += lineh + title_gap;

// Bonus rows 
draw_set_font(summary_font)
draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Crit Chance: ");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, string(crit_pct) + "%");
tpos_y += lineh;

draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Brighter Bulb(+DPS): ");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, string(bulb_pct) + "%");
tpos_y += lineh;

draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Wide Lens(+Radius): ");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, string(lens_pct) + "%");
tpos_y += lineh;

draw_set_halign(fa_left);  draw_text(tpos_x, tpos_y, "Scholar(+XP): ");
draw_set_halign(fa_right); draw_text(value_x, tpos_y, string(scholar_pct) + "%");
tpos_y += lineh;

tpos_y += lineh;


// simple header (optional)
draw_set_font(fnt_card_title_2)
draw_set_halign(fa_left);
draw_text(tpos_x, tpos_y+4, "Records");
tpos_y += lineh;
tpos_y += lineh;

// local formatter for mm:ss from frames
function _fmt_time_local(_frames) {
    var fps_local = (variable_global_exists("FPS") && global.FPS > 0) ? global.FPS : 60;
    var secs = floor(_frames / fps_local);
    var m = secs div 60;
    var s = secs mod 60;

    var mm = (m < 10) ? ("0" + string(m)) : string(m);
    var ss = (s < 10) ? ("0" + string(s)) : string(s);
    return mm + ":" + ss;
}
draw_set_font(fnt_card_title_1)
// pull bests + “new record” flags
var best_pts = (variable_global_exists("best_score")  ? global.best_score : 0);
var best_timef = (variable_global_exists("best_time_frames") ? global.best_time_frames : 0);
var new_pts = (variable_global_exists("new_best_score") ? global.new_best_score : false);
var new_time = (variable_global_exists("new_best_time") ? global.new_best_time : false);

// build row strings
var best_pts_txt  = string(best_pts);
if (new_pts)  best_pts_txt  += "  (New Record!)";

var best_time_txt = _fmt_time_local(best_timef);
if (new_time) best_time_txt += "  (New Record!)";

// draw rows 
tpos_y = _row_at("Best Score: ", best_pts_txt,  tpos_x, tpos_y+8, value_x);
tpos_y = _row_at("Best Time: ",  best_time_txt, tpos_x, tpos_y+8, value_x);


tpos_y += lineh+8
// Footer hint
draw_set_halign(fa_left);
draw_set_colour(make_color_rgb(70, 90, 110));
draw_text(panel_x + pad, panel_y + panel_h - pad - lineh, "Press R to Restart |  Esc to Quit");
draw_set_colour(c_black); // 
