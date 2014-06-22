#!/bin/bash
cat >> /var/log/send_mail <<EOF
`date +%F_%T`
收件人:$1
标题:$2
内容:$3
--------
EOF
echo $3 |mail -s "$2" $1
