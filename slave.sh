sudo apt-get update
sudo apt-get install -y puppet tree
hostnamectl set-hostname slave
grep master /etc/hosts || echo -e "\n192.168.1.103 master\n"|sudo tee -a /etc/hosts
grep ^server /etc/puppet/puppet.conf || echo -e "\n[agent]\nserver=master\n" |sudo tee -a /etc/puppet/puppet.conf
sudo service puppet restart
sudo service puppet stop
sudo rm -r /var/lib/puppet/ssl
sudo service puppet start
sudo puppet agent --enable
sudo puppet agent -tdv
