include:
    - python
    - postgresql
    - supervisor

mezzanine:
    git.latest:
        - name: https://github.com/project-banjo/veldthollow-mezzanine.git
        - target: /srv/veldthollow-mezzanine/
    file.managed:
        - name: /srv/veldthollow-mezzanine/veldthollow/settings/local.py
        - source: salt://mezzanine/local_settings.py
        - mode: 0644
        - template: jinja
        - require:
            - git: mezzanine
    postgres_database.present:
        - name: {{pillar.postgres.blog_db}}
        - owner: {{pillar.postgres.blog_owner}}
        - require:
            - postgres_user: pg_user-{{pillar.postgres.blog_owner}}

pip_requirements:
    cmd.wait:
        - name: pip3 install -r requirements.txt
        - cwd: /srv/veldthollow-mezzanine/
        - watch:
            - git: mezzanine
        - require:
            - pkg: python
            - pkg: pillow_dependencies
            - git: mezzanine

db_migrations:
    cmd.wait:
        - name: python3 manage.py migrate --noinput
        - cwd: /srv/veldthollow-mezzanine/
        - runas: www-data
        - watch:
            - git: mezzanine
            - postgres_database: mezzanine
        - require:
            - cmd: pip_requirements

collect_static:
    cmd.wait:
        - name: python3 manage.py collectstatic --noinput
        - cwd: /srv/veldthollow-mezzanine/
        - runas: www-data
        - watch:
            - git: mezzanine
        - require:
            - cmd: pip_requirements

mezzanine_supervisor:
    file.managed:
        - name: /etc/supervisor/conf.d/mezzanine.conf
        - source: salt://mezzanine/supervisor.conf
        - template: jinja
        - mode: 644
        - require:
            - pkg: supervisor
            - cmd: supervisor
    supervisord.running:
        - name: gunicorn
        - update: True
        - watch:
            - git: mezzanine
            - file: mezzanine
            - file: /etc/supervisor/conf.d/mezzanine.conf
        - require:
            - file: mezzanine_supervisor

{% for username, user in pillar.postgres.users.items() %}
pg_user-{{username}}:
    postgres_user.present:
        - name: {{username}}
        - password: {{user.password}}
        - encrypted: True
        - superuser: {{user.get('superuser', False)}}
        - require:
            - pkg: postgresql
{% endfor %}

# vim:set ft=yaml:
