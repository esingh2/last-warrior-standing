// INPUTS & DIRECTION
var move_dir = keyboard_check(ord("D")) - keyboard_check(ord("A"));
jump_pressed = keyboard_check_pressed(vk_space);
dash_input = keyboard_check_pressed(vk_shift);

// FACING (FOR ABILITES & DASH)
if (move_dir != 0) {
    facing = move_dir;
}

// DASH TRIGGER & TIMERS
if (dash_input && dash_cooldown_timer <= 0 && !is_dashing && move_dir != 0) {
    is_dashing = true;
    dash_timer = dash_time;
}

// Dash Cooldown Timer
if (dash_cooldown_timer > 0) {
    dash_cooldown_timer--;
}


// MOVEMENT
if (is_dashing) {
    move_x = facing * dash_speed;
    dash_timer--;
    
    // Check if dash finished
    if (dash_timer <= 0) {
        is_dashing = false;
        dash_cooldown_timer = dash_cooldown; // Start the 20-frame cooldown
    }
} else {
    // Normal walking movement
    move_x = move_dir * move_speed; 
}


// 4. VERTICAL MOVEMENT (Jumping / Gravity)
is_grounded = place_meeting(x, y+2, ground_object);
is_ceiling = place_meeting(x, y-2, ground_object);

if (is_grounded) {
    move_y = 0;
    if (jump_pressed) {
        move_y = jump_speed;
    }
} else if (move_y < max_fall_speed) {
    move_y += gravity_force;
}

if (is_ceiling && move_y < 0) {
    move_y = 0;
}

// PLAYER ANIMATIONS
if (is_dashing) {
    image_speed = 1;
    if (facing == 1) {
        sprite_index = spr_dash_right;
    } else { 
        sprite_index = spr_dash_left;
    }
} 
else if (!is_grounded) {
    // Airborne Animations
    if (facing == 1) {
        sprite_index = spr_jump_right; 
    } else {
        sprite_index = spr_jump_left; 
    }
    
    // Explicitly freeze the speed here so it doesn't loop automatically
    image_speed = 0; 
    
    // Choose the exact frame based on vertical movement
    if (move_y < -1) {
        image_index = 0; // First frame: Rising
    } 
    else if (move_y >= -1 && move_y <= 1) {
        image_index = 1; // Second frame: Apex/Peak
    } 
    else {
        image_index = 2; // Third frame: Falling
    }
}
else {
    // Grounded Animations
    image_speed = 1; // Explicitly turn image speed BACK ON for ground movement
    
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
}

// ACTUALLY MOVE THE PLAYER
move_and_collide(move_x, move_y, ground_object);
show_debug_message("move_x: " + string(move_x) + " | move_y: " + string(move_y) + " | grounded: " + string(is_grounded));
// COLLECTED

// GO TO NEXT ROOM
