# Dossier de Spécification - SAE_BD-Maths

## Description générale du projet
Le projet SAE_BD-Maths est une application de gestion de vols et d’aéroports.
Il comprend :
- une API REST en Flask connectée à Oracle ;
- une interface Web SPA (administration des vols et des aéroports) ;
- une application Flutter (consultation des vols et gestion des favoris).

Objectif principal : permettre la consultation, l’ajout, la modification et la suppression des vols et des aéroports, avec une utilisation simple sur Web et mobile.

## Acteurs principaux
- Administrateur (Web SPA)
- Utilisateur mobile (Flutter)
- Système API (Flask)
- Système de données (Oracle)

## Rôles et responsabilités
- Administrateur : gère les aéroports et les vols (CRUD).
- Utilisateur mobile : consulte les vols et gère ses vols favoris.
- API Flask : expose les endpoints, valide les entrées et applique les opérations CRUD.
- Oracle : stocke les données métier (aéroports, vols) et garantit l’intégrité relationnelle.

## Règles de Gestion
### Contraintes Métier
- Un aéroport est identifié de manière unique par son id.
- Un vol est identifié par le couple compagnie + numéro (dans le cadre de l’API actuelle).
- Un vol doit avoir un aéroport de départ et un aéroport d’arrivée existants.
- La suppression d’un aéroport supprime aussi les vols liés à cet aéroport (départ/arrivée) via la logique applicative.

### Règles de Validation
- Champs obligatoires pour créer un vol : compagnie, num_vol, depart, arrivee.
- Interdiction des doublons de vols pour même compagnie + même numéro.
- Champs obligatoires pour créer un aéroport : id_aero, nom_aero, ville, pays.
- Interdiction des doublons d’aéroport sur id ou nom.
- Côté interface, un vol ne peut pas avoir le même aéroport de départ et d’arrivée.

## Interfaces et interactions
### Maquette
- SPA Web :
  - section « Gestion des vols » : formulaire + liste + boutons modifier/supprimer ;
  - section « Gestion des aéroports » : formulaire + liste + boutons modifier/supprimer.
- Mobile Flutter :
  - écran 1 « Tous les vols » : recherche + liste + action favori ;
  - écran 2 « Mes favoris » : liste des favoris sauvegardés localement.

### Choix implémentation
- Flutter a été choisi car nous travaillions dans un des module actuel.
- Flask a été choisi à la place de PHP car nous étions plus à l’aise avec Flask.

## Dictionnaire de données
### Entité Aeroport
- id_aero : entier, clé primaire, identifiant unique de l’aéroport.
- nom_aero : texte, non nul, unique, nom de l’aéroport.
- ville : texte, ville de l’aéroport.
- pays : texte, pays de l’aéroport.

### Entité Vol
- compagnie : texte, nom de la compagnie aérienne.
- num_vol : entier, numéro de vol.
- date_heure_dep : timestamp, date et heure de départ.
- date_heure_arr : timestamp, date et heure d’arrivée.
- id_aero_dep : entier, clé étrangère vers Aeroport.id_aero.
- terminal_dep : texte, terminal de départ.
- id_aero_arr : entier, clé étrangère vers Aeroport.id_aero.
- terminal_arr : texte, terminal d’arrivée.

### Données manipulées par l’API 
- Vol API : compagnie, num_vol, depart, arrivee.
- Aéroport API : id_aero, nom_aero, ville, pays.
