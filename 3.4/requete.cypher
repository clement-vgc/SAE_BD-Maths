MATCH chemin = shortestPath((depart:Aeroport)-[:VOL_VERS*]->(arrivee:Aeroport))
WHERE depart.ville <> arrivee.ville // Empêche les liaisons en boucle (Paris -> Paris)
RETURN depart.ville AS VilleDepart, 
       arrivee.ville AS VilleArrivee, 
       length(chemin) AS Distance
ORDER BY VilleDepart ASC, VilleArrivee ASC;