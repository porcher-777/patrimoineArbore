<?php
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json; charset=utf-8');
header('Cache-control: no-store, no-cache, must-revalidate');
header('Pragma: no-cache');
header("Access-Control-Allow-Origin: *");

/**
 * Fonction pour envoyer des données au format JSON
 *
 * @param mixed $data Données à envoyer
 * @param mixed $code Code de la requête à retourner
 * @return void
 */
function sendJsonData($data, $code)
{
	if ($code == 200) {
		header('HTTP/1.1 200 OK');
		echo json_encode($data);
	} else if ($code == 201) {
		header('HTTP/1.1 201 CREATED');
	} else if ($code == 204) {
		header('HTTP/1.1 204 NO CONTENT');
	}
	exit;
}

/**
 * Fonction pour envoyer une erreur
 *
 * @param mixed $code Code d'erreur à envoyer
 * @return void
 */
function sendError($code)
{
	switch ($code) {
		case 400:
			header('HTTP/1.1 400 Bad Request');
			break;

		case 401:
			header('HTTP/1.1 401 Unauthorized');
			break;

		case 404:
			header('HTTP/1.1 404 Not Found');
			break;

		case 409:
			header('HTTP/1.1 409 Conflict');
			break;

		case 501:
			header('HTTP/1.1 501 Not Implemented');
			break;

		case 500:
		default:
			header('HTTP/1.1 500 Internal Server Error');
			break;
	}
	exit;
}
