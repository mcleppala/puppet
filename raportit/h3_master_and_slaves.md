# Herra ja useita orjia
Kolmannen viikon [tehtävänä](http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5#comment-23269) oli asentaa useita orjia yhdelle herralle ja tutkia orjien asetuksia.

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
