// COLLECTING STUFF

// MOVEMENT VARIABLES
move_speed = 5;
jump_speed = -15;
gravity_force = 0.5;
max_fall_speed = 10;
move_x = 0;
move_y = 0;

// Attacks & Abilities
attack_combo = 0;
spell_cooldown_timer = 0; 
spell_cooldown_max = 240;

// DASH 
// Speed
dash_speed = 10;
// Time and Cooldown
dash_time = 15;
dash_timer = 0;
dash_cooldown = 80; 
dash_cooldown_timer = 0;
// Facing
facing = 1;

// STATE VARIABLES
is_grounded = false;
is_dashing = false;
is_attacking = false;
is_crouching = false;
is_crouch_attacking = false;
 // is_climbing = false;
 // climb_speed = 2.5;
 
// Blocker
blocked_speed = 1.5;

// OBJECT REFERENCES
ground_object = obj_ground;
blocker_object = obj_blocker;