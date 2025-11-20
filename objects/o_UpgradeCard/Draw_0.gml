// Draw the card (origin centered, room-space)
draw_self();

//Compute content rects (from the card center)
var top_x1 = x + TOP_BOX_OX;
var top_y1 = y + TOP_BOX_OY;
var top_w  = TOP_BOX_W;
var top_h  = TOP_BOX_H;

var bot_x1 = x + BOT_BOX_OX;
var bot_y1 = y + BOT_BOX_OY;
var bot_w  = BOT_BOX_W;
var bot_h  = BOT_BOX_H;
var icon_x = top_x1 + top_w * 0.5;
// Icon (draw at native size;centered near top box
if (icon_sprite != noone) {
   var icon_y = top_y1 + 16; // a little down from the top edge 
    draw_sprite(icon_sprite, 0, icon_x, icon_y);
}
// Rarity color by tier: 0=Common, 1=Rare, 2=Epic
var rarity_col = c_white;
switch (tier_index) {
    case 0: rarity_col = c_dkgray; break;
    case 1: rarity_col = make_color_rgb(70,140,255);  break; // Rare (blue)
    case 2: rarity_col = make_color_rgb(180,110,255); break; // Epic (purple)
}


// Title centered under the icon
draw_set_font(fnt_card_title)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(rarity_col);
var title_y = top_y1 + 48 + 10; // icon height + spacing
draw_set_color(c_black); draw_text(icon_x+1, title_y+1, title_text);
draw_set_color(rarity_col); draw_text(icon_x, title_y, title_text);

// Description inside bottom panel with wrapping & small padding
draw_set_font(fnt_card_desc)
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var pad = 6;
var wrap_w = bot_w - pad * 2;
draw_text_ext(bot_x1 + pad, bot_y1 + pad, desc_text, -1, wrap_w);

// Tiny key hint in the bottom-right corner of the card
if (key_hint != "") {
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(c_black);
    draw_text(x + card_w * 0.5 - 6, y + card_h * 0.5 - 6, key_hint);
}
