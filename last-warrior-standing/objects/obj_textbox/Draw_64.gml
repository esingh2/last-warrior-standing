var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// Set font configurations first so string calculations are pixel-perfect
draw_set_font(-1); // Replace with your custom font if you use one
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- 1. ULTRA-WIDE HORIZONTAL WIDTH & DYNAMIC HEIGHT LAYOUT ---
var pad_x = 28; 
var pad_y = 20; 
var line_separation = 22;

// Expanded significantly to 680px for an immersive widescreen layout
var box_total_w = 680; 
var box_inner_w = box_total_w - (pad_x * 2);

// Calculate vertical text height dynamically based on the extra-wide width
var native_text_h = string_height_ext(text_message, line_separation, box_inner_w);
var box_total_h  = native_text_h + (pad_y * 2);

// --- 2. POSITIONING ANCHORS ---
var center_x = gui_w / 2;
var box_x1   = center_x - (box_total_w / 2);
var box_x2   = box_x1 + box_total_w;

// Anchor the box from the bottom up, so it expands downwards gracefully
var box_y1   = gui_h - 220; 
var box_y2   = box_y1 + box_total_h;

// --- 3. DRAW THE CONTAINER ---
// High-contrast outer stroke
draw_set_color(c_black);
draw_roundrect_ext(box_x1 - 2, box_y1 - 2, box_x2 + 2, box_y2 + 2, 8, 8, false);

// Dark interior panel fill
draw_set_color(make_color_rgb(30, 33, 36));
draw_roundrect_ext(box_x1, box_y1, box_x2, box_y2, 6, 6, false);

// --- 4. DRAW THE MAIN DIALOGUE TEXT ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_ext(box_x1 + pad_x, box_y1 + pad_y, text_message, line_separation, box_inner_w);

// --- 5. TOP RIGHT UTILITY PROMPT [ENTER] ---
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);

var prompt_text = "[Enter]";
var prompt_x    = box_x2 - 12;
var prompt_y    = box_y1 - 6; 

// Sharp drop-shadow for prompt text visibility
draw_set_color(c_black);
draw_text(prompt_x + 1, prompt_y + 1, prompt_text);

// Clean functional color highlight
draw_set_color(make_color_rgb(160, 170, 185));
draw_text(prompt_x, prompt_y, prompt_text);