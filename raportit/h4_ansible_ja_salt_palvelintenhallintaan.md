# h4 Ansible ja Salt palvelintenhallinnassa

Neljännen viikon [tehtävänä](http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5) oli kokeilla niin Ansiblea kuin Saltia. Edeltävällä tunnille olimme nähneet esittelyn molemmista Arctic CCM monialaprojektin toimesta, joten päätin jo ennen tehtävien tekoa, hakea tuolta [Joona Leppälahden](https://github.com/joonaleppalahti/CCM) GitHubista apuja tehtäviini. Flunssa oli vienyt minulta viikonlopun tunnit, joten tein tehtävät vasta maanantai-aamuna.
Käytössäni oli samat koneet kuin aikaisemmassa tehtävässä, sen verran edeltävästä kerrasta viisastuneena, päätin kirjoittaa heti aloittaessani jo skriptit, joilla teen tarvittavat asennukset ja asetukset niin Ansiblea, kuin Saltia varten.

## a) Kokeile Ansiblea
Aikaa meni noin 2 tuntia.

Tein siis kaikista asennuksista [master-koneelle](https://raw.githubusercontent.com/mcleppala/puppet/master/andible/ansible-master.sh) oman skriptin samalla, kun tein asennusta ensimmäistä kertaa. Edeltävällä kerralla kun jouduin tekemään käsin asennuksia 
12-15 kertaa, niin ajattelin nyt helpottaa ja nopeuttaa elämääni mahdollisten ongelmien tullessa eteen. Luin [Joona Leppälahden](https://github.com/joonaleppalahti/CCM/blob/master/ansible/Ansible%20raportti.md) tekemää dokumentaatiota Ansiblesta ensin, jotta käsittäisin noin suurinpiirtein mitä minun pitää tehdä. Oli mukavaa, kun materiaali oli suomenkielinen.

Ensimmäisenä siis asensin kaikki tarvittavat ohjelmat eli Ansiblen, OpenSSH:n ja Treen. Ansible kommunikoi orjilleen SSH-yhteyden kautta. Asennukset master-koneella komennoilla 
```
sudo apt-get update
sudo apt-get install -y ansible tree openssh-server openssh-client ssh
```
Ansiblea ei tarvitse asentaa orjalle, joten vain Treen ja OpenSSH:n asennukset orja-koneella komennoilla 
```
sudo apt-get update
sudo apt-get install -y tree openssh-server openssh-client ssh
```

Master-koneella piti muokata Ansiblen hosts-tiedostoa, johon lisäsin orja-ryhmän ja siihen orja-koneeni ip-osoitteen. Muokkaus komennolla
```
sudoedit /etc/ansible/hosts 
```
Tämän jälkeen loin OpenSSH:lla Master-koneellani julkisen avaimen, joka pitää kopioida myös orjalle, jotta kommunikointi onnistuisu. Alla komennot ja tulokset
```
xubuntu@xubuntu:~$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/xubuntu/.ssh/id_rsa): 
Created directory '/home/xubuntu/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/xubuntu/.ssh/id_rsa.
Your public key has been saved in /home/xubuntu/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:MfrrDkwv5qHswovW4Tc4gldBkPGHcNfI/pqPm+km1Nk xubuntu@xubuntu
The key's randomart image is:
+---[RSA 2048]----+
|  ++...o         |
|  .+.oo .        |
|   .o.. o        |
|    .... o       |
|     oo+S        |
|   .ooooE        |
|..ooo *oo        |
|.++*.*+B .       |
|o.o+*+O==        |
+----[SHA256]-----+
xubuntu@xubuntu:~$ ssh-copy-id xubuntu@192.168.1.102
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
xubuntu@192.168.1.102's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'xubuntu@192.168.1.102'"
and check to make sure that only the key(s) you wanted were added.
```
Testasin vielä, että yhteys toimii ilman salasanaa ja toimihan se, alla komennot ja tulos.
```
xubuntu@xubuntu:~$ ssh xubuntu@192.168.1.102
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.10.0-28-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


xubuntu@xubuntu:~$ exit
logout
Connection to 192.168.1.102 closed.
xubuntu@xubuntu:~$ 
```
Nyt minulla toimi yhteys masterin ja orjan välillä. Testasin vielä pingin Ansiblen avulla varmistuakseni, että kaikki on kunnossa. Alla komennot ja tulos.
```
xubuntu@xubuntu:~$ ansible all -m ping
192.168.1.102 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
xubuntu@xubuntu:~$ 
```
Ansiblessa on Playbookeja, jotka vastaavat moduuleja Puppetissa. Halusin vielä kokeilla yksinkertaisen Playbookin ajon ja valitsin siihen Apachen-asennuksen, joka oli hyvin dokumentoitu Joonan [dokumentaatiossa](https://github.com/joonaleppalahti/CCM/blob/master/ansible/Ansible%20raportti.md#playbook).

Loin ensin /etc/ansible-kansion alle apache.yaml-tiedoston, johon ensin lisäsin tuon äskeisen pingin Ansiblen syntaksin mukaisesti, luonti komennolla ```sudoedit /etc/ansible/apache.yaml``` ja tiedostoon seuraavat rivit
```
---
- hosts: orja
  remote_user: xubuntu
  tasks:
    - name: testing ping
      ping:
```
Tämän jälkeen ajoin tiedoston komennolla ```ansible-playbook /etc/ansible/apache.yaml``` ja alla ajon tulos, pingaus toimi siis myös playbookin kautta. 
```
PLAY ***************************************************************************

TASK [setup] *******************************************************************
ok: [192.168.1.102]

TASK [testing ping] ************************************************************
ok: [192.168.1.102]

PLAY RECAP *********************************************************************
192.168.1.102              : ok=2    changed=0    unreachable=0    failed=0   
```
Sitten vaan lisäämään Apachen asennus syntaksin mukaisesti tiedostoon, Joona kertoikin jo tunnilla pidetyssä esityksessä, ongelmista, joita oli puuttuvien käyttöoikeuksien takia ja sama oli myös hänen dokumentaatiossaan. Alla muokatun tiedoston sisältö
```
---
- hosts: orja
  remote_user: xubuntu
  tasks
    - name: testing ping
      ping:
    - name: install apache
      package:
        name: apache2
        state: latest
      become: true

```
Ensin kävin orja-koneella selaimella tarkistamassa mitä vastaa localhost ja eihän siellä mitään ollut. Kuva alla.
![EiApachea](https://raw.githubusercontent.com/mcleppala/puppet/master/kuvat/localhost.png)

Ja sitten ajaminen komennolla ```ansible-playbook /etc/ansible/apache.yaml --ask-become-pass```. Alla ajon tulos
```
PLAY ***************************************************************************

TASK [setup] *******************************************************************
ok: [192.168.1.102]

TASK [testing ping] ************************************************************
ok: [192.168.1.102]

TASK [install apache] **********************************************************
changed: [192.168.1.102]

PLAY RECAP *********************************************************************
192.168.1.102              : ok=3    changed=1    unreachable=0    failed=0   
```
Ja kävin tarkistamassa tämän jälkeen orja-koneelta, oliko sille asentunut Apache ja selaimessa localhost antoi Apachen oletus-sivun, joten asennus oli mennyt läpi. Kuva alla.
![Apache](https://raw.githubusercontent.com/mcleppala/puppet/master/kuvat/localhost_ansible.png)

## b) Kokeile Salt:ia
Aikaa meni noin 1,5 tuntia.
Seurasin myös Saltin osalta Arctic CCM:n dokumentaatiota, jonka oli tehnyt [Jori Laine](https://github.com/joonaleppalahti/CCM/blob/master/salt/Salt%20raportti.md). Tein Saltia varten skriptit, joilla saa tehtyä nopeasti niin [masterin](https://raw.githubusercontent.com/mcleppala/puppet/master/salt/salt-master.sh) kuin [minionin](https://raw.githubusercontent.com/mcleppala/puppet/master/salt/salt-minion.sh) perusasetukset livetikun asennuksen jälkeen. 

Aloitin kaiken asentamalla ensin master-koneelleni Salt-Masterin komennolla
```
sudo apt-get install -y salt-master
```
Ja kävin lisäämässä /etc/salt/master-tiedostoon tiedon masterin ip-osoitteesta komennolla, tämä siksi, että minion-koneet tietävät mistä löytyy master.
```
interface: 192.168.1.101
```
Sitten asensin minion-koneelle Salt-Minionin komennolla
```
sudo apt-get install -y salt-minion
```
Muokkasin ohjeiden mukaisesti /etc/salt/minion-tiedostoa ja lisäsin sinne tiedon masterista
```
master: 192.168.1.101
```
Sitten välttääkseni virheet tein vielä sertifikaattien hyväksymisen 
```
xubuntu@xubuntu:~$ sudo salt-key -F master
Local Keys:
master.pem:  6e:b8:40:f4:c0:fd:3c:cb:a8:f5:23:b7:1c:79:c7:4b
master.pub:  30:c0:09:93:1b:c7:c7:93:d9:da:38:f7:30:19:84:db
Unaccepted Keys:
xubuntu:  0c:57:9d:c4:18:c6:3b:10:41:da:01:6c:bf:de:dd:3f
xubuntu@xubuntu:~$ sudo salt-key -A
The following keys are going to be accepted:
Unaccepted Keys:
xubuntu
Proceed? [n/Y] Y
Key for minion xubuntu accepted.
```
Sitten kokeilen pingiä, tunnilta olin kirjoittanut ylös seuraavanlaisen komennon, mutta jostain syystä minion ei vastaa
```
xubuntu@xubuntu:~$ sudo salt "*" test.ping
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
xubuntu:
    Minion did not return. [No response]
xubuntu@xubuntu:~$ 
```
Muistelin, että jotain tämän kaltaista oli ollut myös tunnilla näytetyissä testeissä, joten käynnistin uudelleen minion-koneella Salt-minionin komennolla
```
sudo service salt-minion restart
```
Ja sitten kokeilin pingiä uudelleen master-koneella ja sain vastauksen
```
xubuntu@xubuntu:~$ sudo salt "*" test.ping
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
xubuntu:
    True
xubuntu@xubuntu:~$
```
Googlasin vielä tuon file_ignore_glob-varoituksen ja tämän [viestiketjun](https://github.com/saltstack/salt/issues/33706) perusteella se ei ole mitään vakavaa, joten en tutkinut sitä sen enempää.

Yhteys siis toimii, joten voidaan siirtyä eteenpäin. Päätin tehdä tässäkin yksinkertaisen testin, eli asentaa Apachen minionille. Olin sen jo tehnyt testatessani Ansiblea, joten poistin koneelta asennuksen komennolla ```sudo apt-get purge apache2``` ja tarkistin vielä localhostin selaimella, eikä mitään enää löytynyt. Kuva alla.
![poistettu](https://raw.githubusercontent.com/mcleppala/puppet/master/kuvat/localhost.png)

Sitten ohjeiden mukaan ajoin master-koneella komennon ```sudo salt xubuntu pkg.install apache2```. Ja pienen hetken jälkeen saan vastauksen
```
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
[WARNING ] Key 'file_ignore_glob' with value None has an invalid type of NoneType, a list is required for this value
xubuntu:
    ----------
    apache2:
        ----------
        new:
            2.4.18-2ubuntu3.5
        old:
    httpd:
        ----------
        new:
            1
        old:
    httpd-cgi:
        ----------
        new:
            1
        old:
xubuntu@xubuntu:~$
```
Käyn tarkistamassa lopputuloksen vielä minion-koneelta avaamalla localhostin selaimella ja siellähän se Apachen oletussivu on. Kuva alla.

![asennettu](https://raw.githubusercontent.com/mcleppala/puppet/master/kuvat/localhost_salt.png)

## Lähteet
* Tehtävänanto: http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5
* Arctic CCM: https://github.com/joonaleppalahti/CCM
* Joona Leppälahti, Ansible: https://github.com/joonaleppalahti/CCM/blob/master/ansible/Ansible%20raportti.md
* Jori Laine, Salt: https://github.com/joonaleppalahti/CCM/blob/master/salt/Salt%20raportti.md
* Saltstack: https://github.com/saltstack/salt/issues/33706
