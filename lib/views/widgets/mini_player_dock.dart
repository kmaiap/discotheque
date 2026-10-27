import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/audio_player_provider.dart';

// Barra de reprodução persistente inferior com disco de vinil animado
class MiniPlayerDock extends StatefulWidget {
  const MiniPlayerDock({super.key});

  @override
  State<MiniPlayerDock> createState() => _MiniPlayerDockState();
}

class _MiniPlayerDockState extends State<MiniPlayerDock>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<AudioPlayerProvider>();
    final track = player.currentTrack;
    if (track == null) return const SizedBox.shrink();

    _handleAnimation(player.isPlaying);

    return Container(
      decoration: _buildContainerDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressBar(player),
            const SizedBox(height: 6),
            _buildControlsRow(player),
          ],
        ),
      ),
    );
  }

  // Controla o giro do disco de vinil conforme a reprodução
  void _handleAnimation(bool isPlaying) {
    if (isPlaying && !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (!isPlaying && _rotationController.isAnimating) {
      _rotationController.stop();
    }
  }

  // Estilização do fundo com efeito neon e borda
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
      border: Border(
        top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black87,
          blurRadius: 20,
          offset: Offset(0, -5),
        ),
      ],
    );
  }

  // Barra de progresso (Scrubber)
  Widget _buildProgressBar(AudioPlayerProvider player) {
    final total = player.currentTrack?.durationMs ?? 1;
    final progress = (player.position.inMilliseconds / total).clamp(0.0, 1.0);

    return Row(
      children: [
        Text(_formatDuration(player.position), style: AppTextStyles.labelCaps),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(AppColors.tertiary),
              minHeight: 3,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(player.currentTrack!.formattedDuration, style: AppTextStyles.labelCaps),
      ],
    );
  }

  // Linha de controles com vinil giratório e botões
  Widget _buildControlsRow(AudioPlayerProvider player) {
    return Row(
      children: [
        _buildSpinningVinyl(),
        const SizedBox(width: 12),
        Expanded(child: _buildTrackInfo(player)),
        _buildPlayPauseButton(player),
      ],
    );
  }

  // Disco de vinil miniatura com rotação contínua
  Widget _buildSpinningVinyl() {
    return RotationTransition(
      turns: _rotationController,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF050608),
          border: Border.all(color: Colors.white24, width: 1.5),
        ),
        child: Center(
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryContainer,
            ),
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Informações de título e artista da faixa atual
  Widget _buildTrackInfo(AudioPlayerProvider player) {
    final track = player.currentTrack!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          track.title,
          style: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          track.artist,
          style: AppTextStyles.bodySm,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Botão circular Play/Pause com brilho neon
  Widget _buildPlayPauseButton(AudioPlayerProvider player) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x66FF4A8D),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        onPressed: player.togglePlayPause,
        icon: Icon(
          player.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 26,
        ),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }
}

