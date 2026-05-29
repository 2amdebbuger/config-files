#!/bin/sh
set -e

WP="wp --path=/var/www/html --allow-root"

echo ">>> Waiting for wp-config.php..."
until [ -f /var/www/html/wp-config.php ]; do sleep 3; done

echo ">>> Installing WordPress (retries until DB is ready)..."
until $WP core is-installed 2>/dev/null || \
  $WP core install \
    --url="${SITE_URL:-http://localhost}" \
    --title="${SITE_TITLE:-My Store}" \
    --admin_user="${WP_ADMIN_USER:-admin}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL:-admin@example.com}" \
    --skip-email 2>/dev/null; do
  echo "    DB not ready, retrying in 5s..."
  sleep 5
done

$WP option update siteurl "${SITE_URL:-http://localhost}"
$WP option update home    "${SITE_URL:-http://localhost}"
$WP option update blogname "${SITE_TITLE:-My Store}"

echo ">>> Installing Storefront theme..."
$WP theme install storefront --activate --quiet 2>/dev/null || true

echo ">>> Installing WooCommerce..."
$WP plugin install woocommerce --activate

echo ">>> Setting up WooCommerce pages..."
$WP wc tool run install_pages --user="${WP_ADMIN_USER:-admin}" 2>/dev/null || true

echo ">>> Applying store settings..."
$WP option update woocommerce_default_country "${STORE_COUNTRY:-ZA}"
$WP option update woocommerce_currency        "${STORE_CURRENCY:-ZAR}"
$WP option update woocommerce_currency_pos    "${STORE_CURRENCY_POS:-left}"
$WP rewrite structure '/%postname%/'
$WP rewrite flush

echo ""
echo "  Done!"
echo "  Store : ${SITE_URL:-http://localhost}"
echo "  Admin : ${SITE_URL:-http://localhost}/wp-admin  (${WP_ADMIN_USER:-admin} / ${WP_ADMIN_PASSWORD})"
