/// @function scr_xp_add(amount)
function scr_xp_add(amount) {
    global.xp += max(0, amount);

    // Handle multiple level-ups if a big XP drop comes in
    while (global.xp >= global.xp_next) {
        global.xp -= global.xp_next;
        global.level += 1;

        // Slightly increase next requirement (mild curve)
        global.xp_next = round(global.xp_next * 1.25 + 5);

        // Flag a level-up; the controller will roll upgrades and pause spawns
        global.leveling = true;
    }
}
