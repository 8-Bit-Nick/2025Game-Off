function scr_run_reset_stats(){
    global.run_stats = {
        
    // end-screen snapshot fields
    score_final:        0,
    time_frames:        0,

    // counters
    kills:              0,
    dmg_total:          0,
    hits_total:         0,
    crit_hits:          0,

    // peaks / aggregates
    intensity_peak:     0.0,  
    level_peak:         1,

    //upgrade
    bulb_mult:          1.0,  
    lens_mult:          1.0,  
    scholar_mult:       1.0,  
    crit_chance_total:  0.0,  
    vol_core:           false 
};

}