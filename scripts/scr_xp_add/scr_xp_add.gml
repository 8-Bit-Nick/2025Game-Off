// adds XP, handles level-ups, and sets flag for upgrade picker
// should be safe to call at anytime in the game

function scr_xp_add(amount){
    //ensure globals exist first
    if(!variable_global_exists("level")){
        global.level = 1;}
    if(!variable_global_exists("xp")){
        global.xp = 0;}
    if(!variable_global_exists("xp_next")){
        global.xp_next = 30;}
    if(!variable_global_exists("leveling")){
        global.leveling = false;}

// Add XP
global.xp += max(0,amount);

// level up as many times as needed (bigger XP drops)
while (global.xp > global.xp_next){
    global.xp -= global.xp_next;
    global.level +=1;
    
    // mild non linear growth (can tweak)
    global.xp_next = round(global.xp_next * 1.25 + 10);
    
    //signal the round controller to pause and show upgrades
    global.leveling = true;

    
}
}