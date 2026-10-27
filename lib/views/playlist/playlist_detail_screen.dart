import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/playlist_model.dart';
import '../../models/track_model.dart';
import '../../providers/audio_player_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/playlist_provider.dart';
import '../../services/firestore_service.dart';
import '../search/music_search_screen.dart';
import '../widgets/custom_toast.dart';
import '../widgets/mini_player_dock.dart';
import 'widgets/invite_collaborator_dialog.dart';
import 'widgets/track_tile.dart';
import 'widgets/vinyl_hero_widget.dart';

// Tela de detalhes e curadoria colaborativa da playlist
class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final firestore = FirestoreService();

    return StreamBuilder<PlaylistModel>(
      stream: firestore.streamPlaylist(playlistId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryContainer)),
          );
        }

        final playlist = snapshot.data!;
        final isOwner = playlist.isOwner(user?.uid);
        final canEdit = isOwner || playlist.isCollaborator(user?.uid);

        return Scaffold(
          appBar: _buildAppBar(context, isOwner),
          body: Column(
            children: [
              Expanded(child: _buildBody(context, playlist, canEdit)),
              const MiniPlayerDock(),
            ],
          ),
        );
      },
    );
  }

  // Barra de topo com opção de excluir caso seja o Dono
  PreferredSizeWidget _buildAppBar(BuildContext context, bool isOwner) {
    return AppBar(
      title: Text('Discoteca Colaborativa', style: AppTextStyles.headlineSm),
      actions: [
        if (isOwner)
          IconButton(
            icon: const Icon(Icons.delete_forever, color: AppColors.error),
            onPressed: () => _confirmDeletePlaylist(context),
            tooltip: 'Excluir playlist',
          ),
      ],
    );
  }

  // Corpo com banner de vinil e lista de faixas
  Widget _buildBody(BuildContext context, PlaylistModel playlist, bool canEdit) {
    final player = context.watch<AudioPlayerProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        VinylHeroWidget(
          coverUrl: playlist.displayCoverUrl,
          isPlaying: player.isPlaying,
        ),
        const SizedBox(height: 16),
        _buildPlaylistInfo(playlist),
        const SizedBox(height: 16),
        _buildActionButtons(context, playlist, canEdit),
        const SizedBox(height: 24),
        _buildTrackList(context, playlist, canEdit, player),
      ],
    );
  }

  // Informações de título, descrição e curadores
  Widget _buildPlaylistInfo(PlaylistModel playlist) {
    return Column(
      children: [
        Text(
          playlist.title,
          style: AppTextStyles.headlineXl.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        if (playlist.description.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            playlist.description,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 8),
        Text(
          '${playlist.tracks.length} faixas • ${playlist.collaborators.length + 1} curadores',
          style: AppTextStyles.bodySm.copyWith(color: AppColors.tertiary),
        ),
      ],
    );
  }

  // Botões de ação rápida: Ouvir em conjunto, Convidar e Adicionar
  Widget _buildActionButtons(BuildContext context, PlaylistModel p, bool canEdit) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        ElevatedButton.icon(
          onPressed: p.tracks.isEmpty ? null : () => _playAll(context, p),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Ouvir em Conjunto'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: Colors.white,
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _openInviteModal(context),
          icon: const Icon(Icons.person_add, color: AppColors.tertiary),
          label: Text('+ Convidar Amigo', style: AppTextStyles.labelMd),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.tertiary),
          ),
        ),
        if (canEdit)
          IconButton.filledTonal(
            onPressed: () => _openSearchToAdd(context, p.id),
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            tooltip: 'Adicionar faixas',
          ),
      ],
    );
  }

  // Lista de faixas da playlist
  Widget _buildTrackList(
    BuildContext context,
    PlaylistModel playlist,
    bool canEdit,
    AudioPlayerProvider player,
  ) {
    if (playlist.tracks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Nenhuma faixa adicionada ainda.', style: AppTextStyles.bodySm),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Faixas da Discoteca', style: AppTextStyles.headlineSm),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: playlist.tracks.length,
          itemBuilder: (context, index) {
            final track = playlist.tracks[index];
            final isPlayingThis = player.isPlaying && player.currentTrack?.id == track.id;

            return TrackTile(
              index: index,
              track: track,
              isPlaying: isPlayingThis,
              canEdit: canEdit,
              onPlay: () => player.playTrack(track),
              onDelete: () => _deleteTrack(context, playlist.id, track),
            );
          },
        ),
      ],
    );
  }

  // Inicia reprodução da primeira faixa da lista
  void _playAll(BuildContext context, PlaylistModel playlist) {
    if (playlist.tracks.isNotEmpty) {
      context.read<AudioPlayerProvider>().playTrack(playlist.tracks.first);
    }
  }

  // Remove a faixa com confirmação
  void _deleteTrack(BuildContext context, String pId, TrackModel track) async {
    final success = await context.read<PlaylistProvider>().removeTrack(pId, track);
    if (context.mounted && success) {
      CustomToast.showSuccess(context, 'Faixa removida da discoteca.');
    }
  }

  // Abre modal de convite
  void _openInviteModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => InviteCollaboratorDialog(playlistId: playlistId),
    );
  }

  // Abre tela de busca de músicas direcionada para esta playlist
  void _openSearchToAdd(BuildContext context, String pId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MusicSearchScreen(targetPlaylistId: pId)),
    );
  }

  // Confirmação para exclusão da playlist (apenas criador)
  void _confirmDeletePlaylist(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Text('Excluir Discoteca?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<PlaylistProvider>().deletePlaylist(playlistId);
      if (context.mounted && success) {
        Navigator.pop(context);
        CustomToast.showSuccess(context, 'Playlist excluída com sucesso.');
      }
    }
  }
}

