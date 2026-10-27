import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// Estilos de texto padrão combinando Space Grotesk para títulos e Manrope para corpo
class AppTextStyles {
  AppTextStyles._();

  // Títulos destacados (Space Grotesk)
  static TextStyle displayHero = GoogleFonts.spaceGrotesk(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: -0.02,
  );

  static TextStyle headlineXl = GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: -0.01,
  );

  static TextStyle headlineMd = GoogleFonts.spaceGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle headlineSm = GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  // Rótulos e Tags (Space Grotesk)
  static TextStyle labelLg = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.04,
  );

  static TextStyle labelMd = GoogleFonts.spaceGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.05,
  );

  static TextStyle labelCaps = GoogleFonts.spaceGrotesk(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  // Textos corridos (Manrope)
  static TextStyle bodyLg = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static TextStyle bodyMd = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static TextStyle bodySm = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );
}

