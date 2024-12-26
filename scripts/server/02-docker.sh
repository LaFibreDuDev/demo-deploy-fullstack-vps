#!/bin/bash

# Arrêter le script en cas d'erreur
set -e

# Fonction pour détecter le gestionnaire de paquets
get_package_manager() {
    if [ -x "$(command -v apt)" ]; then
        echo "apt"
    elif [ -x "$(command -v dnf)" ]; then
        echo "dnf"
    elif [ -x "$(command -v yum)" ]; then
        echo "yum"
    else
        echo "unsupported"
    fi
}

# Fonction pour installer Docker sur Debian/Ubuntu
install_docker_apt() {
    echo "Mise à jour des paquets..."
    apt update -y
    apt install -y ca-certificates curl gnupg lsb-release

    echo "Ajout de la clé GPG de Docker..."
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "Ajout du dépôt Docker..."
    echo \  \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo "Installation de Docker..."
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Fonction pour installer Docker sur CentOS/Fedora/RedHat
install_docker_rpm() {
    echo "Installation des dépendances..."
    dnf install -y yum-utils

    echo "Ajout du dépôt Docker..."
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    echo "Installation de Docker..."
    dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Détection du gestionnaire de paquets
PACKAGE_MANAGER=$(get_package_manager)

if [ "$PACKAGE_MANAGER" == "unsupported" ]; then
    echo "Erreur : Votre système n'est pas pris en charge par ce script."
    exit 1
fi

# Installation de Docker en fonction du gestionnaire de paquets
case $PACKAGE_MANAGER in
    apt)
        install_docker_apt
        ;;
    dnf|yum)
        install_docker_rpm
        ;;
    *)
        echo "Erreur inattendue."
        exit 1
        ;;
esac

# Activer et démarrer Docker
echo "Activation et démarrage de Docker..."
systemctl enable docker
systemctl start docker

# Validation de l'installation
echo "Validation de l'installation..."
docker --version

echo "Docker a été installé avec succès !"
