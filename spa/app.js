const API_URL = 'http://127.0.0.1:5000/api/vols';
let volEnEdition = null;

async function chargerVols() {
    try {
        const reponse = await fetch(API_URL);
        const vols = await reponse.json();
        
        const listeHTML = document.getElementById('liste-vols');
        listeHTML.innerHTML = '';
        
        vols.forEach(vol => {
            const li = document.createElement('li');
            li.textContent = `Vol ${vol.compagnie} n°${vol.num_vol} : ${vol.depart} -> ${vol.arrivee} `;
            
            const btnModifier = document.createElement('button');
            btnModifier.textContent = 'Modifier';
            btnModifier.onclick = () => preparerModification(vol);
            
            const btnSupprimer = document.createElement('button');
            btnSupprimer.textContent = 'Supprimer';
            btnSupprimer.onclick = () => supprimerVol(vol.compagnie, vol.num_vol);
            
            li.appendChild(btnModifier);
            li.appendChild(btnSupprimer);
            listeHTML.appendChild(li);
        });
        
    } catch (erreur) {
        console.error(erreur);
    }
}

async function supprimerVol(compagnie, num_vol) {
    try {
        const reponse = await fetch(`${API_URL}/${compagnie}/${num_vol}`, {
            method: 'DELETE'
        });
        
        if (reponse.ok) {
            chargerVols();
        }
    } catch (erreur) {
        console.error(erreur);
    }
}

function preparerModification(vol) {
    document.getElementById('compagnie').value = vol.compagnie;
    document.getElementById('num_vol').value = vol.num_vol;
    document.getElementById('depart').value = vol.depart;
    document.getElementById('arrivee').value = vol.arrivee;
    
    document.getElementById('compagnie').disabled = true;
    document.getElementById('num_vol').disabled = true;
    
    document.querySelector('#form-ajout button').textContent = 'Valider la modification';
    volEnEdition = vol;
}

document.getElementById('form-ajout').addEventListener('submit', async function(event) {
    event.preventDefault(); 

    const donneesVol = {
        compagnie: document.getElementById('compagnie').value,
        num_vol: parseInt(document.getElementById('num_vol').value),
        depart: document.getElementById('depart').value,
        arrivee: document.getElementById('arrivee').value
    };

    try {
        let reponse;
        
        if (volEnEdition) {
            reponse = await fetch(`${API_URL}/${volEnEdition.compagnie}/${volEnEdition.num_vol}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(donneesVol)
            });
        } else {
            reponse = await fetch(API_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(donneesVol)
            });
        }

        if (reponse.ok) {
            chargerVols();
            document.getElementById('form-ajout').reset();
            document.getElementById('compagnie').disabled = false;
            document.getElementById('num_vol').disabled = false;
            document.querySelector('#form-ajout button').textContent = 'Ajouter le vol';
            volEnEdition = null;
        }
        
    } catch (erreur) {
        console.error(erreur);
    }
});

chargerVols();