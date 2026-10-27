import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// Barra horizontal exibindo salas de audição ativas ao vivo
class LiveRoomsBar extends StatelessWidget {
  final VoidCallback onNewRoom;

  const LiveRoomsBar({super.key, required this.onNewRoom});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildLiveRoomPill(
                title: 'Lounge Synthwave',
                subtitle: '8 sintonizados agora',
                tag: 'LIVE',
                tagColor: AppColors.primaryContainer,
                icon: Icons.headphones,
              ),
              const SizedBox(width: 12),
              _buildLiveRoomPill(
                title: 'Funk & Rare Grooves',
                subtitle: '5 ouvindo juntos',
                tag: 'VINYL',
                tagColor: AppColors.secondary,
                icon: Icons.album,
              ),
              const SizedBox(width: 12),
              _buildLiveRoomPill(
                title: 'Midnight Lo-Fi',
                subtitle: '12 ouvintes',
                tag: 'RADIO',
                tagColor: AppColors.tertiary,
                icon: Icons.radio,
              ),
              const SizedBox(width: 12),
              _buildCreateRoomGhostButton(),
            ],
          ),
        ),
      ],
    );
  }

  // Cabeçalho da seção com marcador animado e contador
  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text('Sessões Ativas Agora', style: AppTextStyles.headlineSm),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.3)),
          ),
          child: Text(
            '3 AO VIVO',
            style: AppTextStyles.labelCaps.copyWith(color: AppColors.tertiary),
          ),
        ),
      ],
    );
  }

  // Pílula com informações da sala ao vivo
  Widget _buildLiveRoomPill({
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: tagColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: tagColor, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(title, style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
                  const SizedBox(width: 6),
                  Text(tag, style: AppTextStyles.labelCaps.copyWith(color: tagColor)),
                ],
              ),
              Text(subtitle, style: AppTextStyles.bodySm),
            ],
          ),
        ],
      ),
    );
  }

  // Botão fantasma tracejado para abrir nova sala
  Widget _buildCreateRoomGhostButton() {
    return InkWell(
      onTap: onNewRoom,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white24, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.group_add, size: 18, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              'Abrir Sala de Vinil',
              style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

