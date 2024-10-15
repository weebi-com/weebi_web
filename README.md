> weebi web-app

# issues
FORK OF flutter-web-admin
open issues in weebi_server : https://github.com/weebi-com/weebi_server/issues
With the tag [WEB]

# web packages to consider

- DataCell View : https://github.com/caduandrade/davi_flutter
- Responsive : https://pub.dev/packages/responsive_builder

# Other open source flutter-web projects 

Depending on your need, you might also want to look at : 

- Invoice tracking - https://github.com/invoiceninja/admin-portal
- ERP & Apache OFBiz - https://github.com/growerp/growerp
- personnal finance - https://github.com/jogboms/ovavue

****

# Flutter Web Admin Portal

Responsive web with light/dark mode and multi language supported. The objective of this project is to develop an admin portal website with Flutter v3 (SDK version 3.19.3).
https://user-images.githubusercontent.com/12734486/174944388-5b80f3c6-187a-4e98-89e3-34180ac61379.mp4

Flutter Web Admin Portal [Website Demo](https://kcflutterwebadmin.surge.sh)

Login with demo account:\
Username: admin
Password: admin


## README : Déploiement d'une application Flutter web avec Docker

### Introduction

Ce document explique comment utiliser Docker pour construire et exécuter une application Flutter web. Les deux commandes clés sont :

* **`docker build -t flutter-web-app .`** : Construit une image Docker à partir du contexte actuel (le point "." représente le répertoire courant) et lui attribue le nom `flutter-web-app`.
* **`docker run -d -p 8080:80 --name flutter-web-app flutter-web-app`** : Exécute l'image Docker en mode détaché (`-d`), expose le port 80 du conteneur sur le port 8080 de votre hôte (`-p 8080:80`) et donne au conteneur le nom `flutter-web-app`.

### Détail des commandes

#### `docker build -t flutter-web-app .`

* **`docker build`** : Cette commande lance le processus de construction d'une image Docker.
* **`-t flutter-web-app`** : Cet argument spécifie le nom de l'image Docker à créer. Vous pouvez remplacer `flutter-web-app` par un nom plus descriptif si vous le souhaitez.
* **`.`** : Ce point indique que le contexte de construction est le répertoire courant. Docker va rechercher votre fichier `Dockerfile` dans ce répertoire pour obtenir les instructions de construction.

#### `docker run -d -p 8080:80 --name flutter-web-app flutter-web-app`

* **`docker run`** : Cette commande exécute un conteneur à partir d'une image Docker.
* **`-d`** : Cet argument démarre le conteneur en mode détaché, c'est-à-dire en arrière-plan.
* **`-p 8080:80`** : Cet argument mappe le port 80 du conteneur (celui sur lequel votre application Flutter web écoute) au port 8080 de votre machine hôte. Cela vous permet d'accéder à votre application en vous rendant sur `http://localhost:8080` dans votre navigateur.
* **`--name flutter-web-app`** : Cet argument donne un nom au conteneur. Cela facilite sa gestion et son identification.
* **`flutter-web-app`** : C'est le nom de l'image Docker que vous avez construite à l'étape précédente.

### Prérequis

* **Docker installé** : Assurez-vous que Docker est installé et en cours d'exécution sur votre machine.
* **Un fichier Dockerfile** : Ce fichier, situé à la racine de votre projet Flutter, contient les instructions pour construire l'image Docker. Il spécifie généralement l'image de base, les dépendances à installer et le point d'entrée de votre application.

### Utilisation

1. **Ouvrez votre terminal** et placez-vous dans le répertoire racine de votre projet Flutter.
2. **Exécutez la première commande** pour construire l'image Docker :
   ```bash
   docker build -t flutter-web-app .
```
3.Exécutez la deuxième commande pour démarrer le conteneur :

```bash
   docker run -d -p 8080:80 --name weebi-web-dev weebi-web-dev
   ```
Accédez à votre application en ouvrant votre navigateur et en vous rendant sur http://localhost:8080.

e