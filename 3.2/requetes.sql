-- (a) pour chaque vol, donner le nombre de personnes de l'équipage, par fonction.
SELECT v.NumVol, e.fonction, COUNT(*) AS nb_personnes
FROM VOL_OR v, TABLE(v.Equipage) e
GROUP BY v.NumVol, e.fonction;

-- (b) pour chaque pilote, indiquer combien des vols lui sont associés.
SELECT e.nom, COUNT(v.NumVol) AS nb_vols
FROM VOL_OR v, TABLE(v.Equipage) e
WHERE e.fonction = 'Pilote'
GROUP BY e.nom;

-- (c) impact de chaque indice de qualité par vol.
SELECT v.NumVol, i.nom_indice, i.get_impact() AS impact
FROM VOL_OR v, TABLE(v.IndicesQualite) i;

-- (d) pour chaque indice de qualité, on calcule son impact moyen.
SELECT i.nom_indice, AVG(i.get_impact()) AS impact_moyen
FROM VOL_OR v, TABLE(v.IndicesQualite) i
GROUP BY i.nom_indice;