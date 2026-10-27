import 'package:flutter/material.dart';
import '../models/track_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

// Gerenciador de estado para operações nas playlists
class PlaylistProvider with ChangeNotifier {
  final FirestoreService _firestoreService;

  bool _isOperating = false;
  String? _operationError;
  List<UserModel> _collaboratorProfiles = [];

  PlaylistProvider(this._firestoreService);

  bool get isOperating => _isOperating;
  String? get operationError => _operationError;
  List<UserModel> get collaboratorProfiles => _collaboratorProfiles;

  // Cria uma nova playlist colaborativa
  Future<String?> createPlaylist({
    required String title,
    required String description,
    required String ownerId,
  }) async {
    _startOperation();
    try {
      final id = await _firestoreService.createPlaylist(
        title: title,
        description: description,
        ownerId: ownerId,
      );
      _finishOperation();
      return id;
    } catch (e) {
      _setError('Falha ao criar playlist: $e');
      return null;
    }
  }

  // Adiciona uma faixa musical à playlist selecionada
  Future<bool> addTrack(String playlistId, TrackModel track) async {
    _startOperation();
    try {
      await _firestoreService.addTrack(playlistId, track);
      _finishOperation();
      return true;
    } catch (e) {
      _setError('Erro ao adicionar música: $e');
      return false;
    }
  }

  // Remove uma faixa da playlist
  Future<bool> removeTrack(String playlistId, TrackModel track) async {
    _startOperation();
    try {
      await _firestoreService.removeTrack(playlistId, track);
      _finishOperation();
      return true;
    } catch (e) {
      _setError('Erro ao remover música: $e');
      return false;
    }
  }

  // Adiciona colaborador buscando pelo e-mail
  Future<bool> inviteCollaborator(String playlistId, String email) async {
    _startOperation();
    try {
      await _firestoreService.addCollaboratorByEmail(playlistId, email);
      _finishOperation();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  // Exclui a playlist inteira (apenas dono)
  Future<bool> deletePlaylist(String playlistId) async {
    _startOperation();
    try {
      await _firestoreService.deletePlaylist(playlistId);
      _finishOperation();
      return true;
    } catch (e) {
      _setError('Falha ao excluir playlist: $e');
      return false;
    }
  }

  // Carrega a lista de perfis dos colaboradores para exibição de avatares
  Future<void> fetchCollaboratorProfiles(List<String> uids) async {
    try {
      _collaboratorProfiles = await _firestoreService.getUsersByIds(uids);
      notifyListeners();
    } catch (_) {
      // Ignora erro em caso de falha de conexão secundária
    }
  }

  void _startOperation() {
    _isOperating = true;
    _operationError = null;
    notifyListeners();
  }

  void _finishOperation() {
    _isOperating = false;
    notifyListeners();
  }

  void _setError(String error) {
    _operationError = error;
    _isOperating = false;
    notifyListeners();
  }
}

