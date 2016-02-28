base:
    '*':
        - base
        - hosts
        - users
        - users.sudo
    'roles:salt-master':
        - match: grain
        - salt.master
    'roles:salt-minion':
        - match: grain
        - salt.minion
    'roles:salt-masterless-minion':
        - match: grain
        - salt.masterless-minion
    'roles:web':
        - match: grain
        - nginx
    'roles:veldthollow-web':
        - match: grain
        - mezzanine
    'roles:redis':
        - match: grain
        - redis
    'roles:postgres':
        - match: grain
        - postgresql
        #- postgresql.backups

# vim:set ft=yaml:
