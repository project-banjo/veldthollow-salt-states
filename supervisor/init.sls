include:
    - python

supervisor:
    pkg:
        - installed
    cmd.run:
        - name: pip3 install gunicorn
        - unless: which gunicorn
        - require:
            - pkg: python
    service:
        - running

restart_supervisor:
    cmd.wait:
        - name: service supervisor stop && sleep .1 && service supervisor start

# vim:set ft=yaml:
