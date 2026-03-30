import 'package:flutter/material.dart';
import 'ui/screens/navigation_accueil.dart';

void main() {
  runApp(const MonAppVols());
}

class MonAppVols extends StatelessWidget {
  const MonAppVols({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vols SAE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: NavigationAccueil(),
    );
  }
}