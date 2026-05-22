// COLLECTING STUFF

// MOVEMENT VARIABLES
move_speed = 5;
jump_speed = -15;
gravity_force = 0.5;
max_fall_speed = 10;
move_x = 0;
move_y = 0;

// STATE VARIABLES
is_grounded = false;
is_climbing = false;
climb_speed = 2.5;

// OBJECT REFERENCES
ground_object = obj_ground;
blocker_object = obj_blocker