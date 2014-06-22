#!/bin/bash

ssl_url=$1
ssl_port=$2
timeout=20

> /tmp/ssl_ca_status_$ssl_url
/opt/zabbix/bin/timeout $timeout /usr/bin/openssl s_client -showcerts -connect $ssl_url:$ssl_port > /tmp/ssl_ca_status_$ssl_url 2>&1
cat /tmp/ssl_ca_status_$ssl_url |grep Verify|awk '{print $4}'
