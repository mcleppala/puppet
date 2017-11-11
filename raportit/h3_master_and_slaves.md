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
