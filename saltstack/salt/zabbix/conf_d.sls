zabbix_agentd.conf.d_io:
  file.managed:
    - name: /opt/zabbix/etc/zabbix_agentd.conf.d/io.conf
    - source: salt://zabbix/files/zabbix_agentd.conf.d/io.conf
    - watch_in:
      service: zabbix

zabbix_agentd.conf.d_iostat:
  file.managed:
    - name: /opt/zabbix/etc/zabbix_agentd.conf.d/iostat.conf
    - source: salt://zabbix/files/zabbix_agentd.conf.d/iostat.conf
    - watch_in:
      service: zabbix
