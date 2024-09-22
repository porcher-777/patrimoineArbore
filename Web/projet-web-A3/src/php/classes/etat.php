<?php

require_once('database.php');

/**
 * Classe pour gérer les requêtes liées aux états
 */
class Etat extends Database
{

	/**
	 * Fonction pour récupérer l'ensemble des états
	 *
	 * @return Array Array contenant toutes les états
	 */
	public function dbGetEtats()
	{
		$query = 'SELECT * FROM etat';
		return $this->fetchAllRequest($query);
	}
}
