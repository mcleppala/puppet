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

## Lähteet
* Tehtävänanto: http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5
* Arctic CCM: https://github.com/joonaleppalahti/CCM
* Joona Leppälahti: https://github.com/joonaleppalahti/CCM/blob/master/ansible/Ansible%20raportti.md
