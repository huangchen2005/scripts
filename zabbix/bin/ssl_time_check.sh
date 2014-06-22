#!/bin/bash

ssl_url=$1
ssl_port=$2
timeout=20


/opt/zabbix/bin/timeout $timeout /bin/ssl-cert-check -s $ssl_url -p $ssl_port|grep $ssl_url |awk '{print $6}'
#/bin/ssl-cert-check -s $ssl_url -p $ssl_port|grep $ssl_url > /tmp/ssl_time_status
