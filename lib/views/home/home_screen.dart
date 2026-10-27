import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/playlist_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../playlist/playlist_detail_screen.dart';
import '../search/music_search_screen.dart';
import '../widgets/mini_player_dock.dart';
import 'widgets/create_playlist_dialog.dart';
import 'widgets/live_rooms_bar.dart';
import 'widgets/playlist_card.dart';

// Tela principal (Home) com lista em tempo real das playlists colaborativas
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) return const Scaffold(body: SizedBox.shrink());

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                LiveRoomsBar(onNewRoom: () => _openCreateDialog(context)),
                const SizedBox(height: 24),
                _buildSectionTitle(context),
                const SizedBox(height: 12),
                _buildPlaylistsStream(context, user.uid),
              ],
            ),
          ),
          const MiniPlayerDock(),
        ],
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  // Barra superior do aplicativo com logo e ações rápidas
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          _buildLogoIcon(),
          const SizedBox(width: 10),
          _buildBrandTitles(),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.onSurface),
          onPressed: () => _openSearch(context),
          tooltip: 'Pesquisar músicas',
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.onSurfaceVariant),
          onPressed: () => context.read<AuthProvider>().signOut(),
          tooltip: 'Sair do Clube',
        ),
      ],
    );
  }

  // Ícone circular neon com equalizador
  Widget _buildLogoIcon() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10),
      ),
      child: const Icon(Icons.graphic_eq, color: AppColors.primary, size: 20),
    );
  }

  // Textos com o nome do aplicativo e slogan
  Widget _buildBrandTitles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Discotheque', style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary)),
        Text('VINYL & SOCIAL CLUB', style: AppTextStyles.labelCaps.copyWith(fontSize: 8)),
      ],
    );
  }

  // Título da seção com botão de atalho para criar
  Widget _buildSectionTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Minhas Playlists Colaborativas', style: AppTextStyles.headlineSm),
            Text('Discotecas sincronizadas com amigos', style: AppTextStyles.bodySm),
          ],
        ),
        TextButton.icon(
          onPressed: () => _openCreateDialog(context),
          icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
          label: Text('Criar', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
        ),
      ],
    );
  }

  // StreamBuilder para escuta em tempo real do Firestore
  Widget _buildPlaylistsStream(BuildContext context, String userId) {
    final firestoreService = FirestoreService();

    return StreamBuilder<List<PlaylistModel>>(
      stream: firestoreService.streamUserPlaylists(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: AppColors.primaryContainer),
          ));
        }

        final playlists = snapshot.data ?? [];
        if (playlists.isEmpty) return _buildEmptyState(context);

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: playlists.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final playlist = playlists[index];
            return PlaylistCard(
              playlist: playlist,
              currentUserId: userId,
              onTap: () => _openPlaylistDetail(context, playlist.id),
            );
          },
        );
      },
    );
  }

  // Estado vazio quando o usuário ainda não possui playlists
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.album_outlined, size: 54, color: AppColors.onSurfaceVariant),
          const SizedBox(height: 12),
          Text('Nenhuma discoteca encontrada', style: AppTextStyles.headlineSm),
          const SizedBox(height: 6),
          Text(
            'Crie sua primeira playlist e convide amigos para colaborar.',
            style: AppTextStyles.bodySm,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _openCreateDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Criar Nova Playlist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Botão de ação flutuante para criação rápida de playlist
  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openCreateDialog(context),
      backgroundColor: AppColors.primaryContainer,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text('Nova Playlist', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
    );
  }

  void _openCreateDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const CreatePlaylistDialog());
  }

  void _openSearch(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MusicSearchScreen()));
  }

  void _openPlaylistDetail(BuildContext context, String playlistId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaylistDetailScreen(playlistId: playlistId)),
    );
  }
}

