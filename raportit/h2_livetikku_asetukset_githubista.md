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


