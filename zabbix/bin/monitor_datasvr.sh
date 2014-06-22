#!/bin/bash

wget http://datasvr.networkbench.com/datasvr/reportLog.do --http-user=netben --http-passwd=nbs20080220 -O /tmp/datasvr.do > /dev/null 2>&1
if [ "$1" == "task_file_queue" ];then
cat /tmp/datasvr.do|grep "Task File Queue"|awk '{print $4}'|awk -F, '{print $1}'

elif [ "$1" == "data_object_queue" ];then
cat /tmp/datasvr.do|grep "Data Object Queue"|awk '{print $NF}'

elif [ "$1" == "insert_oracle_rate" ];then
cat /tmp/datasvr.do |grep Suspended|awk '{print $2}'|awk -F\; '{print $2}'|awk -F, '{print $1}'
fi
