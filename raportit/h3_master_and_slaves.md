# Herra ja useita orjia
Kolmannen viikon [tehtävänä](http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5#comment-23269) oli asentaa useita orjia yhdelle herralle ja tutkia orjien asetuksia. Erinäisistä ongelmista johtuen, jotka käyvät ilmi tästä raportista, työskentelyyn meni aikaa noin 14 tuntia, eikä tullut ihan valmista.

## a) Asenna useita orjia yhteen masteriin. Ainakin yksi rauta- ja useampia virtuaalisia orjia. 
Edeltävällä viikolla tein viikkotehtävän VMWaren Playerillä, kun minulla ei ollut toista konetta käytössäni. Nyt onneksi olin saanut kaverin vanhan läppärin, jossa oleva Vista ei enää käynnistynyt ollenkaan. Romukone siis. Modifoin koneen biosin buuttia siten, että kone alkoi buutata suoraan tikulta. Muutos oli hieman erilainen, sillä tämä kone ei tunnistanut BIOSissa tikkua ja hetken tutkittuani huomasin, että se tulkitsee Transcend tikun kovelevyksi. Muutin siis kovalevyjen buuttijärjestyksen siten, että ensin tikku ja sitten vasta kovalevy ja sain koneen käynnistymän livetikulta.

Kone on ASUS X5DINK. Tarkemmat tiedot katsoin komennolla 
```
sudo lshw -short -sanitize
```
Ja alla koneen tarkat tiedot
```
H/W path                Device      Class       Description
===========================================================
                                    system      K50IN (To Be Filled By O.E.M.)
/0                                  bus         K50IN
/0/0                                memory      64KiB BIOS
/0/4                                processor   Pentium(R) Dual-Core CPU       T
/0/4/5                              memory      64KiB L1 cache
/0/4/6                              memory      1MiB L2 cache
/0/21                               memory      4GiB System Memory
/0/21/0                             memory      2GiB DIMM SDRAM Synchronous 2048
/0/21/1                             memory      2GiB DIMM SDRAM Synchronous 2048
/0/100                              bridge      MCP79 Host Bridge
/0/100/0.1                          memory      RAM memory
/0/100/3                            bridge      MCP79 LPC Bridge
/0/100/3.1                          memory      RAM memory
/0/100/3.2                          bus         MCP79 SMBus
/0/100/3.3                          memory      RAM memory
/0/100/3.5                          processor   MCP79 Co-processor
/0/100/4                            bus         MCP79 OHCI USB 1.1 Controller
/0/100/4/1              usb2        bus         OHCI PCI host controller
/0/100/4.1                          bus         MCP79 EHCI USB 2.0 Controller
/0/100/4.1/1            usb1        bus         EHCI Host Controller
/0/100/4.1/1/2          scsi2       storage     Mass Storage Device
/0/100/4.1/1/2/0.0.0    /dev/sdb    disk        32GB SCSI Disk
/0/100/4.1/1/2/0.0.0/1  /dev/sdb1   volume      29GiB Windows FAT volume
/0/100/4.1/1/5                      multimedia  CNF7129
/0/100/8                            multimedia  MCP79 High Definition Audio
/0/100/9                            bridge      MCP79 PCI Bridge
/0/100/b                            storage     MCP79 AHCI Controller
/0/100/c                            bridge      MCP79 PCI Express Bridge
/0/100/10                           bridge      MCP79 PCI Express Bridge
/0/100/10/0                         display     C79 [GeForce G102M]
/0/100/15                           bridge      MCP79 PCI Express Bridge
/0/100/15/0             enp4s0      network     RTL8111/8168/8411 PCI Express Gi
/0/100/16                           bridge      MCP79 PCI Express Bridge
/0/100/16/0             wlp5s0      network     AR9285 Wireless Network Adapter 
/0/1                    scsi0       storage     
/0/1/0.0.0              /dev/sda    disk        320GB Hitachi HTS54323
/0/1/0.0.0/1            /dev/sda1   volume      11GiB Windows FAT volume
/0/1/0.0.0/2            /dev/sda2   volume      149GiB Windows NTFS volume
/0/1/0.0.0/3            /dev/sda3   volume      137GiB Windows FAT volume
/0/1/0.0.0/3/5          /dev/sda5   volume      137GiB HPFS/NTFS partition
/0/2                    scsi1       storage     
/0/2/0.0.0              /dev/cdrom  disk        DVD-RAM UJ880AS
xubuntu@xubuntu:~$ 
```
Masterina käytin samaa vanhaa [konettani](https://minnaleppala.files.wordpress.com/2017/08/lista.png?w=1000).
UPDATE: Jouduin vaihtamaan käyttööni ystäväni koneen, kun omani ei toiminut. Tarkemmin tässä raportissa myöhemmässä vaiheessa.

Aloitin tehtävän tekemisen toistamalla edeltävän viikon [tehtävän](https://github.com/mcleppala/puppet/blob/master/raportit/h2_livetikku_asetukset_githubista.md) vaiheet. 

### Masterin asetukset
Masterille asensin Puppetmasterin komennolla
```
sudo apt-get install -y puppetmaster
```
Muutan koneen hostnamen komennolla
```
hostnamectl set-hostname master
```
Ja editoin hosts-tiedostoa komennolla
```
sudoedit /etc/hosts
```
Sitten pysäytän puppetmasterin ja poistan ssl-kansion komennoilla
```
sudo service puppetmaster stop
sudo rm -r /var/lib/puppet/ssl
```
Seuraavaksi editoin master-koneen puppet.conf-tiedostoa komennolla
```
sudoedit /etc/puppet/puppet.conf
```
Ja lisäsin tiedostoon seuraavan rivin [master]-otsikon alle
```
dns_alt_names = puppet, master
```
Ja käynnistetään puppetmaster uudestaan komennolla
```
sudo service puppetmaster start
```
Poistetaan vielä sertifikaatit ja käynnistetään puppetmaster
```
sudo service puppetmaster stop
sudo rm -r /var/lib/puppet/ssl
sudo service puppetmaster start
```

### Rauta-slaven asetukset
Lisään slave-koneen hosts-tiedostoon tiedon masterista sekä slavesta edeltävällä komennolla. Alla hosts-tiedoston sisältö
```
127.0.0.1 localhost
127.0.1.1 xubuntu slave
192.168.1.112 master

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
```
Muutan myös slaven hostnamen komennolla
```
hostnamectl set-hostname slave
```
Sitten slave-koneella testi, että yhteys toimii ja kyllä toimii, alla komento ja tulos
```
xubuntu@xubuntu:~$ ping -c 1 master
PING master (192.168.1.112) 56(84) bytes of data.
64 bytes from master (192.168.1.112): icmp_seq=1 ttl=64 time=20.1 ms

--- master ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 20.198/20.198/20.198/0.000 ms
xubuntu@xubuntu:~$
```
Päivitän paketinhallinnan komennolla
```
sudo apt-get update
```
Mutta saankin paketinhallinnasta virheen "AppStream cache update failed." Joten joudun etsimään ratkaisua googlen avulla. AskUbuntun-foorumilta löytyykin [ohje](https://askubuntu.com/questions/854168/how-i-can-fix-appstream-cache-update-completed-but-some-metadata-was-ignored-d), mutta virhe ei korjaudu. Päätän jatkaa tehtävän tekoa virheestä huolimatta ja asennan 
Puppetin ja Treen komennolla
```
sudo apt-get install -y puppet tree
```
Asennus menee läpi ongelmitta. Tämän jälkeen päivitän puppet.conf-tiedoston komennolla
```
sudoedit /etc/puppet/puppet.conf
```
Lisäsin tiedostoon ohjeen mukaisesti rivit
```
[agent]
server = master
```
Ja käynnistetään Puppet uudestaan komennolla
```
sudo service puppet restart
```
Täsä kohtaa tulee mieleeni, että tunnilla minulla oli ongelmia serttien kanssa, joten kaiken varalta poistan vielä slavelta sertit komennoilla
```
sudo service puppet stop
sudo rm -r /var/lib/puppet/ssl
```
Pysäytys ei kuitenkaan onnistu, sillä puppet restart oli käynnistänyt myös agentin, jonka pysäytin komennolla
```
sudo puppet agent --disable
```
Ja sitten pysäytys onnistuu komennolla
```
sudo service puppet stop
```
Ja sitten poistin kansion komennolla
```
sudo rm -r /var/lib/puppet/ssl
```
Ja käynnistin puppetin komennolla
```
sudo service puppet start
```
Sitten käynnistin agentin komennolla
```
sudo puppet agent --enable
```
Ja teen agentilla testin
```
sudo puppet agent -t
```
Mutta mitään ei tapahdu ja saan seuraavan virheilmoituksen
```
Error: Could not request certificate: execution expired
Exiting; failed to retrieve certificate and waitforcert is disabled
```
Sitten ajan vielä agentilla testin ja debugin, alla tulos
```
xubuntu@xubuntu:~$ sudo puppet agent -tdv
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Using settings: adding file resource 'confdir': 'File[/etc/puppet]{:path=>"/etc/puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Puppet::Type::User::ProviderUser_role_add: file roleadd does not exist
Debug: Failed to load library 'ldap' for feature 'ldap'
Debug: Puppet::Type::User::ProviderLdap: feature ldap is missing
Debug: Puppet::Type::User::ProviderPw: file pw does not exist
Debug: Puppet::Type::User::ProviderDirectoryservice: file /usr/bin/dsimport does not exist
Debug: /User[puppet]: Provider useradd does not support features libuser; not managing attribute forcelocal
Debug: Failed to load library 'ldap' for feature 'ldap'
Debug: Puppet::Type::Group::ProviderLdap: feature ldap is missing
Debug: Puppet::Type::Group::ProviderPw: file pw does not exist
Debug: Puppet::Type::Group::ProviderDirectoryservice: file /usr/bin/dscl does not exist
Debug: /Group[puppet]: Provider groupadd does not support features libuser; not managing attribute forcelocal
Debug: Using settings: adding file resource 'vardir': 'File[/var/lib/puppet]{:path=>"/var/lib/puppet", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'logdir': 'File[/var/log/puppet]{:path=>"/var/log/puppet", :mode=>"750", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'statedir': 'File[/var/lib/puppet/state]{:path=>"/var/lib/puppet/state", :mode=>"1755", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'rundir': 'File[/run/puppet]{:path=>"/run/puppet", :mode=>"755", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'libdir': 'File[/var/lib/puppet/lib]{:path=>"/var/lib/puppet/lib", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'preview_outputdir': 'File[/var/lib/puppet/preview]{:path=>"/var/lib/puppet/preview", :mode=>"750", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'certdir': 'File[/var/lib/puppet/ssl/certs]{:path=>"/var/lib/puppet/ssl/certs", :mode=>"755", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'ssldir': 'File[/var/lib/puppet/ssl]{:path=>"/var/lib/puppet/ssl", :mode=>"771", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'publickeydir': 'File[/var/lib/puppet/ssl/public_keys]{:path=>"/var/lib/puppet/ssl/public_keys", :mode=>"755", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'requestdir': 'File[/var/lib/puppet/ssl/certificate_requests]{:path=>"/var/lib/puppet/ssl/certificate_requests", :mode=>"755", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'privatekeydir': 'File[/var/lib/puppet/ssl/private_keys]{:path=>"/var/lib/puppet/ssl/private_keys", :mode=>"750", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'privatedir': 'File[/var/lib/puppet/ssl/private]{:path=>"/var/lib/puppet/ssl/private", :mode=>"750", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'hostprivkey': 'File[/var/lib/puppet/ssl/private_keys/slave.bb.dnainternet.fi.pem]{:path=>"/var/lib/puppet/ssl/private_keys/slave.bb.dnainternet.fi.pem", :mode=>"640", :owner=>"puppet", :group=>"puppet", :ensure=>:file, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'hostpubkey': 'File[/var/lib/puppet/ssl/public_keys/slave.bb.dnainternet.fi.pem]{:path=>"/var/lib/puppet/ssl/public_keys/slave.bb.dnainternet.fi.pem", :mode=>"644", :owner=>"puppet", :group=>"puppet", :ensure=>:file, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'clientyamldir': 'File[/var/lib/puppet/client_yaml]{:path=>"/var/lib/puppet/client_yaml", :mode=>"750", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'client_datadir': 'File[/var/lib/puppet/client_data]{:path=>"/var/lib/puppet/client_data", :mode=>"750", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'clientbucketdir': 'File[/var/lib/puppet/clientbucket]{:path=>"/var/lib/puppet/clientbucket", :mode=>"750", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'graphdir': 'File[/var/lib/puppet/state/graphs]{:path=>"/var/lib/puppet/state/graphs", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'pluginfactdest': 'File[/var/lib/puppet/facts.d]{:path=>"/var/lib/puppet/facts.d", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: /File[/var/lib/puppet/state]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/lib]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/preview]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/ssl/certs]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/ssl/public_keys]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl/certificate_requests]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl/private_keys]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl/private]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl/private_keys/slave.bb.dnainternet.fi.pem]: Autorequiring File[/var/lib/puppet/ssl/private_keys]
Debug: /File[/var/lib/puppet/ssl/public_keys/slave.bb.dnainternet.fi.pem]: Autorequiring File[/var/lib/puppet/ssl/public_keys]
Debug: /File[/var/lib/puppet/client_yaml]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/client_data]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/clientbucket]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/state/graphs]: Autorequiring File[/var/lib/puppet/state]
Debug: /File[/var/lib/puppet/facts.d]: Autorequiring File[/var/lib/puppet]
Debug: Finishing transaction 12768680
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Evicting cache entry for environment 'production'
Debug: Caching environment 'production' (ttl = 0 sec)
Debug: Runtime environment: puppet_version=3.8.5, ruby_version=2.3.1, run_mode=agent, default_encoding=UTF-8
Debug: Using settings: adding file resource 'confdir': 'File[/etc/puppet]{:path=>"/etc/puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'vardir': 'File[/var/lib/puppet]{:path=>"/var/lib/puppet", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'logdir': 'File[/var/log/puppet]{:path=>"/var/log/puppet", :mode=>"750", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'statedir': 'File[/var/lib/puppet/state]{:path=>"/var/lib/puppet/state", :mode=>"1755", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'rundir': 'File[/run/puppet]{:path=>"/run/puppet", :mode=>"755", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'libdir': 'File[/var/lib/puppet/lib]{:path=>"/var/lib/puppet/lib", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'preview_outputdir': 'File[/var/lib/puppet/preview]{:path=>"/var/lib/puppet/preview", :mode=>"750", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'certdir': 'File[/var/lib/puppet/ssl/certs]{:path=>"/var/lib/puppet/ssl/certs", :mode=>"755", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'ssldir': 'File[/var/lib/puppet/ssl]{:path=>"/var/lib/puppet/ssl", :mode=>"771", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'publickeydir': 'File[/var/lib/puppet/ssl/public_keys]{:path=>"/var/lib/puppet/ssl/public_keys", :mode=>"755", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'requestdir': 'File[/var/lib/puppet/ssl/certificate_requests]{:path=>"/var/lib/puppet/ssl/certificate_requests", :mode=>"755", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'privatekeydir': 'File[/var/lib/puppet/ssl/private_keys]{:path=>"/var/lib/puppet/ssl/private_keys", :mode=>"750", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'privatedir': 'File[/var/lib/puppet/ssl/private]{:path=>"/var/lib/puppet/ssl/private", :mode=>"750", :owner=>"puppet", :group=>"puppet", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'hostprivkey': 'File[/var/lib/puppet/ssl/private_keys/slave.bb.dnainternet.fi.pem]{:path=>"/var/lib/puppet/ssl/private_keys/slave.bb.dnainternet.fi.pem", :mode=>"640", :owner=>"puppet", :group=>"puppet", :ensure=>:file, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'hostpubkey': 'File[/var/lib/puppet/ssl/public_keys/slave.bb.dnainternet.fi.pem]{:path=>"/var/lib/puppet/ssl/public_keys/slave.bb.dnainternet.fi.pem", :mode=>"644", :owner=>"puppet", :group=>"puppet", :ensure=>:file, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: Using settings: adding file resource 'pluginfactdest': 'File[/var/lib/puppet/facts.d]{:path=>"/var/lib/puppet/facts.d", :ensure=>:directory, :loglevel=>:debug, :links=>:follow, :backup=>false}'
Debug: /File[/var/lib/puppet/state]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/lib]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/preview]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/ssl/certs]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl]: Autorequiring File[/var/lib/puppet]
Debug: /File[/var/lib/puppet/ssl/public_keys]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl/certificate_requests]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl/private_keys]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl/private]: Autorequiring File[/var/lib/puppet/ssl]
Debug: /File[/var/lib/puppet/ssl/private_keys/slave.bb.dnainternet.fi.pem]: Autorequiring File[/var/lib/puppet/ssl/private_keys]
Debug: /File[/var/lib/puppet/ssl/public_keys/slave.bb.dnainternet.fi.pem]: Autorequiring File[/var/lib/puppet/ssl/public_keys]
Debug: /File[/var/lib/puppet/facts.d]: Autorequiring File[/var/lib/puppet]
Debug: Finishing transaction 17481660
Debug: Creating new connection for https://master:8140
Error: Could not request certificate: execution expired
Exiting; failed to retrieve certificate and waitforcert is disabled
xubuntu@xubuntu:~$ 
```
Yritn tunnin ajan saada hommaa toimimaan, mutta jostain syystä en saa vaan sertifikaatteja haettua orjalle. Alan epäillä, että masterini ei nyt toimi asiallisesti. Yritin myös asentaa vielä vagrantin ja virtualboxin komennolla 
```
sudo apt-get install -y virtualbox vagrant
```
Mutta tässäkin tulee virhettä, joten nyt alan olla epätoivoinen.
```
minna@master:~$ sudo apt-get install virtualbox
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  virtualbox-qt
Suggested packages:
  vde2 virtualbox-guest-additions-iso
The following NEW packages will be installed:
  virtualbox virtualbox-qt
0 upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
Need to get 0 B/21,5 MB of archives.
After this operation, 90,2 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Selecting previously unselected package virtualbox.
(Reading database ... 263159 files and directories currently installed.)
Preparing to unpack .../virtualbox_5.0.40-dfsg-0ubuntu1.16.04.1_amd64.deb ...
Unpacking virtualbox (5.0.40-dfsg-0ubuntu1.16.04.1) ...
Selecting previously unselected package virtualbox-qt.
Preparing to unpack .../virtualbox-qt_5.0.40-dfsg-0ubuntu1.16.04.1_amd64.deb ...
Unpacking virtualbox-qt (5.0.40-dfsg-0ubuntu1.16.04.1) ...
Processing triggers for man-db (2.7.5-1) ...
Processing triggers for systemd (229-4ubuntu21) ...
Processing triggers for ureadahead (0.100.0-19) ...
Processing triggers for hicolor-icon-theme (0.15-0ubuntu1) ...
Processing triggers for shared-mime-info (1.5-2ubuntu0.1) ...
Processing triggers for gnome-menus (3.13.3-6ubuntu3.1) ...
Processing triggers for desktop-file-utils (0.22-1ubuntu5.1) ...
Processing triggers for mime-support (3.59ubuntu1) ...
Setting up virtualbox (5.0.40-dfsg-0ubuntu1.16.04.1) ...
vboxweb.service is a disabled or a static unit, not starting it.
Job for virtualbox.service failed because the control process exited with error code. See "systemctl status virtualbox.service" and "journalctl -xe" for details.
invoke-rc.d: initscript virtualbox, action "restart" failed.
● virtualbox.service - LSB: VirtualBox Linux kernel module
   Loaded: loaded (/etc/init.d/virtualbox; bad; vendor preset: enabled)
   Active: failed (Result: exit-code) since la 2017-11-11 15:19:32 EET; 4ms ago
     Docs: man:systemd-sysv-generator(8)
  Process: 19492 ExecStart=/etc/init.d/virtualbox start (code=exited, status=1/FAILURE)

marras 11 15:19:32 master systemd[1]: Starting LSB: VirtualBox Linux kernel.....
marras 11 15:19:32 master virtualbox[19492]:  * Loading VirtualBox kernel mo....
marras 11 15:19:32 master virtualbox[19492]:  * modprobe vboxdrv failed. Ple...y
marras 11 15:19:32 master virtualbox[19492]:    ...fail!
marras 11 15:19:32 master systemd[1]: virtualbox.service: Control process e...=1
marras 11 15:19:32 master systemd[1]: Failed to start LSB: VirtualBox Linux...e.
marras 11 15:19:32 master systemd[1]: virtualbox.service: Unit entered fail...e.
marras 11 15:19:32 master systemd[1]: virtualbox.service: Failed with resul...'.
Hint: Some lines were ellipsized, use -l to show in full.
Setting up virtualbox-qt (5.0.40-dfsg-0ubuntu1.16.04.1) ...
Processing triggers for systemd (229-4ubuntu21) ...
Processing triggers for ureadahead (0.100.0-19) ...
minna@master:~$ 

```
Ratkaisin yllä olevan ongelman siis hankkimalla vielä yhden koneen lisää. Alla koneen tarkemmat tiedot.
```
xubuntu@xubuntu:~$ sudo lshw -short -sanitize
H/W path                 Device      Class          Description
===============================================================
                                     system         N73JF
/0                                   bus            N73JF
/0/0                                 memory         64KiB BIOS
/0/4                                 processor      Intel(R) Core(TM) i5 CPU       M 460  @ 2.53GHz
/0/4/5                               memory         32KiB L1 cache
/0/4/6                               memory         256KiB L2 cache
/0/4/7                               memory         3MiB L3 cache
/0/41                                memory         6GiB System Memory
/0/41/0                              memory         4GiB SODIMM DDR3 Synchronous 1067 MHz (0.9 ns)
/0/41/1                              memory         DIMM [empty]
/0/41/2                              memory         2GiB SODIMM DDR3 Synchronous 1067 MHz (0.9 ns)
/0/41/3                              memory         DIMM [empty]
/0/100                               bridge         Core Processor DRAM Controller
/0/100/1                             bridge         Core Processor PCI Express x16 Root Port
/0/100/1/0                           display        GF108M [GeForce GT 425M]
/0/100/2                             display        Core Processor Integrated Graphics Controller
/0/100/16                            communication  5 Series/3400 Series Chipset HECI Controller
/0/100/1a                            bus            5 Series/3400 Series Chipset USB2 Enhanced Host Controller
/0/100/1a/1              usb1        bus            EHCI Host Controller
/0/100/1a/1/1                        bus            Integrated Rate Matching Hub
/0/100/1a/1/1/2                      multimedia     USB2.0 UVC 2M WebCam
/0/100/1a/1/1/5                      communication  BT-270
/0/100/1b                            multimedia     5 Series/3400 Series Chipset High Definition Audio
/0/100/1c                            bridge         5 Series/3400 Series Chipset PCI Express Root Port 1
/0/100/1c.1                          bridge         5 Series/3400 Series Chipset PCI Express Root Port 2
/0/100/1c.1/0            wls1        network        AR9285 Wireless Network Adapter (PCI-Express)
/0/100/1c.3                          bridge         5 Series/3400 Series Chipset PCI Express Root Port 4
/0/100/1c.3/0                        bus            Fresco Logic
/0/100/1c.3/0/0          usb3        bus            xHCI Host Controller
/0/100/1c.3/0/1          usb4        bus            xHCI Host Controller
/0/100/1c.4                          bridge         5 Series/3400 Series Chipset PCI Express Root Port 5
/0/100/1c.5                          bridge         5 Series/3400 Series Chipset PCI Express Root Port 6
/0/100/1c.5/0            ens5        network        AR8131 Gigabit Ethernet
/0/100/1d                            bus            5 Series/3400 Series Chipset USB2 Enhanced Host Controller
/0/100/1d/1              usb2        bus            EHCI Host Controller
/0/100/1d/1/1                        bus            Integrated Rate Matching Hub
/0/100/1d/1/1/3          scsi6       storage        Mass Storage Device
/0/100/1d/1/1/3/0.0.0    /dev/sdb    disk           32GB SCSI Disk
/0/100/1d/1/1/3/0.0.0/1  /dev/sdb1   volume         29GiB Windows FAT volume
/0/100/1e                            bridge         82801 Mobile PCI Bridge
/0/100/1f                            bridge         HM55 Chipset LPC Interface Controller
/0/100/1f.2                          storage        5 Series/3400 Series Chipset 4 port SATA AHCI Controller
/0/100/1f.6                          generic        5 Series/3400 Series Chipset Thermal Subsystem
/0/101                               bridge         Core Processor QuickPath Architecture Generic Non-core Registers
/0/102                               bridge         Core Processor QuickPath Architecture System Address Decoder
/0/103                               bridge         Core Processor QPI Link 0
/0/104                               bridge         1st Generation Core i3/5/7 Processor QPI Physical 0
/0/105                               bridge         1st Generation Core i3/5/7 Processor Reserved
/0/106                               bridge         1st Generation Core i3/5/7 Processor Reserved
/0/1                     scsi0       storage        
/0/1/0.0.0               /dev/sda    disk           640GB ST9640320AS
/0/1/0.0.0/1             /dev/sda1   volume         21GiB Windows FAT volume
/0/1/0.0.0/2             /dev/sda2   volume         148GiB Windows NTFS volume
/0/1/0.0.0/3             /dev/sda3   volume         451MiB Windows NTFS volume
/0/1/0.0.0/4             /dev/sda4   volume         425GiB Extended partition
/0/1/0.0.0/4/5           /dev/sda5   volume         425GiB HPFS/NTFS partition
/0/2                     scsi1       storage        
/0/2/0.0.0               /dev/cdrom  disk           BD  E  DS4E1S
xubuntu@xubuntu:~$ 
```
Sitten paketinhallinan päivitys komennolla
```
sudo apt-get update
```
Ja jälleen törmään appstreamin virheeseen, nyt minua alkaa jo todella hermostuttamaan.
```
** (appstreamcli:2964): CRITICAL **: Error while moving old database out of the way.
AppStream cache update failed.
Reading package lists... Done
xubuntu@xubuntu:~$ sudo apt install appstream/xenial-backports
Reading package lists... Done
Building dependency tree       
Reading state information... Done
E: Release 'xenial-backports' for 'appstream' was not found
xubuntu@xubuntu:~$ appstreamcli --version
AppStream CLI tool version: 0.9.4
```
Sama ongelmahan minulla oli myös slave-koneessa. Löysin tähän onneksi kuitenkin [ohjeen](https://administratosphere.wordpress.com/2016/12/25/appstream-error-in-ubuntu-16-04-xenial/), mutta se ei täysin toiminut. 
Minun piti ensin muuttaa Software & Updates asetuksia, siten että sallin myös Unsupported updates kuvan mukaan

![updates](https://raw.githubusercontent.com/mcleppala/puppet/master/kuvat/updates.png). 

Sitten komento
```
sudo apt-get install appstream/xenial-backports
```
Tämän jälkeen sain asennettua appstreamin uuden version ja sain ajettua updaten virheittä läpi.

Vihdoinkin pääsen asentamaan ohjelmia komennolla
```
sudo apt-get install -y puppetmaster tree git virtualbox vagrant
```
Ja nyt kaikki menee ongelmitta läpi. Aloitan tämän raportin Masterin asetukset otsikosta eteenpäin muokkaamaan koneen tietoja.
Muutin myös slaven host-tiedostoon uuden koneen ip-osoitteen masterin kohdalle. Testasin vielä pingillä yhteyden ja slave löytää masterin
```
xubuntu@slave:~$ ping -c 1 master
PING master (192.168.1.103) 56(84) bytes of data.
64 bytes from master (192.168.1.103): icmp_seq=1 ttl=64 time=1.60 ms

--- master ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 1.605/1.605/1.605/0.000 ms
```
Koittaa totuuden hetki, saanko nyt yhteyden toimimaan slavella ensin komento
```
sudo puppet agent -tdv
```
Nyt en saanut enää virhettä ja siirryn master koneelle ja henkeä pidätellen kirjoitan komennon
```
xubuntu@master:~$ sudo puppet cert list
  "slave.bb.dnainternet.fi" (SHA256) 29:1B:21:D9:15:AE:E1:99:BD:CC:14:9F:59:22:D0:F0:B2:42:E4:7E:49:04:62:3A:69:2F:10:7E:BC:43:C4:EA
xubuntu@master:~$ 
```
Ja kuten yllä näkyy, saan vihdoin slaven pyynnön. Tämän jälkeen siis enää allekirjoitus komennolla
```
xubuntu@master:~$ sudo puppet cert --sign slave.bb.dnainternet.fi
Notice: Signed certificate request for slave.bb.dnainternet.fi
Notice: Removing file Puppet::SSL::CertificateRequest slave.bb.dnainternet.fi at '/var/lib/puppet/ssl/ca/requests/slave.bb.dnainternet.fi.pem'
```
Sitten testaamaan hain github repostani yksinkertaisen testisivun, jonka kopioin /etc/puppet-kansioon. Uudelleen käynnistän slavella puppetin ja käyn katsomassa onnistuiko slave hakemaan masterilta tiedoston komennolla 
```
xubuntu@slave:~$ cat /tmp/moiminna 
Moi Minna, moduuli rokkaa!
xubuntu@slave:~$ 
```
Ensimmäinen vaihe siis onnistuneesti tehty. Olen saanut rauta-orjan vihdoin valmiiksi. 

### Virtuaali-slavet
Tätä varten asensinkin jo masterille VirtualBoxin ja Vagrantin. Seuraan tässä muistinvirkistämiseksi Teron [ohjetta](http://terokarvinen.com/2017/multiple-virtual-computers-in-minutes-vagrant-multimachine). Luon tätä varten kotihakemistooni vagrantslaves kansion ja sinne teen Vagrantfilen. Sitten vaan käynnistetään vagrant, alla Vagrantfile ja ja komennot, sekä ajon tulos joka taas päätyy virheeseen....
```
xubuntu@master:~/vagrantslaves$ cat Vagrantfile 
# http://TeroKarvinen.com/
Vagrant.configure(2) do |config|
 config.vm.box = "bento/ubuntu-16.04"

 config.vm.define "slave01" do |slave01|
   slave01.vm.hostname = "slave01"
 end

 config.vm.define "slave02" do |slave02|
   slave02.vm.hostname = "slave02"
 end

 config.vm.define "slave03" do |slave03|
   slave03.vm.hostname = "slave03"
 end
end
xubuntu@master:~/vagrantslaves$ vagrant up
Bringing machine 'slave01' up with 'virtualbox' provider...
Bringing machine 'slave02' up with 'virtualbox' provider...
Bringing machine 'slave03' up with 'virtualbox' provider...
==> slave01: Box 'bento/ubuntu-16.04' could not be found. Attempting to find and install...
    slave01: Box Provider: virtualbox
    slave01: Box Version: >= 0
==> slave01: Loading metadata for box 'bento/ubuntu-16.04'
    slave01: URL: https://atlas.hashicorp.com/bento/ubuntu-16.04
==> slave01: Adding box 'bento/ubuntu-16.04' (v201710.25.0) for provider: virtualbox
    slave01: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-16.04/versions/201710.25.0/providers/virtualbox.box
==> slave01: Successfully added box 'bento/ubuntu-16.04' (v201710.25.0) for 'virtualbox'!
==> slave01: Importing base box 'bento/ubuntu-16.04'...
==> slave01: Matching MAC address for NAT networking...
==> slave01: Checking if box 'bento/ubuntu-16.04' is up to date...
==> slave01: Setting the name of the VM: vagrantslaves_slave01_1510491106711_54003
==> slave01: Clearing any previously set network interfaces...
==> slave01: Preparing network interfaces based on configuration...
    slave01: Adapter 1: nat
==> slave01: Forwarding ports...
    slave01: 22 (guest) => 2222 (host) (adapter 1)
==> slave01: Booting VM...
==> slave01: Waiting for machine to boot. This may take a few minutes...
    slave01: SSH address: 127.0.0.1:2222
    slave01: SSH username: vagrant
    slave01: SSH auth method: private key
    slave01: 
    slave01: Vagrant insecure key detected. Vagrant will automatically replace
    slave01: this with a newly generated keypair for better security.
    slave01: 
    slave01: Inserting generated public key within guest...
    slave01: Removing insecure key from the guest if it's present...
    slave01: Key inserted! Disconnecting and reconnecting using new SSH key...
==> slave01: Machine booted and ready!
==> slave01: Checking for guest additions in VM...
    slave01: The guest additions on this VM do not match the installed version of
    slave01: VirtualBox! In most cases this is fine, but in rare cases it can
    slave01: prevent things such as shared folders from working properly. If you see
    slave01: shared folder errors, please make sure the guest additions within the
    slave01: virtual machine match the version of VirtualBox you have installed on
    slave01: your host and reload your VM.
    slave01: 
    slave01: Guest Additions Version: 5.1.30
    slave01: VirtualBox Version: 5.0
==> slave01: Setting hostname...
==> slave01: Mounting shared folders...
    slave01: /vagrant => /home/xubuntu/vagrantslaves
==> slave02: Box 'bento/ubuntu-16.04' could not be found. Attempting to find and install...
    slave02: Box Provider: virtualbox
    slave02: Box Version: >= 0
==> slave02: Loading metadata for box 'bento/ubuntu-16.04'
    slave02: URL: https://atlas.hashicorp.com/bento/ubuntu-16.04
==> slave02: Adding box 'bento/ubuntu-16.04' (v201710.25.0) for provider: virtualbox
==> slave02: Importing base box 'bento/ubuntu-16.04'...
There was an error while executing `VBoxManage`, a CLI used by Vagrant
for controlling VirtualBox. The command and stderr is shown below.

Command: ["import", "/home/xubuntu/.vagrant.d/boxes/bento-VAGRANTSLASH-ubuntu-16.04/201710.25.0/virtualbox/box.ovf", "--vsys", "0", "--vmname", "ubuntu-16.04-amd64_1510491138001_33725", "--vsys", "0", "--unit", "9", "--disk", "/home/xubuntu/VirtualBox VMs/ubuntu-16.04-amd64_1510491138001_33725/ubuntu-16.04-amd64-disk001.vmdk"]

Stderr: 0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Interpreting /home/xubuntu/.vagrant.d/boxes/bento-VAGRANTSLASH-ubuntu-16.04/201710.25.0/virtualbox/box.ovf...
OK.
0%...
Progress state: VBOX_E_FILE_ERROR
VBoxManage: error: Appliance import failed
VBoxManage: error: Could not create the imported medium '/home/xubuntu/VirtualBox VMs/ubuntu-16.04-amd64_1510491138001_33725/ubuntu-16.04-amd64-disk001.vmdk'.
VBoxManage: error: VMDK: cannot write allocated data block in '/home/xubuntu/VirtualBox VMs/ubuntu-16.04-amd64_1510491138001_33725/ubuntu-16.04-amd64-disk001.vmdk' (VERR_DISK_FULL)
VBoxManage: error: Details: code VBOX_E_FILE_ERROR (0x80bb0004), component ApplianceWrap, interface IAppliance
VBoxManage: error: Context: "RTEXITCODE handleImportAppliance(HandlerArg*)" at line 877 of file VBoxManageAppliance.cpp

xubuntu@master:~/vagrantslaves$ vagrant ssh slave01 
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.4.0-87-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

0 packages can be updated.
0 updates are security updates.


vagrant@slave01:~$ exit
```
Jotain vikaahan tuossa taas on, ei muuta kuin selvittämään. Mieleeni tuli, että tunnilla taisi olla vastaava ongelma ja se liittyi jotenkin muistin loppumiseen. Tarkistin koneeni ja jostain syystä livetikku ei ollutkaan käynnistynyt muistiin, vaan ajoi suoraan tikulta. Tarkistin livetikun asetuksista, mitä olin laittanut asetuksiin ja siellä kyllä löytyivät toram noprompt, mutta jostain syystä boottaus ei onnistu suoraan muistiin. Minun ei siis auta muu kuin bootata kone uudestaan ja manuaalisesti muuttaa tuo asetus. Sinänsä mielenkiintoista, kun slave-koneella homma toimi, mutta ei master-koneella sitten. Turhauttavaa tehdä taas reiska tunti samoja hommia uudestaan, mutta eihän tässä muutakaan voi. Ehkäpä tämän jälkeen osaan nuo master-koneen astusten tekemisen ulkoa.

Toistin yllä olevat toimenpiteet ja sain taas masterin ja rauta-slaven keskustelemaan keskenään, aikaa meni noin 
20 minuuttia eli alan selkeästi kehittymään. Uusi yritys Vagrantfilen kanssa. Onneksi olin dokumentoinut tehdessäni tiedot tarkasti, niin sain nopeasti uuden Vagrantfilen ja käynnistin sen komennolla /home/xubuntu/vagrantslaves/-kansiossa.
```
vagrant up
```
Ajo alkoi pyörimään ongelmitta. Mutta taas asennus kaatuu toisen slaven kohdalla. Asennus luo kotihakemistoon /home/xubuntu/VirtualBox VMs/vagrantslaves_slave01_1510495111482_72608, jonka koko on 1,5Gb ja tyhjää tilaa on enää 415.9MB. Yhden slaven tuo ehtii luomaan, joten teen nyt tässä kohtaa tuon osion, kun on yksi rauta ja yksi virtuaalinen slave olemassa.

Päätän kuitenkin tuhota äskeisen skriptin tekemän slaven komennolla
```
vagrant destroy slave01
```
Ja ajan yksinkertaisesti kolme komentoa, joilla saan yhden koneen pystyyn
```
vagrant init bento/ubuntu-16.04
vagrant up
vagrant ssh
```
Muutan vagrant-koneen hosts-tiedoston seuraavasti
```
127.0.0.1       localhost
127.0.1.1       vagrant.vm      vagrant
192.168.1.103   master

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```
Ja muutan hostnamen komennolla
```
hostnamectl set-hostname vagrant
```
Ja testataan pingillä yhteys
```
vagrant@vagrant:~$ ping -c 1 master
PING master (192.168.1.103) 56(84) bytes of data.
64 bytes from master (192.168.1.103): icmp_seq=1 ttl=63 time=0.340 ms

--- master ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.340/0.340/0.340/0.000 ms
vagrant@vagrant:~$ 
```
Sitten asennan kuten rautaankin Puppetin ja Treen. Tämän jälkeen muokkaan vagrantin puppet.confia lisäämällä agentille tiedon serveristä
```
[agent]
server = master
```
Sitten slaven-toiminnot, joilla saadaan ssl-kansio siivottua, agentti käyntiin ja testataan yhteys
```
sudo service puppet restart
sudo service puppet stop
sudo rm -r /var/lib/puppet/ssl
sudo service puppet start
sudo puppet agent --enable
sudo puppet agent -tdv
```
Sitten oli sertifikaatin list ja sign masterilla
```
xubuntu@master:~$ sudo puppet cert list
  "vagrant.vm" (SHA256) 17:2B:A1:86:ED:5F:A7:3C:A0:02:7E:07:A6:94:5E:94:4A:83:F2:D2:02:C2:0E:54:2C:76:05:27:91:34:D6:05
xubuntu@master:~$ sudo puppet cert --sign vagrant.vm
Notice: Signed certificate request for vagrant.vm
Notice: Removing file Puppet::SSL::CertificateRequest vagrant.vm at '/var/lib/puppet/ssl/ca/requests/vagrant.vm.pem'
xubuntu@master:~$ 
```
Ja lopuksi vielä kävin katsomassa näkyykö vagrantin tempissä terveiset masterilta
```
vagrant@vagrant:~$ cat /tmp/moiminna 
Moi Minna, moduuli rokkaa!
vagrant@vagrant:~$ 
```
Virtuaali-slave yhteys toimii.

## b) Kerää tietoa orjista: verkkokorttien MAC-numerot, virtuaalinen vai oikea… (Katso /var/lib/puppet/)
Menin kansioon ja Treen avulla mitä /var/lib/puppet/-kansiosta ja sen alikansioista löytyy. Kiinostavalta vaikutti heti reports-kansio, mutta siellä olevissa konekohtaisissa kansioissa ei ollut MAC-numeroita, vaan transaktioista tietoja. Toinen kiinostava kansio oli var/lib/puppet/yaml/facts, jonka alla oli konekohtaisest .yaml-tiedostot. Ja sieltähän ne tarkat konekohtaiset tiedot löytyivät. Samaan aikaan master-koneeni päätti syystä tai toisesta lakata toimimasta. Kone jäätyi täydellisesti ja sain otettua vain kameralla valokuvan tuosta tiedostosta. Menetin siis taas master-koneeni ja vagrant-koneeni siinä samalla. Tämä on ollut kyllä surkeiden tapahtumien sarja koko kotitehtävän teko. Joka tapauksessa vagrantin tiedostosta siis poimin seuraavat valokuvan perusteella
```
macaddress_eth0: "08:00:27:67:d9:b9"
is_virtual: "true"
```
Eli vagrant on virtuaalinen. Alla vielä valokuva


Mutta enhän minä c-kohtaa voi tehdä, jos en asenna masteria vielä kerran uudestaan, joten syvä huokaus ja hommiin. Joka tapauksessa nyt en enää jätä mitään sattuman varaan, vaan teen [puppetmaster.sh](https://raw.githubusercontent.com/mcleppala/puppet/master/puppetmaster.sh)-tiedoston, jossa on kaikki tässä raportissa tehdyt toiminnot. Teen myös [slave.sh](https://raw.githubusercontent.com/mcleppala/puppet/master/slave.sh)-tiedoston, johon kokosin tässä raportissa tehdyt slaven asetukset.

## c) OrjaSkripti: Tee skripti, joka muuttaa koneen Puppet-orjaksi tietylle masterille. Voit katsoa mallia Tatun tai Eemelin ratkaisuista. 
Rakensin tiedoston ottaen mallia Teron [ohjeesta](http://terokarvinen.com/2017/provision-multiple-virtual-puppet-slaves-with-vagrant). Ja lopullinen tiedosto löytyy [täältä](). En pystynyt testaamaan skriptin toimivuutta, sillä master-koneeni muistiin ei mahtunut enempää kuin yksi kerralla.

## Lähteet
Tehtävänanto: http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5#comment-23269
Minna Leppälä Wordpress: https://minnaleppala.files.wordpress.com/2017/08/lista.png?w=1000
Raportti h2: https://github.com/mcleppala/puppet/blob/master/raportit/h2_livetikku_asetukset_githubista.md
Appstream korjaus ohje: https://askubuntu.com/questions/854168/how-i-can-fix-appstream-cache-update-completed-but-some-metadata-was-ignored-d
Teron Vagrantfile ohje: http://terokarvinen.com/2017/provision-multiple-virtual-puppet-slaves-with-vagrant


