// Draw the character sprite normally
draw_self(); 

// Draw the debug text
draw_set_color(c_white);

// Dash Debug info
draw_text(10, 10, "Dash Cooldown: " + string(dash_cooldown_timer));
draw_text(10, 30, "Is Dashing: " + string(is_dashing));

// Spell Debug info
draw_text(10, 50, "Spell Cooldown: " + string(spell_cooldown_timer));
draw_text(10, 70, "Is Attacking/Casting: " + string(is_attacking));