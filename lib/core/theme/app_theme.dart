import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

// Configuração central do tema escuro do aplicativo Discotheque
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: _buildColorScheme(),
      appBarTheme: _buildAppBarTheme(),
      cardTheme: _buildCardTheme(),
      inputDecorationTheme: _buildInputTheme(),
    );
  }

  // Esquema de cores Material 3 alinhado ao design
  static ColorScheme _buildColorScheme() {
    return const ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      onSurface: AppColors.onSurface,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
    );
  }

  // Estilização da AppBar superior com vidro escuro
  static AppBarTheme _buildAppBarTheme() {
    return AppBarTheme(
      backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.headlineSm.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: AppColors.onSurface),
    );
  }

  // Estilização dos Cards com cantos arredondados
  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: AppColors.surfaceContainerLow,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );
  }

  // Estilização dos campos de texto (Input Decoration)
  static InputDecorationTheme _buildInputTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      hintStyle: AppTextStyles.bodySm,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.tertiary, width: 1.5),
      ),
    );
  }
}

