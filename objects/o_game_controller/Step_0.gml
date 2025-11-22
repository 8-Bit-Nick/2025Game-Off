/// Animate Popups

// Update and prune popups
for (var i = array_length(popups) - 1; i >= 0; i--) {
    var p = popups[i];

    // lifetime
    p.ttl -= 1;

    // motion (float upward a bit each frame)
    p.y += p.vy;

    // fade out linearly over its lifespan (assumes ttl started at 60)
    p.alpha = max(0, p.ttl / 60);

    // write back the modified struct
    popups[i] = p;

    // remove if expired
    if (p.ttl <= 0) {
        array_delete(popups, i, 1);
    }
}
if (!instance_exists(o_Boat_Parent)){
    game_restart()
}