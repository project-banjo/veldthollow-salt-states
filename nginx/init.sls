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
            - file: /etc/nginx/sites-available/default
            - file: /etc/nginx/sites-available/static
            - file: /etc/nginx/sites-available/redirect
     
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

/etc/nginx/sites-available/default:
    file.managed:
        - source: salt://nginx/sites/default
        - template: jinja
        - require:
            - pkg: nginx

/etc/nginx/sites-available/static:
    file.managed:
        - source: salt://nginx/sites/static
        - template: jinja
        - require:
            - pkg: nginx

/etc/nginx/sites-available/redirect:
    file.managed:
        - source: salt://nginx/sites/redirect
        - template: jinja
        - require:
            - pkg: nginx

# vim:set ft=yaml:
