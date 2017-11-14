# Multislave vagrant for Puppet
# Copyright 2017 Tero Karvinen http://TeroKarvinen.com

$tscript = <<TSCRIPT
sudo apt-get update
sudo apt-get -y install puppet tree
grep ^server /etc/puppet/puppet.conf || echo -e "\n[agent]\nserver=master\n" |sudo tee -a /etc/puppet/puppet.conf
grep master /etc/hosts || echo -e "\n192.168.1.103 master\n"|sudo tee -a /etc/hosts
sudo service puppet restart
sudo service puppet stop
sudo rm -r /var/lib/puppet/ssl
sudo service puppet start
sudo puppet agent --enable
TSCRIPT

Vagrant.configure(2) do |config|

 config.vm.box = "bento/ubuntu-16.04"
 config.vm.provision "shell", inline: $tscript
 
 config.vm.define "vagrant01" do |vagrant01|
 vagrant01.vm.hostname = "vagrant01"
 end
 
 config.vm.define "vagrant02" do |vagrant02|
 vagrant02.vm.hostname = "vagrant02"
 end 
  
 config.vm.define "vagrant03" do |vagrant03|
 vagrant03.vm.hostname = "vagrant03"
 end 
 
 config.vm.provider "virtualbox" do |vb|
 #  Customize the amount of memory on the VM:
 vb.memory = "256"
 end
end
