document.addEventListener('DOMContentLoaded', function () {

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

	sendHttpRequest('GET', '../php/request.php/secteur', null, function (error, data) {
		if (error) {
			httpErrors(error);
		} else {
			let etatSelect = document.getElementById("secteur");
			data.forEach(etat => {
				const option = document.createElement('option');
				option.value = etat.fk_secteur;
				option.text = etat.fk_secteur;
				etatSelect.appendChild(option);
			});
		}
	});

	sendHttpRequest('GET', '../php/request.php/stadedev', null, function (error, data) {
		if (error) {
			httpErrors(error);
		} else {
			let etatSelect = document.getElementById("stade");
			data.forEach(etat => {
				const option = document.createElement('option');
				option.value = etat.fk_stadedev;
				option.text = etat.fk_stadedev;
				etatSelect.appendChild(option);
			});
		}
	});

	sendHttpRequest('GET', '../php/request.php/port', null, function (error, data) {
		if (error) {
			httpErrors(error);
		} else {
			let etatSelect = document.getElementById("port");
			data.forEach(etat => {
				const option = document.createElement('option');
				option.value = etat.fk_port;
				option.text = etat.fk_port;
				etatSelect.appendChild(option);
			});
		}
	});

	sendHttpRequest('GET', '../php/request.php/pied', null, function (error, data) {
		if (error) {
			httpErrors(error);
		} else {
			let etatSelect = document.getElementById("pied");
			data.forEach(etat => {
				const option = document.createElement('option');
				option.value = etat.fk_pied;
				option.text = etat.fk_pied;
				etatSelect.appendChild(option);
			});
		}
	});

	sendHttpRequest('GET', '../php/request.php/espece', null, function (error, data) {
		if (error) {
			httpErrors(error);
		} else {
			let etatSelect = document.getElementById("espece");
			data.forEach(etat => {
				const option = document.createElement('option');
				option.value = etat.fk_espece;
				option.text = etat.fk_espece;
				etatSelect.appendChild(option);
			});
		}
	});


	document.getElementById('addForm').addEventListener('submit', function (event) {
		event.preventDefault(); // Empêche la soumission par défaut du formulaire

		// Récupère les données du formulaire
		const formData = new FormData(event.target);
		const urlEncodedData = new URLSearchParams(formData).toString();

		// Envoie les données via une requête POST
		sendHttpRequest('POST', '../php/request.php/arbre', urlEncodedData, function (error, response) {
			if (error) {
				console.error('Erreur:', error);
			} else {
				console.log('Succès:', response);
				// Redirection ou mise à jour de l'interface utilisateur après succès
			}
		});
	});
});
