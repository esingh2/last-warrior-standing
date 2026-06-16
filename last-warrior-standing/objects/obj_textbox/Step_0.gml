// If the player presses Enter, Space, or E, close the textbox
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("E"))) {
    instance_destroy();
}