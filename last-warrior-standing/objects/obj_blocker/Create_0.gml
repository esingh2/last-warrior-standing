visible = false; // All blockers stay completely invisible forever!

// If group_id is 0, it's a permanent invisible wall.
// If group_id is greater than 0, it waits for the lever.
if (group_id > 0) {
    is_active = false; // Starts turned off
} else {
    is_active = true;  // Permanent ones start turned on
}