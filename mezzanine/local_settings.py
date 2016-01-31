from .base import *  # noqa

DEBUG = False
for t in TEMPLATES:
    t.setdefault('OPTIONS', {})
    t['OPTIONS']['debug'] = DEBUG

ALLOWED_HOSTS = ['{{pillar.django.allowed_host}}']

SECRET_KEY = '{{pillar.django.secret_key}}'
NEVERCACHE_KEY = '{{pillar.django.nevercache_key}}'

STATIC_URL = '{{pillar.django.static_url}}'
MEDIA_URL = '{{pillar.django.media_url}}'

{% set db_engine = pillar[pillar.django.db_engine] -%}
DATABASES = {
    'default': {
        'ENGINE': '{{pillar.django.db_engine_module}}',
        'NAME': '{{db_engine.blog_db}}',
        'USER': '{{db_engine.blog_owner}}',
        'PASSWORD': '{{db_engine.users[db_engine.blog_owner].password}}',
        'HOST': '{{db_engine.get('host', '127.0.0.1')}}',
        'POST': '{{db_engine.get('port', '')}}'
    }
}

{% set redis = pillar.get('redis', {}) -%}
{% if redis %}
CACHES = {
    'default': {
        'BACKEND': 'redis_cache.RedisCache',
        'LOCATION': '{{redis.get("bind_address", "127.0.0.1")}}:{{redis.get("port", 6793)}}',
        'OPTIONS': {
            'DB': {{redis.get('cache_db', 1)}},
            'PASSWORD': '{{redis.password}}',
            'PARSER_CLASS': 'redis.connection.HiredisParser',
            'CONNECTION_POOL_CLASS': 'redis.BlockingConnectionPool',
            'CONNECTION_POOL_CLASS_KWARGS': {
                'max_connections': 50,
                'timeout': 20,
            }
        },
    },
}

SESSION_ENGINE = 'redis_sessions.session'
SESSION_REDIS_HOST = '{{redis.get("bind_address", "127.0.0.1")}}'
SESSION_REDIS_PORT = {{redis.get('port', 6379)}}
SESSION_REDIS_DB = {{redis.get('session_db', 0)}}
SESSION_REDIS_PASSWORD = '{{redis.password}}'
{% endif -%}

