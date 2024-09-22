<?php

require_once('database.php');

/**
 * Classe pour gérer les requêtes liées aux types de pied
 */
class TypePied extends Database
{

	/**
	 * Fonction pour récupérer l'ensemble des types de pied
	 *
	 * @return Array Array contenant toutes les types de pied
	 */
	public function dbGetTypePieds()
	{
		$query = 'SELECT * FROM type_pied';
		return $this->fetchAllRequest($query);
	}
}
