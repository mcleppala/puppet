echo "*******************************************"
echo "Asetetaan näppäimistön kieli ja aikavyöhyke"
echo "*******************************************"
setxkbmap fi
sudo timedatectl set-timezone Europe/Helsinki
echo "*******************************************"
echo "Asennetaan Salt-master ja Tree"
echo "*******************************************"
sudo apt-get update
sudo apt-get install -y salt-master tree
echo "*******************************************"
echo "Muokataan /etc/salt/master-tiedostoa"
echo "*******************************************"
echo -e "\ninterface: 192.168.1.101\n"|sudo tee -a /etc/salt/master
echo "*******************************************"
echo "Asennus valmis"
echo "*******************************************"
