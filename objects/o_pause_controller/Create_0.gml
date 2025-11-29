//Pause
global.paused = false;
pause_layer = "Pause_Menu";

pause_update = function(){
    if (global.paused){
        instance_deactivate_object(o_Spotlight);
        instance_deactivate_object(o_Lightbeam)
        layer_set_visible(pause_layer, true);
    }
    else{
        instance_activate_all();
        layer_set_visible(pause_layer,false);
    }
}
pause_update();
