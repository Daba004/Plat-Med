# Application de Gestion d'Hôpital

## Installation

1. Copiez tout le contenu de ce dossier dans le répertoire `htdocs` de votre installation XAMPP
   (généralement situé dans `C:\xampp\htdocs\` sous Windows)

2. Importez la base de données :
   - Ouvrez phpMyAdmin (http://localhost/phpmyadmin)
   - Créez une nouvelle base de données nommée `hospital_db`
   - Importez le fichier `hospital_db.sql` dans cette base de données

3. Configuration de la base de données :
   - Si nécessaire, modifiez les paramètres de connexion dans `config/database.php`
   - Par défaut, les paramètres sont :
     - Hôte : localhost
     - Utilisateur : root
     - Mot de passe : (vide)
     - Base de données : hospital_db

## Accès à l'application

1. Démarrez XAMPP (Apache et MySQL)
2. Ouvrez votre navigateur et accédez à :
   - http://localhost/hopital-app/

## Structure des fichiers

- `/` - Pages HTML principales
- `/api` - API PHP pour les examens médicaux
- `/config` - Configuration de la base de données
