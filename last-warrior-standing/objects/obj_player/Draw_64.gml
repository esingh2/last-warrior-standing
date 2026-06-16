// =========================================================================
// DRAW GUI EVENT - SLEEK HORIZONTAL COMMAND BAR (FINAL PERFECTED LAYOUT)
// =========================================================================

// --- 1. RESOLUTION ANCHORING ---
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var center_x = gui_w / 2;
var base_y   = gui_h - 55; // Slightly nudged up to make perfect room for the base keys

// Gather real-time tracking properties
var current_fps = game_get_speed(gamespeed_fps);
var current_hp  = variable_instance_exists(id, "hp") ? hp : 100;
var maximum_hp  = variable_instance_exists(id, "max_hp") ? max_hp : 100;
var hp_percent  = clamp(current_hp / maximum_hp, 0, 1);

var neon_green  = make_color_rgb(50, 255, 10);


// =========================================================================
// LEVEL 1: SLIM LONG-CHASSIS CONSOLE FRAME (THE BASE BAR)
// =========================================================================
var block_w  = 520; // Stretched wider across the bottom screen space
var block_h  = 44;  // Drastically dropped height for an ultra-sleek look
var block_x1 = center_x - (block_w / 2);
var block_x2 = block_x1 + block_w;
var block_y1 = base_y - (block_h / 2);
var block_y2 = block_y1 + block_h;

// Draw Outermost High-Contrast Machine Outline
draw_set_color(c_black);
draw_set_alpha(1.0);
draw_roundrect_ext(block_x1 - 2, block_y1 - 2, block_x2 + 2, block_y2 + 2, 8, 8, false);

// Draw Interior Long Dark Frame Chassis
draw_set_color(make_color_rgb(24, 26, 29));
draw_roundrect_ext(block_x1, block_y1, block_x2, block_y2, 6, 6, false);


// =========================================================================
// LEVEL 2: DOCKED HIGH-CONTRAST ABILITY SLOTS (LEFT & RIGHT WINGS)
// =========================================================================
var slot_radius = 20; // Slightly scaled down to fit the sleek frame profile
var slot_y      = base_y;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --- A. LEFT WING: DASH NODE WITH NEON CONTRAST RING ---
var dash_x = block_x1 + 32;

// High-contrast outer frame glow (Severs it visually from the dark chassis)
draw_set_color(c_black); 
draw_circle(dash_x, slot_y, slot_radius + 2, false);
draw_set_color(neon_green); 
draw_circle(dash_x, slot_y, slot_radius + 1, false);

// Inset background window for the art
draw_set_color(make_color_rgb(40, 44, 50)); 
draw_circle(dash_x, slot_y, slot_radius, false);

// Scale & project dash art (Increased scale to fill out the circle more)
var dash_w = sprite_get_width(spr_dash_icon);
var dash_h = sprite_get_height(spr_dash_icon);
var dash_scale = (slot_radius * 1.6) / max(dash_w, dash_h);
var dash_draw_x = dash_x - ((dash_w * dash_scale) / 2);
var dash_draw_y = slot_y - ((dash_h * dash_scale) / 2);
draw_sprite_ext(spr_dash_icon, 0, dash_draw_x, dash_draw_y, dash_scale, dash_scale, 0, c_white, 1.0);

// Cooldown Shade Matrix
if (dash_cooldown_timer > 0) {
    draw_set_alpha(0.75); draw_set_color(c_black); draw_circle(dash_x, slot_y, slot_radius, false); draw_set_alpha(1.0);
    var display_time = string_format(dash_cooldown_timer / current_fps, 0, 1) + "s";
    draw_set_color(c_black); draw_text(dash_x + 1, slot_y + 1, display_time);
    draw_set_color(c_white); draw_text(dash_x, slot_y, display_time);
}


// --- B. RIGHT WING: SPELL NODE WITH NEON CONTRAST RING ---
var spell_x = block_x2 - 32;

// High-contrast outer frame glow (Severs it visually from the dark chassis)
draw_set_color(c_black); 
draw_circle(spell_x, slot_y, slot_radius + 2, false);
draw_set_color(neon_green); 
draw_circle(spell_x, slot_y, slot_radius + 1, false);

// Inset background window for the art
draw_set_color(make_color_rgb(40, 44, 50)); 
draw_circle(spell_x, slot_y, slot_radius, false);

// Scale & project spell art (Brought up to 1.95 to maximize size inside slot)
var spell_w = sprite_get_width(spr_spell1_icon);
var spell_scale = (slot_radius * 1.95) / spell_w; 
var spell_draw_x = spell_x - ((spell_w * spell_scale) / 2);
var spell_draw_y = slot_y - ((spell_w * spell_scale) / 2);
draw_sprite_ext(spr_spell1_icon, 0, spell_draw_x, spell_draw_y, spell_scale, spell_scale, 0, c_white, 1.0);

// Cooldown Shade Matrix
if (spell_cooldown_timer > 0) {
    draw_set_alpha(0.75); draw_set_color(c_black); draw_circle(spell_x, slot_y, slot_radius, false); draw_set_alpha(1.0);
    var display_time = string_format(spell_cooldown_timer / current_fps, 0, 1) + "s";
    draw_set_color(c_black); draw_text(spell_x + 1, slot_y + 1, display_time);
    draw_set_color(c_white); draw_text(spell_x, slot_y, display_time);
}


// =========================================================================
// LEVEL 3: EXTENDED CENTRAL INSET HEALTH BAR
// =========================================================================
// Calculates a much longer width bridging the gap between the isolated wing nodes
var hp_x1 = dash_x + slot_radius + 16;
var hp_x2 = spell_x - slot_radius - 16;
var hp_h  = 16; // Bumped up slightly to cleanly frame the internal numbers
var hp_y1 = base_y - (hp_h / 2);
var hp_y2 = hp_y1 + hp_h;

// Carve Health trench out of the backing panel frame
draw_set_color(c_black);
draw_roundrect_ext(hp_x1 - 1, hp_y1 - 1, hp_x2 + 1, hp_y2 + 1, 4, 4, false);
draw_set_color(make_color_rgb(15, 16, 18));
draw_roundrect_ext(hp_x1, hp_y1, hp_x2, hp_y2, 4, 4, false);

// Fill Fluid Logic
if (hp_percent > 0) {
    var max_fill_w = hp_x2 - hp_x1;
    var fill_x2 = hp_x1 + (max_fill_w * hp_percent);
    var hp_color = merge_color(c_red, neon_green, hp_percent);
    
    draw_set_color(hp_color);
    draw_roundrect_ext(hp_x1 + 1, hp_y1 + 1, fill_x2 - 1, hp_y2 - 1, 4, 4, false);
}


// =========================================================================
// LEVEL 4: INTERNAL DIGITAL STATUS READOUT (INSIDE THE HP BAR)
// =========================================================================
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var hp_string = string(floor(current_hp)) + " / " + string(floor(maximum_hp));

// Perfectly centered inside the fluid math line, offset -1px for optical balance
var text_center_y = hp_y1 + (hp_h / 2) - 1;

// Sharp shadow displacement (Protects readability against the bright neon green)
draw_set_color(c_black); 
draw_text(center_x + 2, text_center_y + 2, hp_string);

// Foreground numbers
draw_set_color(c_white); 
draw_text(center_x, text_center_y, hp_string);


// =========================================================================
// LEVEL 5: INDEPENDENT BASE KEYBIND LABELS (FLOATING BELOW THE ABILITIES)
// =========================================================================
var key_y = block_y2 + 16; // Shifted slightly lower to give the bigger sprite breathing room

// Dash Keybind Text
var dash_key_text = "SHIFT";
draw_set_color(c_black);  draw_text(dash_x + 1, key_y + 1, dash_key_text);
draw_set_color(c_dkgray); draw_text(dash_x, key_y, dash_key_text);

// Spell Input Sprite Configuration
var input_spr_w = sprite_get_width(spr_spell1_input_icon);
var input_spr_h = sprite_get_height(spr_spell1_input_icon);

// Forced width targeting to make it significantly larger on screen
var target_input_w = 22; 
var input_scale    = target_input_w / input_spr_w;

// Scale height proportionately based on the width scale factor
var rendered_h = input_spr_h * input_scale;

// Centering calculation offsets for the sprite draw anchor
var input_draw_x = spell_x - (target_input_w / 2);
var input_draw_y = key_y - (rendered_h / 2);

// --- ADDED BORDER BACKDROP PANEL FOR HIGH VISIBILITY ---
var border_padding_x = 6;
var border_padding_y = 4;
var panel_x1 = spell_x - (target_input_w / 2) - border_padding_x;
var panel_y1 = key_y - (rendered_h / 2) - border_padding_y;
var panel_x2 = spell_x + (target_input_w / 2) + border_padding_x;
var panel_y2 = key_y + (rendered_h / 2) - 1 + border_padding_y;

// Draw background boundary drop-shadow/border
draw_set_color(c_black);
draw_roundrect_ext(panel_x1 - 1, panel_y1 - 1, panel_x2 + 1, panel_y2 + 1, 6, 6, false);
// Draw background solid inner fill
draw_set_color(make_color_rgb(32, 36, 41));
draw_roundrect_ext(panel_x1, panel_y1, panel_x2, panel_y2, 5, 5, false);

// Draw Spell Keybind Sprite Asset centered directly on top of the border panel
draw_sprite_ext(spr_spell1_input_icon, 0, input_draw_x, input_draw_y, input_scale, input_scale, 0, c_white, 1.0);


// --- ENGINE STORAGE HOUSEKEEPING ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);