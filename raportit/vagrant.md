# Slave/vagrant
vagrant@vagrant:~$ history
    1  hostnamectl set-hostname slave
    2  sudoedit /etc/hosts
    9  sudo apt-get install -y puppet
   10  sudoedit /etc/puppet/puppet.conf 
   11  service puppet restart
   12  ping master
   13  ifconfig
   14  sudoedit /etc/hosts
   15  ping -c 1 master
   16  service puppet restart
   17  sudo puppet agent --enable
   21  sudo puppet agent -t
   24  sudoedit /etc/puppet/puppet.conf 
   25  ping -c 1 master
   26  sudo puppet agent -tdv
   27  sudo service puppet stop
   28  sudo rm -r /var/lib/puppet/ssl
   29  sudo service puppet start
   30  sudo puppet agent --enable
   31  sudo puppet agent -t
   32  history

# /etc/hosts

```
127.0.0.1       localhost
127.0.1.1       vagrant.vm      vagrant slave
172.28.172.179  master

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

# Master
xubuntu@master:~$ history
    1  cd /etc/
    2  cd puppet
    3  tree
    4  passpwd
    5  passwd
    6  wget https://raw.githubusercontent.com/mcleppala/puppet/master/asennus.sh
    7  bash asennus.sh 
    8  ls
    9  cd puppet
   10  ls
   11  mkdir varkuuskopio
   12  ls
   13  tree
   14  cp -r /etc/puppet
   15  cp -r /etc/puppet/ /home/xubuntu/puppet/varkuuskopio/ 
   16  tree
   17  cd ..
   18  git add .
   19  cd puppet/
   20  git add .
   21  git commit
   22  git config --global user.email "minna.leppala@outlook.com"
   23  git config --global user.name "mcleppala"
   24  git commit
   25  git pull
   26  git push
   27  tre
   28  tree
   29  cd puppet/varkuuskopio/
   30  tree
   31  cd puppet/modules/mysql/manifests/
   32  nano init.pp 
   33  hostnamectl set-hostname master
   34  service avahi-daemon restart
   35  sudoedit /etc/hosts
   36  ping -c 1 slave
   37  ping -c 1 slave.local
   38  ifconfig
   39  sudoedit /etc/hosts
   40  sudoedit /etc/hostnames
   41* 
   42  ping -c 1 slave
   43  service puppet restart
   44  ping -c 1 slave
   45  sudo apt-get install -y puppetmaster
   46  service puppetmaster stop
   47  sudoedit /etc/puppet/puppet.conf 
   48  service puppetmaster start
   49  ifcongig
   50  ifconfig
   51  sudo service puppetmaster stop
   52  sudo rm -r /var/lib/puppet/ssl
   53  sudoedit /etc/puppet/puppet.conf 
   54  sudo service puppetmaster start
   55  sudo puppet --sign slave
   56  sudo puppet cert --list
   57  sudo puppet cert --list --all
   58  sudo puppet cert --list
   59  sudo puppet cert --list --all
   60  sudo puppet cert --list
   61  sudo puppet cert --list --all
   62  sudo puppet cert --list
   63  sudo puppet cert --list --all
   64* sudo puppet cert
   65  sudo puppet cert --list --all
   66  sudo service puppetmaster restart
   67  sudo ls /var/log/puppet/
   68  sudo tail -F /var/log/puppet/masterhttp.log
   69  history 
   70  sudo service puppetmaster stop
   71  sudo rm -r /var/lib/puppet/ssl
   72  sudo service puppetmaster start
   73  sudo puppet cert --list
   74  sudo puppet --sign slave.vm
   75  sudo puppet cert --sign slave.vm
   76  sudo puppet cert --list
   77  sudo puppet cert --list --all
   78  history
   
# /etc/hosts
```
127.0.0.1 localhost
127.0.1.1 xubuntu master

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
```
