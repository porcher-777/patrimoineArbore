'use strict';

// --- createCell --------------------------------------------------------------
// Crée une balise <td></td> à ajouter à la ligne du tableau
// \param text (str), élément de la ligne à ajouter du tableau 
// \return cell, la balise ajoutée 

function createCell(text) {
    const cell = document.createElement('td');
    cell.textContent = text;
    return cell;
}


// --- createHeaderCell --------------------------------------------------------------
// Crée une balise <th></th>, header de la ligne à ajouter au tableau
// \param text (str), élément de la ligne à ajouter du tableau 
// \return cell, la balise ajoutée  

function createHeaderCell(text) {
    const cell = document.createElement('th');
    cell.textContent = text;
    cell.setAttribute('scope', 'row');
    return cell;
}


// --- createPrédictionCell --------------------------------------------------------------
// Crée une balise <td></td> avec un input radio pour sélectionner l'âge de l'arbre à prédire
// \param id (int), id de l'arbre dont on veut prédire l'âge
// \return cell, la balise ajoutée 

function createPredictionCell(id) {
    const cell = document.createElement('td');
    const radioInput = document.createElement('input');
    radioInput.setAttribute('type', 'radio');
    radioInput.setAttribute('id', `pred_${id}`);
    radioInput.setAttribute('name', 'pred');
    radioInput.setAttribute('value', id);

    cell.appendChild(radioInput);
    return cell;
}