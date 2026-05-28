// CONTROLS
move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
move_x *= move_speed;
jump_pressed = keyboard_check_pressed(vk_space);
dash_input =  keyboard_check_pressed(vk_shift);

// CHECK FOR COLLISIONS
// Check if standing on ground
is_grounded = place_meeting(x, y+2, ground_object);
is_ceiling = place_meeting(x, y-2, ground_object);

// Check if touching a ladder

// MOVEMENT

// Dashing Controls
if (keyboard_check_pressed(vk_shift)) {
    if (dash_cooldown_timer <= 0 && !is_dashing) {
        is_dashing = true;
        dash_timer = dash_time;
        dash_cooldown_timer = dash_cooldown;

        show_debug_message("DASH STARTED");
    }
}
// Actually Dash
if (is_dashing) {
    move_x = facing * dash_speed;
    dash_timer--;

if (dash_timer <= 0) {
    is_dashing = false;
    }
}
// Dash Cooldown
if (dash_cooldown_timer > 0) {
    dash_cooldown_timer--;
}
// Facing
if keyboard_check(ord("D")) facing = 1;
if keyboard_check(ord("A"))  facing = -1;

// Climbing
  // if (is_climbing) {
	// move_y = keyboard_check(ord("S") - keyboard_check(ord("W"));
	// move_y *= climb_speed;
// }

// Jumping 
if (is_grounded) {
	move_y = 0;
	if (jump_pressed) {
	 move_y = jump_speed;
	}
}

// Falling 
else if (!is_grounded && move_y < max_fall_speed) {
	move_y += gravity_force;
  }

//  AVOID STICKING TO THE BOTTOM OF PLATFORMS
if (is_ceiling) {
	if (move_y < 0) {
	 move_y = 0;
   }
}

// OUTSIDE ROOM
if (y < -200 || y > room_height+20 || x < -20 || x > room_width+20) {
	room_restart();
}

// ACTUALLY MOVE THE PLAYER OBJECT
move_and_collide(move_x, move_y, ground_object);

// BLOCKER
if (place_meeting(x, y, obj_blocker)) {
	move_x *= blocked_speed;
}

// COLLECTED

// GO TO NEXT ROOM
