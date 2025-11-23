// When the attack animation finishes, go back to idle
if (is_attacking) {
    is_attacking = false;
    sprite_index = spr_idle;
    image_speed  = 1; // idle speed again
}
