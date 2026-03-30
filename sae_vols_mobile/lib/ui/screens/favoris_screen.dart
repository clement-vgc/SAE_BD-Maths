import 'package:flutter/material.dart';

class FavorisPage extends StatelessWidget {
  final List<dynamic> favoris;
  final Function(dynamic) onBasculerFavori;

  const FavorisPage({
    super.key, 
    required this.favoris, 
    required this.onBasculerFavori
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Favoris')),
      body: favoris.isEmpty
          ? const Center(child: Text("Aucun favori enregistré."))
          : ListView.builder(
              itemCount: favoris.length,
              itemBuilder: (context, index) {
                final vol = favoris[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text('${vol['compagnie']} n°${vol['num_vol']}'),
                    subtitle: Text('De : ${vol['depart']} ➔ Vers : ${vol['arrivee']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => onBasculerFavori(vol),
                    ),
                  ),
                );
              },
            ),
    );
  }
}