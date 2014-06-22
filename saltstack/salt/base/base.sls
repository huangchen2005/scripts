vim-enhanced:
  pkg:
    - name: vim-enhanced
    - installed
unzip:
  pkg:
    - name: unzip
    - installed

/etc/hosts:
  file.managed:
    - source: salt://base/hosts
    - user: root
    - group: root 
    - mode: 644 
    - backup: minion

/etc/security/limits.conf:
  file.managed:
    - source: salt://base/limits.conf
    - user: root
    - group: root 
    - mode: 644 
    - backup: minion
