<?php

require_once('database.php');

/**
 * Classe pour gérer les requêtes liées aux secteurs
 */
class Secteur extends Database
{

	/**
	 * Fonction pour récupérer l'ensemble des secteurs
	 *
	 * @return Array Array contenant toutes les secteurs
	 */
	public function dbGetSecteurs()
	{
		$query = 'SELECT * FROM secteur';
		return $this->fetchAllRequest($query);
	}
}
