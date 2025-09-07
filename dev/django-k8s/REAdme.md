# Django Deployment configration using docker and kubernetes.
## first setup all the requirements 
### 
asgiref==3.9.1
certifi==2025.8.3
charset-normalizer==3.4.3
Django==5.2.5
django-dotenv==1.4.2
django-storages==1.14.6
gunicorn==23.0.0
idna==3.10
packaging==25.0
requests==2.32.5
sqlparse==0.5.3
typing_extensions==4.15.0
urllib3==2.5.0


### setting up .evn and gitignore file : 
DEBUG=0
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_PASSWORD='#include'
DJANGO_SECRET_KEY=do_it_later

# DB CONFIGRATION
POSTGRES_DB=docker_dc
POSTGRES_PASSWORD=my_secret_password
POSTGRES_USER=my_user
POSTGRES_HOTS=postgres_db
POSTGRES_PORT=5433

# redis configration :

REDIS_HOST=redis_db
REDIS_PORT=6379

## DATABASE configration : 


DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

### Database configration

DB_USERNAME=os.environ.get('POSTGRES_USER')
DB_PASSWORD=os.environ.get('POSTGRES_PASSWORD')
DB_DATABASE=os.environ.get('POSTGRES_DB')
DB_HOST=os.environ.get('POSTGRES_HOTS')
DB_PORT=os.environ.get('POSTGRES_PORT')


DB_IS_AVAILABLE=all(
    [
        DB_USERNAME,DB_PASSWORD,DB_HOST,DB_PORT,DB_DATABASE
    ]
)

POSTGRES_READY=str(os.environ.get('POSTGRES_READY'))=='1'


if DB_IS_AVAILABLE and POSTGRES_READY:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': DB_DATABASE,
            'USER':DB_USERNAME,
            'HOST':DB_HOST,
            'PORT':DB_PORT,
            'PASSWORD':DB_PASSWORD
        }
    }

## Gunicorn setup :
### filename entrypoint.sh'
APP_PORT=${PORT:-8000}
cd /app/opt/venv/bin/gunicorn --worker-tmp-dir /dev/shm web.wsgi.application --bind "0.0.0.0:${APP_PORT}"

## Migration and migrate : 

# !/bin/bash

SUPERUSER_EMAIL=${DJANGO_SUPERUSER_SUPERUSER_EMAIL}:-"abhijeetkumar3015@gmail.com"
cd /app/

/opt/venv/bin/python manage.py migrate --noinput
/opt/venv/bin/python manage.py createsuperuser --email $SUPERUSER_EMAIL --noinput || true


## Docker configration for production 

FROM python:3.11-slim
COPY . /app
WORKDIR /app

RUN python3 -m venv /opt/venv
RUN pip install pip --upgrade
RUN /opt/venv/bin/pip install -r requirements.txt
RUn chmod +x entrypoint.sh

CMD ['/app/entrypoint.sh']


