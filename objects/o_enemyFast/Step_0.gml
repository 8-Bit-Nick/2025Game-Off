// Inherit the parent event
event_inherited();

// Play attack anim ONLY if a real hit landed this frame
if (just_attacked) {
    is_attacking  = true;
    sprite_index  = spr_attack;
    image_index   = 0;
    image_speed   = 0.85; // tweak
}

