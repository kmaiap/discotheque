import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/track_model.dart';
import '../../widgets/equalizer_indicator.dart';

// Linha de exibição de faixa de música da playlist
class TrackTile extends StatelessWidget {
  final int index;
  final TrackModel track;
  final bool isPlaying;
  final bool canEdit;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  const TrackTile({
    super.key,
    required this.index,
    required this.track,
    required this.isPlaying,
    required this.canEdit,
    required this.onPlay,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: _buildDecoration(),
      child: ListTile(
        onTap: onPlay,
        leading: _buildLeading(),
        title: _buildTitle(),
        subtitle: Text(track.artist, style: AppTextStyles.bodySm),
        trailing: _buildTrailing(),
      ),
    );
  }

  // Estilização do card da faixa, destacando quando em reprodução
  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: isPlaying
          ? AppColors.surfaceContainerHigh.withValues(alpha: 0.7)
          : AppColors.surfaceContainerLow.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      border: Border(
        left: BorderSide(
          color: isPlaying ? AppColors.primaryContainer : Colors.transparent,
          width: 4,
        ),
      ),
    );
  }

  // Indicador numérico ou equalizador sonoro animado
  Widget _buildLeading() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 26,
          child: isPlaying
              ? const EqualizerIndicator(isPlaying: true)
              : Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
        ),
        const SizedBox(width: 8),
        _buildThumbnail(),
      ],
    );
  }

  // Miniatura da capa da música
  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: track.albumCoverUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Container(
          width: 40,
          height: 40,
          color: AppColors.surfaceContainerHighest,
          child: const Icon(Icons.music_note, size: 20, color: AppColors.outline),
        ),
      ),
    );
  }

  // Título da faixa com cor temática se estiver tocando
  Widget _buildTitle() {
    return Text(
      track.title,
      style: AppTextStyles.bodyMd.copyWith(
        fontWeight: FontWeight.bold,
        color: isPlaying ? AppColors.tertiary : Colors.white,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Duração e botão de exclusão de faixa
  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(track.formattedDuration, style: AppTextStyles.bodySm),
        if (canEdit) ...[
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.outline),
            onPressed: onDelete,
            tooltip: 'Remover música',
          ),
        ],
      ],
    );
  }
}

