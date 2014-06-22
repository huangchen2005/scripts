#!/bin/sh
cat >> /var/log/send_tuilifang <<EOF
`date +%F_%T`
收件人:$1
标题:$2
内容:$3
--------
EOF
wget "http://www.tui3.com/api/send/?k=129b285719826c60872d0ecd5b6b002c&r=json&p=1id&t=$1&c=$2" > /dev/null 2>&1
