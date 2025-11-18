// Frame Helper
var fps_local = variable_global_exists("FPS") ? max(1,global.FPS) : 60;


if (state == "idle" && variable_global_exists("leveling") && global.leveling) {
    // UI startup: hide spotlight visuals & switch to normal cursor
    if (instance_exists(spotlight)) spotlight.visible = false;
    window_set_cursor(cr_handpoint);

    // Begin fading in the dim background
    state       = "fade_in";
    fade_alpha  = 0;        // start transparent
    fade_target = 0.92;     // how dark the screen gets behind cards
    fade_speed  = 2.0;      // alpha per second
}

// Handle fade-in
if (state == "fade_in") {
    fade_alpha += fade_speed / fps_local;
    if (fade_alpha >= fade_target) {
        fade_alpha = fade_target;
        state = "show";  
    }
}


// SHOW: spawn 3 centered cards
if (state == "show" && array_length(cards) == 0) {
    

    // Camera-relative placement 
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam);
    var vy  = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam);
    var vh  = camera_get_view_height(cam);

    var margin   = 24;
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
    for (var i = 0; i < array_length(bucket); i++) ds_list_add(candidates, i);
    ds_list_shuffle(candidates);

    // Pick up to 3 unique upgrades
    var picks = [];
    var want = min(3, ds_list_size(candidates));
    for (var k = 0; k < want; k++) array_push(picks, candidates[| k]);
    ds_list_destroy(candidates);

    // Spawn cards; each rolls its own tier with 60/30/10 odds
    for (var j = 0; j < array_length(picks); j++) {
        var idx = picks[j];
        var e   = bucket[idx];

        // Weighted tier roll: 0 (60%), 1 (30%), 2 (10%)
        var r = random(1);
        var t = (r < 0.60) ? 0 : ((r < 0.90) ? 1 : 2);
        t = clamp(t, 0, max(0, array_length(e.tiers) - 1)); // safety

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
