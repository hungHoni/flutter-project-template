import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// 8 text style tokens — editorial typography system.
///
/// Display / Headline: Instrument Serif (serif)
/// Body / Label / Button: DM Sans (sans-serif)
/// Meta / Caption: JetBrains Mono (monospace)
class AppTypography {
  AppTypography._();

  // ── Serif (display / headline) ──

  static TextStyle get display => GoogleFonts.instrumentSerif(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get headline => GoogleFonts.instrumentSerif(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  // ── Sans-serif (body / interactive) ──

  static TextStyle get title => GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get label => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  static TextStyle get button => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: 0.5,
        color: AppColors.primary,
      );

  // ── Monospace (meta / caption) ──

  static TextStyle get meta => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.5,
        color: AppColors.textMeta,
      );

  static TextStyle get caption => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: 0.3,
        color: AppColors.textMeta,
      );
}
