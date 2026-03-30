import 'package:flutter/material.dart';
import '../../models/aeroport.dart';
import '../../repositories/aeroport_repository.dart';

class ListeAeroportsPage extends StatefulWidget {
  const ListeAeroportsPage({super.key});

  @override
  State<ListeAeroportsPage> createState() => _ListeAeroportsPageState();
}

class _ListeAeroportsPageState extends State<ListeAeroportsPage> {
  List<Aeroport> _tousLesAeros = [];
  List<Aeroport> _aerosFiltres = [];
  bool _chargement = true;
  final AeroportRepository _aeroRepo = AeroportRepository();

  @override
  void initState() {
    super.initState();
    _chargerAeros();
  }

  Future<void> _chargerAeros() async {
    try {
      final data = await _aeroRepo.fetchAeroports();
      setState(() {
        _tousLesAeros = data;
        _aerosFiltres = data;
        _chargement = false;
      });
    } catch (e) {
      setState(() => _chargement = false);
    }
  }

  void _filtrerAeros(String motCle) {
    setState(() {
      _aerosFiltres = _tousLesAeros.where((aero) {
        final search = motCle.toLowerCase();
        return aero.nomAero.toLowerCase().contains(search) || 
               aero.ville.toLowerCase().contains(search) || 
               aero.idAero.toString().contains(search);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Aéroports')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filtrerAeros,
              decoration: const InputDecoration(
                labelText: 'Rechercher (Nom, Ville, ID...)',
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _chargement
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _aerosFiltres.length,
                    itemBuilder: (context, index) {
                      final aero = _aerosFiltres[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.location_city, color: Colors.orange),
                          title: Text('${aero.nomAero} (ID: ${aero.idAero})'),
                          subtitle: Text('${aero.ville}, ${aero.pays}'),
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