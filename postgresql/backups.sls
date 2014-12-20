include:
    - postgresql
    - aws.s3

database_backup_script:
    file.managed:
        - name: /var/lib/postgresql/db_backup_to_s3.sh
        - source: salt://postgresql/db_backup_to_s3.sh
        - user: postgres
        - mode: 0755
        - template: jinja
        - makedirs: True
        - require:
            - pkg: amazons3
            - pkg: postgresql
    cron.present:
        - name: /var/lib/postgresql/db_backup_to_s3.sh
        - user: postgres
        - minute: 0
        - hour: 7
        - require:
            - file: database_backup_script

# vim:set ft=yaml:
