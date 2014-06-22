zabbix_source:
  file.managed:
    - name: /var/tmp/zabbix-2.2.1.tar.gz
    - unless: test -e /var/tmp/zabbix-2.2.1.tar.gz
    - source: salt://zabbix/files/zabbix-2.2.1.tar.gz

extract_zabbix:
  cmd.run:
    - cwd: /var/tmp
    - names:
      - tar xvf zabbix-2.2.1.tar.gz
    - unless: test -d /var/tmp/zabbix-2.2.1
    - require:
      - file: zabbix_source

zabbix_user:
  user.present:
    - name: zabbix
    - uid: 1501
    - createhome: False
    - gid_from_name: True
    - shell: /sbin/nologin

zabbix_pkg:
  pkg.installed:
    - pkgs:
      - gcc

zabbix_compile:
    cmd.run:
      - cwd: /var/tmp/zabbix-2.2.1
      - names:
        - ./configure --prefix=/opt/zabbix --enable-agent; make -j4; make install
      - require:
        - cmd: extract_zabbix
        - pkg: zabbix_pkg
      - unless: test -d /opt/zabbix
