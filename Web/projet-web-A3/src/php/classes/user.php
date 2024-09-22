<?php

require_once('database.php');

/**
 * Classe pour gérer les requêtes liées aux utilisateurs
 */
class User extends Database
{

	/**
	 * Fonction pour vérifier que les identifiants de l'utilisateur sont correctes
	 *
	 * @param mixed $username Nom de l'utilisateur
	 * @param mixed $_password Mot de passe de l'utilisateur
	 * @return mixed Booléen sur la présence ou non de l'utilistaeur dans la BDD
	 */
	public function dbCheckUser($username, $_password)
	{
		$password = hash('sha256', $_password);
		$query = 'SELECT * FROM user WHERE username = :username AND password = :password';
		$params = array(
			'username' => $username,
			'password' => $password
		);
		return $this->fetchRequest($query, $params);
	}

	/**
	 * Fonction pour vérifier si l'username existe déjà afin d'éviter les duplications
	 *
	 * @param mixed $username Nom de l'utilisateur
	 * @return mixed Booléen sur la présence ou non de l'utilisateur dans la BDD
	 */
	public function dbCheckUsername($username)
	{
		$query = 'SELECT * FROM user WHERE username = :username';
		$params = array(
			'username' => $username
		);
		return $this->fetchRequest($query, $params);
	}

	/**
	 * Fonction pour créer un utilisateur
	 *
	 * @param mixed $username Nom de l'utilisateur à créer
	 * @param mixed $_password Mot de passe de l'utilisateur à créer
	 */
	public function dbCreateUser($username, $_password)
	{
		$password = hash('sha256', $_password);
		$query = 'INSERT INTO user (username, password) VALUES (:username,:password)';
		$params = array(
			'username' => $username,
			'password' => $password
		);
		return $this->fetchRequest($query, $params);
	}


	/**
	 * Fonction pour supprimer un utilisateurs
	 *
	 * @param mixed $username Nom de l'utilisateur à supprimer
	 */
	public function dbDeleteUser($username)
	{
		$query = 'DELETE FROM user WHERE username = :username';
		$params = array(
			'username' => $username
		);
		return $this->fetchRequest($query, $params);
	}

	/** 
	 * Fonction pour modifier le mot de passe de l'utilisateur
	 *
	 * @param mixed $username Nom de l'utilisateur dont le mdp doit être modifier
	 * @param mixed $_password Nouveau mot de passe
	 */
	public function dbUpdateUser($username, $_password)
	{
		$password = hash('sha256', $_password);
		$query = 'UPDATE user SET password = :password WHERE username = :username';
		$params = array(
			'username' => $username,
			'password' => $password
		);
		return $this->fetchRequest($query, $params);
	}

	/**
	 * Fonction pour ajouter un token à l'utilisateur
	 *
	 * @param mixed $username Nom de l'utilisateur reçevant le token
	 * @param mixed $token Token à ajouter à l'utilisateur
	 */
	public function dbAddToken($username, $token)
	{
		$query = 'UPDATE user SET token = :token WHERE username = :username';
		$params = array(
			'username' => $username,
			'token' => $token
		);
		return $this->fetchRequest($query, $params);
	}


	/**
	 * Fonction pour vérifier le token et récupérer le nom d'utilisateur à qui il appartient
	 *
	 * @param mixed $token Token dont l'utilisateur doit être trouvé
	 * @return mixed Nom de l'utilisateur propriétaire du token
	 */
	public function dbVerifyToken($token)
	{
		$query = 'SELECT * FROM user WHERE token = :token';
		$params = array(
			'token' => $token
		);
		$result = $this->fetchRequest($query, $params);
		if (!$result) {
			return false;
		}
		return $result['username'];
	}
}
