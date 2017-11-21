echo "*******************************************"
echo "Asetetaan näppäimistön kieli ja aikavyöhyke"
echo "*******************************************"
setxkbmap fi
sudo timedatectl set-timezone Europe/Helsinki
echo "*******************************************"
echo "Asennetaan Ansible, Tree ja OpenSSH"
echo "*******************************************"
sudo apt-get update
sudo apt-get install -y ansible tree openssh-server openssh-client ssh
echo "*******************************************"
echo "Muokataan /etc/ansible/hosts-tiedostoa"
echo "*******************************************"
echo -e "\n[orja]\n192.168.1.102\n"|sudo tee -a /etc/ansible/hosts
echo "*******************************************"
echo "Luodaan avainpari ja kopioidaan se orjalle"
echo "*******************************************"
cd
cd .ssh/
ssh-keygen -f id_rsa -t rsa -N ''
ssh-copy-id xubuntu@192.168.1.102
echo "*******************************************"
echo "Asennus valmis"
echo "*******************************************"
