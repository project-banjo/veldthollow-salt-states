include:
    - python
    - postgresql
    - supervisor

mezzanine:
    git.latest:
        - name: https://github.com/project-banjo/veldthollow-mezzanine.git
        - target: /var/www/veldthollow-mezzanine/
    file.managed:
        - name: /var/www/veldthollow-mezzanine/local_settings.py
        - source: salt://mezzanine/local_settings.py
        - mode: 0644
        - template: jinja
        - require:
            - git: mezzanine
    postgres_database.present:
        - name: {{pillar.postgres.blog_db}}
        - owner: {{pillar.postgres.blog_owner}}
        - runas: postgres
        - require:
            - postgres_user: pg_user-{{pillar.postgres.blog_owner}}

pip_requirements:
    cmd.wait:
        - name: pip install -r requirements.txt
        - cwd: /var/www/veldthollow-mezzanine/
        - watch:
            - git: mezzanine
        - require:
            - pkg: pillow_dependencies

db_migrations:
    cmd.wait:
        - name: python manage.py migrate --noinput
        - cwd: /var/www/veldthollow-mezzanine/
        - runas: www-data
        - watch:
            - git: mezzanine
            - postgres_database: mezzanine
        - require:
            - cmd: pip_requirements

collect_static:
    cmd.wait:
        - name: python manage.py collectstatic --noinput
        - cwd: /var/www/veldthollow-mezzanine/
        - runas: www-data
        - watch:
            - git: mezzanine

restart_gunicorn:
    cmd.wait:
        - name: supervisorctl restart gunicorn
        - watch:
            - git: mezzanine
            - file: mezzanine
            - file: /etc/supervisor/conf.d/mezzanine.conf

/etc/supervisor/conf.d/mezzanine.conf:
    file.managed:
        - source: salt://mezzanine/supervisor.conf
        - mode: 644
        - require:
            - pkg: supervisor
            - pip: supervisor
        - watch_in:
            - cmd: restart_supervisor

{% for username, user in pillar.postgres.users.items() %}
pg_user-{{username}}:
    postgres_user.present:
        - name: {{username}}
        - password: {{user.password}}
        - encrypted: True
        - superuser: {{user.get('superuser', False)}}
        - runas: postgres
        - require:
            - pkg: postgresql
{% endfor %}

# vim:set ft=yaml:
