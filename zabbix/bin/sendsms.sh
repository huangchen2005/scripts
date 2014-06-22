#!/bin/sh
cat >> /var/log/sendsms <<EOF
`date +%F_%T`
收件人:$1
标题:$2
内容:$3
--------
EOF
wget "http://123.103.98.19/fx.php?to=$1&msg=$2" > /dev/null 2>&1
