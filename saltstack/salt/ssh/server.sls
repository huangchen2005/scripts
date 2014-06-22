openssh-server:
  pkg:
    - name: openssh-server
    - installed
  service:
    - name: sshd
    - running
    - reload: True
    - watch:
      - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://ssh/sshd_config
