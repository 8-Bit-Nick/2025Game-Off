//Visual
sprite_index = spr_card;
image_xscale = 1;
image_yscale = 1;

//Card Size px
card_w = sprite_get_width(sprite_index);
card_h = sprite_get_height(sprite_index);

//Display Box math from center point
TOP_BOX_OX = -64;  TOP_BOX_OY = -96;  TOP_BOX_W = 128;  TOP_BOX_H = 77;   // icon/title
BOT_BOX_OX = -68;  BOT_BOX_OY = 16;    BOT_BOX_W = 140;  BOT_BOX_H = 79;   // description/value

//Content Placeholder
upgrade_id = -1;
title_text = "Title";
desc_text = "Description goes here.";
icon_sprite = noone;
key_hint = "";

//Hover / Selected
is_hovered = false;
is_selected = false;

//cached rect corners in room space
left   = x - card_w * 0.5;
right  = x + card_w * 0.5;
top    = y - card_h * 0.5;
bottom = y + card_h * 0.5;