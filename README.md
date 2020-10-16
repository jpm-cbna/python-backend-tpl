# Python Backend Template

Ce dépôt contient un exemple d'API (web service REST) utilisant Python Flask.


## Installation et utilisation

Pour installer ce projet :
- Cloner le projet dans votre "workspace" local : `git clone https://github.com/jpm-cbna/python-backend-tpl.git`
- Se placer dans le dossier cloné : `cd python-flask-tpl`
- Lancer le script d'installation (fonctionne pour Debian 10 Buster, à adapter pour d'autres distributions) : `./bin/install.sh`
- Créer la base de données avec une jeu de données exemple : `./bin/db.sh upgrade`
- Lancer le serveur backend (API) en mode développement : `./bin/bootstrap.sh`


## Tester les webservices

Le dossier `resources/postman/` contient une collection [Postman](https://www.postman.com/downloads/) permettant de tester les web services.

Ce projet contient aussi le code utilisant une authentification à base de JWT qui s'appuie sur [le service Auth0](https://auth0.com/fr/).
Toutefois, il n'est pas actif par défaut car cela demande de créer un compte et de le configurer.
Les décorateurs assurant l'authentification des web services POST, PUT et DELETE sont donc commentés.


## Dépendances

Ce projet utilise les bibliothèques Python et outils suivant :
- [Pyenv](https://github.com/pyenv/pyenv) : pour installer dans l'espace de l'utilisateur courant une version spécifique de Python (créer un fichier `config/settings.ini` pour surcoucher la version spécifique de Python 3 définie par défaut dans le fichier `config/settings.default.ini`).
- [Pipenv](https://pipenv.pypa.io/en/latest/) : pour installer l'environnement virtuel et gérer les dépendances Python.
- [Flask](https://flask.palletsprojects.com/en/1.1.x/) : pour réaliser les web services.
- [SqlAlchemy](https://www.sqlalchemy.org/) : ORM permettant d'intéroger la base de données.
- [Alembic](https://alembic.sqlalchemy.org/en/latest/) : permet de gérer l'installation de la base de donnée et ses migrations futures.


## Utilisation en production

Pour une utilisation en production, il est nécessaire d'ajotuer le support d'un serveur [Gunicorn](https://gunicorn.org/).
De s'assurer de son fonctionnement constant, par exemple, à l'aide de [Supervisord](http://supervisord.org/).
Et d'utiliser un serveur web (Apache, Nginx) configuré de façon à proxifier les requêtes vers Gunicorn.

## TODO

- Trouver une solution pour gérer le mot de passe de la base de données hors du fichier `config/config.yml` pour éviter qu'il soit versionné.