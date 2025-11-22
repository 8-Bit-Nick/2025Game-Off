function scr_add_Highscore(){
     if(!variable_global_exists("points")){
        global.points = 0;
    }
    global.points += max(0,argument0)
if (!variable_global_exists("leveling")) ||!global.leveling {
    scr_popup_from_cursor_points(argument0)
}
}