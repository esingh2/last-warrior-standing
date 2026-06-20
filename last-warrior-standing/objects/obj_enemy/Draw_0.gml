// 1. First, tell GameMaker to draw the enemy's normal sprite layout
draw_self();

// 2. Only draw the health bar if the enemy is active and visible
if (visible) {
    // Calculate current health percentage
    var _hp_percentage = (hp / max_hp) * 100;
    
    // Set up health bar dimensions relative to enemy's position
    var _bar_width = 32;
    var _bar_height = 4;
    var _offset_y = 24; // How high above the enemy center to place the bar
    
    var _x1 = x - (_bar_width / 2);
    var _y1 = y - _offset_y;
    var _x2 = x + (_bar_width / 2);
    var _y2 = _y1 + _bar_height;
    
    // Draw the health bar (Back color dark red, bar color bright red/green mix)
    draw_healthbar(_x1, _y1, _x2, _y2, _hp_percentage, c_black, c_maroon, c_red, 0, true, true);
}