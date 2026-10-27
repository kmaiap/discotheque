import 'package:flutter/material.dart';
import '../models/track_model.dart';
import '../services/music_api_service.dart';

// Gerenciador de estado para a busca de faixas na API externa de música
class MusicSearchProvider with ChangeNotifier {
  final MusicApiService _musicApiService;

  List<TrackModel> _results = [];
  bool _isSearching = false;
  String? _searchError;
  String _currentQuery = '';

  MusicSearchProvider(this._musicApiService);

  List<TrackModel> get results => _results;
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;
  String get currentQuery => _currentQuery;

  // Executa a busca assíncrona com tratamento de erros
  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _clear();
      return;
    }

    _currentQuery = trimmed;
    _setLoading(true);
    try {
      _results = await _musicApiService.searchTracks(trimmed);
      _setLoading(false);
    } catch (e) {
      _setError('Erro ao buscar músicas: $e');
    }
  }

  // Limpa resultados e query atual
  void _clear() {
    _results = [];
    _currentQuery = '';
    _searchError = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isSearching = value;
    _searchError = null;
    notifyListeners();
  }

  void _setError(String error) {
    _searchError = error;
    _isSearching = false;
    notifyListeners();
  }
}

