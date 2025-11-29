if (instance_exists(caster)){
    x = caster.x; y = caster.y;
}
age += 1;
if (age >= life_frames) instance_destroy();