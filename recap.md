# Déploiement sur un VPS

## Noms de domaines et connexion SSH sur le serveur

- Création du VPS et récupération de l'IP de la machine
- Création de la clé SSH en local en utilisant le script client/01-generate-key.sh
- Se connecter sur le DNS pour créer les sous-domaines
  - dashboard.lafibredudev.com - stats pour Traefik
  - frontend.lafibredudev.com - projet React build
  - backend.lafibredudev.com - projet NodeJS build
- On se connecte en SSH sur le VPS

## Création de la clé Github

Toutes les étapes qui suivent doivent être exécutées sur le serveur VPS

- On créer la clé github en utilisant le script server/01-generate-key-github.sh

```sh
# on créer manuellement un fichier sur le serveur
nano generate-key.sh
# on colle le contenu du script
chmod a+x generate-key.sh
# on exécute le script et on suit les étapes
./generate-key.sh
```

- On clone le repo github

```sh
git clone <notre_repo>
```

- On installe docker en utilisant le script server/02-docker.sh

```sh
# on se rend dans le dossier du repo
cd <repo>/scripts/server
# on colle le contenu du script
chmod a+x 02-docker.sh
# on exécute le script et on suit les étapes (il faut le lancer en sudo)
sudo bash 02-docker.sh
```

- On permet d'exécuter docker sans la commande sudo

```sh
sudo groupadd -f docker
sudo chown root:docker /var/run/docker.sock
sudo usermod -a -G docker "$(whoami)"
newgrp docker
sudo systemctl restart docker
```

- On lance enfin pour terminer le fichier docker-compose

docker compose -f docker-compose.prod.yml up --build --force-recreate -d

C'est terminé !
