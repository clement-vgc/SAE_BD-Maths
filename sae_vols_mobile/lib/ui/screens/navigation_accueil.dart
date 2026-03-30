import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import 'vols_screen.dart';
import 'aeroports_screen.dart';
import 'favoris_screen.dart';

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

  void _chargerFavoris() async {
    final data = await StorageService.chargerFavoris();
    setState(() => _volsFavoris = data);
  }

  void _basculerFavori(dynamic vol) {
    setState(() {
      final index = _volsFavoris.indexWhere((v) => 
          v['compagnie'] == vol['compagnie'] && v['num_vol'] == vol['num_vol']);
      
      if (index >= 0) {
        _volsFavoris.removeAt(index);
      } else {
        _volsFavoris.add(vol);
      }
    });
    StorageService.sauvegarderFavoris(_volsFavoris);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ListeVolsPage(favoris: _volsFavoris, onBasculerFavori: _basculerFavori),
      const ListeAeroportsPage(),
      FavorisPage(favoris: _volsFavoris, onBasculerFavori: _basculerFavori),
    ];

    return Scaffold(
      body: pages[_indexActuel],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexActuel,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _indexActuel = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Vols'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Aéroports'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favoris'),
        ],
      ),
    );
  }
}