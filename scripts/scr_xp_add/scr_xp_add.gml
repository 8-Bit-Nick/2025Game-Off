// Adds XP, handles level-ups, and sets a flag to open the upgrade picker.

function scr_xp_add(amount)
{
    // Ensure globals exist (first call safety) 
    if (!variable_global_exists("level"))    global.level    = 1;
    if (!variable_global_exists("xp"))       global.xp       = 0;
    if (!variable_global_exists("xp_next"))  global.xp_next  = 30; // first level threshold
    if (!variable_global_exists("leveling")) global.leveling = false; // true pauses spawns & shows picker

    // Add XP+ apply multiplier
    if (!variable_global_exists("xp_mult"))  global.xp_mult  = 1.0;
    var amt = max(0, amount) * global.xp_mult;   
    amt = round(amt);    // keeps whole integers                        
    global.xp += amt;

    // Level up as many times as needed (big XP drops)
    while (global.xp >= global.xp_next) {
        global.xp -= global.xp_next;
        global.level += 1;
        
        //Update Global Level
        global.run_stats.level_peak = max(global.run_stats.level_peak, global.level);

        // Mild non-linear growth (tweak to taste)
        global.xp_next = round(global.xp_next * 1.15 + 2);

        // Signal the round controller to pause and show upgrade choices
        global.leveling = true;
    }
    if (!global.leveling){
    scr_popup_from_cursor_xp(amount);
}
}
