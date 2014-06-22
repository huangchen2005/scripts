zabbix_log_dir:
  cmd.run:
    - names:
      - mkdir /opt/zabbix/log
    - require:
      - cmd: zabbix_compile
    - unless: test -d /opt/zabbix/log

zabbix_conf:
  file.managed:
    - name: /opt/zabbix/etc/zabbix_agentd.conf
    - source: salt://zabbix/files/zabbix_agentd.conf
    - template: jinja

zabbix_log:
  file.managed:
    - name: /opt/zabbix/log/zabbix_agentd.log
    - user: zabbix
    - group: zabbix
    - mode: 644

zabbix_service:
  file.managed:
    - name: /etc/init.d/zabbix_agentd
    - user: root
    - mode: 755
    - source: salt://zabbix/files/zabbix_agentd
  cmd.run:
    - names:
      - /sbin/chkconfig zabbix_agentd on
    - unless: /sbin/chkconfig --list zabbix_agentd
  service.running:
    - name: zabbix_agentd
    - enable: True
    - watch:
      - file: /opt/zabbix/etc/zabbix_agentd.conf
      - file: /opt/zabbix/etc/zabbix_agentd.conf.d/*.conf
