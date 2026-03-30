import 'package:flutter/material.dart';
import '../models/vol.dart';
import '../repositories/vol_repository.dart';

class VolsProvider extends ChangeNotifier {
  final VolRepository _volRepo = VolRepository();

  List<Vol> _vols = [];
  bool _isLoading = false;
  String _error = '';

  List<Vol> get vols => _vols;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadVols() async {
    _isLoading = true;
    _error = '';
    
    notifyListeners();

    try {
      _vols = await _volRepo.fetchVols();
    } catch (e) {
      _error = "Impossible de récupérer les vols : $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Vol> filtrer(String query) {
    if (query.isEmpty) return _vols;
    return _vols.where((v) => 
      v.compagnie.toLowerCase().contains(query.toLowerCase()) ||
      v.numVol.toString().contains(query)
    ).toList();
  }
}