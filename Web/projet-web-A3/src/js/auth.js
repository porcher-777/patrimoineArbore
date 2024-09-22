document.addEventListener('DOMContentLoaded', function () {
	document.getElementById('loginForm').addEventListener('submit', function (event) {
		event.preventDefault(); // Empêche la soumission par défaut du formulaire


		// Récupération des valeurs des champs
		const username = document.getElementById('username').value;
		const password = document.getElementById('password').value;

		// Vérification des champs
		if (username === '' || password === '') {
			console.log('Veuillez remplir tous les champs');
			return;
		}

		// Requête AJAX pour récupérer le cookie de session
		let xhr = new XMLHttpRequest();
		xhr.open('GET', '../php/request.php/user/login');
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.setRequestHeader('Authorization', 'Basic ' + btoa(`${username}:${password}`));

		xhr.onload = () => {
			switch (xhr.status) {
				case 200:
					Cookies.set('token', JSON.parse(xhr.responseText));
					console.log('Authentification réussite !');
					document.location.href = 'index.html';
					break;

				default:
					console.log('Email ou mot de passe incorrect');
					break;
			}
		};

		xhr.send();
	});
});
