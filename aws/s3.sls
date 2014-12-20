amazons3:
    pkg.installed:
        - name: s3cmd
    file.managed:
        - name: /var/lib/postgresql/.s3cfg
        - source: salt://aws/s3cfg
        - user: postgres
        - mode: 0600
        - template: jinja
        - makedirs: True
        - require:
            - pkg: amazons3

# vim:set ft=yaml:
