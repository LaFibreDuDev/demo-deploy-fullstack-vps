#!/bin/bash

# Script simple pour générer une clé SSH, l'ajouter à un serveur VPS, et configurer SSH

# Vérification si ssh-keygen est installé
if ! command -v ssh-keygen &> /dev/null; then
    echo "Erreur : ssh-keygen n'est pas installé."
    exit 1
fi

# Demander un nom pour la clé (optionnel)
read -p "Entrez le chemin pour enregistrer la clé (par défaut : ~/.ssh/id_rsa_vps) : " KEY_PATH
KEY_PATH=${KEY_PATH:-~/.ssh/id_rsa_vps}

# Générer une nouvelle clé SSH
if [ -f "$KEY_PATH" ]; then
    echo "Une clé existe déjà à cet emplacement : $KEY_PATH"
else
    echo "Génération d'une nouvelle clé SSH..."
    ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -C "vps-key" -N ""
    echo "Clé générée : $KEY_PATH"
fi

# Demander les informations du serveur
read -p "Entrez l'adresse du serveur (user@host) : " SERVER_ADDR
if [[ -z "$SERVER_ADDR" ]]; then
    echo "Adresse du serveur non fournie. Abandon."
    exit 1
fi

# Copier la clé publique sur le serveur
echo "Ajout de la clé au serveur..."
ssh-copy-id -i "$KEY_PATH.pub" "$SERVER_ADDR"
if [ $? -eq 0 ]; then
    echo "Clé ajoutée avec succès au serveur."
else
    echo "Erreur lors de l'ajout de la clé au serveur."
    exit 1
fi

# Configuration du fichier SSH config
SSH_CONFIG="$HOME/.ssh/config"
echo "Configuration du fichier SSH config..."
if ! grep -q "$SERVER_ADDR" "$SSH_CONFIG" 2>/dev/null; then
    {
        echo "Host $(echo $SERVER_ADDR | cut -d'@' -f2)"
        echo "    HostName $(echo $SERVER_ADDR | cut -d'@' -f2)"
        echo "    User $(echo $SERVER_ADDR | cut -d'@' -f1)"
        echo "    IdentityFile $KEY_PATH"
    } >> "$SSH_CONFIG"
    echo "Fichier config mis à jour : $SSH_CONFIG"
else
    echo "Une configuration pour ce serveur existe déjà dans $SSH_CONFIG."
fi

# Test de connexion
read -p "Voulez-vous tester la connexion SSH maintenant ? (y/n) : " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ssh "$SERVER_ADDR"
fi

echo "Configuration SSH terminée."
