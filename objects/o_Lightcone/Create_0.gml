// If no owner was set when this was created, try to auto-attach to the nearest oTower
if (!variable_instance_exists(id, "owner") || !instance_exists(owner)) {
    var inst = instance_nearest(x, y, o_Tower);
    owner = instance_exists(inst) ? inst : noone;
}

//Base Stats
half_angle = 20;  // 70deg total width
length = 150;
dps = 20;
visible_fx = true;

//Origination point of tower origin
anchor_off_x = 0;
anchor_off_y = -125;

aim_mode = "mouse";

if (!layer_exists("LightFX")){
    layer_create(0,"LightFX");
}
layer = 2;