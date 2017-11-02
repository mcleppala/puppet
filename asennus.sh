setxkbmap fi
sudo timedatectl set-timezone Europe/Helsinki
sudo apt-get update
sudo apt-get install -y puppet tree git
git clone https://github.com/mcleppala/puppetconf
sudo cp -r /home/xubuntu/puppetconf/puppetter /etc/
