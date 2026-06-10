// --- 1. SET UP POSITIONING VARIABLES ---
// We place the boxes in the bottom-left corner of your 640x360 screen
var start_x = 20;
var start_y = 360 - 50; // 50 pixels up from the bottom edge
var box_size = 32;       // Match this to your sprite size
var spacing = 10;       // Gap between the two boxes

// --- 2. DRAW THE DASH BOX & COOLDOWN ---
var dash_x = start_x;
var dash_y = start_y;

// Draw a simple dark background box first
draw_set_color(c_dkgray); // Fixed spelling for GameMaker
draw_rectangle(dash_x - 2, dash_y - 2, dash_x + box_size + 2, dash_y + box_size + 2, false);

// Draw the actual Dash Icon inside the box
draw_sprite(spr_dash_icon, 0, dash_x, dash_y);

// If the dash is on cooldown, draw the dark shadow over it
if (dash_cooldown_timer > 0) {
    // Calculate how much of the cooldown is left (a percentage from 0.0 to 1.0)
    var dash_pct = dash_cooldown_timer / dash_cooldown;
    
    // Draw a semi-transparent black rectangle that shrinks downwards as it recharges
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(dash_x, dash_y + (box_size * (1 - dash_pct)), dash_x + box_size, dash_y + box_size, false);
    draw_set_alpha(1.0); // Always reset alpha back to normal!
}


// --- 3. DRAW THE SPELL BOX & COOLDOWN ---
// Shift the next box to the right by adding the size of the first box + our spacing
var spell_x = dash_x + box_size + spacing;
var spell_y = start_y;

// Draw a simple dark background box
draw_set_color(c_dkgray);
draw_rectangle(spell_x - 2, spell_y - 2, spell_x + box_size + 2, spell_y + box_size + 2, false);

// Draw the Spell Icon
draw_sprite(spr_spell1_icon, 0, spell_x, spell_y);

// If the spell is on cooldown, draw the dark shadow over it
if (spell_cooldown_timer > 0) {
    var spell_pct = spell_cooldown_timer / spell_cooldown_max;
    
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(spell_x, spell_y + (box_size * (1 - spell_pct)), spell_x + box_size, spell_y + box_size, false);
    draw_set_alpha(1.0); 
}