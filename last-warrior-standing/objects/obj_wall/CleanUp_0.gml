// Look at every single instance of obj_wall_bridge placed in the room
with (obj_wall_bridge) {
    // Force EVERY single one of them to become visible!
    visible = true;
    
    // Safety check: Make sure they have their collision masks active
    mask_index = sprite_index; 
}