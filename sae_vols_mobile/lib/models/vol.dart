class Vol {
  final String compagnie;
  final int numVol;
  final int depart;
  final int arrivee;

  Vol({required this.compagnie, required this.numVol, required this.depart, required this.arrivee});

  factory Vol.fromJson(Map<String, dynamic> json) {
    return Vol(
      compagnie: json['compagnie'],
      numVol: json['num_vol'],
      depart: json['depart'],
      arrivee: json['arrivee'],
    );
  }

  Map<String, dynamic> toJson() => {
    'compagnie': compagnie,
    'num_vol': numVol,
    'depart': depart,
    'arrivee': arrivee,
  };
}