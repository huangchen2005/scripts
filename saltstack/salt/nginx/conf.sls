{% set nginx_user = 'nginx' %}

nginx_conf:
  file.managed:
    - name: /opt/nginx/conf/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - template: jinja
    - defaults:
      nginx_user: {{ nginx_user }}

nginx_vhost_dir:
  cmd.run:
    - names:
      - mkdir /opt/nginx/conf/vhost
    - require:
      - cmd: nginx_compile
    - unless: test -d /opt/nginx/conf/vhost

nginx_service:
  file.managed:
    - name: /etc/init.d/nginx
    - user: root
    - mode: 755
    - source: salt://nginx/files/nginx
  cmd.run:
    - names:
      - /sbin/chkconfig nginx on
    - unless: /sbin/chkconfig --list nginx
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: /opt/nginx/conf/nginx.conf
      - file: /opt/nginx/conf/vhost/*.conf

nginx_log_cut:
  file.managed:
    - name: /opt/nginx/sbin/nginx_log_cut.sh
    - user: root
    - mode: 755
    - source: salt://nginx/files/nginx_log_cut.sh
  cron.present:
    - name: /opt/nginx/sbin/nginx_log_cut.sh
    - user: root
    - minite: 10
    - hour: 0
    - require:
      - file: nginx_log_cut
