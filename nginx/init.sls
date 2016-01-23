nginx:
    pkgrepo.managed:
        - ppa: nginx/stable
        - required_in:
            - pkg: nginx
    pkg.installed:
        - require:
            - pkgrepo: nginx
    service:
        - running
        - watch:
            - file: /etc/nginx/nginx.conf
            - file: /etc/nginx/mime.types
            - file: /etc/nginx/sites-enabled/default
            - file: /etc/nginx/sites-enabled/static
            - file: /etc/nginx/sites-enabled/redirect

/etc/nginx/nginx.conf:
    file.managed:
        - source: salt://nginx/nginx.conf
        - template: jinja
        - require:
            - pkg: nginx

/etc/nginx/mime.types:
    file.managed:
        - source: salt://nginx/mime.types
        - template: jinja
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/default:
    file.managed:
        - source: salt://nginx/sites/default
        - template: jinja
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/static:
    file.managed:
        - source: salt://nginx/sites/static
        - template: jinja
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/redirect:
    file.managed:
        - source: salt://nginx/sites/redirect
        - template: jinja
        - require:
            - pkg: nginx

/etc/nginx/ssl:
    file.directory:
        - user: www-data
        - group: www-data
        - mode: 700
        - file_mode: 600
        - recurse:
            - user
            - group
            - mode

/etc/nginx/ssl/veldthollow_com.crt:
    file.managed:
        - source: salt://ssl/veldthollow_com.crt
        - require:
            - pkg: nginx

/etc/nginx/ssl/veldthollow_com.key:
    file.managed:
        - source: salt://ssl/veldthollow_com.key
        - require:
            - pkg: nginx

# vim:set ft=yaml:
