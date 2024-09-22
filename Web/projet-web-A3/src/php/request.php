<?php

require_once('inc/debug.php');
require_once('inc/data_encode.php');
require_once('inc/utilities.php');
require_once('classes/espece.php');
require_once('classes/etat.php');
require_once('classes/secteur.php');
require_once('classes/stadedev.php');
require_once('classes/type_pied.php');
require_once('classes/type_port.php');
require_once('classes/user.php');
require_once('classes/arbre.php');

$requestMethod = $_SERVER['REQUEST_METHOD'];
$request = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$request = explode('/', $request);

// Les URL sont formattés de la forme php/request.php/requestRessource..
$requestRessource = $request[5];

$login = "mickael.delaere";

// L'ISEN et ses configuration de serveurs... Bref à cause de ça le login peut pas fonctionner
/*
// Vérification de l'utilisateur
$db = new User(); // Création de l'objet User qui contient les fonctions pour gérer les utilisateurs
$headers = getallheaders();
$token = $headers['Authorization'];

if (isset($token) && preg_match('/Bearer (.*)/', $token, $tab))
	$token = $tab[1];

if ($token != null) {
	$login = $db->dbVerifyToken($token);
	// Vérification que l'utilisateur existe
	if (!$login)
		$login = null;
}
*/

// Gestion des requêtes utilisateur
if ($requestRessource == "user") {
	$db = new User();
	switch ($requestMethod) {
		case 'GET':
			// Authentification de l'utilisateur
			if ($request[6] == 'login') {
				$username = $_SERVER['PHP_AUTH_USER'];
				$password = $_SERVER['PHP_AUTH_PW'];

				if (!checkInput(isset($username) && isset($password), 400))
					break;

				// Vérification de l'existence de l'utilisateur
				if ($db->dbCheckUser($username, $password)) {
					// Création du token + ajout dans la BDD
					$token = base64_encode(openssl_random_pseudo_bytes(12));
					$data = $db->dbAddToken($username, $token);
					checkData($token, 200, 404);
				} else {
					sendError(401);
				}
			} else {
				sendError(400);
			}
			break;

		case 'POST':
			if (!checkInput(isset($_POST['username']) && isset($_POST['password']), 400))
				break;

			if ($db->dbCheckUsername($_POST['username'])) {
				sendError(409);
				break;
			}

			$data = $db->dbCreateUser($_POST['username'], $_POST['password']);
			sendJsonData($data, 201);
			break;

		case 'PUT':
			// Vérífication que l'utilisateur est bien connecté
			if (!checkVariable($login, 401))
				break;

			// Récupération des données envoyées
			parse_str(file_get_contents('php://input'), $_PUT);
			if (!checkInput(isset($_PUT['password']), 400))
				break;

			$data = $db->dbUpdateUser($login, $_PUT['password']);
			sendJsonData($data, 204);

		case 'DELETE':
			// Vérífication que l'utilisateur est bien connecté
			if (!checkVariable($login, 401))
				break;

			// Suppression de l'utilisateur
			$data = $db->dbDeleteUser($login);
			sendJsonData($data, 204);
			break;

		default:
			// Requête non implémentée
			sendError(501);
			break;
	}
}

if ($requestRessource == "arbre") {
	$db = new Arbre();

<<<<<<< HEAD
	//var_dump($requestRessource);

=======
>>>>>>> 81a604734d94d012207a62f1a486d1788ba93c1a
	switch ($requestMethod) {
		case 'GET':
			// Suite de la requête ou id de l'arbre
			if (isset($request[6]))
				$path = $request[6];
			else
				$path = null;

			// Vérification des infos à récupérer
			if ($path == 'cluster') {
				// Prédire les clusters
				$data = $db->dbGetClusters();
			} elseif ($path == 'pred-age') {
				// Prédire l'âge de l'arbre
				if (!checkVariable(isset($request[7]), 400))
					break;

				$data = $db->dbPredAge($request[7]);
			} elseif ($path == 'pred-deracinnement') {
				// Prédire le déracinnement de l'arbre
				if (!checkVariable(isset($request[7]), 400))
					break;

				$data = $db->dbPredDeracinnement($request[7]);
			} elseif ($path != null) {
				$id = $path;
				$data = $db->dbInfoArbre($id);
			} elseif ($path == null)
				$data = $db->dbGetArbres();

			// Vérification des infos
			checkData($data, 200, 404);
			break;

		case 'POST':
			// Vérification qu'on est bien connecté
			if (!checkVariable($login, 401))
				break;

			if (!checkVariable(
				isset($_POST['longitude']) && isset($_POST['latitude']) && isset($_POST['haut_tot'])
					&& isset($_POST['haut_tronc']) && isset($_POST['tronc_diam']) && isset($_POST['prec_estim'])
					&& isset($_POST['nbr_diag']) && isset($_POST['remarquable']) && isset($_POST['fk_espece'])
					&& isset($_POST['fk_port']) && isset($_POST['fk_pied']) && isset($_POST['fk_secteur'])
					&& isset($_POST['fk_etat']) && isset($_POST['fk_stadedev']),
				400
			))
				break;

			// Vérificatin si l'arbre existe déjà
			if ($db->dbCheckArbre($_POST['longitude'], $_POST['latitude'], $_POST['haut_tot'], $_POST['haut_tronc'], $_POST['tronc_diam'], $_POST['prec_estim'], $_POST['nbr_diag'], $_POST['remarquable'], $_POST['fk_espece'], $_POST['fk_port'], $_POST['fk_pied'], $_POST['fk_secteur'], $_POST['fk_etat'], $_POST['fk_stadedev'], $login)) {
				sendError(409);
				break;
			}

			$data = $db->dbAddArbre($_POST['longitude'], $_POST['latitude'], $_POST['haut_tot'], $_POST['haut_tronc'], $_POST['tronc_diam'], $_POST['prec_estim'], $_POST['nbr_diag'], $_POST['remarquable'], $_POST['fk_espece'], $_POST['fk_port'], $_POST['fk_pied'], $_POST['fk_secteur'], $_POST['fk_etat'], $_POST['fk_stadedev'], $login);
			sendJsonData($data, 201);
			break;

		default:
			// Requête non implémentée
			sendError(501);
			break;
	}
}

if ($requestRessource == "stadedev") {
	$db = new Stadedev();

	switch ($requestMethod) {
		case 'GET':
			// Vérification des infos à récupérer
			$data = $db->dbGetStadedevs();

			// Vérification des infos
			checkData($data, 200, 404);
			break;

		default:
			// Requête non implémentée
			sendError(501);
			break;
	}
}

if ($requestRessource == "etat") {
	$db = new Etat();

	switch ($requestMethod) {
		case 'GET':
			// Vérification des infos à récupérer
			$data = $db->dbGetEtats();

			// Vérification des infos
			checkData($data, 200, 404);
			break;

		default:
			// Requête non implémentée
			sendError(501);
			break;
	}
}

if ($requestRessource == "secteur") {
	$db = new Secteur();

	switch ($requestMethod) {
		case 'GET':
			// Vérification des infos à récupérer
			$data = $db->dbGetSecteurs();

			// Vérification des infos
			checkData($data, 200, 404);
			break;

		default:
			// Requête non implémentée
			sendError(501);
			break;
	}
}

if ($requestRessource == "pied") {
	$db = new TypePied();

	switch ($requestMethod) {
		case 'GET':
			// Vérification des infos à récupérer
			$data = $db->dbGetTypePieds();

			// Vérification des infos
			checkData($data, 200, 404);
			break;

		default:
			// Requête non implémentée
			sendError(501);
			break;
	}
}

if ($requestRessource == "port") {
	$db = new TypePort();

	switch ($requestMethod) {
		case 'GET':
			// Vérification des infos à récupérer
			$data = $db->dbGetTypePorts();

			// Vérification des infos
			checkData($data, 200, 404);
			break;

		default:
			// Requête non implémentée
			sendError(501);
			break;
	}
}

if ($requestRessource == "espece") {
	$db = new Espece();

	switch ($requestMethod) {
		case 'GET':
			// Vérification des infos à récupérer
			$data = $db->dbGetEspeces();

			// Vérification des infos
			checkData($data, 200, 404);
			break;

		default:
			// Requête non implémentée
			sendError(501);
			break;
	}
}
