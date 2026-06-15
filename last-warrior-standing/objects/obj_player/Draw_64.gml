// =========================================================================
// DRAW GUI EVENT - SLEEK HUD SYSTEM (SNAPS TO BOTTOM-CENTER)
// =========================================================================

// --- 1. GET THE ACTUAL SCREEN/GUI DIMENSIONS ---
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// --- 2. SET UP THE UNIFORM BUBBLE LOOK (SUPER-SIZED) ---
var box_size = 80;          // <-- MASSIVE BUBBLE SIZE
var spacing = 16;           // Slightly wider gap for bigger boxes
var bubble_roundness = 24;  // High roundness for soft, bubbly edges

// MATH TO AUTOMATICALLY CENTER ON ANY SCREEN SIZE
var total_hud_width = (box_size * 2) + spacing; 

// Base alignment coordinates for the entire HUD unit
var start_x = (gui_w / 2) - (total_hud_width / 2);
var start_y = gui_h - (box_size + 75); // Safe clearance height

// Safely get current game FPS for the timer math
var current_fps = game_get_speed(gamespeed_fps);


// =========================================================================
// --- 3. DRAW THE DASH BUBBLE ---
// =========================================================================
var dash_x = start_x;
var dash_y = start_y;

// Set smooth text alignment for cooldown numbers
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw Bubbly Background Outer Glow/Border
draw_set_color(c_white);
draw_set_alpha(0.15);
draw_roundrect_ext(dash_x - 3, dash_y - 3, dash_x + box_size + 3, dash_y + box_size + 3, bubble_roundness + 2, bubble_roundness + 2, false);

// Draw Base Dark Bubble Background
draw_set_color(c_dkgray);
draw_set_alpha(0.8);
draw_roundrect_ext(dash_x - 1, dash_y - 1, dash_x + box_size + 1, dash_y + box_size + 1, bubble_roundness, bubble_roundness, false);
draw_set_alpha(1.0); 

// --- DYNAMIC SCALE & CENTERING FOR DASH ICON ---
var dash_scale_w = box_size / sprite_get_width(spr_dash_icon);
var dash_scale_h = dash_scale_w; 

// Calculate exact center offsets assuming Top-Left (0,0) sprite origin
var dash_icon_x_offset = (box_size - (sprite_get_width(spr_dash_icon) * dash_scale_w)) / 2;
var dash_icon_y_offset = (box_size - (sprite_get_height(spr_dash_icon) * dash_scale_h)) / 2;

// Draw the Dash Icon centered
draw_sprite_ext(spr_dash_icon, 0, dash_x + dash_icon_x_offset, dash_y + dash_icon_y_offset, dash_scale_w, dash_scale_h, 0, c_white, 1.0);

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


// =========================================================================
// --- 4. DRAW THE SPELL BUBBLE ---
// =========================================================================
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

// --- DYNAMIC SCALE FOR SPELL ICON ---
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


// =========================================================================
// --- 5. THE SLEEK CYBER-GREEN HEALTH BAR SYSTEM (FIXED TEXT ALIGNMENT) ---
// =========================================================================
var current_hp = variable_instance_exists(id, "hp") ? hp : 100;
var maximum_hp = variable_instance_exists(id, "max_hp") ? max_hp : 100;

var hp_percent = clamp(current_hp / maximum_hp, 0, 1);

// --- DIMENSION CONFIGURATION ---
var hp_bar_w  = 320;        
var hp_bar_h  = 32;         
var hp_gap    = 14;         

// Position Calculation
var hp_x1     = (gui_w / 2) - (hp_bar_w / 2);
var hp_y1     = start_y + box_size + hp_gap;
var hp_x2     = hp_x1 + hp_bar_w;
var hp_y2     = hp_y1 + hp_bar_h;

var neon_green = make_color_rgb(50, 255, 10); 

// A. Ultra-Thick Matte Blackout Framing
draw_set_color(c_black);
draw_set_alpha(1.0);
draw_roundrect_ext(hp_x1 - 5, hp_y1 - 5, hp_x2 + 5, hp_y2 + 5, 14, 14, false);

// B. Neon Cyber-Glow Backdrop Accent Wrap
draw_set_color(neon_green);
draw_set_alpha(0.25);
draw_roundrect_ext(hp_x1 - 2, hp_y1 - 2, hp_x2 + 2, hp_y2 + 2, 12, 12, false);

// C. Dark Empty Well
draw_set_color(make_color_rgb(20, 24, 20));
draw_set_alpha(1.0);
draw_roundrect_ext(hp_x1, hp_y1, hp_x2, hp_y2, 10, 10, false);

// D. Dynamic Color Health Fill
if (hp_percent > 0) {
    var hp_fill_x2 = hp_x1 + (hp_bar_w * hp_percent);
    var hp_color   = merge_color(c_red, neon_green, hp_percent);
    
    draw_set_color(hp_color);
    draw_roundrect_ext(hp_x1 + 1, hp_y1 + 1, hp_fill_x2 - 1, hp_y2 - 1, 8, 8, false);
}

// E. Smooth Gloss Overlay
draw_set_color(c_white);
draw_set_alpha(0.12);
draw_roundrect_ext(hp_x1 + 2, hp_y1 + 2, hp_x2 - 2, hp_y1 + (hp_bar_h / 2), 5, 5, false);


// --- F. FIXED: DEAD-CENTER TEXT RENDERING ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(1.0);

var hp_string = string(floor(current_hp)) + " / " + string(floor(maximum_hp));

// Recalculating the physical structural middle coordinates
var text_center_x = hp_x1 + (hp_bar_w / 2);
var text_center_y = hp_y1 + (hp_bar_h / 2) - 1; // Added a -1px vertical adjustment for visual balance

// Drop shadow position adjustments matching the fixed vertical anchor
draw_set_color(c_black);
draw_text(text_center_x + 2, text_center_y + 2, hp_string);

// Crisp center foreground text
draw_set_color(c_white);
draw_text(text_center_x, text_center_y, hp_string);


// --- CLEAN UP DRAW STATES ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);