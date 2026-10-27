// Constantes globais do Discotheque
class AppConstants {
  AppConstants._();

  static const String appName = 'Discotheque';
  static const String appTagline = 'Vinyl & Social Club';

  // Capa padrão quando nenhuma capa for fornecida
  static const String defaultAlbumCover =
      'https://images.unsplash.com/photo-1539185441755-769473a23570?w=500&auto=format&fit=crop&q=60';

  // Coleções do Cloud Firestore
  static const String usersCollection = 'users';
  static const String playlistsCollection = 'playlists';
}

