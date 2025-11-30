// Basic Stats
max_hp = 0;
hp = max_hp;
base_spd = 0.0;
spd = base_spd;
contact_damage = 0; // damage dealt to the tower per hit
dmg = contact_damage;
xp_value = 0;
points = 1;

//attack and track
hit_radius = 10;
stop_margin_px = 6;    // how far from the tower to stop before attacking
hit_flash = 0;
enemy_radius = 0;
image_angle = 0;
target_boat = noone; // the specific boat this enemy will pursue
retarget_cooldown_frames = 15;    // how often the enemy is allowed to switch boats
retarget_cd = 0;     // counts down each Step
attack_rate_frames = 0;   // cooldown between hits 
attack_cooldown = 0;    // counts down in Step
just_attacked = false;

//Status timers
hurt_timer = 0;
stun_timer = 0;
blind_timer = 0;
blind_t = 0;
slow_t      = 0;    // frames remaining of slow
slow_factor = 1.0;  // 1.0 = 

//Stun setup
base_anim_speed = image_speed;    // if you set per-child speeds, they can overwrite this

// Tiny orbit state for “stun stars” 
stun_orbit_ang = irandom(359); // per-enemy desync
stun_orbit_speed = 8; // degrees per frame (tweak 4–8)
stun_orbit_radius = 8; // pixels around the head
stun_star_height = - (sprite_get_height(sprite_index) * 0.5 + 6); // sit above head

// cache the icon sprite id 
spr_stun_icon = asset_get_index(spr_stun); 
explosion_taken = false;
explosion_timer = 5;