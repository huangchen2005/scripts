#!/bin/bash

if [ -d "/opt/nginx" ];then
	rm -rf /opt/nginx
fi
mkdir /opt/nginx
#chown -R prism.prism /opt/nginx
#su - prism <<EOF
if [ -f "/var/tmp/nginx-1.2.5.tar.gz" ];then
	rm -f /var/tmp/nginx-1.2.5.tar.gz
fi
wget -P/var/tmp ftp://192.168.0.250/packs/nginx-1.2.5.tar.gz
cd /var/tmp
if [ -d "/var/tmp/nginx-1.2.5" ];then
	rm -rf /var/tmp/nginx-1.2.5
fi
tar xvf nginx-1.2.5.tar.gz
cd nginx-1.2.5
./configure --prefix=/opt/nginx --with-http_stub_status_module
make -j8
make install
#EOF

cd /var/tmp/nginx-1.2.5 
if [ -f "/etc/init.d/nginx" ];then
	rm -f /etc/init.d/nginx
fi
cp -f nginx /etc/init.d/nginx
#chown prism.prism /etc/init.d/nginx
chmod 755 /etc/init.d/nginx
chkconfig nginx on
if [ -f "/opt/nginx/conf/nginx.conf" ];then
	rm -f /opt/nginx/conf/nginx.conf
fi
cp -f nginx.conf /opt/nginx/conf/nginx.conf
#chown prism.prism /opt/nginx/conf/nginx.conf
rm -rf /var/tmp/nginx-1.2.5.tar.gz /var/tmp/nginx-1.2.5
cd /var/tmp
