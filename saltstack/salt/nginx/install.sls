nginx_source:
  file.managed:
    - name: /var/tmp/tengine-2.0.2.tar.gz
    - unless: test -e /var/tmp/tengine-2.0.2.tar.gz
    - source: salt://nginx/files/tengine-2.0.2.tar.gz

ajp_source:
  file.managed:
    - name: /var/tmp/nginx_ajp_module-master.zip
    - unless: test -e /var/tmp/nginx_ajp_module-master.zip
    - source: salt://nginx/files/nginx_ajp_module-master.zip

extract_nginx:
  cmd.run:
    - cwd: /var/tmp
    - names:
      - tar xvf tengine-2.0.2.tar.gz
      - unzip nginx_ajp_module-master.zip
    - unless: test -d /var/tmp/tengine-2.0.2
    - unless: test -d /var/tmp/nginx_ajp_module-master
    - require:
      - file: nginx_source
      - file: ajp_source

nginx_user:
  user.present:
    - name: nginx
    - uid: 1500
    - createhome: False
    - gid_from_name: True
    - shell: /sbin/nologin

nginx_pkg:
  pkg.installed:
    - pkgs:
      - gcc
      - openssl-devel
      - pcre-devel
      - zlib-devel
      - unzip

nginx_compile:
    cmd.run:
      - cwd: /var/tmp/tengine-2.0.2
      - names:
        - ./configure --prefix=/opt/nginx --user=nginx --group=nginx --with-http_upstream_check_module --add-module=/var/tmp/nginx_ajp_module-master/; make -j4; make install
      - require:
        - cmd: extract_nginx
        - pkg: nginx_pkg
      - unless: test -d /opt/nginx
