#!/bin/bash

echo
echo "Bienvenue sur ce script de configuration de Git & GitHub <3"
echo
echo "Pour générer la clé SSH, tu as besoin de ton pseudo et email Github."
echo 
echo "Tu peux te rendre sur https://github.com/settings/emails si tu ne t'en rappelle pas."

# Clé existante
if [ -f ~/.ssh/id_ed25519.pub ]
then
    echo
    echo "Attention : une clé SSH existe déjà !!!"
    echo "si vous continuez, vous écraserez la clé existante"
    echo
    read -p "Souhaitez-vous continuer ? (y/n) : " confirm
    if [ "$confirm" != "y" ]
    then
        echo
        echo "La nouvelle clé n'a pas été générée."
        echo "Bye."
        exit 0;
    fi
fi

# Récupération pseudo Github
pseudo=""
while [ -z $pseudo ]
do 
    echo
    read -p "1. Quel est ton pseudo sur GitHub : " pseudo
    if [ -z  "$pseudo" ]
    then
        echo
        echo "Le pseudo doit être renseigné"
    fi
done

# Récupération email Github
email=""
while [ -z $email ]
do 
    echo
    read -p "2. Quel est l'email que tu as renseigné dans ton compte GitHub : " email
    if [ -z "$email" ]
    then
        echo
        echo "L'email doit être renseigné"
    fi
done

# Vérification des informations saisies
echo
echo "Pseudo : $pseudo"
echo "Email : $email"
echo
read -p "3. Ces informations sont-elles exactes ? (y/n) : " confirm

if [ "$confirm" != "y" ]
then
    echo
    echo "La clé n'a pas pu être générée. Veuillez relancer le script pour réessayer."
    echo "Bye."
    exit 0;
else
    # Git config
    echo
    echo "4. Paramétrage Git"
    echo
    git config --global user.name "$pseudo"
    git config --global user.email "$email"
    git config --global core.editor nano
    git config --global color.ui true
    git config -l

    # Création de la clé SSH
    echo
    echo "5. Génération de la clé SSH"
    echo
    ssh-keygen -t ed25519 -N '' -C "$email" -f ~/.ssh/id_ed25519 <<< y
fi

# Vérification que le fichier contenant la clé existe bien
if [ -f ~/.ssh/id_ed25519.pub ]
then
    echo
    echo
    echo "6. Voici votre clé publique :"
    echo
    echo "-> copier TOUTE la ligne"
    echo "   commençant par ssh-ed25519.. et se terminant par $email"
    echo
    echo "-> puis coller la dans l'interface GitHub"
    echo "   GitHub > Settings > SSH & GPG Keys > New SSH key"
    echo "   Title : vps_hidora"
    echo "   Key   : la clé ci-dessous, commençant par ssh-ed25519..."
    echo
    echo "-> Tu peux aussi te rendre sur l'URL : https://github.com/settings/keys"
    echo "-> Une fois terminé, tu peux taper la commande : ssh -T git@github.com"
    echo 
    echo "=========================="
    echo
    cat ~/.ssh/id_ed25519.pub
    echo
    echo
fi