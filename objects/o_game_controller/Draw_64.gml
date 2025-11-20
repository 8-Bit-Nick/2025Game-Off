if (global.DEBUG){
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(8,6,"Level: " + string(global.level))
    draw_text(8,22,"XP to next level: " + string(global.xp) + " / " + string(global.xp_next))
    with o_Tower{
        draw_text(8,38,"HP: " + string(o_Tower.hp) + " / " + string(o_Tower.max_hp))
    }
    draw_text(8,54, "Score: " + string(global.points))
}