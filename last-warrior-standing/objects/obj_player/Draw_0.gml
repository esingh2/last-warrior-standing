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
gpu_set_texfilter(false); 
gpu_set_fog(true, outline_color, 0, 0); 

var directions = [0, 90, 180, 270];
for (var i = 0; i < 4; i++) {
    var angle_rad = degtorad(directions[i]);
    var ox = cos(angle_rad) * total_offset;
    var oy = -sin(angle_rad) * total_offset;
    
    draw_surface_ext(player_surf, (x - local_x) + ox, (y - local_y) + oy, 1, 1, 0, c_white, outline_alpha * image_alpha);
}

gpu_set_fog(false, c_white, 0, 0);

// 5. DRAW THE REAL PLAYER DIRECTLY ON TOP (IN FULL COLOR)
draw_self();

// 6. DRAW UI PROMPT PROGRESS CIRCLE IF CLOSE TO AN INTERACTABLE
// Uses a 2-pixel look-ahead padding so it still works when pressing against solid NPCs
if (place_meeting(x + 2, y, obj_interactable) || 
    place_meeting(x - 2, y, obj_interactable) || 
    place_meeting(x, y + 2, obj_interactable) || 
    place_meeting(x, y - 2, obj_interactable)) {
    
    var _ui_x = x;
    var _ui_y = bbox_top - 10; 
    
    // Draw background circle
    var _circle_radius = 14; 
    draw_set_color(c_dkgray);
    draw_circle(_ui_x, _ui_y, _circle_radius, false); 
    
    // Draw hold prompt icon
    var _scale = 0.06; 
    draw_sprite_ext(spr_hold_prompt, -1, _ui_x, _ui_y, _scale, _scale, 0, c_white, 1);
    
    // Draw clockwise progress ring
    var _progress = (interact_timer / 90) * 360; 
    
    if (_progress > 0) {
        draw_set_color(c_lime);
        
        var _sections = 32; 
        var _ring_thickness = 3; 
        
        draw_primitive_begin(pr_trianglestrip);
        for (var i = 0; i <= _sections; i++) {
            var _angle = 270 + (i / _sections) * _progress; 
            if ((i / _sections) * 360 > _progress) break;
            
            var _rad = degtorad(_angle);
            
            var _ox = _ui_x + cos(_rad) * (_circle_radius + 2);
            var _oy = _ui_y + sin(_rad) * (_circle_radius + 2);
            var _ix = _ui_x + cos(_rad) * (_circle_radius + 2 - _ring_thickness);
            var _iy = _ui_y + sin(_rad) * (_circle_radius + 2 - _ring_thickness);
            
            draw_vertex(_ox, _oy);
            draw_vertex(_ix, _iy);
        }
        draw_primitive_end();
    }
}