import 'dart:convert';
import '../api/api_client.dart';
import '../models/vol.dart';

class VolRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Vol>> fetchVols() async {
    final response = await _apiClient.get('/vols');
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Vol.fromJson(item)).toList();
    } else {
      throw Exception('Impossible de charger les vols');
    }
  }
}