<?php

require_once('database.php');

/**
 * Classe pour gérer les requêtes liées aux ports
 */
class TypePort extends Database
{

	/**
	 * Fonction pour récupérer l'ensemble des types de port
	 *
	 * @return Array Array contenant toutes les types de port
	 */
	public function dbGetTypePorts()
	{
		$query = 'SELECT * FROM type_port';
		return $this->fetchAllRequest($query);
	}
}
