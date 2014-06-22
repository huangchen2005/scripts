#!/bin/bash
if [ -f "/var/tmp/prismdeployment.tar.gz" ];then
        rm -f /var/tmp/prismdeployment.tar.gz
fi
wget -P/var/tmp ftp://192.168.0.250/packs/prismdeployment.tar.gz
cd /var/tmp
if [ -d "/var/tmp/prismdeployment" ];then
        rm -rf prismdeployment
fi
tar xvf prismdeployment.tar.gz

if [ -d "/opt/prismdeployment" ];then
        rm -rf /opt/prismdeployment
fi
mkdir /opt/ReplayData

cp -rf prismdeployment /opt/prismdeployment
#if ! grep -q "/opt/prismdeployment/prism/libs" /etc/ld.so.conf;then
#        echo /opt/prismdeployment/prism/libs >> /etc/ld.so.conf
#fi
#ldconfig


if [ -f "/etc/init.d/prism-script" ];then
        rm -f /etc/init.d/prism-script
fi
cp -f /opt/prismdeployment/tools/prism-script /etc/init.d/prism-script
cp -f /opt/prismdeployment/tools/set_irq_and_load /etc/init.d/set_irq_and_load
chmod +x /etc/init.d/prism-script
chmod +x /etc/init.d/set_irq_and_load
chkconfig prism-script on
chkconfig set_irq_and_load on

/opt/prismdeployment/tools/update_crontab.sh

if [ ! -d "/data/data" ];then
        mkdir /data/data
fi

if [ -f "/var/tmp/di_rsa_new_new_machine.tar.gz" ];then
        rm -f /var/tmp/di_rsa_new_new_machine.tar.gz
fi
wget -P/var/tmp ftp://192.168.0.250/packs/di_rsa_new_new_machine.tar.gz
tar xvf di_rsa_new_new_machine.tar.gz
if [ -f "/var/tmp/di_rsa_new_new_machin/License" ];then
        rm -f /var/tmp/di_rsa_new_new_machine/License
fi
if [ -f "/var/tmp/di_rsa_new_new_machine/SourceData" ];then
        rm -f /var/tmp/di_rsa_new_new_machine/SourceData
fi
rm -f /var/tmp/di_rsa_new_new_machine/License /var/tmp/di_rsa_new_new_machine/SourceData
dmidecode >> di_rsa_new_new_machine/SourceData
cd di_rsa_new_new_machine
sh get_key.sh
if [ -f "/opt/License" ];then
        rm -f /opt/License
fi
cp -f License /opt/License


if [ -f "/var/tmp/prismdeployment/prism/SSL.tar.gz" ];then
    cd /var/tmp/prismdeployment/prism/
    tar xvf SSL.tar.gz
    mv SSL /home/
    rm /opt/prismdeployment/prism/SSL.tar.gz -rf
fi


rm -rf /var/tmp/di_rsa /var/tmp/di_rsa.tar.gz

rm -rf /var/tmp/prismdeployment /var/tmp/prismdeployment.tar.gz
#chown -R prism.prism  /opt/prismdeployment/
#chown -R prism.prism /etc/init.d/prism-script
#chown -R prism.prism /etc/init.d/set_irq_and_load
#chown -R prism.prism /opt/ReplayData
cd /var/tmp
