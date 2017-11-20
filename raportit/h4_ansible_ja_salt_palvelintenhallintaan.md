# h4 Ansible ja Salt palvelintenhallinnassa

Neljännen viikon [tehtävänä](http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5) oli kokeilla niin Ansiblea kuin Saltia. Edeltävällä tunnille olimme nähneet esittelyn molemmista Arctic CCM monialaprojektin toimesta, joten päätin jo ennen tehtävien tekoa, hakea tuolta [Joona Leppälahden](https://github.com/joonaleppalahti/CCM) GitHubista apuja tehtäviini. Flunssa oli vienyt minulta viikonlopun tunnit, joten tein tehtävät vasta maanantai-aamuna.
Käytössäni oli samat koneet kuin aikaisemmassa tehtävässä, sen verran edeltävästä kerrasta viisastuneena, päätin kirjoittaa heti aloittaessani jo skriptit, joilla teen tarvittavat asennukset ja asetukset niin Ansiblea, kuin Saltia varten.

## a) Kokeile Ansiblea
Tein siis kaikista asennuksista [master-koneelle](https://raw.githubusercontent.com/mcleppala/puppet/master/andible/ansible-master.sh) oman skriptin samalla, kun tein asennusta ensimmäistä kertaa. Edeltävällä kerralla kun jouduin tekemään käsin asennuksia 
12-15 kertaa, niin ajattelin nyt helpottaa ja nopeuttaa elämääni mahdollisten ongelmien tullessa eteen. Luin [Joona Leppälahden](https://github.com/joonaleppalahti/CCM/blob/master/ansible/Ansible%20raportti.md) tekemää dokumentaatiota Ansiblesta ensin, jotta käsittäisin noin suurinpiirtein mitä minun pitää tehdä. Oli mukavaa, kun materiaali oli suomenkielinen.

Ensimmäisenä siis asensin kaikki tarvittavat ohjelmat eli Ansiblen, OpenSSH:n ja Treen. Ansible kommunikoi orjilleen SSH-yhteyden kautta. Asennukset komennoilla
```
sudo apt-get update
sudo apt-get install -y ansible tree openssh-server openssh-client ssh
```
Master-koneella piti muokata Ansiblen hosts-tiedostoa, johon lisäsin orja-ryhmän ja siihen orja-koneeni ip-osoitteen. Muokkaus komennolla


## Lähteet
* Tehtävänanto: http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5
* Arctic CCM: https://github.com/joonaleppalahti/CCM
* Joona Leppälahti: https://github.com/joonaleppalahti/CCM/blob/master/ansible/Ansible%20raportti.md
