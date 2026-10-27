import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// Utilitário para exibição de mensagens de alerta e sucesso estilizadas
class CustomToast {
  CustomToast._();

  // Exibe mensagem de sucesso com tema neon
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      icon: Icons.check_circle_outline,
      borderColor: AppColors.primaryContainer,
      iconColor: AppColors.primary,
    );
  }

  // Exibe mensagem de erro
  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      icon: Icons.error_outline,
      borderColor: AppColors.error,
      iconColor: AppColors.error,
    );
  }

  // Monta a estrutura da SnackBar personalizada
  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color borderColor,
    required Color iconColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceContainerHigh,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

