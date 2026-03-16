# Modèle Logique (AbcDatalog)

## 1. Prédicats extensionnels

Un prédicat extensionnel est une relation qui est définie par une liste explicite de faits. Dans notre cas, les prédicats extensionnels sont : 

* **`vol(VilleDep, VilleArr, HeureDep, HeureArr)`** : qui stocke les vols directs.
* **`plusPetit(H1, H2)`** : qui sert de table de vérité pour comparer les horaires.

---

## 2. Réponses aux questions 3.3.2 et 3.3.3

### Question 3.3.2 : Toutes les villes connectées
Pour relier toutes les villes, la logique repose sur deux cas :
* **Cas de base :** Un vol direct.
* **Cas récursif :** Un vol direct + un trajet existant, à condition que les horaires soient compatibles.

### Question 3.3.3 : Villes connectées avec un nombre IMPAIR de connexions
La logique repose sur un rebond entre trajets pairs et impairs:
* **0 connexion** = vol direct = Pair.
* **1 connexion** = Impair.
* **2 connexions** = Pair....

On définit donc :
* **Base des trajets pairs :** Un vol direct (0 connexion).
* **Récursivité paire :** Un vol + la suite du trajet qui est impair.
* **Récursivité impaire :** Un vol + la suite du trajet qui est pair.

---

## 3. Code Complet (à copier dans AbcDatalog)

```datalog
% FAITS (PRÉDICATS EXTENSIONNELS)
vol(paris, londres, 10, 11).
vol(londres, new_york, 14, 18).
vol(new_york, tokyo, 21, 25).
vol(tokyo, sydney, 28, 35).
vol(paris, rio, 23, 29).

% Simulation de l'opérateur < pour les correspondances
plusPetit(11, 14). % Arrivée Londres < Départ Londres
plusPetit(18, 21). % Arrivée NY < Départ NY
plusPetit(25, 28). % Arrivée Tokyo < Départ Tokyo

% QUESTION 3.3.2 : TOUTES LES VILLES CONNECTÉES
trajet(D, A, HD, HA) :- vol(D, A, HD, HA).
trajet(D, A, HD, HA) :- vol(D, V, HD, H1), trajet(V, A, H2, HA), plusPetit(H1, H2).

% QUESTION 3.3.3 : VILLES AVEC UN NOMBRE IMPAIR DE CONNEXIONS
conn_pair(D, A, HD, HA) :- vol(D, A, HD, HA).
conn_pair(D, A, HD, HA) :- vol(D, V, HD, H1), conn_impair(V, A, H2, HA), plusPetit(H1, H2).
conn_impair(D, A, HD, HA) :- vol(D, V, HD, H1), conn_pair(V, A, H2, HA), plusPetit(H1, H2).
```

---

## 4. Tests à exécuter

**Pour la Question 2 :**
```datalog
trajet(paris, A, HD, HA)?
```

**Pour la Question 3 :**
```datalog
conn_impair(paris, A, HD, HA)?
```