// Inherit the parent event
event_inherited();
hit_radius = 10;
enemy_radius = 8;
contact_damage = 8;
stun_star_height = - (sprite_get_height(sprite_index) * 0.5 + 18); // sit above head

/// sprites + animation state 
spr_idle   = asset_get_index("spr_Shelly");   
spr_attack = asset_get_index("spr_Shelly_attack"); 

image_speed   = .95;   // idle speed 
sprite_index  = spr_idle;

is_attacking      = false; // visual state
_prev_cooldown    = 0;     // to detect attack