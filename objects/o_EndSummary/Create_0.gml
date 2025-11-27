// GUI canvas size
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

// Panel rectangle (centered). Tweak these to taste.
panel_w = min(560, gui_w * 0.85);
panel_h = min(660, gui_h * 1.23);
panel_x = (gui_w - panel_w) * 0.5;
panel_y = (gui_h - panel_h) * 0.5;
inner_x = 10;
inner_y = 10;
inner_w = 10;
inner_h = 10;
// Inner layout metrics
pad        = 24;  
lineh      = 24;  
title_gap  = 14; 

// set font
if (font_exists(fnt_card_title_1)) {
    summary_font = fnt_card_title_1; 
} else {
    summary_font = -1;
}

//if you want a subtle fade-in for the card itself
card_alpha      = 1;     // set <1 for fade-in; keep 1 if unnecessary
card_fade_speed = 0.0;   // >0 to animate in Update/Step
