// =========================================================================
// DRAW GUI EVENT - AUTOMATICALLY SNAPS TO BOTTOM-CENTER OF YOUR SCREEN
// =========================================================================

// --- 1. GET THE ACTUAL SCREEN/GUI DIMENSIONS ---
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// --- 2. SET UP THE UNIFORM BUBBLE LOOK (SUPER-SIZED) ---
var box_size = 80;         // <-- MASSIVE BUBBLE SIZE (Was 48)
var spacing = 16;          // Slightly wider gap for bigger boxes
var bubble_roundness = 24; // Much higher roundness so they stay soft and bubbly

// MATH TO AUTOMATICALLY CENTER ON ANY SCREEN SIZE
var total_hud_width = (box_size * 2) + spacing; 

// Snaps to the exact middle of the width and sits at the bottom
var start_x = (gui_w / 2) - (total_hud_width / 2);
var start_y = gui_h - (box_size + 20); // 20 pixels up from the true bottom edge

// Safely get current game FPS for the timer math
var current_fps = game_get_speed(gamespeed_fps);

// Set smooth text alignment for numbers
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


// --- 2. DRAW THE DASH BUBBLE ---
var dash_x = start_x;
var dash_y = start_y;

// Draw Bubbly Background Outer Glow/Border
draw_set_color(c_white);
draw_set_alpha(0.15);
draw_roundrect_ext(dash_x - 3, dash_y - 3, dash_x + box_size + 3, dash_y + box_size + 3, bubble_roundness + 2, bubble_roundness + 2, false);

// Draw Base Dark Bubble Background
draw_set_color(c_dkgray);
draw_set_alpha(0.8);
draw_roundrect_ext(dash_x - 1, dash_y - 1, dash_x + box_size + 1, dash_y + box_size + 1, bubble_roundness, bubble_roundness, false);
draw_set_alpha(1.0); 

// --- DYNAMIC SCALE FOR DASH ICON (44x11 Rectangle) ---
var dash_scale_w = box_size / sprite_get_width(spr_dash_icon);
var dash_scale_h = dash_scale_w; 
var dash_icon_y_offset = (box_size - (sprite_get_height(spr_dash_icon) * dash_scale_h)) / 2;

// Draw the Dash Icon
draw_sprite_ext(spr_dash_icon, 0, dash_x, dash_y + dash_icon_y_offset, dash_scale_w, dash_scale_h, 0, c_white, 1.0);

// Cooldown Overlay
if (dash_cooldown_timer > 0) {
    var center_x = dash_x + (box_size / 2);
    var center_y = dash_y + (box_size / 2);
    var radius   = (box_size / 2) + 1;
    
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_circle(center_x, center_y, radius, false); 
    draw_set_alpha(1.0);
    
    var display_time = string_format(dash_cooldown_timer / current_fps, 0, 1) + "s";
	draw_text_transformed_color(center_x, center_y, display_time, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, 1.0);
}

// BUBBLE GLOSS LAYER
draw_set_color(c_white);
draw_set_alpha(0.15);
draw_roundrect_ext(dash_x + 2, dash_y + 2, dash_x + box_size - 2, dash_y + (box_size / 2.5), bubble_roundness / 2, bubble_roundness / 2, false);
draw_set_alpha(1.0);


// --- 3. DRAW THE SPELL BUBBLE ---
var spell_x = dash_x + box_size + spacing;
var spell_y = start_y;

// Draw Bubbly Background Outer Glow/Border
draw_set_color(c_white);
draw_set_alpha(0.15);
draw_roundrect_ext(spell_x - 3, spell_y - 3, spell_x + box_size + 3, spell_y + box_size + 3, bubble_roundness + 2, bubble_roundness + 2, false);

// Draw Base Dark Bubble Background
draw_set_color(c_dkgray);
draw_set_alpha(0.8);
draw_roundrect_ext(spell_x - 1, spell_y - 1, spell_x + box_size + 1, spell_y + box_size + 1, bubble_roundness, bubble_roundness, false);
draw_set_alpha(1.0);

// --- DYNAMIC SCALE FOR SPELL ICON (500x500 Square) ---
var spell_scale = box_size / sprite_get_width(spr_spell1_icon);

// Draw the Spell Icon
draw_sprite_ext(spr_spell1_icon, 0, spell_x, spell_y, spell_scale, spell_scale, 0, c_white, 1.0);

// Cooldown Overlay
if (spell_cooldown_timer > 0) {
    var s_center_x = spell_x + (box_size / 2);
    var s_center_y = spell_y + (box_size / 2);
    var s_radius   = (box_size / 2) + 1;
    
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_circle(s_center_x, s_center_y, s_radius, false);
    draw_set_alpha(1.0);
    
    var display_time = string_format(spell_cooldown_timer / current_fps, 0, 1) + "s";
	draw_text_transformed_color(s_center_x, s_center_y, display_time, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, 1.0);
}

// BUBBLE GLOSS LAYER
draw_set_color(c_white);
draw_set_alpha(0.15);
draw_roundrect_ext(spell_x + 2, spell_y + 2, spell_x + box_size - 2, spell_y + (box_size / 2.5), bubble_roundness / 2, bubble_roundness / 2, false);
draw_set_alpha(1.0);

// --- CLEAN UP DRAW STATES ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);
