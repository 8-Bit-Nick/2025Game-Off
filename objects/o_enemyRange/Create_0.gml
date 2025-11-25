// Inherit the parent event
event_inherited();
stop_margin_px = 180;
ranged_ai = true;
enemy_radius = 22;
// combat tuning 
contact_damage = 10; // if it ever touches a boat
attack_rate_frames = 120; // throw - 60=1s
attack_cooldown = irandom_range(240, 270); // small desync on spawn
engage_delay = irandom_range(235,265)
//throw parameters (
throw_windup_frames = 15; // frames to “wind up” before rock spawns
throw_timer = 0;  // counts down during a windup

rock_damage = 8; // damage dealt on hit 
rock_speed = 2.85; // initial horizontal speed
rock_gravity = 0.22;// pixels/frame^2 for a lob arc
rock_spread = 35; // slight random aim spread in degrees

// spawn offset near a front tentacle
rock_offx = -20;
rock_offy = -2;

// Keep base anim speed from parent for stun/unfreeze restore
base_anim_speed = image_speed;