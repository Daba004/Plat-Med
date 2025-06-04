<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once '../config/database.php';

$conn = getConnection();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        if (isset($_GET['search'])) {
            // Recherche d'examens
            $search = '%' . $_GET['search'] . '%';
            $stmt = $conn->prepare("
                SELECT e.*, s.nom as specialite_nom, s.icon, s.couleur
                FROM examens e
                JOIN specialites s ON e.specialite_id = s.id
                WHERE e.nom LIKE :search
            ");
            $stmt->bindParam(':search', $search);
        } else if (isset($_GET['specialite'])) {
            // Examens par spécialité
            $stmt = $conn->prepare("
                SELECT e.*, s.nom as specialite_nom, s.icon, s.couleur
                FROM examens e
                JOIN specialites s ON e.specialite_id = s.id
                WHERE s.id = :specialite_id
            ");
            $stmt->bindParam(':specialite_id', $_GET['specialite']);
        } else {
            // Tous les examens groupés par spécialité
            $stmt = $conn->prepare("
                SELECT 
                    s.id as specialite_id,
                    s.nom as specialite_nom,
                    s.icon,
                    s.couleur,
                    e.*,
                    GROUP_CONCAT(DISTINCT et.nom) as etablissements
                FROM specialites s
                LEFT JOIN examens e ON s.id = e.specialite_id
                LEFT JOIN examens_etablissements ee ON e.id = ee.examen_id
                LEFT JOIN etablissements et ON ee.etablissement_id = et.id
                GROUP BY s.id, e.id
                ORDER BY s.nom, e.nom
            ");
        }

        $stmt->execute();
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Organiser les résultats par spécialité
        $specialites = [];
        foreach ($result as $row) {
            if (!isset($specialites[$row['specialite_id']])) {
                $specialites[$row['specialite_id']] = [
                    'id' => $row['specialite_id'],
                    'nom' => $row['specialite_nom'],
                    'icon' => $row['icon'],
                    'couleur' => $row['couleur'],
                    'examens' => []
                ];
            }
            if ($row['id']) { // Si l'examen existe
                $etablissements = $row['etablissements'] ? explode(',', $row['etablissements']) : [];
                $specialites[$row['specialite_id']]['examens'][] = [
                    'id' => $row['id'],
                    'nom' => $row['nom'],
                    'description' => $row['description'],
                    'prix_min' => $row['prix_min'],
                    'prix_max' => $row['prix_max'],
                    'conseils' => $row['conseils'],
                    'etablissements' => $etablissements
                ];
            }
        }

        echo json_encode(array_values($specialites));
    } catch(PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
}
?>
