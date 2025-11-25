// GUI canvas size
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

// Panel rectangle (centered). Tweak these to taste.
panel_w = min(800, gui_w * 0.85);
panel_h = min(400, gui_h * 0.78);
panel_x = (gui_w - panel_w) * 0.5;
panel_y = (gui_h - panel_h) * 0.5;

// Inner layout metrics
pad        = 24;  
lineh      = 24;  
title_gap  = 14; 

// set font
if (font_exists(fnt_card_title)) {
    summary_font = fnt_card_title; 
} else {
    summary_font = -1;
}

//if you want a subtle fade-in for the card itself
card_alpha      = 1;     // set <1 for fade-in; keep 1 if unnecessary
card_fade_speed = 0.0;   // >0 to animate in Update/Step
