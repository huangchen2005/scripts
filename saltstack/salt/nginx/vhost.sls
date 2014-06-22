include:
  - nginx.install

{% for vhostname in pillar['vhost'] %}

{{vhostname['name']}}:
  file.managed:
    - name: {{vhostname['target']}}
    - source: {{vhostname['source']}}
    - template: jinja
    - watch_in:
      service: nginx 

{% endfor %}
