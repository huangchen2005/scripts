openssh-clients:
  pkg:
    - name: openssh-clients
    - installed

/etc/ssh/ssh_config:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://ssh/ssh_config
