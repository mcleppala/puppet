echo "*******************************************"
echo "Asetetaan näppäimistön kieli ja aikavyöhyke"
echo "*******************************************"
setxkbmap fi
sudo timedatectl set-timezone Europe/Helsinki
echo "*******************************************"
echo "Asennetaan Puppetmaster, Tree, Github, VirtualBox ja Vagrant"
echo "*******************************************"
sudo apt-get update
sudo apt-get install -y puppetmaster tree git virtualbox vagrant
echo "*******************************************"
echo "Kloonataan repository ja kopioidaan tiedostot"
echo "*******************************************"
git clone https://github.com/mcleppala/puppetconf
sudo cp -r /home/$USER/puppetconf/modules/moiminna /etc/puppet/modules/
sudo cp -r /home/$USER/puppetconf/manifests/site.pp /etc/puppet/manifests/
echo "*******************************************"
echo "Poistetaan tilaa viemästä GitHub klooni"
echo "*******************************************"
cd
sudo rm -r /home/$USER/puppetconf/
echo "*******************************************"
echo "Asetetaan hostname ja editoidaan hosts-tiedosto"
echo "*******************************************"
hostnamectl set-hostname master
grep master /etc/hosts || echo -e "\n127.0.0.1 master\n"|sudo tee -a /etc/hosts
grep ^server /etc/puppet/puppet.conf || echo -e "\ndns_alt_names = puppet, master\n" |sudo tee -a /etc/puppet/puppet.conf
sudo service puppetmaster start
echo "*******************************************"
echo "Pysätytetään Puppetmaster, poistetaan ssl ja käynnistys"
echo "*******************************************"
sudo service puppetmaster stop
sudo rm -r /var/lib/puppet/ssl
sudo service puppetmaster start
echo "*******************************************"
echo "Tehdään yksi virtuaalikone"
echo "*******************************************"
cd
mkdir vagrant
cd vagrant/
#wget https://raw.githubusercontent.com/mcleppala/puppet/master/Vagrantfile
vagrant init bento/ubuntu-16.04
vagrant up
echo "*******************************************"
echo "Asennus valmis."
echo "*******************************************"
