const urlVols = 'http://127.0.0.1:5000/api/vols';

const urlAeroports = 'http://127.0.0.1:5000/api/aeroports';

let aeroEnEdition = null;
let volEnEdition = null;

// ==========================================
// GESTION DES AÉROPORTS
// ==========================================

async function chargerAeroports() {
    try {
        const reponse = await fetch(urlAeroports);
        let aeroports = await reponse.json();
        
        aeroports.sort((a, b) => a.nom_aero.localeCompare(b.nom_aero));
        
        const liste = document.getElementById('liste-aeroports');
        const selectDepart = document.getElementById('depart');
        const selectArrivee = document.getElementById('arrivee');
        
        liste.innerHTML = '';
        selectDepart.innerHTML = '<option value="">Sélectionnez l\'aéroport de départ...</option>';
        selectArrivee.innerHTML = '<option value="">Sélectionnez l\'aéroport d\'arrivée...</option>';
        
        aeroports.forEach(aero => {
            const li = document.createElement('li');
            li.innerHTML = `
                <span><strong>${aero.nom_aero}</strong> (${aero.ville}, ${aero.pays}) - ID: ${aero.id_aero}</span>
                <div class="action-buttons">
                    <button class="btn-edit" onclick="preparerModificationAero(${aero.id_aero}, \`${aero.nom_aero}\`, \`${aero.ville}\`, \`${aero.pays}\`)">Modifier</button>
                    <button class="btn-delete" onclick="supprimerAeroport(${aero.id_aero})">Supprimer</button>
                </div>
            `;
            liste.appendChild(li);

            const optionHTML = `<option value="${aero.id_aero}">${aero.ville} (${aero.nom_aero})</option>`;
            selectDepart.innerHTML += optionHTML;
            selectArrivee.innerHTML += optionHTML;
        });
    } catch (erreur) {
        console.error(erreur);
    }
}

function preparerModificationAero(id, nom, ville, pays) {
    document.getElementById('id_aero').value = id;
    document.getElementById('id_aero').disabled = true;
    document.getElementById('nom_aero').value = nom;
    document.getElementById('ville').value = ville;
    document.getElementById('pays').value = pays;
    
    document.querySelector('#form-aeroport button[type="submit"]').textContent = "Mettre à jour l'Aéroport";
    aeroEnEdition = id;
    window.scrollTo(0, document.getElementById('form-aeroport').offsetTop);
}

function reinitialiserFormAero() {
    document.getElementById('form-aeroport').reset();
    document.getElementById('id_aero').disabled = false;
    document.querySelector('#form-aeroport button[type="submit"]').textContent = "Ajouter l'Aéroport";
    aeroEnEdition = null;
}

document.getElementById('form-aeroport').addEventListener('submit', async (e) => {
    e.preventDefault();
    const aero = {
        id_aero: parseInt(document.getElementById('id_aero').value),
        nom_aero: document.getElementById('nom_aero').value,
        ville: document.getElementById('ville').value,
        pays: document.getElementById('pays').value
    };

    try {
        if (aeroEnEdition !== null) {
            await fetch(`${urlAeroports}/${aeroEnEdition}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(aero)
            });
        } else {
            await fetch(urlAeroports, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(aero)
            });
        }
        reinitialiserFormAero();
        chargerAeroports();
        chargerVols();
    } catch (erreur) {
        console.error(erreur);
    }
});

async function supprimerAeroport(id_aero) {
    if(confirm("ATTENTION : Supprimer cet aéroport supprimera également TOUS les vols (départs et arrivées) qui y sont associés. Confirmer la suppression définitive ?")) {
        try {
            await fetch(`${urlAeroports}/${id_aero}`, { method: 'DELETE' });
            chargerAeroports();
            chargerVols();
        } catch (erreur) {
            console.error(erreur);
        }
    }
}

// ==========================================
// GESTION DES VOLS
// ==========================================

async function chargerVols() {
    try {
        const reponse = await fetch(urlVols);
        const vols = await reponse.json();
        
        const liste = document.getElementById('liste-vols');
        liste.innerHTML = '';
        
        vols.forEach(vol => {
            const li = document.createElement('li');
            li.innerHTML = `
                <span><strong>${vol.compagnie}</strong> (Vol n°${vol.num_vol}) - Aéroport Dép: ${vol.depart} ➔ Aéroport Arr: ${vol.arrivee}</span>
                <div class="action-buttons">
                    <button class="btn-edit" onclick="preparerModificationVol('${vol.compagnie}', ${vol.num_vol}, ${vol.depart}, ${vol.arrivee})">Modifier</button>
                    <button class="btn-delete" onclick="supprimerVol('${vol.compagnie}', ${vol.num_vol})">Supprimer</button>
                </div>
            `;
            liste.appendChild(li);
        });
    } catch (erreur) {
        console.error(erreur);
    }
}

function preparerModificationVol(compagnie, num_vol, depart, arrivee) {
    document.getElementById('compagnie').value = compagnie;
    document.getElementById('compagnie').disabled = true;
    document.getElementById('num_vol').value = num_vol;
    document.getElementById('num_vol').disabled = true;
    document.getElementById('depart').value = depart;
    document.getElementById('arrivee').value = arrivee;
    
    document.querySelector('#form-ajout button[type="submit"]').textContent = "Mettre à jour le Vol";
    volEnEdition = { compagnie, num_vol };
    window.scrollTo(0, document.getElementById('form-ajout').offsetTop);
}

function reinitialiserFormVol() {
    document.getElementById('form-ajout').reset();
    document.getElementById('compagnie').disabled = false;
    document.getElementById('num_vol').disabled = false;
    document.querySelector('#form-ajout button[type="submit"]').textContent = "Ajouter le vol";
    volEnEdition = null;
}

document.getElementById('form-ajout').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const departVal = document.getElementById('depart').value;
    const arriveeVal = document.getElementById('arrivee').value;

    if (!departVal || !arriveeVal) {
        alert("Veuillez sélectionner un aéroport de départ ET d'arrivée valides.");
        return;
    }
    
    if (departVal === arriveeVal) {
        alert("Un vol ne peut pas avoir le même aéroport de départ et d'arrivée.");
        return;
    }

    const vol = {
        compagnie: document.getElementById('compagnie').value,
        num_vol: parseInt(document.getElementById('num_vol').value),
        depart: parseInt(departVal),
        arrivee: parseInt(arriveeVal)
    };

    try {
        if (volEnEdition !== null) {
            await fetch(`${urlVols}/${volEnEdition.compagnie}/${volEnEdition.num_vol}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(vol)
            });
        } else {
            await fetch(urlVols, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(vol)
            });
        }
        reinitialiserFormVol();
        chargerVols();
    } catch (erreur) {
        console.error(erreur);
        alert("Erreur lors de l'opération");
    }
});

async function supprimerVol(compagnie, num_vol) {
    if(confirm(`Supprimer le vol ${compagnie} n°${num_vol} ?`)) {
        try {
            await fetch(`${urlVols}/${compagnie}/${num_vol}`, { method: 'DELETE' });
            chargerVols();
        } catch (erreur) {
            console.error(erreur);
        }
    }
}

function filtrerAeroports() {
    // On récupère ce que tu as tapé et on le met en minuscules
    const filtre = document.getElementById('recherche-aero').value.toLowerCase();
    // On cible toutes les lignes <li> de la liste des aéroports
    const lignes = document.querySelectorAll('#liste-aeroports li');

    lignes.forEach(li => {
        // On récupère le texte affiché dans la ligne (Nom + ID)
        const texte = li.querySelector('span').innerText.toLowerCase();
        
        // Si le texte contient ce que tu as tapé, on l'affiche, sinon on le cache
        if (texte.includes(filtre)) {
            li.style.display = 'flex'; // 'flex' pour garder l'alignement des boutons
        } else {
            li.style.display = 'none';
        }
    });
}

chargerAeroports();
chargerVols();