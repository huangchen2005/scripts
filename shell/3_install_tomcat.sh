#!/bin/bash

if [ -f "/var/tmp/jdk1.6.0_32.tar.gz" ];then
        rm -f /var/tmp/jdk1.6.0_32.tar.gz
fi
if [ -f "/var/tmp/apache-tomcat-5.5.35.tar.gz" ];then
        rm -f /var/tmp/apache-tomcat-5.5.35.tar.gz
fi
wget -P/var/tmp ftp://192.168.0.250/packs/jdk1.6.0_32.tar.gz
wget -P/var/tmp ftp://192.168.0.250/packs/apache-tomcat-5.5.35.tar.gz
cd /var/tmp

if [ -d "/var/tmp/jdk1.6.0_32" ];then
        rm -rf /var/tmp/jdk1.6.0_32
fi
if [ -d "/opt/jdk1.6.0_32" ];then
	rm -rf /opt/jdk1.6.0_32
fi
tar xvf jdk1.6.0_32.tar.gz
cp -rf jdk1.6.0_32 /opt/jdk1.6.0_32

if [ -d "/var/tmp/apache-tomcat-5.5.35" ];then
	rm -rf /var/tmp/apache-tomcat-5.5.35
fi
if [ -d "/opt/apache-tomcat-5.5.35" ];then
	rm -rf /var/tmp/apache-tomcat-5.5.35
fi
tar xvf apache-tomcat-5.5.35.tar.gz
cp -rf apache-tomcat-5.5.35 /opt/apache-tomcat-5.5.35

if [ -f "/etc/init.d/tomcat" ];then
	rm -f /etc/init.d/tomcat
fi
cp -f apache-tomcat-5.5.35/tomcat /etc/init.d/tomcat
chmod 755 /etc/init.d/tomcat
chkconfig tomcat on
cp -rf apache-tomcat-5.5.35/.bash_profile /root/.bash_profile
source /root/.bash_profile

rm -rf /var/tmp/apache-tomcat-5.5.35 /var/tmp/apache-tomcat-5.5.35.tar.gz /var/tmp/jdk1.6.0_32.tar.gz /var/tmp/jdk1.6.0_32
#chown -R prism.prism /opt/apache-tomcat-5.5.35
#chown -R prism.prism /opt/jdk1.6.0_32
#chown -R prism.prism /etc/init.d/tomcat
cd /var/tmp
