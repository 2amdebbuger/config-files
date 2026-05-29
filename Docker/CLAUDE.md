# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

WordPress + WooCommerce e-commerce stack via Docker Compose. Built for exam/assignment scenarios: populate `.env` with business details, run two commands, and the fully configured store is ready for content entry — no database or plugin configuration needed.

## Quick Start

```sh
# 1. Populate environment (required before anything else)
cp .env.example .env
#    Edit .env: set all passwords and store details

# 2. Start all services
docker compose up -d

# 3. First-time setup — installs WooCommerce, all plugins, Storefront theme
docker compose run --rm setup
```

Store is then live at `SITE_URL`, admin at `SITE_URL/wp-admin`.

## Services and Ports

| Service    | Default Port | Purpose                            |
|------------|--------------|------------------------------------|
| WordPress  | `:80`        | Store frontend + `/wp-admin`       |
| phpMyAdmin | `:8081`      | Database GUI                       |
| Mailpit    | `:8025`      | Capture all outgoing WordPress email |

All ports are configurable in `.env` (`HTTP_PORT`, `PMA_PORT`, `MAIL_UI_PORT`).

## Architecture

| Container    | Image                      | Role |
|--------------|---------------------------|------|
| `db`         | `mysql:8.0`               | Persistent store; `wordpress` waits for its health check before starting |
| `redis`      | `redis:7-alpine`          | Object cache, enabled by setup script via Redis Object Cache plugin |
| `wordpress`  | `wordpress:php8.2-apache` | Mounts `wp_data` volume; custom PHP limits via `config/php.ini` |
| `setup`      | `wordpress:cli-php8.2`    | WP-CLI one-shot container (Docker profile `setup`); idempotent — safe to re-run |
| `phpmyadmin` | `phpmyadmin:latest`       | DB admin UI on internal network |
| `mailpit`    | `axllent/mailpit`         | Dev email catcher; SMTP on internal port 1025, web UI on 8025 |

`config/mu-plugins/smtp-config.php` is a must-use plugin (auto-loaded, cannot be deactivated) that routes all WP email to Mailpit — no manual SMTP plugin configuration needed.

## Exam Content Customization

All business-specific values are in `.env`. After editing, re-run setup (it skips already-complete steps):

```sh
docker compose run --rm setup
```

| `.env` variable | What it controls |
|-----------------|-----------------|
| `SITE_TITLE` | Store name shown site-wide |
| `SITE_URL` | Full URL including protocol (use LAN IP for private access) |
| `WP_ADMIN_EMAIL` | Admin account email |
| `STORE_COUNTRY` / `STORE_CURRENCY` | Regional and currency settings |
| `STORE_ADDRESS` / `STORE_CITY` | Address shown in WooCommerce and invoices |

Logo, product images, pages, and all copy are managed through `wp-admin`.

## Public / Subdomain Access

For the public hosting and subdomain requirements, run one of these alongside the stack:

```sh
# Free public URL instantly (no account)
npx localtunnel --port 80 --subdomain your-store-name

# Ngrok (free account, persistent subdomain on paid plan)
ngrok http 80

# Cloudflare Tunnel (persistent custom subdomain, free)
cloudflared tunnel --url http://localhost:80
```

For LAN/private access, set `SITE_URL=http://<your-machine-ip>` in `.env` and re-run setup.

## Installed Plugins (via scripts/setup.sh)

| Plugin | E-commerce role |
|--------|----------------|
| WooCommerce | Cart, checkout, orders, catalogue, user accounts |
| WooCommerce Gateway — Stripe | Payment processing |
| Redis Object Cache | Performance caching layer |
| MailPoet | Transactional email + notification campaigns |
| Smart Wishlist for WooCommerce | Wishlist (feeds recommendations) |
| Google Analytics for WordPress | Analytics |
| Yoast SEO | SEO |
| AI Engine | OpenAI-powered chatbot, content generation, product recommendations |
| WooCommerce PDF Invoices | Order documents / packing slips for shipping |
| Contact Form 7 | Customer enquiry forms |

## Common Commands

```sh
# Start / stop
docker compose up -d
docker compose down

# Run setup again (idempotent — safe to re-run after .env changes)
docker compose run --rm setup

# Follow WordPress logs
docker compose logs -f wordpress

# Open interactive WP-CLI shell
docker compose run --rm --entrypoint sh setup

# Run a WP-CLI command directly (example: list plugins)
docker compose run --rm --entrypoint wp setup --path=/var/www/html --allow-root plugin list

# Restart a single service
docker compose restart wordpress

# Full wipe and fresh start (deletes all data and volumes)
docker compose down -v
docker compose up -d
docker compose run --rm setup

# Windows: free a blocked port (replace 80 with the blocked port number)
for /f "tokens=5" %a in ('netstat -ano ^| findstr :80') do taskkill /PID %a /F
```
