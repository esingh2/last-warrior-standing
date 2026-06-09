// 1. INPUTS & DIRECTION
var move_dir = keyboard_check(ord("D")) - keyboard_check(ord("A"));
jump_pressed = keyboard_check_pressed(vk_space);
dash_input = keyboard_check_pressed(vk_shift);
attack_input = mouse_check_button_pressed(mb_left);
spell_input = mouse_check_button_pressed(mb_right);
crouch_input = keyboard_check(ord("S"));
// FACING (FOR ABILITIES & DASH)
if (move_dir != 0) {
    facing = move_dir;
}

// CROUCH CHECK (Only on the ground, and not during locked states)
if (is_grounded && crouch_input && !is_dashing && !is_attacking) {
    is_crouching = true;
} else {
    is_crouching = false;
}

// TRIGGER ATTACK 
if (attack_input && !is_dashing && !is_attacking && !is_crouch_attacking) { 
    
    // Update facing direction based on mouse position first
    if (mouse_x > x) facing = 1;
    else facing = -1;

    if (is_crouching) {
        // Trigger Crouch Attack
        is_crouch_attacking = true;
        image_index = 0;
        
        if (facing == 1) sprite_index = spr_crouch_attack_right;
        else sprite_index = spr_crouch_attack_left;
        
    } else {
        // Trigger Normal Attack Combo
        is_attacking = true;
        image_index = 0;
        
        if (attack_combo == 0) {
            if (facing == 1) sprite_index = spr_attack_right;
            else sprite_index = spr_attack_left;
            attack_combo = 1;
        }
        else if (attack_combo == 1) {
            if (facing == 1) sprite_index = spr_attack_k2_right;
            else sprite_index = spr_attack_k2_left;
            attack_combo = 0;
        }
    }
}

// TRIGGER SPELL (Prevent casting mid-crouch-attack)
if (spell_input && spell_cooldown_timer <= 0 && !is_dashing && !is_attacking && !is_crouch_attacking) {
    is_attacking = true; // Treats spellcast as normal attack state lock
    image_index = 0;
    
    if (mouse_x > x) facing = 1;
    else facing = -1;
    
    if (facing == 1) sprite_index = spr_spell_right;
    else sprite_index = spr_spell_left;

    spell_cooldown_timer = spell_cooldown_max;
}

// DASH TRIGGER & TIMERS
if (dash_input && dash_cooldown_timer <= 0 && !is_dashing && !is_attacking && move_dir != 0) {
    is_dashing = true;
    dash_timer = dash_time;
}

// Dash Cooldown Timer
if (dash_cooldown_timer > 0) {
    dash_cooldown_timer--;
}

// Spell Cooldown Timer
if (spell_cooldown_timer > 0) {
    spell_cooldown_timer--;
}

// MOVEMENT
if (is_attacking || is_crouch_attacking) {
    move_x = 0;
    
    // Gravity calculation during attack
    if (!is_grounded && move_y < max_fall_speed) {
        move_y += gravity_force;
    }
}
else if (is_dashing) {
    move_x = facing * dash_speed;
    move_y = 0; // Keep vertical movement locked during dash
    dash_timer--;
    
    // Check if dash finished
    if (dash_timer <= 0) {
        is_dashing = false;
        dash_cooldown_timer = dash_cooldown; 
    }
} 
else if (is_crouching) {
    // You can change '0' to 'move_dir * (move_speed * 0.4)' if you want a crouch-walk
move_x = move_dir * (move_speed * 0.4);
}
else {
    // Normal walking movement
    move_x = move_dir * move_speed; 
}


// 4. VERTICAL MOVEMENT (Jumping / Gravity)
is_grounded = place_meeting(x, y+2, ground_object);
is_ceiling = place_meeting(x, y-2, ground_object);

if (is_grounded) {
    move_y = 0;
if (jump_pressed && !is_attacking && !is_crouch_attacking && !is_crouching) { 
        move_y = jump_speed;
    }
} else if (!is_attacking && !is_crouch_attacking && move_y < max_fall_speed) { 
    move_y += gravity_force;
}

if (is_ceiling && move_y < 0) {
    move_y = 0;
}


// PLAYER ANIMATIONS
if (is_crouch_attacking) {
    image_speed = 1;
}
else if (is_attacking) {
    image_speed = 1; 
}
else if (is_dashing) {
    image_speed = 1;
    if (facing == 1) {
        sprite_index = spr_dash_right;
    } else { 
        sprite_index = spr_dash_left;
    }
} 
else if (!is_grounded) {
    if (facing == 1) {
        sprite_index = spr_jump_right; 
    } else {
        sprite_index = spr_jump_left; 
    }
    
    image_speed = 0; 
    
    if (move_y < -1) {
        image_index = 0; 
    } 
    else if (move_y >= -1 && move_y <= 1) {
        image_index = 1; 
    } 
    else {
        image_index = 2; 
    }
}
else if (is_crouching) {
    var target_crouch_sprite = (facing == 1) ? spr_crouch_right : spr_crouch_left;
    
    // Only change the sprite if we aren't already using it (prevents animation resetting)
    if (sprite_index != target_crouch_sprite) {
        sprite_index = target_crouch_sprite;
        image_index = 0; // Start the transition cleanly
    }
    
    // If the animation reaches the last frame, freeze it there so they stay down
    if (image_index >= image_number - 1) {
        image_speed = 0;
        image_index = image_number - 1; 
    } else {
        image_speed = 1; // Play the crouch-down transition
    }
}
else {
    image_speed = 1; 
    
    if (move_dir > 0) {
        sprite_index = spr_walk_right;
    }
    else if (move_dir < 0) {
        sprite_index = spr_walk_left;
    }
    else {
        if (facing == 1) {
            sprite_index = spr_idle_right;
        } else {
            sprite_index = spr_idle_left;
        }
    }
}

// 5. ROOM BOUNDS & COLLISIONS
if (y < -200 || y > room_height+20 || x < -20 || x > room_width+20) {
    room_restart();
}

// BLOCKER
if (place_meeting(x, y, obj_blocker)) {
    move_x *= blocked_speed;
} else {
    // If not touching the blocker, make sure we use normal speed
    move_x *= move_speed; 
}

// ACTUALLY MOVE THE PLAYER
move_and_collide(move_x, move_y, ground_object);

// COLLECTED

// GO TO NEXT ROOM