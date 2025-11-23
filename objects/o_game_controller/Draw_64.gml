// Cursor Pop-ups

for (var i = 0; i < array_length(popups); i++) {
    var p = popups[i];

    // shadow for readability
    draw_set_alpha(p.alpha);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_set_color(c_black);
    draw_text(p.x + 1, p.y + 1, p.text);

    // main colored text
    draw_set_color(p.col);
    draw_text(p.x, p.y, p.text);

    draw_set_alpha(1);
}

#region Ability Tray
// Ability tray: center under timer + draw Q / W labels

// ===== 1) Placement under the timer =====
var gui_w = display_get_gui_width();

// If your timer code sets a real bottom Y, read it; otherwise use a fallback height.
var timer_bottom = (variable_global_exists("timer_gui_bottom"))
    ? global.timer_gui_bottom
    : timer_text_h; // set in Create

tray_x = round((gui_w - tray_w) * 0.5);
tray_y = round(timer_bottom + tray_top_gap);

// ===== 2) Draw tray background =====
if (spr_tray != -1 && sprite_exists(spr_tray)) {
    draw_sprite(spr_tray, 0, tray_x, tray_y);
} else {
    // Fallback debug rect if sprite missing
    draw_set_alpha(0.3);
    draw_rectangle(tray_x, tray_y, tray_x + tray_w, tray_y + tray_h, false);
    draw_set_alpha(1);
}

// ===== 3) Compute slot rects (based on your art measurements) =====
var s1x1 = tray_x + slot1_offx;
var s1y1 = tray_y + slot1_offy;
var s1x2 = s1x1 + slot_w;
var s1y2 = s1y1 + slot_h;

var s2x1 = tray_x + slot2_offx;
var s2y1 = tray_y + slot2_offy;
var s2x2 = s2x1 + slot_w;
var s2y2 = s2y1 + slot_h;

// Store for later (icons/cooldowns/mouse hit-tests if you add clicks later)
slot1_rect = [s1x1, s1y1, s1x2, s1y2];
slot2_rect = [s2x1, s2y1, s2x2, s2y2];

// ===== 4) Optional icons centered in slots =====
var s1cx = (s1x1 + s1x2) * 0.5;
var s1cy = (s1y1 + s1y2) * 0.5;
var s2cx = (s2x1 + s2x2) * 0.5;
var s2cy = (s2y1 + s2y2) * 0.5;

//if (spr_icon_overcharge != -1 && sprite_exists(spr_icon_overcharge)) {
    //draw_sprite_ext(spr_icon_overcharge, 0, s1cx, s1cy, 1, 1, 0, c_white, 1);
//}
//if (spr_icon_flare != -1 && sprite_exists(spr_icon_flare)) {
    //draw_sprite_ext(spr_icon_flare, 0, s2cx, s2cy, 1, 1, 0, c_white, 1);
//}

// Q / W labels centered in the boxes
var old_h = draw_get_halign();
var old_v = draw_get_valign();
var old_c = draw_get_colour();
//Line up letters
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_UI)
//Draw Letters
draw_set_colour(c_black);
draw_text(s1cx, s1cy, "Q");
draw_text(s2cx, s2cy, "W");

// Restore text state
draw_set_colour(old_c);
draw_set_halign(old_h);
draw_set_valign(old_v);

//Cooldown masks (top → bottom grey fill)

var q_pct = oc_active ? 1 : (oc_cd_max > 0 ? oc_cd / oc_cd_max : 0);
var w_pct = (flare_cd_max > 0 ? flare_cd / flare_cd_max : 0);

// Helper to draw a top-down mask inside a rect
function _cd_mask(_x1, _y1, _x2, _y2, _pct) {
    if (_pct <= 0) return;
    var h = (_y2 - _y1) * _pct;
    draw_set_colour(tray_cool_col); // define in Create: make_color_rgb(40,40,40)
    draw_set_alpha(0.94);
    draw_rectangle(_x1, _y1, _x2, _y1 + h, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

// Draw the masks last so they sit on top of icons/letters
_cd_mask(s1x1+4, s1y1+8, s1x2+1, s1y2-2, q_pct);
_cd_mask(s2x1+2, s2y1+8, s2x2, s2y2-2, w_pct);

#endregion
