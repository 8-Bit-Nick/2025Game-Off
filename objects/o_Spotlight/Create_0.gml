//Base Stats
radius_px = 20;
dps = 18;


//Sprite Stuff
sprite_index = spr_Spotlight;
image_alpha = .75;
sprite_base_diameter = 36;

// Replacing Cursor
window_set_cursor(cr_none);

//Tower ref for beam
tower = instance_exists(o_Tower) ? instance_find(o_Tower,0) : noone;
