<?php
/**
 * Routes all WordPress email to Mailpit (internal SMTP on port 1025).
 * View captured emails at http://localhost:8025
 * Remove or replace with production SMTP settings before going live.
 */
add_action('phpmailer_init', function ($phpmailer) {
    $phpmailer->isSMTP();
    $phpmailer->Host     = 'mailpit';
    $phpmailer->Port     = 1025;
    $phpmailer->SMTPAuth = false;
});
