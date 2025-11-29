function scr_get_tower_anchor(){
    var objLH = asset_get_index("o_Tower");

    if (objLH != -1 && instance_exists(objLH)) {
        var lh = instance_find(objLH, 0);
        return { x: lh.x, y: lh.y - 42 }; // a bit above the light
    }
        // Fallback: top-center of camera view
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam);
    var vy  = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam);

    return { x: vx + vw * 0.5, y: vy + 48 };

}