draw_self(); // This makes sure your character sprite still draws normally
draw_text(10, 10, "Cooldown Timer: " + string(dash_cooldown_timer));
draw_text(10, 30, "Is Dashing: " + string(is_dashing));