function scr_add_Highscore(){
     if(!variable_global_exists("points")){
        global.points = 0;
    }
    global.points += max(0,argument0)

}