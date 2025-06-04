<?php
define('DB_HOST', '127.0.0.1');
define('DB_PORT', '3306');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'hospital_db');

function getConnection() {
    try {
        $dsn = "mysql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME;
        $options = array(
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        );
        
        $conn = new PDO($dsn, DB_USER, DB_PASS, $options);
        $conn->exec("SET NAMES utf8");
        return $conn;
    } catch(PDOException $e) {
        error_log("Erreur de connexion : " . $e->getMessage());
        throw $e;
    }
}
?>
