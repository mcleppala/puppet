# Tehtävät h2

## Livetikku ja asetukset GitHubista

### a) Gittiä livenä: Tee ohjeet ja skriptit, joilla saat live-USB -tikun konfiguroitua hetkessä – ohjelmat asennettua ja asetukset tehtyä.

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
sudo cp -r /home/xubuntu/puppet/modules /etc/puppet/modules
sudo cp -r /home/xubuntu/puppet/manifests /etc/puppet/manifests
```

Alla valmis [skripti](https://github.com/mcleppala/puppet/blob/master/asennus.sh) (tai avaa linkistä tiedosto). 

```bash
echo "***************************"
echo "Asetetaan näppäimistön kieli ja aikavyöhyke"
echo "***************************"
setxkbmap fi
sudo timedatectl set-timezone Europe/Helsinki
echo "***************************"
echo "Asennetaan Puppet, Tree ja Github"
echo "***************************"
sudo apt-get update
sudo apt-get install -y puppet tree git
echo "***************************"
echo "Kloonataan repository ja kopioidaan tiedostot"
echo "***************************"
git clone https://github.com/mcleppala/puppet
sudo cp -r /home/xubuntu/puppet/modules /etc/puppet/modules
sudo cp -r /home/xubuntu/puppet/manifests /etc/puppet/manifests
echo "***************************"
echo "Asennus valmis."
echo "***************************"

```

b) Kokeile Puppetin master-slave arkkitehtuuria kahdella koneella. Liitä raporttiisi listaus avaimista (sudo puppet cert list) ja pätkä herran http-lokista (sudo tail -5 /var/log/puppet/masterhttp.log).

