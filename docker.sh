#!/bin/sh

# arrêter les images docker en cours
docker compose -f docker-compose.prod.yml down

# Il faudra modifier le fichier .env.production manuellement sur le serveur avant la phase de build

# lancer docker en mode background
# en rebuildant les images
docker compose -f docker-compose.prod.yml up --build --force-recreate -d
# Pour voir les logs en direct
docker compose -f docker-compose.prod.yml up --build


# Pour voir les logs d'un conteneur
docker logs backend

# Pour se connecter dans un conteneur
docker exec -ti backend sh 
docker exec -ti frontend sh 

