// Modelo de Faixa de Música (Track) armazenado dentro da Playlist
class TrackModel {
  final String id;
  final String title;
  final String artist;
  final String albumCoverUrl;
  final int durationMs;
  final String? previewUrl;

  const TrackModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumCoverUrl,
    required this.durationMs,
    this.previewUrl,
  });

  // Converte mapa salvo no Firestore em TrackModel
  factory TrackModel.fromMap(Map<String, dynamic> map) {
    return TrackModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Faixa Sem Título',
      artist: map['artist'] as String? ?? 'Artista Desconhecido',
      albumCoverUrl: map['albumCoverUrl'] as String? ?? '',
      durationMs: (map['durationMs'] as num?)?.toInt() ?? 0,
      previewUrl: map['previewUrl'] as String?,
    );
  }

  // Converte instância para salvar na lista 'tracks' do Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'albumCoverUrl': albumCoverUrl,
      'durationMs': durationMs,
      if (previewUrl != null) 'previewUrl': previewUrl,
    };
  }

  // Formata os milissegundos para o formato mm:ss
  String get formattedDuration {
    final totalSeconds = durationMs ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final secStr = seconds.toString().padLeft(2, '0');
    return '$minutes:$secStr';
  }
}

