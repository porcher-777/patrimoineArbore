'use strict';

// Récupération des données pour remplir le filtre de l'état de l'arbre
sendHttpRequest('GET', '../php/request.php/etat', null, function (error, data) {
	if (error) {
		httpErrors(error);
	} else {
		let etatSelect = document.getElementById("etat");
		data.forEach(etat => {
			const option = document.createElement('option');
			option.value = etat.fk_etat;
			option.text = etat.fk_etat;
			etatSelect.appendChild(option);
		});
	}
});

// Récupération des données pour remplir le filtre de l'espèce de l'arbre
sendHttpRequest('GET', '../php/request.php/espece', null, function (error, data) {
	if (error) {
		httpErrors(error);
	} else {
		let especeSelect = document.getElementById("espece");
		data.forEach(espece => {
			const option = document.createElement('option');
			option.value = espece.fk_espece;
			option.text = espece.fk_espece;
			especeSelect.appendChild(option);
		});
	}
});

// Récupération des données pour remplir le filtre du stade de développement de l'arbre
sendHttpRequest('GET', '../php/request.php/stadedev', null, function (error, data) {
	if (error) {
		httpErrors(error);
	} else {
		let stadeSelect = document.getElementById("stade");
		data.forEach(stadedev => {
			const option = document.createElement('option');
			option.value = stadedev.fk_stadedev;
			option.text = stadedev.fk_stadedev;
			stadeSelect.appendChild(option);
		});
	}
});


// --- updateMap --------------------------------------------------------------
// Charge la map contenant l'ensemble des arbres au chargement de la page et modifie l'affichage selon les filtres sélectionnés
// \param rowsData (json array), variable dans laquelle est stocké l'ensemble des données
// \no return

function updateMap(rowsData) {
	// Récupérer le filtre sélectionné
	var speciesFilter = document.getElementById('espece').value;
	var stateFilter = document.getElementById('etat').value;
	var stageFilter = document.getElementById('stade').value;

	console.log(rowsData);

	var filteredRows = rowsData.filter(function (row) {
		return (speciesFilter === 'Filtrer selon l\'espèce' || row.fk_nomtech === speciesFilter) &&
			(stateFilter === 'Filtrer selon l\'état' || row.fk_arb_etat === stateFilter) &&
			(stageFilter === 'Filtrer selon le stade de développement' || row.fk_stadedev === stageFilter);
	});

	// Affichage
	if (filteredRows.length > 0) {
		var classArray = unpack(filteredRows, 'class');
		var classes = [...new Set(classArray)];

		var data = classes.map(function (classe) {
			var rowsFiltered = filteredRows.filter(function (row) {
				return (row.class === classe);
			});

			var latitudes = unpack(rowsFiltered, 'latitude');
			var longitudes = unpack(rowsFiltered, 'longitude');
			var quartiers = unpack(rowsFiltered, 'clc_quartier');
			var noms = unpack(rowsFiltered, 'fk_nomtech');
			var etat_arbres = unpack(rowsFiltered, 'fk_arb_etat');

			var texts = quartiers.map((quartier, index) =>
				`Lat: ${latitudes[index]}<br> Lon: ${longitudes[index]}<br>Nom: ${noms[index]}<br>Quartier: ${quartier}<br>Etat: ${etat_arbres[index]}`
			);

			return {
				type: 'scattermapbox',
				name: classe,
				lat: latitudes,
				lon: longitudes,
				mode: 'markers',
				marker: {
					size: 8,
					color: 'green'
				},
				text: texts,
				hoverinfo: 'text'
			};
		});

		var layout = {
			title: 'Carte de la répartition des arbres de la ville de Saint-Quentin',
			font: {
				color: 'white'
			},
			dragmode: 'zoom',
			mapbox: {
				center: {
					lat: 49.8465253,  // Coordonnées du centre de Saint-Quentin
					lon: 3.2876843
				},
				domain: {
					x: [0, 1],
					y: [0, 1]
				},
				style: 'dark',
				zoom: 13
			},
			margin: {
				r: 0,
				t: 60,
				b: 0,
				l: 0,
				pad: 0
			},
			paper_bgcolor: 'black',
			plot_bgcolor: 'black',
			showlegend: false,
		};

		Plotly.setPlotConfig({
			mapboxAccessToken: "pk.eyJ1IjoiamVhbi1kZS1jdWxhc3NlIiwiYSI6ImNseGo2Y2VoazFwOHoyanMzdzY5amZmejgifQ.U_ZQY7Mk0VuT-p0YpLGbLA"
		});

		Plotly.newPlot('map', data, layout);
	} else
		alert("Aucune donnée trouvée pour les filtres sélectionnés.");
}

document.addEventListener('DOMContentLoaded', function () {
	let rowsData = [];
	let plotlyInitialized = false; // Pour suivre l'initialisation de Plotly

	// Chargement des données via Data_Arbre.csv
	Plotly.d3.csv('../../assets/Data_Arbre.csv', function (err, rows) {
		if (err) {
			console.error('Erreur lors du chargement des données:', err);
			return;
		}

		rowsData = rows;

		// Initialiser la carte une fois que les données sont chargées
		if (!plotlyInitialized) {
			updateMap(rowsData);
			plotlyInitialized = true; // Marquer Plotly comme initialisé
		}
	});

	// Changement de filtre
	document.getElementById('espece').addEventListener('change', () => updateMap(rowsData));
	document.getElementById('etat').addEventListener('change', () => updateMap(rowsData));
	document.getElementById('stade').addEventListener('change', () => updateMap(rowsData));
});
