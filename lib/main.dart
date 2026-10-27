import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'providers/audio_player_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/music_search_provider.dart';
import 'providers/playlist_provider.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/music_api_service.dart';
import 'views/auth/auth_screen.dart';
import 'views/home/home_screen.dart';

// Ponto de entrada da aplicação Discotheque
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebaseApp();
  runApp(const DiscothequeApp());
}

// Inicializa a conexão com o Firebase
Future<void> _initializeFirebaseApp() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Aviso de inicialização do Firebase: $e');
  }
}

// Widget raiz configurando Providers e Tema do aplicativo
class DiscothequeApp extends StatelessWidget {
  const DiscothequeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _buildProviders(),
      child: MaterialApp(
        title: 'Discotheque',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthGate(),
      ),
    );
  }

  // Lista de injeção de dependências e gerenciadores de estado
  static List<SingleChildWidget> _buildProviders() {
    return [
      Provider<AuthService>(create: (_) => AuthService()),
      Provider<FirestoreService>(create: (_) => FirestoreService()),
      Provider<MusicApiService>(create: (_) => MusicApiService()),
      ChangeNotifierProvider<AuthProvider>(
        create: (ctx) => AuthProvider(ctx.read<AuthService>()),
      ),
      ChangeNotifierProvider<PlaylistProvider>(
        create: (ctx) => PlaylistProvider(ctx.read<FirestoreService>()),
      ),
      ChangeNotifierProvider<MusicSearchProvider>(
        create: (ctx) => MusicSearchProvider(ctx.read<MusicApiService>()),
      ),
      ChangeNotifierProvider<AudioPlayerProvider>(
        create: (_) => AudioPlayerProvider(),
      ),
    ];
  }
}

// Portão de autenticação que direciona entre Login e Home
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return auth.isAuthenticated ? const HomeScreen() : const AuthScreen();
  }
}

