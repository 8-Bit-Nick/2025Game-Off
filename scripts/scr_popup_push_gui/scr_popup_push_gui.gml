function scr_popup_push_gui(_xg, _yg, _text, _col, _ttl, _vy)
{
    if (!instance_exists(o_game_controller)) return;
    var gc = instance_find(o_game_controller, 0);

    // Build struct 
    var p = {
        x     : _xg,
        y     : _yg,
        text  : _text,
        col   : _col,
        ttl   : _ttl,   
        alpha : 1,
        vy    : _vy     
    };

    array_push(gc.popups, p);
}
