//Base Stats
radius_px = 20;
dps = 16;
crit_chance = 0;
crit_mult = 1.6;
ef_crit_chance = 0;
base_radius_px = radius_px;
//Sprite Stuff
sprite_index = spr_Spotlight;
image_alpha = .75;
spotlight_alpha = image_alpha;
sprite_base_diameter = 36;

// Replacing Cursor
window_set_cursor(cr_none);

//Tower ref for beam
tower = instance_exists(o_Tower) ? instance_find(o_Tower,0) : noone;
