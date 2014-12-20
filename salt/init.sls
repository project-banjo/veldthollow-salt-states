/etc/salt/minion:
    file.managed:
        - source: salt://salt/minion

saltstack_ppa:
    pkgrepo.managed:
        - ppa: saltstack/salt

# vim:set ft=yaml:
