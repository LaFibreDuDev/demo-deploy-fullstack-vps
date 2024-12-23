#!/bin/sh

# arrêter les images docker en cours
docker compose down

# lancer docker en mode background
# en rebuildant les images
docker compose up --build -d