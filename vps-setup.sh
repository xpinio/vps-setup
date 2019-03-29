#!/bin/bash

apt-get update
apt-get upgrade -y

# -------------- install webmin --------------------
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
#echo "" >> /etc/apt/sources.list
#echo "#webmin" >> /etc/apt/sources.list
#echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list

curl -fsSL http://www.webmin.com/jcameron-key.asc | sudo apt-key add -


# -------------- install docker ---------------------
apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sh -c 'echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list'

# --------------- install certbot ----------------
apt-get install software-properties-common -y
add-apt-repository -y ppa:certbot/certbot

apt-get update
apt-get install webmin docker-ce docker-compose certbot -y

# change sshd port
sed -i -e 's/^#*Port[[:space:]{1,}].*/Port 10012/' /etc/ssh/sshd_config
service sshd restart

#change webmin port
sed -i -e 's/^port=[[:digit:]]*/port=10011/' /etc/webmin/miniserv.conf
service webmin restart

# ------------ firewall ----------------
apt-get install iptables-persistent netfilter-persistent -y
iptables-restore < iptables.save
iptables-save > /etc/iptables/rules.v4

service docker restart

exit 0