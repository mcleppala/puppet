# Useita käyttöjärjestelmiä
Viidennen viikon [tehtävänä](http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5#comment-23294) oli asentaa Puppet ja vähintään kahdella eri käyttöjärjestelmällä olevat orjat. Tunnilla testasimme Windows 10-koneen "orjuuttamista", joten se oli luonnollinen valinta myös kotitehtävässä.

## a) Asenna Puppetin orjaksi vähintään kaksi eri käyttöjärjestelmää. (Tee alusta, pelkkä tunnilla tehdyn muistelu ei riitä). 
Minulla oli jo valmiina [skripti](https://github.com/mcleppala/puppet/blob/master/puppetmaster.sh), jolla pystytän Master-koneen ja yhdestä kolmeen Vagrant slaven, jolle asennan Ubuntu 16.04 käyttöjärjestelmän. Toiseksi koneeksi valitsin, kuten tunnillakin teimme, Windows 10-käyttöjärjestelmän, jonka latasin [täältä](https://www.microsoft.com/en-gb/software-download/windows10ISO).

Ensin hain wgetin avulla puppetmaster.sh-skriptini ja ajoin sen /home/xubuntu-kansiossa komennolla 
```
bash puppetmaster.sh
```
Sillä asentui siis Master-kone ja yksi Ubuntu 16.04 Vagrant-orja noin 10 minuutissa. Testasin, että kaikki on kunnossa laittamalla yksinkertaisen tekstitiediston Vagrant-orjan /tmp/-hakemistoon.

Toisella koneella asensin Windows 10 Pro-käyttöjärjestelmän VirtualBoxiin, sillä en voinut asentaa koneeseen ko. käyttöjärjestelmää ja kouluun en ehtinyt työkiireiltäni. 
