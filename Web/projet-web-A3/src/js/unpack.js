// --- unpack --------------------------------------------------------------
// Parcourt les données et sélectionne les colonnes utiles
// Renvoie la colonne désignée par key
// \param rows (json array), variable dans laquelle est stocké l'ensemble des données
// \param key (str), la colonne à extraire
// \return la colonne sélectionnée

function unpack(rows, key) {
	return rows.map(function (row) { return row[key]; });
}