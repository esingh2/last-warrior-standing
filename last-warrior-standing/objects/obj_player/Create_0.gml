// COLLECTING STUFF
interact_timer = 0;
// INVENTORY
has_key = false;
key_popup_timer = 0;       // Keeps track of how long the text stays on screen
key_popup_max_time = 180;  // 180 frames = 3 seconds at 60FPS

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
 
// Blocker
blocked_speed = 1;

// OBJECT REFERENCES
ground_object = obj_ground;
blocker_object = obj_blocker;
room_object = obj_interactable

// --- SOLID LIGHT GRAY OUTLINE (NO GAP) ---
player_surf = -1;
outline_thickness = 1;   
outline_gap = 0;         
outline_color = c_ltgray; 
outline_alpha = 0.8;

// Position of your cooldown box on the screen
box_x = 32;  
box_y = 32;  

// Health Bar
hp = 100;     
max_hp = 100; 

// Inherit any base NPC variables if you use a parent object
event_inherited();

destroy_after_dialogue = true; 

// Dialogue tracking
dialogue_text = "Thank you for listening! My business here is finished. Goodbye!";
is_talking = false;

// Portal
is_teleporting = false;
portal_cooldown = 0;