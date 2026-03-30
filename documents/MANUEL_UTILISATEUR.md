# Manuel Utilisateur - SAE_BD-Maths

## 1. Objectif
Cette application permet de gérer des aéroports et des vols.

Elle propose deux interfaces :
- une interface Web (administration) pour créer, modifier et supprimer des données ;
- une application mobile Flutter pour consulter les vols et gérer des favoris.

## 2. Pré-requis
- API Flask lancée sur `http://127.0.0.1:5000`
- Base Oracle initialisée
- Pour le Web : navigateur moderne
- Pour le mobile : Flutter + émulateur/appareil

## 3. Démarrage rapide
## 3.1 Lancer l'API
Depuis la racine du projet :

```bash
source .venv/bin/activate
cd api
python app.py
```

## 3.2 Lancer l'interface Web

Ouvrir le fichier index.html

## 3.3 Lancer l'application mobile
Dans un deuxième terminal :

```bash
cd sae_vols_mobile
flutter pub get
flutter run -d chrome
```

## 4. Guide d'utilisation - Interface Web 

## 4.1 Gestion des aéroports
1. Remplir le formulaire "Ajouter un aéroport".
2. Cliquer sur "Ajouter l'Aéroport".
3. Pour modifier : cliquer sur "Modifier" dans la liste, corriger les champs, puis valider.
4. Pour supprimer : cliquer sur "Supprimer".

## 4.2 Gestion des vols
1. Remplir le formulaire "Ajouter un nouveau vol".
2. Choisir un aéroport de départ et d'arrivée.
3. Cliquer sur "Ajouter le vol".
4. Pour modifier : cliquer sur "Modifier", ajuster départ/arrivée, puis valider.
5. Pour supprimer : cliquer sur "Supprimer".

Règle importante : un vol ne peut pas avoir le même aéroport en départ et en arrivée.

## 5. Guide d'utilisation - Application mobile

## 5.1 Écran "Tous les vols"
- Affiche la liste des vols disponibles.
- Utiliser la barre de recherche pour filtrer.
- Cliquer sur l'étoile pour ajouter/retirer un favori.

## 5.2 Écran "Mes favoris"
- Affiche uniquement les vols favoris.
- Cliquer sur l'étoile pour retirer un vol des favoris.
- Les favoris sont conservés localement sur le téléphone.

## 6. Messages et erreurs fréquentes
- Données invalides : vérifier que tous les champs obligatoires sont remplis.
- Vol déjà existant : même compagnie + même numéro déjà présent.
- Aéroport déjà existant : id ou nom déjà présent.
- Aucun chargement : vérifier que l'API est bien lancée.

## 7. Fin de session
Pour arrêter l'application :
- fermer le serveur Flask (Ctrl+C) ;
- fermer le serveur HTTP SPA (Ctrl+C) ;
- arrêter Flutter (q ou Ctrl+C selon le terminal).
