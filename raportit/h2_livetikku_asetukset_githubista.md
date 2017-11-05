# Tehtävät h2

## Livetikku ja asetukset GitHubista

### a) Gittiä livenä: Tee ohjeet ja skriptit, joilla saat live-USB -tikun konfiguroitua hetkessä – ohjelmat asennettua ja asetukset tehtyä.

(käytetty aikaa ongelman selvittelyjen kanssa noin 3 tuntia)

Tätä aloitinkin jo tekemään tunnilla, pääsin jo melko pitkälle, mutta aika ei taaskaan riittänyt. Luin [tehtävänannossa](http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5#comment-23251) annetut ohjeet läpi ja jatkoin työtäni. Loin myös tämän uuden repositoryn, sillä vanha [reponi](https://github.com/mcleppala/puppetconf) oli totaalisen räjähtänyt, mutta se toimikoon jatkossa harjoittelukappaleena ja tänne tallennan sitten valmiit ja asiallisesti muotoillut tuotokset. 

Tekemäni skripti asentaa tälle kurssille tarvittavat onjelmistot eli Puppetin, Treen ja GitHubin. Ensimmäisenä asetan näppäimistön suomenkielelle komennolla

```
setxkbmap fi
```

Materiaaleissa oli linkki myös kurssikaverin [GitHub-sivustolle](https://github.com/poponappi/essential-tools/blob/master/essentialtools.sh) ja katsoin hänen tekemäänsä skriptiä. Huomasin, että olinkin omasta tiedostostani unohtanut aikavyöhykkeen asetukset, joten lisäsin sen myös omaani komennolla

```
sudo timedatectl set-timezone Europe/Helsinki
```
Tämän jälkeen päivitän paketinhallinnan ja asennan työkalut komennoilla

```
sudo apt-get update
sudo apt-get install -y puppet tree git
```
Tämän jälkeen kloonaan repositoryni ja kopioin tarvittavat tiedostot Puppetin-kansioihin komennoilla

```
git clone https://github.com/mcleppala/puppet
sudo cp -r /home/$USER/puppet/modules/apache2 /etc/puppet/modules/
sudo cp -r /home/$USER/puppet/modules/sshd /etc/puppet/modules/
sudo cp -r /home/$USER/puppet/modules/mysql /etc/puppet/modules/
```

Linkin takaa valmis [skripti](https://github.com/mcleppala/puppet/blob/master/asennus.sh). 

Lopuksi vielä testasin tuota skriptiä. Olin poistanut koneeltani GitHubin, Puppetin ja Treen komennolla

```
sudo apt-get purge -y git puppet tree
```

Jostain syystä saan kuitenkin virheilmoituksen Puppetin asennuksen yhteydessä, en löytänyt suoraa vastausta googlettamalla, mistä tuo virhe johtuu. Virhe alla

```
Setting up puppet (3.8.5-2ubuntu0.1) ...
Job for puppet.service failed because a timeout was exceeded. See "systemctl status puppet.service" and "journalctl -xe" for details.
invoke-rc.d: initscript puppet, action "start" failed.
● puppet.service - Puppet agent
   Loaded: loaded (/lib/systemd/system/puppet.service; enabled; vendor preset: enabled)
   Active: failed (Result: timeout) since su 2017-11-05 15:39:06 EET; 4ms ago
  Process: 26809 ExecStart=/usr/bin/puppet agent $DAEMON_OPTS (code=exited, status=0/SUCCESS)
 Main PID: 1047 (code=exited, status=1/FAILURE)

marras 05 15:37:36 kuusi systemd[1]: Starting Puppet agent...
marras 05 15:37:37 kuusi puppet-agent[26821]: Reopening log files
marras 05 15:37:37 kuusi systemd[1]: puppet.service: PID file /run/puppet/agent.pid not readable ...tory
marras 05 15:37:37 kuusi puppet-agent[26821]: Could not request certificate: Failed to open TCP co...wn)
marras 05 15:39:06 kuusi systemd[1]: puppet.service: Start operation timed out. Terminating.
marras 05 15:39:06 kuusi puppet-agent[26821]: Could not run: SIGTERM
marras 05 15:39:06 kuusi systemd[1]: Failed to start Puppet agent.
marras 05 15:39:06 kuusi systemd[1]: puppet.service: Unit entered failed state.
marras 05 15:39:06 kuusi systemd[1]: puppet.service: Failed with result 'timeout'.
Hint: Some lines were ellipsized, use -l to show in full.
Setting up ruby-selinux (2.4-3build2) ...
Setting up tree (1.7.0-3) ...
Setting up virt-what (1.14-1) ...
Processing triggers for libc-bin (2.23-0ubuntu9) ...
Processing triggers for systemd (229-4ubuntu21) ...
Processing triggers for ureadahead (0.100.0-19) ...

```
Aikani eräässä [Stackoverflown](https://stackoverflow.com/questions/36056066/cant-request-for-certificate-form-agent-using-puppet-agent-test) artikkelissa mainittiin puppet.conf ja siin vaiheessa mietin, että mitähän olin oikein tuhonnut kun poistin puppet-kansion /etc/-kansiorakenteesta ja tajusin, ettei purge ja uudelleen asennus enää lisänneet tiedostoja puppet.conf, etckeeper-commit-post ja etckeeper-commit-pre -tiedostoja, joten kopioin ne /etc/puppet/ -kansioon vanhasta repostani ja tämän jälkeen asennus meni läpi ongelmitta. En tiedä mikä vika oli ja olenko nyt korjannut riittävästi Xubuntun kansiota.


### b) Kokeile Puppetin master-slave arkkitehtuuria kahdella koneella. Liitä raporttiisi listaus avaimista (sudo puppet cert list) ja pätkä herran http-lokista (sudo tail -5 /var/log/puppet/masterhttp.log).

Tähän tehtävään jouduin hetken miettimään mitä tekisin, sillä minulla ei ollut kahta konetta. Hain Googlesta ohjeita, miten tehdä homma kahdella virtuaalikoneella ja löysin seuraavan [ohjeen](http://discoposse.com/2013/06/25/puppet-101-basic-installation-for-master-and-agent-machines-on-ubuntu-12-04-with-vmware-workstation/). Päätin kokeilla tehtävää ohjeen mukaisesti. Tein tehtävän Windows 10-koneellani, jossa minulla on VMWare Player asennettuna.

Hain Ubuntu Server 16.04.3 LTS [ISO](https://www.ubuntu.com/download/server)-imagen ja aloin asentamaan sitä ohjeen mukaan. Otin rinnalle käyttööni myös Teron [ohjeen](http://terokarvinen.com/2012/puppetmaster-on-ubuntu-12-04). * Lisää kuvat tähän *

Kun asennus oli valmis, muutin puppetmaster-koneen host nimen komennolla
```
hostnamectl set-hostname master
```

Tämän jälkeen avasin network/interfaces tiedoston komennolla
```
sudoedit /etc/network/interfaces
```
ja lisäsin siihen ohjeen mukaiset 10.-osoitteet, kuva alla.
* lisää kuva *

Tämän jälkeen muokkasin hosts-tiedostoa komennolla
```
sudoedit /etc/hosts/
```
Ja lisäsin siihen ohjeen mukaisesti masterin ja slaven tiedot, kuva alla.
* lisää kuva *

Sitten yritin asentaa puppetmasterin, mutta paketinhallinnassa saan virheen, eikä mikään asennus onnistu ja uudelleen käynnistyksen jälkeen, en enää pääse kirjautumaan master-koneelle. Jotain meni pahasti rikki.

Tässä kohtaa alkaa iskemään epätoivo, olen tehnyt nyt töitä 2 tuntia ja mikään ei enää toimi. Päätän asentaa master-koneen uudestaan ja aloittaa alusta Teron ohjeiden mukaan. Google löysi myös toisen kurssikaverin [sivut](http://renki.dy.fi/linux2/tehtava2.php), joista myös sain apua.

Master-koneella ajan komennon 
```
hostnamectl set-hostname master
sudo service avahi-daemon restart
```
Koneellani ei ollut ilmeisesti asennettuna avahi-daemonia, sillä saan virheen ettei ko. serviceä tunneta. Asennan avahi-daemonin komennolla
```
sudo apt-get install -y avahi-daemon
```

Asennan sen samalla myös slave-koneelle. Lopulta pääsen tilanteeseen, jossa voin muokata hosts tiedostoja, aloitan master-koneesta komennolla
```
sudoedit /etc/hosts
```
Ja teen kuvan mukaiset muutokset
* lisää kuva *

Ja sitten muutan vielä slave-koneelle tiedot samalla tavalla, kuva alla.
* lisää kuva *

Sitten testaan pingillä vastaavatko koneet komennoilla
```
minna@slave:~$ ping -c 1 master.local 
minna@master:~$ ping -c 1 slave.local
```
Ja master vastaa kuvan mukaisesti
* lisää kuva *

Ja niin myös slave
* lisää kuva *

Sitten pääsin vihdoinkin asentamaan Puppetmasterin master-koneelle komennolla
```
sudo apt-get install -y puppetmaster
```
Pysäytin Puppetmasterin ja poistin kansion ssl komennoilla
```
sudo service puppetmaster stop
sudo rm -r /var/lib/puppet/ssl
```
Seuraavaksi editoin master-koneen puppet.conf-tiedostoa komennolla
```
sudoedit /etc/puppet/puppet.conf
```
Ja lisäsin tiedostoon seuraavan rivin master-otsikon alle
```
dns_alt_names = puppet, master.local
```
Ja lopuksi vielä käynnistin Puppetmasterin komennolla 
```
sudo service puppetmaster start
```
Sitten asennetaan slave-koneelle puppet komennolla
```
sudo apt-get install -y puppet
```
Muokataan slave-koneen puppet.conf tiedostoa komennolla
```
sudoedit /etc/puppet/puppet.conf
```
Lisäsin tiedostoon ohjeen mukaisesti rivit
```
[agent]
server = master.local
```
Sitten muokkasin puppet-tiedostoa komennolla
```
sudoedit /etc/default/puppet
```
Ja lisäsin tyhjään tiedostoon seuraavan rivin
```
START=yes
```
Tämän jälkeen käynnistin Puppetin uudestaan komennolla
```
sudo service puppet restart
```
Siirryin master-koneelle, jossa tehdään sertifikaatti slave-koneelle komennolla
```
sudo puppet cert --list
```
Ja kuvassa tulos
* lisää kuva

Ja sitten vielä allekirjoitus komennolla
```
sudo puppet --sign slave.localdomain
```
Ja lopuksi vielä tein pikaisen moduulin master-koneelle testiä varten komennoilla
```
cd /etc/puppet
sudo mkdir -p manifests/ modules/helloworld/manifests/
```
Tuonne /puppet/manifests-kansioon lisään tiedoston site.pp ja siihen yhden rivin komennoilla
```
sudoedit manifests/site.pp
include helloworld
```
Sitten teen moduulin helloworld ja sen manifests-kansioon lisään init.pp tiedoston komennolla
```
sudoedit modules/helloworld/manifests/init.pp
```
Johon lisään seuraavat rivit
```
class helloworld {
        file { '/tmp/helloFromMaster':
                content => "Masterilta väsynyttä viestiä ja läppää\n"
        }
}
```
Ja sitten käynnistämään uudelleen puppet slave-koneella, jotta slave hakee tekemäni moduulin, komennolla
```
sudo service puppet restart 
```
Ja tämän jälkeen /tmp/-kansiosta katsomaan onko tullut masterilta ohjeita komennolla
```
cat /tmp/helloFromMaster
```
Mutta mitään ei näy... Olen 6 tunnin työskentelyn jälkeen melko epätoivoinen tässä kohtaa, mutta vilkaisen [Matiaksen](http://renki.dy.fi/linux2/tehtava2.php) tekemää tehtävää ja hänelläkin oli ollut sama ongelma ja ratkaisukin löytyi! Kirjoitin komennon
```
sudo puppet agent --enable
```
Ja käynnistin vielä puppetin uudestaan komennolla
```
sudo service puppet restart
```
Sitten uudestaan komento 
```
cat /tmp/helloFromMaster
```
Ja niin näkyi masterilta tullut viesti joka ei olisi ollut voinut olla oikeampi tähän aikaan illasta
```
Masterilta väsynyttä viestiä ja läppää
```
Sitten piti vielä listata sertifikaatit ja masterhttp.log-tiedoston viisi viimeistä riviä. Lokin rivit sain talteen ja löytyvät alla olevasta kuvasta
* lisää kuva

Ja sertifikaatit komennolla
```
sudo puppet cert list --all
```
Kuvassa tulokset
* kuva
