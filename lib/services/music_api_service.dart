import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/track_model.dart';

// Serviço de integração com API pública de músicas (Deezer com suporte a Spotify)
class MusicApiService {
  static const String _deezerBaseUrl = 'https://api.deezer.com/search';

  // Realiza busca de faixas musicais por termo de pesquisa
  Future<List<TrackModel>> searchTracks(String query) async {
    if (query.trim().isEmpty) return [];

    final encoded = Uri.encodeComponent(query.trim());
    final uri = Uri.parse('$_deezerBaseUrl?q=$encoded&limit=25');

    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Falha ao comunicar com a API de músicas: ${response.statusCode}');
    }

    return _parseDeezerResponse(response.body);
  }

  // Faz o parsing do JSON retornado pela API da Deezer
  List<TrackModel> _parseDeezerResponse(String responseBody) {
    final Map<String, dynamic> json = jsonDecode(responseBody);
    final List<dynamic> data = json['data'] as List<dynamic>? ?? [];

    return data.map((item) => _mapDeezerItemToTrack(item)).toList();
  }

  // Converte cada item retornado em nosso modelo TrackModel padronizado
  TrackModel _mapDeezerItemToTrack(dynamic item) {
    final album = item['album'] as Map<String, dynamic>? ?? {};
    final artist = item['artist'] as Map<String, dynamic>? ?? {};
    final durationSeconds = (item['duration'] as num?)?.toInt() ?? 0;

    return TrackModel(
      id: item['id'].toString(),
      title: item['title'] as String? ?? 'Sem título',
      artist: artist['name'] as String? ?? 'Artista Desconhecido',
      albumCoverUrl: album['cover_medium'] as String? ?? album['cover'] as String? ?? '',
      durationMs: durationSeconds * 1000,
      previewUrl: item['preview'] as String?,
    );
  }
}

