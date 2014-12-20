include:
    - python

supervisor:
    pkg:
        - installed
    pip.installed:
        - name: gunicorn
        - require:
            - pkg: python
    service:
        - running

restart_supervisor:
    cmd.wait:
        - name: service supervisor stop && sleep .1 && service supervisor start

# vim:set ft=yaml:
