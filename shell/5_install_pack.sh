#!/bin/bash

source /root/.bash_profile
ldconfig
if [ -f "/var/tmp/libzdb-2.10.tar.gz" ];then
    rm -f /var/tmp/libzdb-2.10.tar.gz
fi
if [ -d "/var/tmp/libzdb-2.10" ];then
    rm -rf /var/tmp/libzdb-2.10
fi
wget -P/var/tmp ftp://192.168.0.250/packs/libzdb-2.10.tar.gz
cd /var/tmp
tar xvf libzdb-2.10.tar.gz
cd libzdb-2.10
./configure
make -j8
make install
cd ..
#if ! grep -q "/usr/local/lib" /etc/ld.so.conf;then
#    echo /usr/local/lib >> /etc/ld.so.conf
#fi
#ldconfig


if [ -f "/var/tmp/zeromq-2.1.10.tar.gz" ];then
    rm -f /var/tmp/zeromq-2.1.10.tar.gz
fi  
if [ -d "/var/tmp/zeromq-2.1.10" ];then
    rm -rf /var/tmp/zeromq-2.1.10
fi
wget -P/var/tmp ftp://192.168.0.250/packs/zeromq-2.1.10.tar.gz
tar xvf zeromq-2.1.10.tar.gz
cd  zeromq-2.1.10
./configure
make -j8
make install
cd ..

if [ -f "/var/tmp/jzmq.tar" ];then
    rm -f /var/tmp/jzmq.tar
fi  
if [ -d "/var/tmp/jzmq" ];then
    rm -rf /var/tmp/jzmq
fi  
wget -P/var/tmp ftp://192.168.0.250/packs/jzmq.tar
tar xvf jzmq.tar
cd jzmq
./autogen.sh
./configure
make -j8
make install
cd ..
cd /var/tmp


if [ -f "/var/tmp/inotify-tools-3.14.tar.gz" ];then
    rm -f /var/tmp/inotify-tools-3.14.tar.gz
fi  
if [ -d "/var/tmp/inotify-tools-3.14" ];then
    rm -rf /var/tmp/inotify-tools-3.14
fi  
wget -P/var/tmp ftp://192.168.0.250/packs/inotify-tools-3.14.tar.gz
tar xvf inotify-tools-3.14.tar.gz
cd inotify-tools-3.14
./configure
make -j8
make install
cd ..
cd /var/tmp
