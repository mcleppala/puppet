echo "*******************************************"
echo "Asetetaan näppäimistön kieli ja aikavyöhyke"
echo "*******************************************"
setxkbmap fi
sudo timedatectl set-timezone Europe/Helsinki
echo "*******************************************"
echo "Asennetaan Salt-master ja Tree"
echo "*******************************************"
sudo apt-get update
sudo apt-get install -y salt-minion tree
echo "*******************************************"
echo "Muokataan /etc/salt/minion-tiedostoa"
echo "*******************************************"
echo -e "\nmaster: 192.168.1.101\n"|sudo tee -a /etc/salt/minion
echo "*******************************************"
echo "Asennus valmis"
echo "*******************************************"
