if (!explosion_taken && explosion_timer <=0){
    hp -= other.dmg;
    explosion_taken = true;
    explosion_timer += 10;
}