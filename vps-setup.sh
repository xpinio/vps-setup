#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install apt-transport-https ca-certificates curl software-properties-common iptables-persistent netfilter-persistent -y

# -------------- install webmin --------------------
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
curl -fsSL http://www.webmin.com/jcameron-key.asc | sudo apt-key add -


# -------------- install docker ---------------------
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sh -c 'echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list'

# --------------- install certbot ----------------
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
iptables-restore < iptables.save
iptables-save > /etc/iptables/rules.v4

service docker restart

exit 0