postgresql:
    pkgrepo.managed:
        - name: deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
        - file: /etc/apt/sources.list.d/postgresql.list
        - key_url: http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc
        - require_in:
            - pkg: postgresql
    pkg.installed:
        - names:
            - postgresql-contrib
            - postgresql-9.3
            - postgresql-server-dev-9.3
        - require:
            - pkgrepo: postgresql
    service:
        - name: postgresql
        - running
        - reload: True
        - require:
            - pkg: postgresql

# vim:set ft=yaml:
