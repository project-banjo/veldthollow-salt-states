base:
    "*":
        - base
        - hosts
    "roles:salt-master":
        - match: grains
        - salt.master
    "roles:salt-minion":
        - match: grains
        - salt.minion
    "roles:salt-masterless-minion":
        - match: grains
        - salt.masterless-minion
    "roles:web":
        - match: grains
        - nginx
    "roles:veldthollow-web"
        - match: grains
        - mezzanine
    "roles:redis"
        - match: grains
        - redis
    "roles:postgres"
        - match: grains
        - postgresql
        #- postgresql.backups

# vim:set ft=yaml:
