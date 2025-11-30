//Visual beam that extends from lighthouse to cursor

// References
tower = instance_exists(o_Tower) ? instance_find(o_Tower,0) : noone;
spotlight = instance_exists(o_Spotlight) ? instance_find(o_Spotlight,0) : noone;

fps_local = variable_global_exists("FPS") ? max(1,global.FPS): 60;

// Beam Geometry

cur_dir_deg = 0; //Current beam facing(degrees)
cur_len_px = 0; //Current beam length (pixels)

// Appearance 
beam_width_px = 0;
beam_alpha = .28;

//Rotation
max_rot_dps = 100000; //Max rotation in degree per sec
extend_pps = 100000;
retract_pps = 100000;
rot_smooth = 0;

//Safety
if (instance_exists(tower)){
    cur_dir_deg = point_direction(x,y,tower.x,tower.y); //will update in step
}
