# Ville Tilvis 2023-05

# Tämänä tiedoston kautta voi ajaa muutamaa testikoodia, jotka käyttävät pienehköjä kuvia.
# Toimii myös ympäristössä, jossa on käytössä vähän muistia ja laskentatehoa.

# Jos koodi ei toimi, todennäköisesti jokin paketti puuttuu. Paketit voi asentaa 
# komentokehotteen kautta (shell) seuraavan kaltaisilla komennoilla:
    
# pip install scipy
# pip install matplotlib    



# Valitse näistä yksi ajettavaksi:


# Kahden valokuvan yhteenlasku    
exec( open('nopeat_demot/yhteenlasku.py').read() )

# RGB-värien lineaarinen muunnos
#exec( open('nopeat_demot/RGB-lineaarinen-muunnos.py').read() )

# Kuvan paikkaus (Poisson)
#exec( open('nopeat_demot/Poisson_FD_finni_pois.py').read() )
