<?php

require_once('database.php');

/**
 * Classe pour gérer les requêtes liées aux arbres
 */
class Arbre extends Database
{
	/**
	 * Fonction pour récupérer les informations de l'arbre
	 *
	 * @param mixed $id Identifiant de l'arbre
	 * @return Array Array contenant les informations de l'arbre 
	 */
	public function dbInfoArbre($id)
	{
		$query = 'SELECT * FROM arbre WHERE id = :id';
		$params = array(
			'id' => $id
		);
		return $this->fetchRequest($query, $params);
	}

	/**
	 * Fonction pour récupérer tous les arbres
	 *
	 * @return Array Liste contenant les informatiosn de tous les arbres
	 */
	public function dbGetArbres()
	{
		$query = 'SELECT * FROM arbre';
		return $this->fetchAllRequest($query);
	}

	/**
	 * Fonction pour ajouter un arbre
	 *
	 * @param mixed $longitude Longitude de l'arbre
	 * @param mixed $latitude Latitude de l'arbre
	 * @param mixed $haut_tot Hauteur totale de l'arbre
	 * @param mixed $haut_tronc Hauteur du tronc de l'arbre
	 * @param mixed $tronc_diam Diamètre du tronc de l'arbre
	 * @param mixed $prec_estim Précédente estimation de l'âge
	 * @param mixed $nbr_diag Nombre d'arbre dans l'alignement
	 * @param mixed $remarquable Booléen sur la remarquabilité de l'arbre
	 * @param mixed $fk_espece Nom de l'espèce de l'arbre
	 * @param mixed $fk_port Nom du type de port (coupe et entretien) de l'arbre
	 * @param mixed $fk_pied Nom du type de pied de l'arbre
	 * @param mixed $fk_secteur Nom du secteur où se situe l'arbre
	 * @param mixed $fk_etat État de l'arbre
	 * @param mixed $fk_stadedev Stade de développement de l'arbre
	 * @param mixed $username Username du créateur de l'arbre
	 */
	public function dbAddArbre($longitude, $latitude, $haut_tot, $haut_tronc, $tronc_diam, $prec_estim, $nbr_diag, $remarquable, $fk_espece, $fk_port, $fk_pied, $fk_secteur, $fk_etat, $fk_stadedev, $username)
	{
		if (strtoupper($remarquable) == "OUI")
			$remarquable = 1;
		else
			$remarquable = 0;

		$query = 'INSERT INTO arbre (longitude, latitude, haut_tot, haut_tronc, tronc_diam, prec_estim, nbr_diag, remarquable, date_ajout, fk_espece, fk_port, fk_pied, fk_secteur, fk_etat, fk_stadedev, username) VALUES (:longitude, :latitude, :haut_tot, :haut_tronc, :tronc_diam, :prec_estim, :nbr_diag, :remarquable, NOW(), :fk_espece, :fk_port, :fk_pied, :fk_secteur, :fk_etat, :fk_stadedev, :username)';
		$params = array(
			'longitude' => $longitude,
			'latitude' => $latitude,
			'haut_tot' => $haut_tot,
			'haut_tronc' => $haut_tronc,
			'tronc_diam' => $tronc_diam,
			'prec_estim' => $prec_estim,
			'nbr_diag' => $nbr_diag,
			'remarquable' => $remarquable,
			'fk_espece' => $fk_espece,
			'fk_port' => $fk_port,
			'fk_pied' => $fk_pied,
			'fk_secteur' => $fk_secteur,
			'fk_etat' => $fk_etat,
			'fk_stadedev' => $fk_stadedev,
			'username' => $username
		);
		return $this->fetchRequest($query, $params);
	}

	/**
	 * Fonction pour vérifier si cet arbre existe déjà dans la BDD pour éviter la duplication
	 *
	 * @param mixed $longitude Longitude de l'arbre
	 * @param mixed $latitude Latitude de l'arbre
	 * @param mixed $haut_tot Hauteur totale de l'arbre
	 * @param mixed $haut_tronc Hauteur du tronc de l'arbre
	 * @param mixed $tronc_diam Diamètre du tronc de l'arbre
	 * @param mixed $prec_estim Précédente estimation de l'âge
	 * @param mixed $nbr_diag Nombre d'arbre dans l'alignement
	 * @param mixed $remarquable Booléen sur la remarquabilité de l'arbre
	 * @param mixed $fk_espece Nom de l'espèce de l'arbre
	 * @param mixed $fk_port Nom du type de port (coupe et entretien) de l'arbre
	 * @param mixed $fk_pied Nom du type de pied de l'arbre
	 * @param mixed $fk_secteur Nom du secteur où se situe l'arbre
	 * @param mixed $fk_etat État de l'arbre
	 * @param mixed $fk_stadedev Stade de développement de l'arbre
	 * @param mixed $username Username du créateur de l'arbre
	 */
	public function dbCheckArbre($longitude, $latitude, $haut_tot, $haut_tronc, $tronc_diam, $prec_estim, $nbr_diag, $remarquable, $fk_espece, $fk_port, $fk_pied, $fk_secteur, $fk_etat, $fk_stadedev, $username)
	{

		if (strtoupper($remarquable) == "OUI")
			$remarquable = 1;
		else
			$remarquable = 0;

		$query = 'SELECT * FROM arbre WHERE longitude = :longitude AND latitude = :latitude AND haut_tot = :haut_tot AND haut_tronc = :haut_tronc AND tronc_diam = :tronc_diam AND prec_estim = :prec_estim AND nbr_diag = :nbr_diag AND remarquable = :remarquable AND fk_espece = :fk_espece AND fk_port = :fk_port AND fk_pied = :fk_pied AND fk_secteur = :fk_secteur AND fk_etat = :fk_etat AND fk_stadedev = :fk_stadedev AND username = :username';
		$params = array(
			'longitude' => $longitude,
			'latitude' => $latitude,
			'haut_tot' => $haut_tot,
			'haut_tronc' => $haut_tronc,
			'tronc_diam' => $tronc_diam,
			'prec_estim' => $prec_estim,
			'nbr_diag' => $nbr_diag,
			'remarquable' => $remarquable,
			'fk_espece' => $fk_espece,
			'fk_port' => $fk_port,
			'fk_pied' => $fk_pied,
			'fk_secteur' => $fk_secteur,
			'fk_etat' => $fk_etat,
			'fk_stadedev' => $fk_stadedev,
			'username' => $username
		);
		return $this->fetchRequest($query, $params);
	}

	/**
	 * Fonction pour récupérer la liste dans arbres divisé en clusters
	 *
	 * @return Array Liste des arbres avec leurs informations et leur cluster
	 */
	public function dbGetClusters()
	{
		$arbre_data = $this->dbGetArbres();
		$arbre_count = count($arbre_data);

		$clusters = json_decode(exec("../../.venv/bin/python3 ../../scripts/clusters.py " . $arbre_count));

		$nb_cluster = count($clusters);

		for ($i = 0; $i < $nb_cluster; $i++) {
			$arbre_data[$i]['cluster'] = $clusters[$i];
		}

		return $arbre_data;
	}

	/**
	 * Fonction pour prédire l'âge d'un arbre
	 *
	 * @param mixed $id Identifiant de l'arbre dont l'âge doit être prédit
	 * @return Array Array contenant les informations de l'arbre et son âge prédit
	 */
	public function dbPredAge($id)
	{
		$arbre_data = $this->dbInfoArbre($id);

		$arbre_data['age_knn'] = exec("../../.venv/bin/python3 ../../scripts/age.py -m knn");
		$arbre_data['age_svm'] = exec("../../.venv/bin/python3 ../../scripts/age.py -m svm");
		$arbre_data['age_rf'] = exec("../../.venv/bin/python3 ../../scripts/age.py -m rf");
		$arbre_data['age_mlp'] = exec("../../.venv/bin/python3 ../../scripts/age.py -m mlp");

		return $arbre_data;
	}

	/**
	 * Fonction pour prédire si l'arbre est déracinné ou non
	 *
	 * @param mixed $id Identifiant de l'arbre dont le déracinnement doit être prédit
	 * @return Array Array contenant les informations de l'arbre et sa prédiction de déracinnement
	 */
	public function dbPredDeracinnement($id)
	{
		$arbre_data = $this->dbInfoArbre($id);

		$arbre_data['deracinnement_knn'] = exec("../../.venv/bin/python3 ../../scripts/deracinnement.py -m knn");
		$arbre_data['deracinnement_svm'] = exec("../../.venv/bin/python3 ../../scripts/deracinnement.py -m svm");
		$arbre_data['deracinnement_rf'] = exec("../../.venv/bin/python3 ../../scripts/deracinnement.py -m rf");
		$arbre_data['deracinnement_mlp'] = exec("../../.venv/bin/python3 ../../scripts/deracinnement.py -m mlp");

		return $arbre_data;
	}
}
