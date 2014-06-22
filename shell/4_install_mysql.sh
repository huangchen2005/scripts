#!/bin/bash

source /root/.bash_profile
killall -9 mysqld
useradd mysql
if [ -d "/opt/mysql" ];then
	rm -rf /opt/mysql
fi
mkdir /opt/mysql
mkdir /opt/mysql/data
chown -R mysql.mysql /opt/mysql

#su - prism <<EOF
if [ -f "/var/tmp/mysql-5.5.21.tar.gz" ];then
	rm -f /var/tmp/mysql-5.5.21.tar.gz
fi
wget -P/var/tmp ftp://192.168.0.250/packs/mysql-5.5.21.tar.gz
cd /var/tmp
if [ -d "/var/tmp/mysql-5.5.21" ];then
	rm -rf /var/tmp/mysql-5.5.21
fi
tar xvf mysql-5.5.21.tar.gz
cd mysql-5.5.21

cmake -DCMAKE_INSTALL_PREFIX=/opt/mysql \
-DWITH_DEBUG=0 \
-DSYSCONFDIR=/opt/mysql/etc \
-DMYSQL_DATADIR=/opt/mysql/data \
-DMYSQL_TCP_PORT=3306 \
-DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \
-DMYSQL_USER=mysql \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DEXTRA_CHARSETS=all \
-DWITH_READLINE=1 \
-DWITH_EMBEDDED_SERVER=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1
make -j8
make install
mkdir /opt/mysql/log
mkdir /opt/mysql/etc
if [ -f "/opt/mysql/etc/my.cnf" ];then
	rm -f /opt/mysql/etc/my.cnf
fi
cp -f my.cnf /opt/mysql/etc/my.cnf
#EOF

if [ -f "/etc/init.d/mysqld" ];then
	rm -f /etc/init.d/mysqld
fi
#cd mysql-5.5.21
cp -f mysqld /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
#chown prism.prism /etc/init.d/mysqld
chkconfig mysqld on

#su - prism <<EOE
cd /opt/mysql
chmod 755 scripts/mysql_install_db
chown -R prism.prism /opt/mysql
./scripts/mysql_install_db --user=mysql --basedir=/opt/mysql/ --datadir=/opt/mysql/data/
/etc/init.d/mysqld start
source /root/.bash_profile 
mysql -uroot < /var/tmp/mysql-5.5.21/createdb.sql
chown -R mysql.mysql /opt/mysql
/etc/init.d/mysqld restart
mysql -uroot -pnbprismdb2o11 -Dprism < /opt/prismdeployment/init/prism-schema-init.sql

cd /var/tmp
#EOE
