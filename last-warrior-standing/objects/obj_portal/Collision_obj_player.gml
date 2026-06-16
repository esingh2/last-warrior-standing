// 1. Only run if the player's safety cooldown is ready
if (other.portal_cooldown <= 0) {
    
    // 2. If we explicitly set coordinates in the Instance Creation Code, use them!
    if (portal_target_x != -1 && portal_target_y != -1) {
        other.x = portal_target_x;
        other.y = portal_target_y;
        other.portal_cooldown = 20;
    } 
    // 3. AUTOMATIC FINDER: If no coordinates are set, find the other portal in the room
    else if (is_entrance) {
        // Find the nearest portal object that is NOT this specific instance
        var _total_portals = instance_number(obj_portal);
        
        for (var i = 0; i < _total_portals; i++) {
            var _check_portal = instance_find(obj_portal, i);
            
            // If it's a different portal instance, that's our exit!
            if (_check_portal != id) {
                other.x = _check_portal.x;
                other.y = _check_portal.y;
                other.portal_cooldown = 20; // Prevent looping back
                break;
            }
        }
    }
}