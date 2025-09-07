#!/bin/bash

# Set superuser email with correct syntax
SUPERUSER_EMAIL=${DJANGO_SUPERUSER_EMAIL:-"abhijeetkumar3015@gmail.com"}

# Run migrations and collect static files
python manage.py migrate --noinput
python manage.py collectstatic --noinput

# Create superuser if it doesn't exist
python manage.py createsuperuser --email "$SUPERUSER_EMAIL" --noinput --username admin 2>/dev/null || true