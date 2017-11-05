echo "*******************************************"
echo "Asetetaan näppäimistön kieli ja aikavyöhyke"
echo "*******************************************"
setxkbmap fi
sudo timedatectl set-timezone Europe/Helsinki
echo "*******************************************"
echo "Asennetaan Puppet, Tree ja Github"
echo "*******************************************"
sudo apt-get update
sudo apt-get install -y puppet tree git
echo "*******************************************"
echo "Kloonataan repository ja kopioidaan tiedostot"
echo "*******************************************"
git clone https://github.com/mcleppala/puppet
sudo cp -r /home/xubuntu/puppet/modules/apache2 /etc/puppet/modules/
sudo cp -r /home/xubuntu/puppet/modules/sshd /etc/puppet/modules/
sudo cp -r /home/xubuntu/puppet/modules/mysql /etc/puppet/modules/
sudo cp -r /home/xubuntu/puppet/manifests/site.pp /etc/puppet/manifests/
echo "*******************************************"
echo "Asennus valmis."
echo "*******************************************"
