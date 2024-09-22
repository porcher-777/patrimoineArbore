'use strict';

<<<<<<< HEAD
// fill_table.js

// Fonction pour remplir le tableau
function fillTable() {
    // URL de l'API
    const apiUrl = 'http://votre-domaine.com/path/to/api/request.php';

    // Requête AJAX pour récupérer les données des espèces
    $.ajax({
        url: apiUrl + '/espece',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            // Vider le tableau existant
            $('#table-body').empty();

            // Parcourir les données reçues
            data.forEach(function(espece) {
                // Créer une nouvelle ligne de tableau
                const newRow = $('<tr>');

                // Ajouter les cellules à la ligne
                newRow.append($('<td>').text(espece.id));
                newRow.append($('<td>').text(espece.nom));

                // Ajouter la ligne au corps du tableau
                $('#table-body').append(newRow);
=======
// --- fillTable --------------------------------------------------------------
// Remplis le tableau avec l'intégralité des données de la base 
// \no param
// \no return   

function fillTable() {

    // Requête HTTP pour récupérer les données des arbres
    sendHttpRequest('GET', '../php/request.php/arbre', null, function (error, data) {
        if (error) {
            console.error('Erreur lors de la récupération des données:', error);
        } else {
            const tableBody = document.getElementById('table-body');
            tableBody.innerHTML = ''; // Vider le tableau existant

            data.forEach(function (arbre) {
                // Créer une nouvelle ligne de tableau
                const newRow = document.createElement('tr');

                // Ajouter les cellules à la ligne

                newRow.appendChild(createHeaderCell(arbre.id));
                newRow.appendChild(createCell(arbre.fk_espece));
                newRow.appendChild(createCell(arbre.haut_tot));
                newRow.appendChild(createCell(arbre.haut_tronc));
                newRow.appendChild(createCell(arbre.tronc_diam));
                newRow.appendChild(createCell(arbre.latitude));
                newRow.appendChild(createCell(arbre.longitude));
                newRow.appendChild(createCell(arbre.fk_etat));
                newRow.appendChild(createCell(arbre.fk_stadedev));
                newRow.appendChild(createCell(arbre.fk_port));
                newRow.appendChild(createCell(arbre.fk_pied));
                newRow.appendChild(createPredictionCell(arbre.id));

                // Ajouter la ligne au corps du tableau
                tableBody.appendChild(newRow);
>>>>>>> 81a604734d94d012207a62f1a486d1788ba93c1a
            });
        },
        error: function(xhr, status, error) {
            console.error('Erreur lors de la récupération des données:', error);
        }
    });
}
<<<<<<< HEAD

// Appeler la fonction pour remplir le tableau lorsque le document est prêt
$(document).ready(function() {
    fillTable();
});
=======
>>>>>>> 81a604734d94d012207a62f1a486d1788ba93c1a


// --- getPrédiction --------------------------------------------------------------
// Remplis le tableau avec l'intégralité des données de la base 
// \param id (int), l'id de l'arbre dont on veut prédire l'âge
// \no return  

function getPrediction(id) {
    const predAgeRequest = new Promise((resolve, reject) => {
        sendHttpRequest('GET', `../php/request.php/arbre/pred-age/${id}`, null, function (error, data) {
            if (error) {
                reject('Erreur lors de la récupération de la prédiction de l\'âge:', error);
            } else {
                console.log(data)
                localStorage.setItem('predictionAge', JSON.stringify(data));
                resolve();
            }
        });
    });

    const predRiskRequest = new Promise((resolve, reject) => {
        sendHttpRequest('GET', `../php/request.php/arbre/pred-deracinnement/${id}`, null, function (error, data) {
            if (error) {
                reject('Erreur lors de la récupération de la prédiction du risque de déracinement:', error);
            } else {
                localStorage.setItem('predictionRisk', JSON.stringify(data));
                resolve();
            }
        });
    });

    Promise.all([predAgeRequest, predRiskRequest])
        .then(() => {
            window.location.href = '../html/fonc5_pred_age.html';
        })
        .catch(error => {
            console.error(error);
        });
}



document.addEventListener('DOMContentLoaded', function () {
    fillTable();
    const btnOne = document.querySelector('.btn-one');

    btnOne.addEventListener('click', function () {
        const selectedRadio = document.querySelector('input[name="pred"]:checked');

        if (selectedRadio) {
            const id = selectedRadio.value;
            getPrediction(id);
        } else {
            alert('Veuillez sélectionner un arbre pour la prédiction.');
        }
    });

});
