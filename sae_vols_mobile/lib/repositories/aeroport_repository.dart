import 'dart:convert';
import '../api/api_client.dart';
import '../models/aeroport.dart';

class AeroportRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Aeroport>> fetchAeroports() async {
    final response = await _apiClient.get('/aeroports');
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Aeroport.fromJson(item)).toList();
    }
    throw Exception('Erreur de chargement des aéroports');
  }
}