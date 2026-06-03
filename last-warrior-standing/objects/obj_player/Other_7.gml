if (is_crouch_attacking) {
    is_crouch_attacking = false;
    // This instantly returns control back to the state engine 
    // to check if you are still holding down the crouch key.
}

if (is_attacking) {
    is_attacking = false;
}