#!/bin/sh

# Set default port
APP_PORT=${PORT:-8000}

# Run migrations (if needed)
# python manage.py migrate

# Start Gunicorn
exec python -m gunicorn web.wsgi:application \
    --workers 2 \
    --worker-tmp-dir /dev/shm \
    --bind "0.0.0.0:${APP_PORT}" \
    --timeout 120

