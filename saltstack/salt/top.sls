base:
  '*':
    - base.base
    - ssh.client
    - ssh.server
    - zabbix.install
    - zabbix.conf
    - zabbix.conf_d

  'lens1,lens2':
    - match: list
    - nginx.install
    - nginx.conf
    - nginx.vhost
