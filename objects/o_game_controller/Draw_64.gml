if (global.DEBUG){
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(8,8,"FPS Target: " + string(global.FPS) + "Frame: " + string(global.FRAME));
}