// If a text box exists, freeze the player and skip the rest of the step event
if (instance_exists(obj_textbox)) {
    exit; 
}

// Tick down the portal safety cooldown
if (portal_cooldown > 0) {
    portal_cooldown--;
}

// Tick down the key popup display timer
if (instructions_popup_timer > 0) {
    instructions_popup_timer--;
}

// 1. INPUTS & DIRECTION
var move_dir = keyboard_check(ord("D")) - keyboard_check(ord("A"));
jump_pressed = keyboard_check_pressed(vk_space);
dash_input = keyboard_check_pressed(vk_shift);
attack_input = mouse_check_button_pressed(mb_left);
spell_input = mouse_check_button_pressed(mb_right);
spell2_input = keyboard_check_pressed(ord("F")); // Input for Spell 2
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

// TRIGGER SPELL 2 (Requires Sword collected from obj_ability_unlock)
if (spell2_input && variable_instance_exists(id, "has_sword") && has_sword) {
    if (spell2_cooldown_timer <= 0 && !is_dashing && !is_attacking && !is_crouch_attacking) {
        is_attacking = true;
        image_index = 0;
        if (mouse_x > x) facing = 1;
        else facing = -1;
        
        if (facing == 1) sprite_index = spr_spell2_right;
        else sprite_index = spr_spell2_left;
        
        spell2_cooldown_timer = spell2_cooldown_max;

        // --- SPECIAL WALL DESTRUCTION LOGIC ---
        var check_distance = 32;
        var target_x = x + (facing * check_distance);
        var target_y = y;

        var hit_wall = instance_place(target_x, target_y, obj_wall);
        if (hit_wall != noone) {
            with (hit_wall) {
                instance_destroy(); 
            }
        }
    }
}

// DASH TRIGGER & TIMERS
if (dash_input && dash_cooldown_timer <= 0 && !is_dashing && !is_attacking && move_dir != 0) {
    is_dashing = true;
    dash_timer = dash_time;
}

if (dash_cooldown_timer > 0) dash_cooldown_timer--;
if (spell_cooldown_timer > 0) spell_cooldown_timer--;
if (variable_instance_exists(id, "spell2_cooldown_timer") && spell2_cooldown_timer > 0) spell2_cooldown_timer--;

// ==========================================
// FIXED BLOCKER CALCULATIONS (IGNORES INACTIVE)
// ==========================================
var _h_modifier = 1.0;
var _v_modifier = 1.0;

var _h_blocker = instance_place(x + move_dir * move_speed, y, blocker_object);
if (_h_blocker == noone) _h_blocker = instance_place(x, y, blocker_object); 

if (_h_blocker != noone && _h_blocker.is_active) {
    _h_modifier = blocked_speed / move_speed;
}

var _v_blocker = instance_place(x, y, blocker_object);
if (_v_blocker != noone && _v_blocker.is_active) {
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

// ==========================================
// VERTICAL MOVEMENT & GROUND RUNTIME CHECK
// ==========================================
var bridge_grounded = false;

var hit_bridge = instance_place(x, y + 2, obj_wall_bridge);
if (hit_bridge != noone && hit_bridge.visible) {
    bridge_grounded = true;
}

var _ground_below = instance_place(x, y + 2, ground_object);
var _ground_grounded = (_ground_below != noone);

// Only filter out structural puzzle ground chunks if they are specifically marked and inactive
if (_ground_below != noone && variable_instance_exists(_ground_below, "is_puzzle_ground")) {
    if (!_ground_below.is_active) _ground_grounded = false;
}

var _ground_above = instance_place(x, y - 2, ground_object);
var _ground_ceiling = (_ground_above != noone);
if (_ground_above != noone && variable_instance_exists(_ground_above, "is_puzzle_ground")) {
    if (!_ground_above.is_active) _ground_ceiling = false;
}

var _blocker_below = instance_place(x, y + 2, blocker_object);
var _blocker_grounded = (_blocker_below != noone && _blocker_below.is_active);

var _blocker_above = instance_place(x, y - 2, blocker_object);
var _blocker_ceiling = (_blocker_above != noone && _blocker_above.is_active);

is_grounded = _ground_grounded || _blocker_grounded || bridge_grounded;
is_ceiling = _ground_ceiling || _blocker_ceiling;

if (is_grounded) {
    move_y = 0; 
    if (jump_pressed && !is_attacking && !is_crouch_attacking && !is_crouching) { 
        move_y = jump_speed * _v_modifier;
    }
} 
else if (!is_attacking && !is_crouch_attacking && move_y < max_fall_speed) { 
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

// =========================================================================
// WALL JUMP & WALL HANG MECHANICS
// =========================================================================
var basic_wall_left  = place_meeting(x - 4, y, ground_object);
var basic_wall_right = place_meeting(x + 4, y, ground_object);

var _plat_check_left = instance_place(x - 4, y, ground_object);
if (_plat_check_left != noone && variable_instance_exists(_plat_check_left, "is_puzzle_ground")) {
    if (!_plat_check_left.is_active) basic_wall_left = false;
}

var _plat_check_right = instance_place(x + 4, y, ground_object);
if (_plat_check_right != noone && variable_instance_exists(_plat_check_right, "is_puzzle_ground")) {
    if (!_plat_check_right.is_active) basic_wall_right = false;
}

if (!is_grounded && (basic_wall_left || basic_wall_right) && move_y >= 0) {
    is_wall_hanging = true;
} else {
    is_wall_hanging = false;
}

if (is_wall_hanging) {
    move_y = 0; 
    if (basic_wall_left) {
        move_x = 0; 
        facing = 1; 
        sprite_index = spr_wall_hang_left; 
    } else if (basic_wall_right) {
        move_x = 0; 
        facing = -1; 
        sprite_index = spr_wall_hang_right;
    }
    
    if (jump_pressed) {
        if (basic_wall_left) {
            move_x = move_speed * 1.5; 
            facing = 1;
            sprite_index = spr_wall_climb_right;
        } else if (basic_wall_right) {
            move_x = -move_speed * 1.5;
            facing = -1;
            sprite_index = spr_wall_climb_left;
        }
        
        move_y = jump_speed * _v_modifier; 
        is_wall_hanging = false;
        image_index = 0;
    }
}

// ==========================================
// DYNAMIC COLLISION MANAGEMENT FOR MOVE_AND_COLLIDE
// ==========================================
var _collision_list = [obj_npc_main, obj_wall];

with(ground_object) {
    var _can_collide = true;
    if (variable_instance_exists(id, "is_puzzle_ground")) {
        if (!is_active) {
            _can_collide = false;
        }
    }
    if (_can_collide) {
        array_push(_collision_list, id); 
    }
}

with(blocker_object) {
    if (is_active) {
        array_push(_collision_list, id);
    }
}

with(obj_wall_bridge) {
    if (visible) {
        array_push(_collision_list, id);
    }
}

move_and_collide(move_x, move_y, _collision_list);

// ==========================================
// INTERACTABLES PROCESSING
// ==========================================
var _interact_target = instance_place(x + (facing * 12), y, obj_interactable);
if (_interact_target == noone) _interact_target = instance_place(x, y + 12, obj_interactable);
if (_interact_target == noone) _interact_target = instance_place(x, y - 12, obj_interactable);
if (_interact_target == noone) _interact_target = instance_place(x, y, obj_interactable); 

var _sword_target = instance_place(x, y, obj_ability_unlock);
if (_sword_target == noone) _sword_target = instance_place(x + (facing * 12), y, obj_ability_unlock);
if (_sword_target == noone) _sword_target = instance_place(x, y + 12, obj_ability_unlock);
if (_sword_target == noone) _sword_target = instance_place(x, y - 12, obj_ability_unlock);

if (_interact_target != noone || _sword_target != noone) {
    if (keyboard_check(ord("E"))) {
        interact_timer += 1; 
        if (interact_timer >= 90) {
            
            if (_sword_target != noone) {
                if (variable_instance_exists(id, "has_instructions") && has_instructions) {
                    has_sword = true;
                    var _sword_box = instance_create_layer(0, 0, "Instances", obj_textbox);
                    _sword_box.text_message = "You gathered both the instructions and the Sword! Spell 2 unlocked! Press F to strike!";
                    instance_destroy(_sword_target); 
                } else {
                    var _fail_box = instance_create_layer(0, 0, "Instances", obj_textbox);
                    _fail_box.text_message = "The sword is locked tight inside. Check the cage mechanisms first.";
                }
            } 
            else if (_interact_target != noone) {
                switch (_interact_target.action_type) {
                    case "next_room":
                        if (room_exists(room_next(room))) room_goto_next();
                        break;
                    case "chest":
                        has_key = true;
                        has_instructions = true; 
                        instructions_popup_timer = instructions_popup_max_time;
                        
                        var _chest_box = instance_create_layer(0, 0, "Instances", obj_textbox);
                        _chest_box.text_message = "New Ability: Wall Hanging! Jump toward the sides of the cage and press SPACE to leap upwards!";
                        
                        with (_interact_target) {
                            action_type = "opened_chest"; 
                        }
                        break;
                   case "lever":
                        var _ground_asset = ground_object; 
                        
                        with (_interact_target) {
                            if (!is_pulled) {
                                is_pulled = true;
                                sprite_index = spr_lever_green; 
                                image_index = 0;
                                image_speed = 1; 
                                
                                var my_group = group_id; 
                                
                                // --- 1. VANISH SPECIFIC ARROWS MATCHING THE GROUP ---
                                with (obj_arrow) {
                                    if (variable_instance_exists(id, "group_id") && group_id == my_group) {
                                        instance_destroy();
                                    }
                                }
                                
                                // --- 2. ACTIVATE BLOCKERS ---
                                with (other.blocker_object) {
                                    if (variable_instance_exists(id, "group_id") && group_id == my_group) {
                                        is_active = true; 
                                    }
                                }
                                
                                // --- 3. ACTIVATE HIDDEN SOLID GROUND ---
                                with (_ground_asset) {
                                    if (variable_instance_exists(id, "group_id") && group_id == my_group) {
                                        is_active = true; 
                                    }
                                }
                                
                                // --- 4. MAKE EXISTING PLATFORM VISIBLE ---
                                with (obj_platform) {
                                    if (variable_instance_exists(id, "group_id") && group_id == my_group) {
                                        visible = true;
                                    }
                                }
                                
                                // --- 5. MAKE EXISTING ENEMY VISIBLE ---
                                with (obj_enemy) {
                                    if (variable_instance_exists(id, "group_id") && group_id == my_group) {
                                        visible = true;
                                    }
                                }
                            }
                        }
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
            }
            interact_timer = 0;
        }
    } else {
        interact_timer = max(0, interact_timer - 2); 
    }
} else {
    interact_timer = 0;
}