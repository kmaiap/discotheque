import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// Widget interativo de capa de álbum com disco de vinil giratório saindo da luva
class VinylHeroWidget extends StatefulWidget {
  final String coverUrl;
  final bool isPlaying;

  const VinylHeroWidget({
    super.key,
    required this.coverUrl,
    required this.isPlaying,
  });

  @override
  State<VinylHeroWidget> createState() => _VinylHeroWidgetState();
}

class _VinylHeroWidgetState extends State<VinylHeroWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _vinylController;

  @override
  void initState() {
    super.initState();
    _vinylController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    if (widget.isPlaying) _vinylController.repeat();
  }

  @override
  void didUpdateWidget(VinylHeroWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_vinylController.isAnimating) {
      _vinylController.repeat();
    } else if (!widget.isPlaying && _vinylController.isAnimating) {
      _vinylController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 160,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(right: 0, child: _buildSpinningVinyl()),
            Positioned(left: 0, child: _buildAlbumSleeve()),
          ],
        ),
      ),
    );
  }

  // Disco de vinil estilizado com sulcos e rotação suave
  Widget _buildSpinningVinyl() {
    return RotationTransition(
      turns: _vinylController,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF050608),
          border: Border.all(color: Colors.white24, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66FF007F),
              blurRadius: 18,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryContainer,
              border: Border.all(color: Colors.white54, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DISCO',
                  style: AppTextStyles.labelCaps.copyWith(fontSize: 8, color: Colors.white),
                ),
                Text(
                  '33 RPM',
                  style: AppTextStyles.labelCaps.copyWith(fontSize: 6, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Luva física do disco de vinil contendo a arte da capa e selo Lossless
  Widget _buildAlbumSleeve() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 20, offset: Offset(2, 6)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: widget.coverUrl,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                color: AppColors.surfaceContainer,
                child: const Icon(Icons.music_note, color: AppColors.primary, size: 40),
              ),
            ),
            _buildLosslessBadge(),
          ],
        ),
      ),
    );
  }

  // Selo de qualidade no canto da luva
  Widget _buildLosslessBadge() {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(
          'HQ LOSSLESS',
          style: AppTextStyles.labelCaps.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _vinylController.dispose();
    super.dispose();
  }
}

