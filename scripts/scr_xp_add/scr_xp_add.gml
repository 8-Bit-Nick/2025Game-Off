/// scr_xp_add(amount)
// Adds XP, handles level-ups, and sets a flag to open the upgrade picker.
// Safe to call anytime; it initializes globals on first use.

function scr_xp_add(amount)
{
    // --- Ensure globals exist (first call safety) ---
    if (!variable_global_exists("level"))    global.level    = 1;
    if (!variable_global_exists("xp"))       global.xp       = 0;
    if (!variable_global_exists("xp_next"))  global.xp_next  = 30; // first level threshold
    if (!variable_global_exists("leveling")) global.leveling = false; // true pauses spawns & shows picker

    // --- Add XP ---
    global.xp += max(0, amount);

    // --- Level up as many times as needed (big XP drops) ---
    while (global.xp >= global.xp_next) {
        global.xp -= global.xp_next;
        global.level += 1;

        // Mild non-linear growth (tweak to taste)
        global.xp_next = round(global.xp_next * 1.25 + 5);

        // Signal the round controller to pause and show upgrade choices
        global.leveling = true;
    }
}
