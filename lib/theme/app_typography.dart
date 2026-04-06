import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// 8 text style tokens — editorial typography system.
///
/// Display / Headline: Instrument Serif (serif)
/// Body / Title / Button: DM Sans (sans-serif)
/// Label / Meta / Caption: JetBrains Mono (monospace)
class AppTypography {
  AppTypography._();

  // ── Serif (display / headline) ──

  static final TextStyle display = GoogleFonts.instrumentSerif(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  static final TextStyle headline = GoogleFonts.instrumentSerif(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  // ── Sans-serif (body / interactive) ──

  static final TextStyle title = GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static final TextStyle body = GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.textPrimary,
      );

  static final TextStyle button = GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: 0.5,
        color: AppColors.primaryDark,
      );

  // ── Monospace (label / meta / caption) ──

  static final TextStyle label = GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 1.5,
        color: AppColors.textSecondary,
      );

  static final TextStyle meta = GoogleFonts.jetBrainsMono(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 1.5,
        color: AppColors.textMeta,
      );

  static final TextStyle caption = GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.3,
        color: AppColors.textMeta,
      );
}
