#!/bin/bash
DBHOST=$1

/usr/bin/mysql -uroot -pnEtbendbsa2o13  -h $DBHOST  -A  -e "show slave status\G"|grep Seconds_Behind_Master|awk -F: '{print $2}'
