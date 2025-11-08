switch (state) {
    case "prep":
        if (timer > 0) {timer--; break;}
          
        //spawn this waves enemies off screan  
        var count = base_count + (wave - 1) * per_wave_bonus;
        
        var alive = instance_number(o_EnemyParent);
        var to_spawn = 
	
}