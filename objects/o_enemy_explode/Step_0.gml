//Level up pause
if (variable_global_exists("leveling") && global.leveling){
    image_speed = 0;
}
else image_speed = 1;
if (variable_global_exists("paused") && global.paused){
    exit;
}

