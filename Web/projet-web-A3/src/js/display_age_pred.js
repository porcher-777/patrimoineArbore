'use strict';

// --- displayPredictionAge --------------------------------------------------------------
// Affiicher dans un tableau les prédictions de l'âge selon la méthode
// \param data (json array), variable dans laquelle est stocké l'ensemble des données
// \no return   

function displayPredictionAge(data) {
    const tableBodyPred = document.getElementById('table-body-pred-tech');
    tableBodyPred.innerHTML = '';

    // Créer une nouvelle ligne de tableau
    const newRow = document.createElement('tr');

    // Ajouter les cellules à la ligne
    newRow.appendChild(createHeaderCell(data.age_knn));
    newRow.appendChild(createCell(data.age_svm));
    newRow.appendChild(createCell(data.age_rf));
    newRow.appendChild(createCell(data.age_mlp));

    // Ajouter la ligne au tableau
    tableBodyPred.appendChild(newRow);
}


// --- displayPredictionRisk --------------------------------------------------------------
// Affiicher dans un tableau les prédictions du risque de déracinement selon la méthode
// \param data (json array), variable dans laquelle est stocké l'ensemble des données
// \no return   

function displayPredictionRisk(data) {
    const tableBodyPred = document.getElementById('table-body-pred-tech');
    tableBodyPred.innerHTML = '';

    // Créer une nouvelle ligne de tableau
    const newRow = document.createElement('tr');

    // Ajouter les cellules à la ligne
    newRow.appendChild(createHeaderCell(data.deracinnement_knn));
    newRow.appendChild(createCell(data.deracinnement_svm));
    newRow.appendChild(createCell(data.deracinnement_rf));
    newRow.appendChild(createCell(data.deracinnement_mlp));

    // Ajouter la ligne au tableau
    tableBodyPred.appendChild(newRow);
}


// --- displayArbre --------------------------------------------------------------
// Affiicher dans un tableau l'ensemble des données d'un arbre
// \param arbre (json array), variable dans laquelle est stocké l'ensemble des arbres
// \no return   

function displayArbre(arbre) {
    const tableBody = document.getElementById('table-body-pred');
    tableBody.innerHTML = ''; // Vider le tableau existant

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

    // Ajouter la ligne au tableau
    tableBody.appendChild(newRow);
}

document.addEventListener('DOMContentLoaded', function () {

    const predictionAge = JSON.parse(localStorage.getItem('predictionAge'));
    const predictionRisk = JSON.parse(localStorage.getItem('predictionRisk'));

    const btnOne = document.querySelector('.btn-one-pred');
    const btnTwo = document.querySelector('.btn-two-pred');

    btnOne.addEventListener('click', function () {
        displayArbre(predictionAge)
        if (predictionAge) {
            displayPredictionAge(predictionAge);
        }
    });

    btnTwo.addEventListener('click', function () {
        if (predictionRisk) {
            displayPredictionRisk(predictionRisk);
        }
    });

    const mapContainer = document.getElementById('map-tree-age');
    if (!mapContainer) {
        console.error("Map container not found!");
        return;
    }

    // Affichage de la map
    var latitude = [predictionAge.latitude];    //Même données pour age et risk
    var longitude = [predictionAge.longitude];
    var secteur = predictionAge.fk_secteur;
    var nom = predictionAge.fk_espece;
    var etat_arbre = predictionAge.fk_etat;
    var texts = `Lat: ${latitude}<br> Lon: ${longitude}<br>Nom: ${nom}<br>Secteur: ${secteur}<br>Etat: ${etat_arbre}`;
    console.log(nom)

    var data = [{
        type: 'scattermapbox',
        lat: latitude,
        lon: longitude,
        mode: 'markers',
        marker: {
            size: 8,
            color: 'green'
        },
        text: texts,
        hoverinfo: 'text'
    }]

    var layout = {
        title: 'Arbre dont l\'âge est prédit',
        font: {
            color: 'white'
        },
        dragmode: 'zoom',
        mapbox: {
            center: {
                lat: 49.8465253,  //Coordonnées du centre de Saint-Quentin
                lon: 3.2876843
            },
            domain: {
                x: [0, 1],
                y: [0, 1]
            },
            style: 'dark',
            zoom: 12
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

    Plotly.newPlot('map-tree-age', data, layout);

});


