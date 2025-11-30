// Own the level-up UI (fade-in/out + cards)
// Spawn 3 cards on a dedicated instance layer
// Swap cursor/spotlight visibility during leveling
// Apply the chosen upgrade, then clean up and resume

// Base Vars
state        = "idle";      // 
fade_alpha   = 0;           // 0..1 for the screen-dim overlay
cards        = [];          // will hold the 3 card instance ids
chosen_id    = -1;          // upgrade id selected 

// Find spotlight to toggle during levling
spotlight = instance_exists(o_Spotlight) ? instance_find(o_Spotlight, 0) : noone;

// Find UI layer for cards
ui_layer_name = "Leveling_UI";
if (!layer_exists(ui_layer_name)) {
    var lid = layer_create(-1000,ui_layer_name);     // very on top
    layer_get_name(ui_layer_name);
} else {
    // force depth in case the room changed it
    layer_depth(layer_get_id(ui_layer_name), -1000);
}


// Card placement
CARD_W = 194;
CARD_H = 250;

var y_center = 225;                    // vertical center for cards
var x_left   = 280 //112
var x_mid    = 400 //320
var x_right  = 520 //528               // Room math to line up 3 cards

card_positions = [
    { x: x_left,  y: y_center },
    { x: x_mid,   y: y_center },
    { x: x_right, y: y_center }
];

winw = window_get_width();
winh = window_get_height();
