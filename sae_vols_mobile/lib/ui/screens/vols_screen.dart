import 'package:flutter/material.dart';
import '../../models/vol.dart';
import '../../repositories/vol_repository.dart';

class ListeVolsPage extends StatefulWidget {
  final List<dynamic> favoris;
  final Function(dynamic) onBasculerFavori;

  const ListeVolsPage({
    super.key, 
    required this.favoris, 
    required this.onBasculerFavori
  });

  @override
  State<ListeVolsPage> createState() => _ListeVolsPageState();
}

class _ListeVolsPageState extends State<ListeVolsPage> {
  List<Vol> _tousLesVols = [];
  List<Vol> _volsFiltres = [];
  bool _chargement = true;
  
  final VolRepository _volRepo = VolRepository();

  @override
  void initState() {
    super.initState();
    _chargerVols();
  }

  Future<void> _chargerVols() async {
    try {
      final vols = await _volRepo.fetchVols();
      setState(() {
        _tousLesVols = vols;
        _volsFiltres = vols;
        _chargement = false;
      });
    } catch (e) {
      print("Erreur de récupération: $e");
      setState(() => _chargement = false);
    }
  }

  void _filtrerVols(String motCle) {
    setState(() {
      if (motCle.isEmpty) {
        _volsFiltres = _tousLesVols;
      } else {
        _volsFiltres = _tousLesVols.where((vol) {
          final recherche = motCle.toLowerCase();
          // Accès propre via les propriétés de l'objet Vol
          return vol.compagnie.toLowerCase().contains(recherche) ||
                 vol.depart.toString().contains(recherche) ||
                 vol.arrivee.toString().contains(recherche) ||
                 vol.numVol.toString().contains(recherche);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau des Vols')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filtrerVols,
              decoration: const InputDecoration(
                labelText: 'Rechercher (ID, Ville, Compagnie...)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _chargement
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _volsFiltres.length,
                    itemBuilder: (context, index) {
                      final vol = _volsFiltres[index];
                      // Logique de favoris adaptée aux objets
                      final estFavori = widget.favoris.any((v) => 
                          v['compagnie'] == vol.compagnie && v['num_vol'] == vol.numVol);

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.flight_takeoff, color: Colors.blue),
                          title: Text('${vol.compagnie} n°${vol.numVol}'),
                          subtitle: Text('ID Dép: ${vol.depart} ➔ ID Arr: ${vol.arrivee}'),
                          trailing: IconButton(
                            icon: Icon(
                              estFavori ? Icons.star : Icons.star_border, 
                              color: estFavori ? Colors.amber : null
                            ),
                            onPressed: () => widget.onBasculerFavori({
                              'compagnie': vol.compagnie,
                              'num_vol': vol.numVol,
                              'depart': vol.depart,
                              'arrivee': vol.arrivee,
                            }),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}