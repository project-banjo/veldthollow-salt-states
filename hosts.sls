{% for hostname, host in pillar.hostnames.items() -%}
host_{{hostname}}:
    host.present:
        - name: {{hostname}}
        {% if hostname == grains['id'] %}
        - ip: 127.2.0.1
        {% else %}
        - ip: {{host['ip']}}
        {% endif %}
        {% if host.get('names', '') %}- names: {{host['names']}}{% endif %}
{% endfor -%}

# vim:set ft=yaml:
