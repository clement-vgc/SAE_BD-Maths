import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MonAppVols());
}

class MonAppVols extends StatelessWidget {
  const MonAppVols({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vols SAE',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NavigationAccueil(),
    );
  }
}

class NavigationAccueil extends StatefulWidget {
  const NavigationAccueil({super.key});

  @override
  State<NavigationAccueil> createState() => _NavigationAccueilState();
}

class _NavigationAccueilState extends State<NavigationAccueil> {
  int _indexActuel = 0;
  List<dynamic> _volsFavoris = [];

  @override
  void initState() {
    super.initState();
    _chargerFavoris();
  }

  Future<void> _chargerFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    final favorisStringList = prefs.getStringList('vols_favoris');
    
    if (favorisStringList != null) {
      setState(() {
        _volsFavoris = favorisStringList.map((item) => json.decode(item)).toList();
      });
    }
  }

  Future<void> _sauvegarderFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    final favorisStringList = _volsFavoris.map((item) => json.encode(item)).toList();
    await prefs.setStringList('vols_favoris', favorisStringList);
  }

  void _basculerFavori(dynamic vol) {
    setState(() {
      final index = _volsFavoris.indexWhere((v) => v['compagnie'] == vol['compagnie'] && v['num_vol'] == vol['num_vol']);
      
      if (index >= 0) {
        _volsFavoris.removeAt(index);
      } else {
        _volsFavoris.add(vol);
      }
      
      _sauvegarderFavoris();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ListeVolsPage(
        favoris: _volsFavoris,
        onBasculerFavori: _basculerFavori,
      ),
      FavorisPage(
        favoris: _volsFavoris,
        onBasculerFavori: _basculerFavori,
      ),
    ];

    return Scaffold(
      body: pages[_indexActuel],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexActuel,
        onTap: (index) {
          setState(() {
            _indexActuel = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: 'Tous les vols',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Mes favoris',
          ),
        ],
      ),
    );
  }
}

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
  List vols = [];
  bool chargement = true;

  @override
  void initState() {
    super.initState();
    fetchVols();
  }

  Future<void> fetchVols() async {
    /*final url = Uri.parse('http://127.0.0.1:5000/api/vols'); --- Pour pouvoir ouvrir l'appli via flutter run -d Chrome*/
    final url = Uri.parse('http://10.0.2.2:5000/api/vols');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        setState(() {
          vols = json.decode(response.body);
          chargement = false;
        });
      }
    } catch (e) {
      setState(() {
        chargement = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vols Disponibles'),
      ),
      body: chargement
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vols.length,
              itemBuilder: (context, index) {
                final vol = vols[index];
                final estFavori = widget.favoris.any((v) => v['compagnie'] == vol['compagnie'] && v['num_vol'] == vol['num_vol']);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.flight_takeoff, color: Colors.blue),
                    title: Text('${vol['compagnie']} (Vol n°${vol['num_vol']})'),
                    subtitle: Text('De : ${vol['depart']} ➔ Vers : ${vol['arrivee']}'),
                    trailing: IconButton(
                      icon: Icon(
                        estFavori ? Icons.star : Icons.star_border,
                        color: estFavori ? Colors.amber : null,
                      ),
                      onPressed: () {
                        widget.onBasculerFavori(vol);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class FavorisPage extends StatelessWidget {
  final List<dynamic> favoris;
  final Function(dynamic) onBasculerFavori;

  const FavorisPage({
    super.key, 
    required this.favoris,
    required this.onBasculerFavori,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Vols Favoris'),
      ),
      body: favoris.isEmpty
          ? const Center(
              child: Text("Vous n'avez pas encore de vols favoris."),
            )
          : ListView.builder(
              itemCount: favoris.length,
              itemBuilder: (context, index) {
                final vol = favoris[index];
                
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.flight_takeoff, color: Colors.blue),
                    title: Text('${vol['compagnie']} (Vol n°${vol['num_vol']})'),
                    subtitle: Text('De : ${vol['depart']} ➔ Vers : ${vol['arrivee']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.star, color: Colors.amber),
                      onPressed: () {
                        onBasculerFavori(vol);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}