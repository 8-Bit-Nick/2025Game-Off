function scr_tower_take_contact(){
     // Read params safely (works even if your IDE shows 0 formal args)
    var _boat = (argument_count > 0) ? argument0 : noone;
    var _dmg  = (argument_count > 1) ? max(0, argument1) : 0;

    // Validate target boat
    if (!instance_exists(_boat) || _dmg <= 0) return false;

    // Ensure expected vars exist on this boat (defaults if missing)
    if (!variable_instance_exists(_boat, "max_hp"))     _boat.max_hp = 100;
    if (!variable_instance_exists(_boat, "hp"))         _boat.hp     = _boat.max_hp;
    if (!variable_instance_exists(_boat, "iframes"))    _boat.iframes = 0;
    if (!variable_instance_exists(_boat, "contact_mult")) _boat.contact_mult = 1.0; // future upgrades

    // Tick down i-frames; if still active, no damage this frame
    if (_boat.iframes > 0) {
        _boat.iframes -= 1;
        return false;
    }

    // Apply scaled damage
    var applied = round(_dmg * _boat.contact_mult);
    if (applied <= 0) return false;

    _boat.hp = max(0, _boat.hp - applied);
    // kick the flash timer on this specific boat
    if (!variable_instance_exists(_boat, "hit_flash")) _boat.hit_flash = 0;
    _boat.hit_flash = max(_boat.hit_flash, 10); // ~8 frames (~0.13s) of flash

    // Give brief per-boat 
    _boat.iframes = 20; // ~0.2s at 60fps 
    
    // TODO (later): handle boat-destroyed state if _boat.hp <= 0
    return true;
}
