// Only lower alpha and destroy if this specific instance has been triggered to fade
if (is_fading) {
    image_alpha -= 0.04; // Adjust this decimal to make it fade faster or slower
    
    // Once completely invisible, wipe it from memory
    if (image_alpha <= 0) {
        instance_destroy();
    }
}