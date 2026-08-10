#!/bin/bash
set -e

# Fix permissions for Laravel
if [ -d "/app" ]; then
    # Erlauben dass www-data und der Host-User beide schreiben können
    chmod -R 775 /app/storage /app/bootstrap/cache
fi

# Run PHP-FPM
exec php-fpm
