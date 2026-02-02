-- (a) villes accessibles par vols directs depuis Paris
SELECT DISTINCT A.ville
FROM Vol V
JOIN Aeroport D ON V.id_aero_dep = D.id_aero
JOIN Aeroport A ON V.id_aero_arr = A.id_aero
WHERE D.ville = 'Paris';

-- (b) villes accessibles avec une correspondance
SELECT DISTINCT A2.ville
FROM Vol V1
JOIN Aeroport D1 ON V1.id_aero_dep = D1.id_aero
JOIN Vol V2 ON V1.id_aero_arr = V2.id_aero_dep
JOIN Aeroport A2 ON V2.id_aero_arr = A2.id_aero
WHERE D1.ville = 'Paris'
  AND V2.date_heure_dep > V1.date_heure_arr;

-- (c) villes accessibles avec deux correspondances 
SELECT DISTINCT A3.ville
FROM Vol V1
JOIN Aeroport D1 ON V1.id_aero_dep = D1.id_aero
JOIN Vol V2 ON V1.id_aero_arr = V2.id_aero_dep
JOIN Vol V3 ON V2.id_aero_arr = V3.id_aero_dep
JOIN Aeroport A3 ON V3.id_aero_arr = A3.id_aero
WHERE D1.ville = 'Paris'
  AND V2.date_heure_dep > V1.date_heure_arr
  AND V3.date_heure_dep > V2.date_heure_arr;