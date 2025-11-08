//Checks to see if enemy is in light cone

function scr_in_cone (px,py,ox,oy,dir,half_angle,length){
    var dist = point_distance(ox,oy,px,py);
    if (dist > length) return false;
        var a = angle_difference (point_direction(ox, oy, px, py), dir);
    return (abs(a) <= half_angle);
}