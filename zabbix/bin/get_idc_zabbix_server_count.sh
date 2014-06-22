#!/bin/bash
#ssh 192.168.0.40 "ps aux|grep zabbix_server|grep -v grep |wc -l " 2> /dev/null
cat /tmp/zabbix_server_count
echo "0"  > /tmp/zabbix_server_count
