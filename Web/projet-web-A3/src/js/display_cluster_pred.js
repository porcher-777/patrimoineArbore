'use strict';

sendHttpRequest('GET', '../php/request.php/arbre/cluster', null, function (error, arbres) {
    if (error) {
        console.log('Impossible de récupérer les clusters', error);
    } else {

        // Extraction des clusters uniques pour la légende
        var classArray = unpack(arbres, 'cluster');
        var clusters = [...new Set(classArray)];
        clusters.sort((a, b) => a - b);

        var colors = ["#6A645A", "#E3CD8B", "#5D7052", "#C18845", "#F0BE86"];
        var data = [];

        // Parcourt l'intégralité des clusters
        clusters.forEach(function (cluster, index) {

            var rowsFiltered = arbres.filter(function (row) {
                return (row.cluster === cluster);
            });

            var latitudes = unpack(rowsFiltered, 'latitude');
            var longitudes = unpack(rowsFiltered, 'longitude');
            var quartiers = unpack(rowsFiltered, 'fk_secteur');
            var noms = unpack(rowsFiltered, 'fk_espece');
            var etat_arbres = unpack(rowsFiltered, 'fk_etat');

            var texts = quartiers.map((quartier, idx) =>
                `Lat: ${latitudes[idx]}<br> Lon: ${longitudes[idx]}<br>Nom: ${noms[idx]}<br>Quartier: ${quartier}<br>Etat: ${etat_arbres[idx]}<br>Cluster: ${cluster}`
            );

            var clusterColor = colors[index % colors.length];

            var trace = {
                type: 'scattermapbox',
                name: `Cluster ${cluster}`, // Nom de chaque cluster unique pour la légende
                lat: latitudes,
                lon: longitudes,
                mode: 'markers',
                marker: {
                    size: 8,
                    color: clusterColor
                },
                text: texts,
                hoverinfo: 'text',
                hoverlabel: {
                    bgcolor: 'paper',
                    bordercolor: 'black',
                    font: {
                        color: 'white'
                    }
                }
            };
            console.log(clusterColor);
            data.push(trace);
        });

        var layout = {
            title: 'Répartition des clusters des arbres à Saint-Quentin',
            font: {
                color: 'white'
            },
            dragmode: 'zoom',
            mapbox: {
                center: {
                    lat: 49.8465253, // Coordonnées du centre de Saint-Quentin
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
            legend: {
                orientation: 'h',
                x: 0.5,
                xanchor: 'center',
                y: -0.1,
                yanchor: 'top',
                font: {
                    color: 'white'
                },
            },
            showlegend: true
        };

        Plotly.setPlotConfig({
            mapboxAccessToken: "pk.eyJ1IjoiamVhbi1kZS1jdWxhc3NlIiwiYSI6ImNseGo2Y2VoazFwOHoyanMzdzY5amZmejgifQ.U_ZQY7Mk0VuT-p0YpLGbLA"
        });

        Plotly.newPlot('map-clusters', data, layout);
    }
});
