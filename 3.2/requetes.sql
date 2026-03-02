-- (a) Pour chaque vol, donner le nombre de personnes de l'équipage, par fonction[cite: 52].
SELECT v.NumVol, e.fonction, COUNT(*) AS nb_personnes
FROM VOL_OR v, TABLE(v.Equipage) e -- "Unnesting" de la table imbriquée [cite: 283, 287]
GROUP BY v.NumVol, e.fonction;

-- (b) Pour chaque pilote, indiquer combien des vols lui sont associés[cite: 53].
SELECT e.nom, COUNT(v.NumVol) AS nb_vols
FROM VOL_OR v, TABLE(v.Equipage) e
WHERE e.fonction = 'Pilote'
GROUP BY e.nom;

-- (c) Impact de chaque indice de qualité par vol[cite: 54, 55].
-- On utilise la méthode de l'objet comme dans le cours (ex: a.get_totalPower() [cite: 351])
SELECT v.NumVol, i.nom_indice, i.get_impact() AS impact
FROM VOL_OR v, TABLE(v.IndicesQualite) i;

-- (d) Pour chaque indice de qualité, calculer son impact moyen[cite: 56].
SELECT i.nom_indice, AVG(i.get_impact()) AS impact_moyen
FROM VOL_OR v, TABLE(v.IndicesQualite) i
GROUP BY i.nom_indice;