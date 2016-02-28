include:
    - salt

install_salt_master:
    cmd.script:
        - source: http://bootstrap.saltstack.org
        - unless: which salt
        - args: "-P -M git v{{grains['saltversion']}}"

/etc/salt/master:
    file.managed:
        - source: salt://salt/master

salt-master:
    service.running:
        - watch:
            - file: /etc/salt/master
