// If the player is currently inside a portal, FREEZE this event completely!
if (variable_instance_exists(id, "is_teleporting") && is_teleporting) {
    exit;
}

if (is_crouch_attacking) {
    is_crouch_attacking = false;
    // This instantly returns control back to the state engine 
    // to check if you are still holding down the crouch key.
}

if (is_attacking) {
    is_attacking = false;
}