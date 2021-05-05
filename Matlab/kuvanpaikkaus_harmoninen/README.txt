5.5.2021 Samuli Siltanen

Selostus Matlab-koodeille hakemistossa “kuvanpaikkaus_harmoninen”.


1. JOHDANTO 

Kuvanpaikkauksessa ideana on korvata jokin kuvan osa käyttäen tuon osan ympärillä olevaa kuvan sisältöä. Yleensä tarpeen on poistaa jokin kuvaan kuulumaton asia, kuten ei-toivottu teksti taikka etualalla oleva liikennemerkki. 

Harmoninen kuvanpaikkaus käyttää puuttuvan kuvainformaation luomiseen keskiarvoperiaatetta. Pyrkimys on se, että jokaisen kuva-alkion (eli pikselin) lukuarvo on keskiarvo neljän naapuripikselin luvuista. Syntyvä paikkaus on sileä ja pehmeä, eikä siinä ole mitään teräviä rajoja. Siksi harmoninen kuvanpaikkaus soveltuu parhaiten tilanteisiin, joissa poistettavan alueen ympärillä on tasaista värisävyä. 


2. KÄYTTÖOHJE

Ajamalla Matlab-rutiinin Poisson_FD_ahven_solve.m saat alihakemistoon "_kuvat" tuotettua kuvan nimeltä ahven_pois.jpg. Siitä on poistettu henkilön vieressä roikkuva leluahven, mutta ei naruja, joista tuo pehmokala roikkuu. Edelleen ajamalla rutiinin Poisson_FD_ahven_solve2.m saat alihakemistoon "_kuvat" tuotettua kuvan nimeltä ahven_ja_narut_pois.jpg. 

Yllä mainitut Matlab-rutiinit kutsuvat funktiota FD_Laplace.m. Ne perustuvat suorakaiteen muotoisen palan paikkaamiseen. 

Voimme käyttää myös mielivaltaisen muotoista maskia. Ahvenkuvalle on maski _kuvat/KimmoSiltanen8MV_rough_mask.png, jossa on merkitty mustalla paikattavat pikselit. Voit kokeilla tätä paikkausta ajamalla rutiinin Poisson_FD_ahven_solve3.m, joka puolestaan kutsuu rutiineja AS_FD_Laplace.m ja Back_Together.m. Tulos tallennetaan alihakemistoon "_kuvat" nimellä ahven_ja_narut_pois2.jpg. 


3. LISÄTIETOA

Näissä esitelmäkalvoissa selitetään asiaa alkaen kalvolta 61:
http://www.siltanen-research.net/fi/puheet/Olari2021_Siltanen_v1.pdf

Videomuotoisen esityksen harmonisesta kuvanpaikkauksesta löydät YouTubesta nimellä "Samun tiedepläjäys: Ahvenenpoisto" (https://youtu.be/Mge0jjA2xxw). Katso myös tämä: https://youtu.be/-yfApxV62hw