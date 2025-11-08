// Wave State
wave = 1;
state = "prep";
timer = round(1.5 * max(1,global.FPS)); //delay for first wave


//Tuning
spawn_margin = 128; //pixels off screen
base_count = 5; //enemies in wave 1;
per_wave_bonus = 2; //enemies added per wave
max_on_field_cap = 40; // Cap for enemies

enemies_to_spawn = o_enemyTank;

// Wave banner
show_wave_banner = true;
banner_timer = round(3 * max(1,global.FPS));