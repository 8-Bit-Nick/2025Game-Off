//Level up pause
if (variable_global_exists("leveling") && global.leveling){
    exit;
}

//Status - Tick
if (blind_timer > 0){
    blind_timer -= 1;
}
if (hurt_timer > 0){
    hurt_timer -= 1;
}

//Speed compute
var mult = 1.0
if (blind_timer > 0){
    mult *= 0.75;
}
spd = base_spd * mult;

//Move to Tower
if (instance_exists(target)){
    var dir = point_direction(x, y, target.x, target.y-63);
    x += lengthdir_x(spd,dir);
    y += lengthdir_y(spd,dir);
}

if (hurt_timer > 0) hurt_timer -=1;
    
if (hp <= 0) {
    if (script_exists(scr_xp_add)){
        scr_xp_add(xp_value); // Set by spawner
    }
    instance_destroy()
}