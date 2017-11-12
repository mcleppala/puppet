# Multislave vagrant for Puppet
# Copyright 2017 Tero Karvinen http://TeroKarvinen.com

$tscript = <<TSCRIPT
set -o verbose
echo "See you on http://TeroKarvinen.com"
apt-get update
apt-get -y install puppet
grep ^server /etc/puppet/puppet.conf || echo -e "\n[agent]\nserver=master\n" |sudo tee -a /etc/puppet/puppet.conf
grep master /etc/hosts || echo -e "\n192.168.1.103 master\n"|sudo tee -a /etc/hosts
puppet agent --enable
sudo service puppet start
sudo service puppet restart
TSCRIPT

Vagrant.configure(2) do |config|

 config.vm.box = "bento/ubuntu-16.04"
 config.vm.provision "shell", inline: $tscript
 
 config.vm.define "vagrants01" do |vagrants01|
 vagrants01.vm.hostname = "vagrants01"
 end
 
end
