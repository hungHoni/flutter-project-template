import 'dart:ui';

/// Anduin blue design system — 11 color tokens.
///
/// Primary accent: Anduin Blue #3FA6EE
/// WCAG note: Anduin Blue fails AA for text on white (2.9:1).
/// Use [primaryDark] (#2B7AB8, 4.6:1) for text links.
class AppColors {
  AppColors._();

  // ── Primary ──
  static const Color primary = Color(0xFF3FA6EE);
  static const Color primaryDark = Color(0xFF2B7AB8);
  static const Color primaryLight = Color(0xFFE8F4FD);

  // ── Neutrals ──
  static const Color surface = Color(0xFFFAFAF8);
  static const Color background = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFEAEAEA);

  // ── Text ──
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textMeta = Color(0xFF999999);

  // ── Semantic ──
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28A745);
}
