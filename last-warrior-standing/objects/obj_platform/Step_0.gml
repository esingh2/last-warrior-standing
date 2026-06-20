// 1. Only run if the lever has activated the platform and made it visible
if (visible) {
    
    // 2. Only run if the enemy has been killed
    if (!instance_exists(obj_enemy)) {
        
        // 3. Find the specific solid obj_ground block overlapping this platform
        var _my_ground = instance_place(x, y, obj_ground);
        
        // Find the blocker object overlapping this platform
        var _my_blocker = instance_place(x, y, obj_blocker); // Make sure this matches your blocker's object name!
        
        // 4. Check if the player is standing on top of this visual platform
        var _player_on_top = instance_place(x, y - 2, obj_player);
        
        if (_player_on_top != noone) {
            
            // 5. REMOVED THE MAX HEIGHT CHECK - Now it moves up endlessly!
            
            // Move this visual platform up
            y -= move_speed;
            
            // Move the player up so they stay synced
            _player_on_top.y -= move_speed;
            
            // Move the matching ground block up if it exists
            if (_my_ground != noone) {
                _my_ground.y -= move_speed;
            }
            
            // Move the blocker object up at the exact same speed
            if (_my_blocker != noone) {
                _my_blocker.y -= move_speed;
            }
        }
    }
}