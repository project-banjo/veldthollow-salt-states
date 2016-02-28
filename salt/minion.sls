{% if pillar.get('master') -%}
    {% set saltmaster_version = grains['saltversion'] -%}
{% elif pillar.get('mine_functions', {}).get('saltversion') -%}
    {% set saltmaster_version = salt['mine.get']('roles:salt-master', 'saltversion', 'grain').items()[0][1] -%}
{% else -%}
    {% set saltmaster_version = grains['saltversion'] -%}
{% endif -%}
include:
    - salt

install_salt:
    cmd.script:
        - source: http://bootstrap.saltstack.org
        - unless: which salt
        - args: "-P git v{{saltmaster_version}}"

upgrade_salt:
    cmd.script:
        - source: http://bootstrap.saltstack.org
        - onlyif: which salt
        - unless: {{grains['saltversion'] == saltmaster_version}}
        - args: "-P git v{{saltmaster_version}}"

/etc/salt/minion:
    file.managed:
        - source: salt://salt/minion
        - template: jinja
        - defaults:
            master_host: {{pillar.get('salt:master', 'saltmaster')}}
            id: {{ grains['id'] }}
        - require:
            - cmd: install_salt

salt-minion:
    service.running:
        - watch:
            - file: /etc/salt/minion
