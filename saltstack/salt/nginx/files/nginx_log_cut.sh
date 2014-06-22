#!/bin/bash

logs_path=/opt/nginx/logs
pid_path=/opt/nginx/logs/nginx.pid
yesterday=`date -d "yesterday" +%F`

mkdir -p $logs_path/$yesterday

cd $logs_path

for nginx_logs in `ls *log`
do
mv $nginx_logs ${yesterday}/${yesterday}-${nginx_logs}

kill -USR1 `cat ${pid_path}`
done
