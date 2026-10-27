import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import 'track_model.dart';

// Modelo da Playlist Colaborativa no Cloud Firestore
class PlaylistModel {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final List<String> collaborators;
  final DateTime createdAt;
  final List<TrackModel> tracks;

  const PlaylistModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.collaborators,
    required this.createdAt,
    required this.tracks,
  });

  // Converte documento do Firestore em PlaylistModel
  factory PlaylistModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final rawCollabs = data['collaborators'] as List<dynamic>? ?? [];
    final rawTracks = data['tracks'] as List<dynamic>? ?? [];

    return PlaylistModel(
      id: doc.id,
      title: data['title'] as String? ?? 'Discoteca Sem Nome',
      description: data['description'] as String? ?? '',
      ownerId: data['ownerId'] as String? ?? '',
      collaborators: rawCollabs.map((e) => e.toString()).toList(),
      createdAt: _parseTimestamp(data['createdAt']),
      tracks: rawTracks.map((t) => TrackModel.fromMap(t as Map<String, dynamic>)).toList(),
    );
  }

  // Auxiliar para conversão de Timestamp do Firestore para DateTime
  static DateTime _parseTimestamp(dynamic rawDate) {
    if (rawDate is Timestamp) {
      return rawDate.toDate();
    }
    return DateTime.now();
  }

  // Serializa a playlist para gravação no Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'collaborators': collaborators,
      'createdAt': Timestamp.fromDate(createdAt),
      'tracks': tracks.map((t) => t.toMap()).toList(),
    };
  }

  // Verifica se um determinado UID é o criador da playlist
  bool isOwner(String? userId) => userId != null && ownerId == userId;

  // Verifica se um determinado UID é colaborador convidado
  bool isCollaborator(String? userId) {
    return userId != null && collaborators.contains(userId);
  }

  // Retorna a capa da primeira música ou uma imagem padrão retrô
  String get displayCoverUrl {
    if (tracks.isNotEmpty && tracks.first.albumCoverUrl.isNotEmpty) {
      return tracks.first.albumCoverUrl;
    }
    return AppConstants.defaultAlbumCover;
  }
}

