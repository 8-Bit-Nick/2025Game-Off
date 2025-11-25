// Inherit the parent event
event_inherited();
stop_margin_px = 9
attack_rate_frames = 12;
hit_radius = 8;
enemy_radius = 8;
contact_damage = 10;
stun_star_height = - (sprite_get_height(sprite_index) * 0.5 + 7); // sit above head
/// sprites + animation state 
spr_idle   = asset_get_index("spr_SeaSnake"); 
spr_attack = asset_get_index("spr_SeaSnake_Attack"); 

image_speed   = .95;   // idle speed (tweak)
sprite_index  = spr_idle;

is_attacking      = false; // visual state
_prev_cooldown    = 0;     // 