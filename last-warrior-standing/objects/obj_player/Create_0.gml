// COLLECTING STUFF
interact_timer = 0;

// MOVEMENT VARIABLES
move_speed = 3;
jump_speed = -6.5;
gravity_force = 0.30;
max_fall_speed = 5.5;
move_x = 0;
move_y = 0;

// Attacks & Abilities
attack_combo = 0;
spell_cooldown_timer = 0; 
spell_cooldown_max = 240;

// DASH 
// Speed
dash_speed = 7;
// Time and Cooldown
dash_time = 12;
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
blocked_speed = 1;

// OBJECT REFERENCES
ground_object = obj_ground;
blocker_object = obj_blocker;
room_object = obj_interactable

// --- SOLID LIGHT GRAY OUTLINE (NO GAP) ---
player_surf = -1;
outline_thickness = 1;   // Kept at a solid 1-pixel thickness for sharp edges
outline_gap = 0;         // <-- Removed the gap completely!
outline_color = c_ltgray; // Your favorite soft light gray color
outline_alpha = 0.8;

// Position of your cooldown box on the screen
box_x = 32;  // 32 pixels from the left side of the screen
box_y = 32;  // 32 pixels from the top of the screen

// Health Bar
hp = 100;     // Or whatever your starting health is
max_hp = 100; // Your maximum health