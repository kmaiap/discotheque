import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/playlist_provider.dart';
import '../../widgets/custom_toast.dart';

// Diálogo modal para criação de uma nova playlist colaborativa
class CreatePlaylistDialog extends StatefulWidget {
  const CreatePlaylistDialog({super.key});

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLiveRoom = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.tertiary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDialogHeader(),
            const SizedBox(height: 20),
            _buildFormFields(),
            const SizedBox(height: 16),
            _buildLiveRoomToggle(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  // Cabeçalho do modal com ícone e título
  Widget _buildDialogHeader() {
    return Row(
      children: [
        const Icon(Icons.queue_music, color: AppColors.tertiary, size: 24),
        const SizedBox(width: 10),
        Text(
          'Nova Mesa Colaborativa',
          style: AppTextStyles.headlineSm.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  // Campos de texto para título e descrição
  Widget _buildFormFields() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Nome da Discoteca',
            hintText: 'Ex: Vaporwave Nights 1984',
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _descController,
          maxLines: 2,
          style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Descrição / Vibe Musical',
            hintText: 'Descreva a atmosfera sonora...',
          ),
        ),
      ],
    );
  }

  // Alternador para indicar sessão sincronizada
  Widget _buildLiveRoomToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sessão Sincronizada', style: AppTextStyles.labelMd),
                Text('Reprodução entre convidados', style: AppTextStyles.bodySm),
              ],
            ),
          ),
          Switch(
            value: _isLiveRoom,
            activeThumbColor: AppColors.tertiary,
            onChanged: (val) => setState(() => _isLiveRoom = val),
          ),
        ],
      ),
    );
  }

  // Botões de ação (Cancelar e Criar)
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: AppTextStyles.labelMd),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tertiary,
            foregroundColor: AppColors.onTertiary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text('Criar Playlist', style: AppTextStyles.labelMd),
        ),
      ],
    );
  }

  // Validação e chamada de criação da playlist
  Future<void> _handleSubmit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      CustomToast.showError(context, 'Informe o nome da playlist.');
      return;
    }

    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    final provider = context.read<PlaylistProvider>();
    final newId = await provider.createPlaylist(
      title: title,
      description: _descController.text.trim(),
      ownerId: user.uid,
    );

    if (!mounted) return;
    if (newId != null) {
      Navigator.pop(context);
      CustomToast.showSuccess(context, 'Discoteca criada com sucesso!');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}

