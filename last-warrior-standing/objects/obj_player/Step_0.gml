// If a text box exists, freeze the player and skip the rest of the step event
if (instance_exists(obj_textbox)) {
    exit; 
}

// Tick down the portal safety cooldown
if (portal_cooldown > 0) {
    portal_cooldown--;
}

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

// CROUCH CHECK
if (is_grounded && crouch_input && !is_dashing && !is_attacking) {
    is_crouching = true;
} else {
    is_crouching = false;
}

// TRIGGER ATTACK 
if (attack_input && !is_dashing && !is_attacking && !is_crouch_attacking) { 
    if (mouse_x > x) facing = 1;
    else facing = -1;

    if (is_crouching) {
        is_crouch_attacking = true;
        image_index = 0;
        if (facing == 1) sprite_index = spr_crouch_attack_right;
        else sprite_index = spr_crouch_attack_left;
    } else {
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

// TRIGGER SPELL
if (spell_input && spell_cooldown_timer <= 0 && !is_dashing && !is_attacking && !is_crouch_attacking) {
    is_attacking = true; 
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

if (dash_cooldown_timer > 0) dash_cooldown_timer--;
if (spell_cooldown_timer > 0) spell_cooldown_timer--;

// BLOCKER CALCULATIONS
var _h_modifier = 1.0;
var _v_modifier = 1.0;

if (place_meeting(x + move_dir * move_speed, y, blocker_object) || place_meeting(x, y, blocker_object)) {
    _h_modifier = blocked_speed / move_speed;
}
if (place_meeting(x, y, blocker_object)) {
    _v_modifier = blocked_speed / move_speed; 
}

// MOVEMENT STATES
if (is_attacking || is_crouch_attacking) {
    move_x = 0;
    if (!is_grounded && move_y < max_fall_speed) {
        move_y += gravity_force * _v_modifier;
    }
}
else if (is_dashing) {
    move_x = (facing * dash_speed) * _h_modifier;
    move_y = 0;
    dash_timer--;
    if (dash_timer <= 0) {
        is_dashing = false;
        dash_cooldown_timer = dash_cooldown; 
    }
} 
else if (is_crouching) {
    move_x = move_dir * (move_speed * 0.4) * _h_modifier;
}
else {
    move_x = move_dir * move_speed * _h_modifier; 
}

// VERTICAL MOVEMENT
is_grounded = place_meeting(x, y+2, ground_object) || place_meeting(x, y+2, blocker_object);
is_ceiling = place_meeting(x, y-2, ground_object) || place_meeting(x, y-2, blocker_object);

if (is_grounded) {
    move_y = 0;
    if (jump_pressed && !is_attacking && !is_crouch_attacking && !is_crouching) { 
        move_y = jump_speed * _v_modifier;
    }
} else if (!is_attacking && !is_crouch_attacking && move_y < max_fall_speed) { 
    move_y += gravity_force * _v_modifier;
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
    if (facing == 1) sprite_index = spr_dash_right;
    else sprite_index = spr_dash_left;
} 
else if (!is_grounded) {
    if (facing == 1) sprite_index = spr_jump_right; 
    else sprite_index = spr_jump_left;
    
    image_speed = 0; 
    if (move_y < -1) image_index = 0; 
    else if (move_y >= -1 && move_y <= 1) image_index = 1; 
    else image_index = 2; 
}
else if (is_crouching) {
    var target_crouch_sprite = (facing == 1) ? spr_crouch_right : spr_crouch_left;
    if (sprite_index != target_crouch_sprite) {
        sprite_index = target_crouch_sprite;
        image_index = 0;
    }
    if (image_index >= image_number - 1) {
        image_speed = 0;
        image_index = image_number - 1; 
    } else {
        image_speed = 1;
    }
}
else {
    image_speed = 1; 
    if (move_dir > 0) sprite_index = spr_walk_right;
    else if (move_dir < 0) sprite_index = spr_walk_left;
    else {
        if (facing == 1) sprite_index = spr_idle_right;
        else sprite_index = spr_idle_left;
    }
}

// ROOM BOUNDS
if (y < -200 || y > room_height+20 || x < -20 || x > room_width+20) {
    room_restart();
}

// MOVE PLAYER
move_and_collide(move_x, move_y, [ground_object, blocker_object, obj_npc_main]);

// INTERACTABLES (Padded checking to read through solid collisions)
var _interact_target = instance_place(x + (facing * 2), y, obj_interactable);
if (_interact_target == noone) _interact_target = instance_place(x, y + 2, obj_interactable);
if (_interact_target == noone) _interact_target = instance_place(x, y - 2, obj_interactable);

if (_interact_target != noone) {
    if (keyboard_check(ord("E"))) {
        interact_timer += 1; 
        if (interact_timer >= 90) {
            switch (_interact_target.action_type) {
                case "next_room":
                    if (room_exists(room_next(room))) room_goto_next();
                    break;
                case "chest":
                    show_debug_message("Opened a chest!");
                    break;
                case "lever":
                    show_debug_message("Pulled a lever!");
                    break;
                case "npc":
                    var _dialogue = variable_instance_exists(_interact_target, "dialogue_text") ? _interact_target.dialogue_text : "Hello!";
                    var _should_fade = variable_instance_exists(_interact_target, "destroy_after_dialogue") ? _interact_target.destroy_after_dialogue : false;
                    var _box = instance_create_layer(0, 0, "Instances", obj_textbox);
                    _box.text_message = _dialogue;
                    if (_should_fade) {
                        with (_interact_target) {
                            is_fading = true;
                            mask_index = -1;
                        }
                    }
                    break;
            }
            interact_timer = 0;
        }
    } else {
        interact_timer = max(0, interact_timer - 2); 
    }
} else {
    interact_timer = 0;
}