# Tehtävät h2

## Livetikku ja asetukset GitHubista

### a) Gittiä livenä: Tee ohjeet ja skriptit, joilla saat live-USB -tikun konfiguroitua hetkessä – ohjelmat asennettua ja asetukset tehtyä.

Tätä aloitinkin jo tekemään tunnilla, pääsin jo melko pitkälle, mutta aika ei taaskaan riittänyt. Luin [tehtävänannossa](http://terokarvinen.com/2017/aikataulu-palvelinten-hallinta-ict4tn022-3-5-op-uusi-ops-loppusyksy-2017-p5#comment-23251) annetut ohjeet läpi ja jatkoin työtäni. Loin myös tämän uuden repositoryn, sillä vanha [reponi](https://github.com/mcleppala/puppetconf) oli totaalisen räjähtänyt, mutta se toimikoon jatkossa harjoittelukappaleena ja tänne tallennan sitten valmiit ja asiallisesti muotoillut tuotokset. 

Materiaaleissa oli linkki myös kurssikaverin [GitHub-sivustolle](https://github.com/poponappi/essential-tools/blob/master/essentialtools.sh) ja katsoin hänen tekemäänsä skriptiä. Huomasin, että olinkin omasta tiedostostani unohtanut aikavyöhykkeen asetukset, joten lisäsin sen myös omaani. Sen jälkeen tein haluamani tiedostojen kopioinnit ja alla valmis skripti. 

'''

setxkbmap fi
sudo apt-get update
sudo apt-get install -y puppet tree git
git clone https://github.com/mcleppala/puppet

cd /puppet/puppet/
sudo cp -r /home/xubuntu/puppet/manifests /etc/puppet/manifests
sudo cp -r /home/xubuntu/puppet/manifests /etc/puppet/manifests

'''

b) Kokeile Puppetin master-slave arkkitehtuuria kahdella koneella. Liitä raporttiisi listaus avaimista (sudo puppet cert list) ja pätkä herran http-lokista (sudo tail -5 /var/log/puppet/masterhttp.log).

