// Frame Helper
var fps_local = variable_global_exists("FPS") ? max(1,global.FPS) : 60;


if (state == "idle" && variable_global_exists("leveling") && global.leveling) {
    // UI startup: hide spotlight visuals & switch to normal cursor
    cursor_sprite = spr_Spotlight;
    window_set_cursor(cursor_sprite);
    var mx = (variable_global_exists("mouse_room_x")) ? global.mouse_room_x : mouse_x;
    var my = (variable_global_exists("mouse_room_y")) ? global.mouse_room_y : mouse_y;

    // Begin fading in the dim background
    state       = "fade_in";
    fade_alpha  = 0;        // start transparent
    fade_target = .92;     // how dark the screen gets behind cards
    fade_speed  = 1.5;      // alpha per second
}

// fade-in
if (state == "fade_in") {
    fade_alpha += fade_speed / fps_local;
    if (fade_alpha >= fade_target) {
        fade_alpha = fade_target;
        state = "show";  
    }
}


// spawn 3 centered cards
if (state == "show" && array_length(cards) == 0) {
    

    // Camera-relative placement 
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam);
    var vy  = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam);
    var vh  = camera_get_view_height(cam);

    var margin   = 65;
    var y_center = vy + vh * 0.5;
    var x_left   = vx + margin + CARD_W * 0.5;
    var x_right  = vx + vw - margin - CARD_W * 0.5;
    var x_mid    = (x_left + x_right) * 0.5;

    var pos_array = [
        { x: x_left,  y: y_center },
        { x: x_mid,   y: y_center },
        { x: x_right, y: y_center }
    ];

    // Get the upgrade bucket
    var bucket = scr_upgrades_get_bucket(); // [{id,name,icon,tiers,desc_fmt}, ...]

    // Build list of all upgrade indices, shuffle
    var candidates = ds_list_create();
        for (var i = 0; i < array_length(bucket); i++) {
        var allow = true;

    // If Volatile Core already taken, never offer it again
        if (bucket[i].id == "volatile_core" &&  variable_global_exists("enemy_explode") && global.enemy_explode){
            allow = false;
            }
            if (allow) ds_list_add(candidates, i);
            }
    ds_list_shuffle(candidates);
    // Pick up to 3 unique upgrades
    var picks = [];
    var want = min(3, ds_list_size(candidates));
    for (var k = 0; k < want; k++) array_push(picks, candidates[| k]);
    ds_list_destroy(candidates);

    // enemy explode
   if (!(variable_global_exists("enemy_explode") && global.enemy_explode)) {
    var vol_idx = -1;
    for (var ii = 0; ii < array_length(bucket); ii++) {
        if (bucket[ii].id == "volatile_core") { vol_idx = ii; break; }
    }
    if (vol_idx != -1) {
        var already = false;
        for (var jj = 0; jj < array_length(picks); jj++) {
            if (picks[jj] == vol_idx) { already = true; break; }
        }
        if (!already && irandom(14) == 0 && array_length(picks) > 0) {
            var slot = irandom(array_length(picks) - 1);
            picks[slot] = vol_idx;
        }
    }
}
    // Spawn cards; each rolls its own tier with 60/30/10 odds
    for (var j = 0; j < array_length(picks); j++) {
        var idx = picks[j];
        var e   = bucket[idx];

        // Weighted tier roll: 0 (60%), 1 (30%), 2 (10%)
        var r = random(1);
        var t = (r < 0.60) ? 0 : ((r < 0.90) ? 1 : 2);
        t = clamp(t, 0, max(0, array_length(e.tiers) - 1)); // safety
        
        if (e.id == "volatile_core") t = 2;

        // Create the card on the UI layer at the camera-centered position
        var pos = pos_array[j];
        var c = instance_create_layer(pos.x, pos.y, ui_layer_name, o_UpgradeCard);

        // Fill card content
        c.upgrade_id  = e.id;
        c.title_text  = e.name;
        c.desc_text   = e.desc_fmt[t];
        c.icon_sprite = e.icon;
        c.key_hint    = string(j + 1); // "1","2","3"
        c.tier_index  = t;

        // Track for cleanup
        array_push(cards, c);
    }
}
//Show State Input/Choose Card
//handle input (click
var picked = noone;
if (state == "show" && array_length(cards) > 0) {
    
// 2Mouse click (cards are drawn in ROOM space, so use mouse_x/mouse_y)
    if (picked == noone && mouse_check_button_pressed(mb_left)) {
        var mx = mouse_x;
        var my = mouse_y;
        for (var i = 0; i < array_length(cards); i++) {
            var c = cards[i];
            var left   = c.x - c.card_w * 0.5;
            var right  = c.x + c.card_w * 0.5;
            var top    = c.y - c.card_h * 0.5;
            var bottom = c.y + c.card_h * 0.5;
            if (mx >= left && mx <= right && my >= top && my <= bottom) { picked = c; break; }
        }
    }

    // If something was picked, stash choice and begin fade-out
    if (picked != noone) {
        chosen_id   = picked.upgrade_id;   // string id like "bb","wl","fb","dz","sch","fc"
        chosen_tier = picked.tier_index;   // 0,1,2

        // destroy the three card instances
        for (var j = 0; j < array_length(cards); j++) {
            if (instance_exists(cards[j])) instance_destroy(cards[j]);
                audio_play_sound(snd_upgrade,1,false,0.06,undefined)
        }
        cards = [];

        // transition to fade-out; the fade-out block will call scr_upgrades_apply(...)
        state      = "fade_out";
        fade_speed = 1.5;
    }
}
// Fade out
if (state == "fade_out") {
    fade_alpha = max(0, fade_alpha - (fade_speed / fps_local));

    if (fade_alpha <= 0) {
        // Apply the selected upgrade (if any)
        if (is_string(chosen_id) && chosen_id != "") {
            scr_upgrades_apply(chosen_id, chosen_tier);
        }

        // Restore spotlight + custom cursor
        if (instance_exists(spotlight)) spotlight.visible = true;
        window_set_cursor(cr_none);

        // Clear temp UI state
        chosen_id   = "";
        chosen_tier = -1;

        // Close the level-up flow and resume gameplay
        global.leveling = false;
        state = "idle";
    }
}
