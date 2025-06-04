-- Creation de la base de données
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- Table des zones
CREATE TABLE zones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table des spécialités médicales
CREATE TABLE specialites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    icon VARCHAR(50) NOT NULL,
    couleur VARCHAR(20) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table des examens médicaux
CREATE TABLE examens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    specialite_id INT,
    nom VARCHAR(200) NOT NULL,
    description TEXT,
    prix_min DECIMAL(10, 2),
    prix_max DECIMAL(10, 2),
    conseils TEXT,
    preparation TEXT,
    duree_moyenne VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (specialite_id) REFERENCES specialites(id)
);

-- Table des établissements de santé
CREATE TABLE etablissements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(200) NOT NULL,
    type ENUM('hopital', 'clinique', 'centre', 'cabinet', 'laboratoire') NOT NULL,
    adresse TEXT,
    telephone VARCHAR(50),
    email VARCHAR(100),
    zone_id INT,
    horaires TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES zones(id)
);

-- Table de liaison examens-établissements
CREATE TABLE examens_etablissements (
    examen_id INT,
    etablissement_id INT,
    prix_specifique DECIMAL(10, 2),
    disponibilite TEXT,
    equipement_specifique TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (examen_id, etablissement_id),
    FOREIGN KEY (examen_id) REFERENCES examens(id),
    FOREIGN KEY (etablissement_id) REFERENCES etablissements(id)
);

-- Table des médecins
CREATE TABLE medecins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    specialite_id INT,
    type ENUM('generaliste', 'specialiste') NOT NULL,
    telephone VARCHAR(50),
    email VARCHAR(100),
    photo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (specialite_id) REFERENCES specialites(id)
);

-- Table des consultations (lien médecins-établissements)
CREATE TABLE consultations (
    medecin_id INT,
    etablissement_id INT,
    jours_consultation TEXT,
    heures_debut TIME,
    heures_fin TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (medecin_id, etablissement_id),
    FOREIGN KEY (medecin_id) REFERENCES medecins(id),
    FOREIGN KEY (etablissement_id) REFERENCES etablissements(id)
);

-- Table des pharmacies
CREATE TABLE pharmacies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(200) NOT NULL,
    adresse TEXT,
    telephone VARCHAR(50),
    zone_id INT,
    horaires TEXT,
    garde BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES zones(id)
);

-- Insertion des données d'exemple
-- Zones
INSERT INTO zones (nom) VALUES 
('Mermoz'),
('Fass');

-- Spécialités
INSERT INTO specialites (nom, icon, couleur, description) VALUES
('Cardiologie', 'fa-heart', 'red', 'Spécialité médicale qui traite des affections du cœur et des vaisseaux'),
('Neurologie', 'fa-brain', 'purple', 'Spécialité médicale qui traite des maladies du système nerveux'),
('Gynécologie', 'fa-venus', 'pink', 'Spécialité médicale qui traite des affections du système génital féminin'),
('Radiologie', 'fa-x-ray', 'blue', 'Spécialité médicale qui utilise l''imagerie pour diagnostiquer les maladies'),
('Gastro-entérologie', 'fa-stomach', 'green', 'Spécialité qui traite des maladies de l''appareil digestif'),
('Analyses', 'fa-flask', 'yellow', 'Laboratoire d''analyses médicales');

-- Examens (quelques exemples)
INSERT INTO examens (specialite_id, nom, description, prix_min, prix_max, conseils) VALUES
(1, 'Électrocardiogramme (ECG)', 'Enregistrement de l''activité électrique du cœur', 15000, 25000, 'Évitez les crèmes et lotions sur le thorax le jour de l''examen'),
(1, 'Échographie cardiaque', 'Examen du cœur par ultrasons', 40000, 50000, 'Venez à jeun si possible'),
(2, 'Électroencéphalogramme (EEG)', 'Enregistrement de l''activité électrique du cerveau', 35000, 45000, 'Les cheveux doivent être propres et secs'),
(3, 'Échographie pelvienne', 'Examen des organes pelviens par ultrasons', 25000, 35000, 'Vessie pleine nécessaire');

-- Établissements
INSERT INTO etablissements (nom, type, zone_id, adresse, telephone) VALUES
('Hôpital Principal', 'hopital', 1, 'Avenue Nelson Mandela', '+221 33 xxx xx xx'),
('Clinique du Cœur', 'clinique', 1, 'Rue des Médecins', '+221 33 xxx xx xx'),
('Centre Neurologique', 'centre', 2, 'Boulevard de la Santé', '+221 33 xxx xx xx');

-- Pharmacies
INSERT INTO pharmacies (nom, zone_id, adresse, telephone, horaires, garde) VALUES
('Pharmacie Centrale Mermoz', 1, 'Avenue Cheikh Anta Diop', '+221 33 xxx xx xx', '24h/24', true),
('Pharmacie du Soleil', 1, 'Rue des Écoles', '+221 33 xxx xx xx', '8h00 - 23h00', false),
('Pharmacie Fass Delorme', 2, 'Avenue Bourguiba', '+221 33 xxx xx xx', '24h/24', true);

-- Médecins
INSERT INTO medecins (nom, prenom, specialite_id, type) VALUES
('Diop', 'Marie', 1, 'generaliste'),
('Sow', 'Amadou', NULL, 'generaliste'),
('Ndiaye', 'Fatou', 1, 'specialiste'),
('Fall', 'Omar', 2, 'specialiste');

-- Examens disponibles dans les établissements
INSERT INTO examens_etablissements (examen_id, etablissement_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 3);

-- Consultations
INSERT INTO consultations (medecin_id, etablissement_id, jours_consultation, heures_debut, heures_fin) VALUES
(1, 1, 'Lundi,Mercredi,Vendredi', '08:00', '17:00'),
(2, 1, 'Mardi,Jeudi,Samedi', '09:00', '18:00'),
(3, 2, 'Lundi,Mardi,Mercredi', '08:30', '16:30');


-- Insert sample keywords for specialties
INSERT INTO specialite_keywords (specialite_id, keyword) VALUES
(1, 'coeur'),
(1, 'cardiaque'),
(1, 'arteres'),
(2, 'cerveau'),
(2, 'neurologie'),
(2, 'nerfs'),
(3, 'feminin'),
(3, 'gynecologie'),
(3, 'uterus'),
(4, 'radiologie'),
(4, 'imagerie'),
(4, 'rayons x'),
(5, 'estomac'),
(5, 'intestin'),
(5, 'gastro'),
(6, 'laboratoire'),
(6, 'analyses'),
(6, 'sang');