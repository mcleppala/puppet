echo "*******************************************"
echo "Asennetaan Puppet ja Tree"
echo "*******************************************"
sudo apt-get update
sudo apt-get install -y puppet tree
echo "*******************************************"
echo "Asetetaan hostname ja editoidaan hosts-tiedosto"
echo "*******************************************"
hostnamectl set-hostname vagrant
grep master /etc/hosts || echo -e "\n192.168.1.103 master\n"|sudo tee -a /etc/hosts
grep ^server /etc/puppet/puppet.conf || echo -e "\n[agent]\nserver=master\n" |sudo tee -a /etc/puppet/puppet.conf
echo "*******************************************"
echo "Tehdään Puppetin uudelleen käynistys, ssl-kansion siivous ja testiyhteys"
echo "*******************************************"
sudo service puppet restart
sudo service puppet stop
sudo rm -r /var/lib/puppet/ssl
sudo service puppet start
sudo puppet agent --enable
sudo puppet agent -tdv
echo "*******************************************"
echo "Asennus valmis."
echo "*******************************************"
