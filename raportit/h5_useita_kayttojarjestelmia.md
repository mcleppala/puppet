# Useita käyttöjärjestelmiä
Viidennen viikon [tehtävänä](http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5#comment-23294) oli asentaa Puppet ja vähintään kahdella eri käyttöjärjestelmällä olevat orjat. Tunnilla testasimme Windows 10-koneen "orjuuttamista", joten se oli luonnollinen valinta myös kotitehtävässä.

Alla olevien tehtävien tekoon meni noin 3,5 tuntia. Eniten aikaa meni Windows-koneen asennukseen, sillä skriptini avulla Master ja Vagrant-slave olivat valmiina 10 minuutissa.

## a) Asenna Puppetin orjaksi vähintään kaksi eri käyttöjärjestelmää. (Tee alusta, pelkkä tunnilla tehdyn muistelu ei riitä). 
Minulla oli jo valmiina [skripti](https://github.com/mcleppala/puppet/blob/master/puppetmaster.sh), jolla pystytän Master-koneen ja yhdestä kolmeen Vagrant slaven, jolle asennan Ubuntu 16.04 käyttöjärjestelmän. Toiseksi koneeksi valitsin, kuten tunnillakin teimme, Windows 10-käyttöjärjestelmän, jonka latasin [täältä](https://www.microsoft.com/en-gb/software-download/windows10ISO).

Master-koneeksi olin saanut lainaan uuden Dell Precicion 5510-kannettavan, jonka tekniset tiedot alla.
```
xubuntu@master:~$ sudo lshw -short -sanitize
H/W path               Device     Class          Description
============================================================
                                  system         Precision 5510 (06E5)
/0                                bus            0N8J4R
/0/0                              memory         64KiB BIOS
/0/38                             memory         128KiB L1 cache
/0/39                             memory         128KiB L1 cache
/0/3a                             memory         1MiB L2 cache
/0/3b                             memory         8MiB L3 cache
/0/3c                             processor      Intel(R) Core(TM) i7-6820HQ CPU @ 2.70GHz
/0/3d                             memory         16GiB System Memory
/0/3d/0                           memory         8GiB SODIMM Synchronous 2133 MHz (0.5 ns)
/0/3d/1                           memory         8GiB SODIMM Synchronous 2133 MHz (0.5 ns)
/0/100                            bridge         Sky Lake Host Bridge/DRAM Registers
/0/100/1                          bridge         Sky Lake PCIe Controller (x16)
/0/100/1/0                        display        GM107GLM [Quadro M1000M]
/0/100/2                          display        Intel Corporation
/0/100/4                          generic        Intel Corporation
/0/100/14                         bus            Sunrise Point-H USB 3.0 xHCI Controller
/0/100/14/0            usb1       bus            xHCI Host Controller
/0/100/14/0/c                     multimedia     Integrated_Webcam_HD
/0/100/14/1            usb2       bus            xHCI Host Controller
/0/100/14/1/1          scsi2      storage        Mass Storage Device
/0/100/14/1/1/0.0.0    /dev/sda   disk           32GB SCSI Disk
/0/100/14/1/1/0.0.0/1  /dev/sda1  volume         29GiB Windows FAT volume
/0/100/14/1/2          scsi3      storage        Mass Storage Device
/0/100/14/1/2/0.0.0    /dev/sdb   disk           31GB SCSI Disk
/0/100/14/1/2/0.0.0/1  /dev/sdb1  volume         29GiB Windows FAT volume
/0/100/14.2                       generic        Sunrise Point-H Thermal subsystem
/0/100/15                         generic        Sunrise Point-H LPSS I2C Controller #0
/0/100/15.1                       generic        Sunrise Point-H LPSS I2C Controller #1
/0/100/16                         communication  Sunrise Point-H CSME HECI #1
/0/100/17                         storage        SATA Controller [RAID mode]
/0/100/1c                         bridge         Sunrise Point-H PCI Express Root Port #1
/0/100/1c/0            wlp2s0     network        Wireless 8260
/0/100/1c.1                       bridge         Sunrise Point-H PCI Express Root Port #2
/0/100/1c.1/0                     generic        Realtek Semiconductor Co., Ltd.
/0/100/1d                         bridge         Sunrise Point-H PCI Express Root Port #13
/0/100/1d.6                       bridge         Sunrise Point-H PCI Express Root Port #15
/0/100/1f                         bridge         Sunrise Point-H LPC Controller
/0/100/1f.2                       memory         Memory controller
/0/100/1f.3                       multimedia     Sunrise Point-H HD Audio
/0/100/1f.4                       bus            Sunrise Point-H SMBus
/1                                power          DELL T453X74
xubuntu@master:~$ 
```

Ensin hain wgetin avulla puppetmaster.sh-skriptini ja ajoin sen /home/xubuntu-kansiossa komennolla 
```
bash puppetmaster.sh
```
Sillä asentui siis Master-kone ja yksi Ubuntu 16.04 Vagrant-orja noin 10 minuutissa. Testasin, että kaikki on kunnossa tekemällä yksinkertaisen moduulin, joka tekee Vagrant-orjan /tmp/-hakemistoon yksinkertaisen tervehdyksen. Alla ote terminaalista.
```
Debug: Closing connection for https://master:8140
vagrant@vagrant01:~$ cat /tmp/moiminna 
Moi Minna, moduuli rokkaa!
vagrant@vagrant01:~$ 
```

Toisella koneella asensin Windows 10 Pro-käyttöjärjestelmän VirtualBoxiin, sillä en voinut asentaa koneeseen ko. käyttöjärjestelmää ja kouluun en ehtinyt työkiireiltäni. Tein [Teron ohjeessa](http://terokarvinen.com/2016/windows-10-as-a-puppet-slave-for-ubuntu-16-04-master) olleet muutokset asennuksen aikana koneelle, jonka nimesin idearikkaasti orjawin10:ksi. Poistin käytöstä UAC eli User Account Controllin, jotta Puppetin asennus onnistuu ongelmitta. Sitten kopioin suoraan ohjeesta [Puppetin.msi](https://downloads.puppetlabs.com/windows/puppet-3.8.5-x64.msi)-tiedoston. Tässä kohtaa buuttasin Windows 10-virtuaalikoneen, jotta välttyisin ohjeessa mainituilta ongelmilta.

Aloitin asentamaan Puppetia. Asennusohjelma kysyi kiltisti, minkäniminen on master ja syötin siihen kuvan mukaisesti master-koneeni DNS-nimen. Kun asennus oli valmis, menin tarkistamaan puppet.conf-tiedoston C:\\ProgramData\PuppetLabs\puppet\etc-kansiosta ja kuten kuvasta näkyy, on asennusohjelma lisännyt antamani tiedot Master-koneesta.
* lisää kuva

Sitten onkin edessä yhteyden testaaminen Windows-koneelta, joka ajetaan Windowsin Command Promptissa seuraavasti
```
puppet agent -tdv
```
Eli miltei samanlainen komento kuin Linuxissa. Mutta sain saman virheilmoituksen kuin luokassa, tämän olinkin siellä jo ratkaissut, eli Windows-koneessa olevaa hosts-tiedostoa pitää muokata siten, että lisään sinne tiedon masterista ja sen ip-osoitteen. Hosts-tiedosto löytyy Windowsista C:\\Windows\System32\drivers\etc. Ensin minun pitää antaa orjawin10-käyttäjälle käyttöoikeudet muokata sitä, jonka jälkeen lisään kuvan rivin.
* lisää kuva

Tämän jälkeen ajoin testin uudestaan ja tällä kertaa en saanut virheitä, vaan Windows jää odottamaan sertin hyväksymistä. 
* lisää kuva

Ja Master-koneella tarkistan tuliko pyyntö perille ja siellä näkyykin Windows-orjan pyyntö. Alla komento ja vastaus
```
xubuntu@master:~$ sudo puppet cert --list
  "desktop-mrtt5id" (SHA256) 20:80:24:DA:95:E8:3E:5E:44:EB:3C:15:C1:37:8B:A4:14:CD:7A:F0:4B:A5:D1:CC:8A:A4:A6:FD:3D:DC:D1:58
xubuntu@master:~$ 
```
Sitten vain allekirjoitus tutulla komennolla ```sudo puppet cert --sign desktop-mrtt5id```. Tämän jälkeen teen masterille yksinkertaisen Windows-orjalle sopivan testimoduulin. Tähän otin mallia Teron ohjeesta. Moduuli siis tuttuun paikkaan ```/etc/puppet/modules/init.pp```. Alla moduulin sisältö.
```
class hellowindows {
 file {"C:/moiminna":
   content => "Moi Minna Winkkarilla!\n",
 }
}
```
Sitten kävin muokkaamassa site.pp-tiedostoa kansiossa ```/etc/puppet/manifests/```. Johon lisäsin ```class {hellowindows:}```. Ja taas testaamaan Windows-orjalla komennolla ```puppet agent -tdv```. Ja C:n juuresta löytyikin moiminna-tiedosto, jonka sisältä löytyi Masterilla kirjoittamani tervehdys.
* lisää kuva

## b) Säädä Windows-työpöytää. Voit esimerkiksi asentaa jonkin sovelluksen ja tehdä sille asetukset. 
Tähän ajattelin kokeilla suoraan [Arctic CCM:n](https://github.com/joonaleppalahti/CCM/blob/master/puppet/Puppet%20moduulit%20Windows%2010%20Pro.md) tekemää ohjetta ja moduulia. Kopioin heidän tekemänsä tiedostot ```/etc/puppet/modules/```-kansioon. Alla Treen avulla kansiopuurakenne.
```
├── hellowindows
│   └── manifests
│       └── init.pp
├── moiminna
│   └── manifests
│       └── init.pp
└── wuserwall
    ├── files
    │   └── img0.jpg
    └── manifests
        └── init.pp

7 directories, 4 files
```
Mutta ennen kuin kokeilen tuota wuserwall-moduulia, testaan vielä Chocolatey:tä Teron [ohjeen](http://terokarvinen.com/2016/automatically-install-a-list-of-software-to-windows-chocolatey-puppet-provider) mukaan.

Master koneella pitää siis ensin ajaa komento ```sudo puppet module install puppetlabs/windows```, joka asentaa Master-koneelleni tarvittavat Windows kilkkeet, jotta voin tehdä asennuksia Puppetin avulla Windows-orjalle. Alla ajon tulos.
```
Notice: Preparing to install into /etc/puppet/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/etc/puppet/modules
└─┬ puppetlabs-windows (v5.0.0)
  ├── puppet-download_file (v2.1.0)
  ├── puppet-windows_env (v2.3.0)
  ├── puppet-windowsfeature (v2.1.0)
  ├── puppetlabs-acl (v1.1.2)
  ├─┬ puppetlabs-chocolatey (v2.0.2)
  │ ├── puppetlabs-powershell (v2.1.2)
  │ ├── puppetlabs-registry (v1.1.4)
  │ └── puppetlabs-stdlib (v4.22.0)
  ├─┬ puppetlabs-dsc (v1.4.0)
  │ └── puppetlabs-reboot (v1.2.1)
  ├── puppetlabs-iis (v4.2.0)
  └── puppetlabs-wsus_client (v1.0.3)
``` 
Teen moduulin asennuspaketti hakemistoon etc/puppet/modules/asennuspaketti/manifests. Alla init.pp-tiedoston sisältö.
```
class asennuspaketti {
   include chocolatey

   Package {
       ensure => "installed",
       provider => "chocolatey",
   }

   package {["gedit", "googlechrome", "firefox", "vlc", "libreoffice", "putty.portable"]:}

}
```
Eli asennan Gedit, Chrome, Firefox, VLC, LibreOffice ja Putty-ohjelmat Chokolateyn avulla. Sitten lisään vielä site.pp-tiedostoon ```class {asennuspaketti:}``` rivin. Ja eikun testaamaan Windows-orjalla tutulla komennolla ```puppet agent tdv```. Kone ruksuttaa hetken ja työpöydälle alkaa ilmestymään kuvakkeita asennusten edetessä. Lopuksi kaikki yllä mainitut ohjelmat löytyivät Windows-orjalta.
* lisää kuvat

Enää sitten onkin oikeastaan jäljellä testata saanko kuvan vaihtumaan, tunnilla tämä kaatui siihen, että olimme asentaneet Windows-koneeksi Windows 10 Home-version, jossa kuvan muokkaaminen oli hankalaa. Testaan vielä miten toimii tuo wuserwall, ainakin sen pitäisi lisätä käyttäjä opiskelija. Lisään site.pp-tiedostoon rivin ```class{wuserwall:}``` ja ajan taas Windows-orjalla komennon ```puppet agent -t```. Alla vielä wuserwall-moduulin sisältö.
```
class wuserwall {
        acl { 'C:\WINDOWS\web\wallpaper\Windows\img0.jpg':
        permissions => [
                { identity => 'Administrator', rights => ['full'],
                source_permissions => ignore },
        ],
        }
        file {"C:\WINDOWS\web\wallpaper\Windows\img0.jpg":
                source => "puppet:///modules/wuserwall/img0.jpg"
        }
        user {'opiskelija':
                name      => 'opiskelija',
                ensure    => present,
                groups    => ['Users'],
                password  => 'salainen',
                managehome => true,
        }
}
```
Saan kuitenkin saman virheen kuin tunnilla taustakuvan vaihdosta, eli se ei ratkennut vain versiota vaihtamalla. Käyttäjä opiskelija kuitenkin luotiin. Kuva alla.
* lisää kuva

En enää jäänyt taustakuva-asiaa selvittämään. Olin kuitenkin tehnyt tehtävää tässä vaiheessa usean tunnin ja väsy alkoi painaa.
