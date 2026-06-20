// --- PLAYER HITTING ENEMY ---
if (other.is_attacking || other.is_crouch_attacking) {
    if (hit_stun_timer <= 0) {
        var _current_sprite = other.sprite_index;
        
        // --- SPELL 1 DAMAGE SYSTEM (BUFFED) ---
        if (_current_sprite == spr_spell_right || _current_sprite == spr_spell_left) {
            if (other.image_index >= 2 && other.image_index <= 4) {
                hp -= 35; // Increased from 25 to 35!
                hit_stun_timer = 20; 
                
                if (other.facing == 1) x += 15;
                else x -= 15;
            }
        }
        
        // --- SPELL 2 DAMAGE SYSTEM (SUPER BUFFED) ---
        else if (_current_sprite == spr_spell2_right || _current_sprite == spr_spell2_left) {
            if (other.image_index >= 1 && other.image_index <= 3) {
                hp -= 60; // Increased from 35 to 60! (One-shot kill)
                hit_stun_timer = 30; 
                
                if (other.facing == 1) x += 25;
                else x -= 25;
            }
        }
        
        // --- REGULAR MELEE ATTACKS ---
        else {
            if (other.image_index >= 1 && other.image_index <= 3) {
                hp -= 15; // Kept at 15 basic damage
                hit_stun_timer = 15; 
                
                if (other.facing == 1) x += 10;
                else x -= 10;
            }
        }
    }
}