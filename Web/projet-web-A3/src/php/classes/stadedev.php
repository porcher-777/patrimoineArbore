<?php

require_once('database.php');

/**
 * Classe pour gérer les requêtes liées aux stades de développement
 */
class StadeDev extends Database
{

	/**
	 * Fonction pour récupérer l'ensemble des stades de développement
	 *
	 * @return Array Array contenant toutes les stades de développement
	 */
	public function dbGetStadeDevs()
	{
		$query = 'SELECT * FROM stadedev';
		return $this->fetchAllRequest($query);
	}
}
