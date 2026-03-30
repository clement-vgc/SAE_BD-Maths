class Aeroport {
  final int idAero;
  final String nomAero;
  final String ville;
  final String pays;

  Aeroport({required this.idAero, required this.nomAero, required this.ville, required this.pays});

  factory Aeroport.fromJson(Map<String, dynamic> json) {
    return Aeroport(
      idAero: json['id_aero'],
      nomAero: json['nom_aero'],
      ville: json['ville'],
      pays: json['pays'],
    );
  }
}