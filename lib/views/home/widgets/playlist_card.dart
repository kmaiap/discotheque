import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/playlist_model.dart';
import '../../../providers/audio_player_provider.dart';

// Card em estilo Bento retrô apresentando a playlist colaborativa
class PlaylistCard extends StatelessWidget {
  final PlaylistModel playlist;
  final String currentUserId;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = playlist.isOwner(currentUserId);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _buildCardDecoration(isOwner),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCoverThumbnail(),
                const SizedBox(width: 14),
                Expanded(child: _buildDetails(isOwner)),
              ],
            ),
            const SizedBox(height: 14),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // Decoração do card com borda sutil e sombra neon suave
  BoxDecoration _buildCardDecoration(bool isOwner) {
    return BoxDecoration(
      color: AppColors.surfaceContainerLow.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isOwner
            ? AppColors.primaryContainer.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.1),
        width: isOwner ? 1.5 : 1,
      ),
      boxShadow: [
        if (isOwner)
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
      ],
    );
  }

  // Miniatura da capa da playlist
  Widget _buildCoverThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: playlist.displayCoverUrl,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Container(
          width: 72,
          height: 72,
          color: AppColors.surfaceContainerHighest,
          child: const Icon(Icons.album, color: AppColors.primary),
        ),
      ),
    );
  }

  // Detalhes da playlist (Etiqueta, Título, Descrição)
  Widget _buildDetails(bool isOwner) {
    final roleColor = isOwner ? AppColors.primary : AppColors.secondary;
    final roleText = isOwner ? 'DONO' : 'COLABORADOR';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildRoleBadge(roleText, roleColor),
            const SizedBox(width: 8),
            Text('${playlist.tracks.length} faixas', style: AppTextStyles.bodySm),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          playlist.title,
          style: AppTextStyles.headlineSm.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (playlist.description.isNotEmpty)
          Text(
            playlist.description,
            style: AppTextStyles.bodySm,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  // Selo de Dono ou Colaborador
  Widget _buildRoleBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelCaps.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Rodapé com quantidade de curadores e botão de play rápido
  Widget _buildFooter(BuildContext context) {
    final totalMembers = playlist.collaborators.length + 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.groups, size: 16, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              '$totalMembers curador${totalMembers > 1 ? 'es' : ''}',
              style: AppTextStyles.bodySm,
            ),
          ],
        ),
        if (playlist.tracks.isNotEmpty)
          IconButton(
            onPressed: () => _playFirstTrack(context),
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceContainer,
              padding: const EdgeInsets.all(6),
            ),
          ),
      ],
    );
  }

  // Inicia reprodução da primeira faixa da playlist no mini player
  void _playFirstTrack(BuildContext context) {
    if (playlist.tracks.isNotEmpty) {
      context.read<AudioPlayerProvider>().playTrack(playlist.tracks.first);
    }
  }
}

