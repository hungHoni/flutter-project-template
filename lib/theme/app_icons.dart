import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Phosphor icon mappings — thin weight by default.
class AppIcons {
  AppIcons._();

  // ── Icon sizes ──
  static const double sm = 20;
  static const double md = 24;
  static const double lg = 32;

  // ── Bottom nav ──
  static final PhosphorIconData radar = PhosphorIcons.crosshair();
  static final PhosphorIconData radarFill = PhosphorIcons.crosshair(PhosphorIconsStyle.fill);
  static final PhosphorIconData feed = PhosphorIcons.rssSimple();
  static final PhosphorIconData feedFill = PhosphorIcons.rssSimple(PhosphorIconsStyle.fill);
  static final PhosphorIconData profile = PhosphorIcons.user();
  static final PhosphorIconData profileFill = PhosphorIcons.user(PhosphorIconsStyle.fill);

  // ── Trends ──
  static final PhosphorIconData trendUp = PhosphorIcons.arrowUp();
  static final PhosphorIconData trendHot = PhosphorIcons.fire();
  static final PhosphorIconData trendNew = PhosphorIcons.sparkle();

  // ── Actions ──
  static final PhosphorIconData arrowRight = PhosphorIcons.arrowRight();
  static final PhosphorIconData check = PhosphorIcons.check();

  // ── States ──
  static final PhosphorIconData offline = PhosphorIcons.wifiSlash();
  static final PhosphorIconData warning = PhosphorIcons.warning();
}
