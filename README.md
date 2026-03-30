# SAE_BD-Maths

Application de gestion de vols et d'aéroports, composée de 3 parties :

- une API Flask connectée à Oracle (`api/`)
- un front web SPA HTML/CSS/JS (`spa/`)
- une application mobile Flutter (`sae_vols_mobile/`)


## 1) Prérequis

### Outils à installer

- Python 3.10+
- pip
- Oracle Database accessible avec un service `ora12`
- Flutter SDK 
- Android Studio + émulateur Android

### Accès base de données utilisées par l'API

Le fichier `api/db.py` utilise actuellement :

- utilisateur : `riotte`
- mot de passe : `riotte`
- dsn : `ora12`

Si votre configuration Oracle est différente, modifiez `api/db.py` avant de lancer l'API.

## 2) Initialiser la base Oracle

Depuis la racine du projet, exécuter les scripts SQL dans cet ordre :

```bash
sqlplus riotte/riotte@ora12 @3.1/creation.sql
sqlplus riotte/riotte@ora12 @3.1/insertion.sql
```

## 3) Installer et lancer l'API Flask

Depuis la racine du projet :

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r api/requirements.txt
```

Puis lancer l'API :

```bash
cd api
python app.py
```

API disponible sur :

- `http://127.0.0.1:5000`

## 4) Lancer le front web SPA

Ouvrir le index.html dans un navigateur web.


## 5) Lancer l'application Flutter

Depuis la racine du projet, dans un deuxième terminal :

```bash
cd sae_vols_mobile
flutter pub get
flutter run -d chrome --web-port=8080
```

## 6) Tests API

Les tests sont dans `api/tests/test_api.py`.

Lancement :

```bash
cd api
pytest
```

Résultats observés le 30/03/2026 :

- tests exécutés : 5
- tests réussis : 5
- échecs : 0
- couverture globale (`app.py` + `db.py`) : 22%
- détail : `app.py` = 21% ; `db.py` = 67%