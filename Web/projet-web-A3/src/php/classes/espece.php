<?php

require_once('database.php');

/**
 * Classe pour gérer les requêtes liées aux espèces
 */
class Espece extends Database
{
<<<<<<< HEAD
	public function dbGetEspeces(){
=======

	/**
	 * Fonction pour récupérer l'ensemble des espèces
	 *
	 * @return Array Array contenant toutes les espèces
	 */
	public function dbGetEspeces()
	{
>>>>>>> 81a604734d94d012207a62f1a486d1788ba93c1a
		$query = 'SELECT * FROM espece';
		return $this->fetchAllRequest($query);
	}
}
