// Inherit the parent event
event_inherited();
stop_margin_px = 180;
ranged_ai = true;
enemy_radius = 26;
// combat tuning 
contact_damage = 0; // set by spawner
attack_rate_frames = 135; // throw - 60=1s
attack_cooldown = irandom_range(330, 390); // small desync on spawn
engage_delay = irandom_range(360,390)
//throw parameters (
throw_windup_frames = 20; // frames to “wind up” before rock spawns
throw_timer = 0;  // counts down during a windup

rock_damage = contact_damage; // damage dealt on hit 
rock_speed = 2.85; // initial horizontal speed
rock_gravity = 0.21;// pixels/frame^2 for a lob arc
rock_spread = 88; // slight random aim spread in degrees

// spawn offset near a front tentacle
rock_offx = -28;
rock_offy = -6;

// Keep base anim speed from parent for stun/unfreeze restore
base_anim_speed = image_speed;

explosion_taken = false;
explosion_timer = 5;