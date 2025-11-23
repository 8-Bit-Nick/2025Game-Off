// Inherit the parent event
event_inherited();
attack_rate_frames = 12;
hit_radius = 8;
enemy_radius = 8;
contact_damage = 8;
stun_star_height = - (sprite_get_height(sprite_index) * 0.5 + 7); // sit above head
/// sprites + animation state 
spr_idle   = asset_get_index("spr_SeaSnake");   // <- your idle sprite name
spr_attack = asset_get_index("spr_SeaSnake_Attack"); // <- your attack sprite name

image_speed   = .95;   // idle speed (tweak)
sprite_index  = spr_idle;

is_attacking      = false; // visual state
_prev_cooldown    = 0;     // to detect “just attacked” this frame