import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/playlist_provider.dart';
import '../../widgets/custom_toast.dart';

// Modal para convidar amigos por e-mail ou link para colaborar na playlist
class InviteCollaboratorDialog extends StatefulWidget {
  final String playlistId;

  const InviteCollaboratorDialog({super.key, required this.playlistId});

  @override
  State<InviteCollaboratorDialog> createState() => _InviteCollaboratorDialogState();
}

class _InviteCollaboratorDialogState extends State<InviteCollaboratorDialog> {
  final _emailController = TextEditingController();
  bool _canAddTracks = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.primaryContainer, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildLinkSection(),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 14),
            _buildPermissionRow(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  // Cabeçalho com ícone e descrição
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_add, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Convidar Colaborador', style: AppTextStyles.headlineSm),
            Text('Sincronização em tempo real', style: AppTextStyles.bodySm),
          ],
        ),
      ],
    );
  }

  // Seção com link rápido para cópia
  Widget _buildLinkSection() {
    final link = 'https://discotheque.live/room/${widget.playlistId}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              link,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.tertiary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18, color: AppColors.tertiary),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: link));
              CustomToast.showSuccess(context, 'Link copiado!');
            },
          ),
        ],
      ),
    );
  }

  // Campo para inserção do e-mail do colaborador
  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'E-mail do Colaborador',
        hintText: 'amigo@email.com',
        prefixIcon: Icon(Icons.mail_outline, color: AppColors.outline),
      ),
    );
  }

  // Permissão de adição de músicas
  Widget _buildPermissionRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Permitir adicionar músicas', style: AppTextStyles.labelMd),
          Checkbox(
            value: _canAddTracks,
            activeColor: AppColors.primaryContainer,
            onChanged: (val) => setState(() => _canAddTracks = val ?? true),
          ),
        ],
      ),
    );
  }

  // Botões de Cancelar e Enviar Convite
  Widget _buildActionButtons(BuildContext context) {
    final provider = context.watch<PlaylistProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: AppTextStyles.labelMd),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: provider.isOperating ? null : _handleInviteSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: provider.isOperating
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text('Enviar Convite', style: AppTextStyles.labelMd),
        ),
      ],
    );
  }

  // Processa o envio do convite buscando o usuário por e-mail
  Future<void> _handleInviteSubmit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      CustomToast.showError(context, 'Informe um e-mail válido.');
      return;
    }

    final provider = context.read<PlaylistProvider>();
    final success = await provider.inviteCollaborator(widget.playlistId, email);

    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      CustomToast.showSuccess(context, 'Colaborador adicionado à mesa!');
    } else if (provider.operationError != null) {
      CustomToast.showError(context, provider.operationError!);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

