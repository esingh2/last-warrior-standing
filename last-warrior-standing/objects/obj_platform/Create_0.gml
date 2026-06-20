is_puzzle_ground = true; // Tells the player this is a puzzle block
is_active = false;       // Starts with collisions turned off
group_id = 1;            // Match this number to your lever's group_id in the Room Editor

// Movement settings
move_speed = 0.5;       // Speed at which the platform floats up
start_y = y;            // Remembers where the platform started
max_up_distance = 128;  // How many pixels up it will travel before stopping