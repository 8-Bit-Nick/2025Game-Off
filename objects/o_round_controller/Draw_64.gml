// elapsed time HUD
// Show while playing or during level-up pause

if (state == "running" || state == "levelup_pause") {
    var gw = display_get_gui_width();
    draw_set_font(fnt_UI)
    
    
    // Elapsed mm:ss from elapsed_frames
    var fps_local = (variable_instance_exists(id,"frames_per_second") && frames_per_second > 0) ? frames_per_second : 60;
    var secs = floor(elapsed_frames / fps_local);
    var mm = secs div 60;
    var ss = secs mod 60;

    // zero-pad mm:ss
    var mm_str = (mm < 10) ? "0" + string(mm) : string(mm);
    var ss_str = (ss < 10) ? "0" + string(ss) : string(ss);
    var timer_text = "Time Survived: " + mm_str + ":" + ss_str;

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    // subtle shadow
    draw_set_color(c_fuchsia);
    draw_text(gw * 0.5 + 1, 9, timer_text);

    draw_set_color(c_white);
    draw_text(gw * 0.5, 8, timer_text);
    
    //  Wave Intensity (top-right): show difficulty_01 as a percent
    var I_scaler = (variable_global_exists("intensity_scaler") && global.intensity_scaler > 0)
    ? global.intensity_scaler
    : 1.0;

// % growth since start (1.0 → 0%, 2.0 → 100%, 3.0 → 200% ...)
    var intensity_pct_growth = round(max(0, (I_scaler - 1.0) * 100));
    intensity_pct_growth = max(1, intensity_pct_growth);

// draw
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);

// shadow
    draw_set_color(c_fuchsia);
    draw_text(gw - 9, 9, "Intensity: " + string(intensity_pct_growth) + "%");

// text
    draw_set_color(c_white);
    draw_text(gw - 10, 8, "Intensity: " + string(intensity_pct_growth) + "%");
    
    //Level/XP/Score -- Left Top
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    //shadow
    draw_set_color(c_fuchsia);
    draw_text(9,7,"Level: " + string(global.level))
    draw_text(9,32,"XP to next level: " + string(global.xp) + " / " + string(global.xp_next))
    draw_text(9,57, "Score: " + string(global.points))
    
    //text
    draw_set_color(c_white);
    draw_text(8,6,"Level: " + string(global.level))
    draw_text(8,31,"XP to next level: " + string(global.xp) + " / " + string(global.xp_next))
    draw_text(8,56, "Score: " + string(global.points))


}

