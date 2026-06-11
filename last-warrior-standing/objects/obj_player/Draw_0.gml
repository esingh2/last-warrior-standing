// 1. DYNAMIC AUTO-FILTER FOR COMBOS, DASHES, AND SPELLS
var sprite_name = sprite_get_name(sprite_index);

if (string_pos("attack", sprite_name) > 0 || 
    string_pos("slash", sprite_name) > 0  || 
    string_pos("dash", sprite_name) > 0   || 
    string_pos("spell", sprite_name) > 0) {
    
    draw_self();
    exit; 
}

// 2. SETUP CANVAS BOUNDARIES
var total_offset = outline_gap + outline_thickness;
var pad = total_offset + 4;
var surf_w = sprite_width + (pad * 2);
var surf_h = sprite_height + (pad * 2);

if (!surface_exists(player_surf)) {
    player_surf = surface_create(surf_w, surf_h);
}

// 3. DRAW SILHOUETTE TO SURFACE
surface_set_target(player_surf);
draw_clear_alpha(c_white, 0); 

gpu_set_texfilter(true); 

var local_x = pad + sprite_xoffset;
var local_y = pad + sprite_yoffset;

draw_sprite_ext(sprite_index, image_index, local_x, local_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

surface_reset_target();

// 4. DRAW THE SURFACE AS A SOLID, SHARP LIGHT GRAY HALO
gpu_set_texfilter(false); // <-- Keeps the line perfectly solid and crisp, just like you liked!
gpu_set_fog(true, outline_color, 0, 0); 

// ONLY ONE LOOP RUNNING (4-WAY CROSS FOR MAXIMUM CLEAN LINES)
var directions = [0, 90, 180, 270];
for (var i = 0; i < 4; i++) {
    var angle_rad = degtorad(directions[i]);
    var ox = cos(angle_rad) * total_offset;
    var oy = -sin(angle_rad) * total_offset;
    
    draw_surface_ext(player_surf, (x - local_x) + ox, (y - local_y) + oy, 1, 1, 0, c_white, outline_alpha * image_alpha);
}

gpu_set_fog(false, c_white, 0, 0);

// 5. DRAW THE REAL PLAYER DIRECTLY ON TOP (IN FULL COLOR)
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);