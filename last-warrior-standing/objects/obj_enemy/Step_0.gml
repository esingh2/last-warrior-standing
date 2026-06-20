if (!visible) exit;

if (hit_stun_timer > 0) {
    hit_stun_timer--;
    exit; 
}

if (attack_cooldown_timer > 0) {
    attack_cooldown_timer--;
}

if (instance_exists(obj_player)) { 
    var _distance = distance_to_object(obj_player);
    
    // --- FOLLOWING THE CHARACTER ---
    if (_distance < 120) {
        if (obj_player.x > x) {
            x += move_speed;
        } else if (obj_player.x < x) {
            x -= move_speed;
        }
    }
    
    // --- NEW REPLACED DAMAGE CHECK ---
    // If player is within 16 pixels of the enemy, they ALWAYS take damage instantly
    if (_distance <= 16 && attack_cooldown_timer <= 0) {
        obj_player.hp -= damage_amount;
        attack_cooldown_timer = attack_cooldown_max; 
        
        show_debug_message("Player Hit consistently! Current HP: " + string(obj_player.hp));
        
        if (obj_player.hp <= 0) {
            room_restart();
        }
    }
}

// --- DEATH CHECK ---
if (hp <= 0) {
    instance_destroy();
}