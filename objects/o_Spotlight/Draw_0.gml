//compute visual scale to sprite radius
var want_diam = radius_px *2;
var scale = want_diam / max(1,sprite_base_diameter);

//Draw Sprite
draw_sprite_ext(sprite_index,image_index,x,y,scale,scale,0,c_white,image_alpha);