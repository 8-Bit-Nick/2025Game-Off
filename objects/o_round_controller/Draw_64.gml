///elapsed time HUD
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
    var intensity_pct = round(difficulty_01 * 100);

    draw_set_halign(fa_right);
    draw_set_valign(fa_top);

    // shadow
    draw_set_color(c_fuchsia);
    draw_text(gw - 9, 9, "Intensity: " + string(intensity_pct) + "%");
    
    //text
    draw_set_color(c_white);
    draw_text(gw - 10, 8, "Intensity: " + string(intensity_pct) + "%");
    
    //Level/XP/Score -- Left Top
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    //shadow
    draw_set_color(c_fuchsia);
    draw_text(9,7,"Level: " + string(global.level))
    draw_text(9,32,"XP to next level: " + string(global.xp) + " / " + string(global.xp_next))
    with o_Tower{
        draw_text(9,57,"HP: " + string(o_Tower.hp) + " / " + string(o_Tower.max_hp))
    }
    draw_text(9,82, "Score: " + string(global.points))
    
    //text
    draw_set_color(c_white);
    draw_text(8,6,"Level: " + string(global.level))
    draw_text(8,31,"XP to next level: " + string(global.xp) + " / " + string(global.xp_next))
    with o_Tower{
        draw_text(8,56,"HP: " + string(o_Tower.hp) + " / " + string(o_Tower.max_hp))
    }
    draw_text(8,81, "Score: " + string(global.points))


}

