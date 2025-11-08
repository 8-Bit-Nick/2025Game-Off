//Follow Owner Postiion
if(instance_exists(owner)){
    x = owner.x +anchor_off_x;
    y = owner.y + anchor_off_y
}

//Auto or mouse aim
if (aim_mode == "inherit" && instance_exists(owner) && variable_instance_exists(owner, "cone_dir")) {
    dir = owner.cone_dir;
} else {
    dir = point_direction(x, y, mouse_x, mouse_y);
}

//Conver dmg per sec to dmg per frame
var dmg_per_frame = dps/ max(1,global.FPS);

//Blind
var blind_linger = round(0.3 * max(1,global.FPS));

//Check enemies
with (o_EnemyParent){
    if (scr_in_cone(x, y, other.x, other.y, other.dir, other.half_angle, other.length)){
        hp -= other.dps <= 0 ? 0 : dmg_per_frame;
        
        // Enemy hit indicator
        hurt_timer = 8;
        blind_timer = max(blind_timer,blind_linger)
    }
}