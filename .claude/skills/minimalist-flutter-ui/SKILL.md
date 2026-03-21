---
name: minimalist-flutter-ui
description: Clean editorial-style Flutter interfaces. Warm monochrome palette, typographic contrast, flat bento grids, muted pastels. No gradients, no heavy shadows. Flutter/Dart native.
---

# Protocol: Premium Utilitarian Minimalism — Flutter UI Architect

## 1. Protocol Overview
Name: Premium Utilitarian Minimalism & Editorial UI for Flutter
Description: An advanced Flutter engineering directive for generating highly refined, ultra-minimalist, "document-style" mobile and web interfaces. This protocol strictly enforces a high-contrast warm monochrome palette, bespoke typographic hierarchies, meticulous structural macro-whitespace, bento-grid layouts, and an ultra-flat component architecture with deliberate muted pastel accents. It actively rejects standard generic Material Design defaults and cookie-cutter Flutter templates.

## 2. Absolute Negative Constraints (Banned Elements)
The AI must strictly avoid the following generic Flutter development defaults:
- DO NOT use default Material Design elevation shadows. Shadows must be practically non-existent or ultra-diffuse (`blurRadius: 24, color: Colors.black.withValues(alpha: 0.03)`).
- DO NOT use default Material color scheme (blue primary, purple secondary). Override `ThemeData` completely.
- DO NOT use `Colors.blue`, `Colors.red`, `Colors.green` etc. directly. Use only the defined palette.
- DO NOT use default `AppBar` styling with elevation. Use `elevation: 0` with custom styling.
- DO NOT use `Card` widget with default elevation. Use `Container` with custom `BoxDecoration`.
- DO NOT use `FloatingActionButton` with default Material styling.
- DO NOT use gradients, neon colors, or glassmorphism (beyond subtle `BackdropFilter` navbar blurs).
- DO NOT use `CircleBorder` or `StadiumBorder` for large containers or primary buttons.
- DO NOT use emojis anywhere in code, markup, text content, or comments.
- DO NOT use generic placeholder names like "John Doe", "Acme Corp". Use realistic, contextual content.
- DO NOT use AI copywriting clichés: "Elevate", "Seamless", "Unleash", "Next-Gen". Write plain, specific language.
- DO NOT use `Colors.black` for text. Always use off-black from the palette.
- DO NOT use default `ListTile` without custom styling — it produces generic Material look.
- AVOID `showDialog` with default `AlertDialog` — build custom dialog widgets matching the design system.

## 3. Typographic Architecture
The interface must rely on extreme typographic contrast and premium font selection to establish an editorial feel.

### Font Families (via `google_fonts` package or asset fonts)
- Primary Sans-Serif (Body, UI, Buttons): `GoogleFonts.inter()` weight 400/500/600 only, or `SF Pro Display` via asset. Target hierarchy with weight, not size bloat.
  - EXCEPTION: Inter is acceptable in Flutter because system font rendering differs from web. Prefer `GoogleFonts.plusJakartaSans()` or `GoogleFonts.dmSans()` if avoiding Inter.
- Editorial Serif (Hero Headings & Display): `GoogleFonts.playfairDisplay()`, `GoogleFonts.instrumentSerif()`, or `GoogleFonts.newsreader()`. Apply tight letter spacing (`letterSpacing: -0.5` to `-1.5`) and tight line height (`height: 1.1`).
- Monospace (Code, Metadata, Timestamps): `GoogleFonts.jetBrainsMono()` or `GoogleFonts.geistMono()`.

### Text Theme Override
```dart
TextTheme _textTheme() => TextTheme(
  displayLarge: GoogleFonts.instrumentSerif(
    fontSize: 48, fontWeight: FontWeight.w400,
    letterSpacing: -1.5, height: 1.1,
    color: const Color(0xFF111111),
  ),
  displayMedium: GoogleFonts.instrumentSerif(
    fontSize: 36, fontWeight: FontWeight.w400,
    letterSpacing: -1.0, height: 1.15,
    color: const Color(0xFF111111),
  ),
  headlineLarge: GoogleFonts.dmSans(
    fontSize: 24, fontWeight: FontWeight.w600,
    letterSpacing: -0.5, height: 1.2,
    color: const Color(0xFF111111),
  ),
  headlineMedium: GoogleFonts.dmSans(
    fontSize: 20, fontWeight: FontWeight.w600,
    letterSpacing: -0.3, height: 1.25,
    color: const Color(0xFF111111),
  ),
  titleLarge: GoogleFonts.dmSans(
    fontSize: 18, fontWeight: FontWeight.w500,
    color: const Color(0xFF2F3437),
  ),
  titleMedium: GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w500,
    color: const Color(0xFF2F3437),
  ),
  bodyLarge: GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w400,
    height: 1.6, color: const Color(0xFF2F3437),
  ),
  bodyMedium: GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 1.6, color: const Color(0xFF2F3437),
  ),
  bodySmall: GoogleFonts.dmSans(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: const Color(0xFF787774),
  ),
  labelLarge: GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w600,
    letterSpacing: 0.3, color: const Color(0xFF111111),
  ),
  labelSmall: GoogleFonts.jetBrainsMono(
    fontSize: 11, fontWeight: FontWeight.w400,
    letterSpacing: 0.5, color: const Color(0xFF787774),
  ),
);
```

### Text Color Rules
- Body text must never be `Colors.black`. Use off-black/charcoal `Color(0xFF111111)` or `Color(0xFF2F3437)`.
- Secondary/meta text: muted gray `Color(0xFF787774)`.
- Disabled text: `Color(0xFFB4B4B0)`.

## 4. Color Palette (Warm Monochrome + Spot Pastels)
Color is a scarce resource, utilized only for semantic meaning or subtle accents.

### Core Palette
```dart
abstract class AppColors {
  // Canvas
  static const canvas = Color(0xFFFBFBFA);
  static const canvasWarm = Color(0xFFF7F6F3);

  // Surfaces
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSecondary = Color(0xFFF9F9F8);

  // Text
  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF2F3437);
  static const textTertiary = Color(0xFF787774);
  static const textDisabled = Color(0xFFB4B4B0);

  // Borders & Dividers
  static const border = Color(0xFFEAEAEA);
  static const borderSubtle = Color(0x0F000000); // rgba(0,0,0,0.06)

  // Accent Pastels (backgrounds)
  static const paleRed = Color(0xFFFDEBEC);
  static const paleRedText = Color(0xFF9F2F2D);
  static const paleBlue = Color(0xFFE1F3FE);
  static const paleBlueText = Color(0xFF1F6C9F);
  static const paleGreen = Color(0xFFEDF3EC);
  static const paleGreenText = Color(0xFF346538);
  static const paleYellow = Color(0xFFFBF3DB);
  static const paleYellowText = Color(0xFF956400);

  // Interactive
  static const primaryButton = Color(0xFF111111);
  static const primaryButtonText = Color(0xFFFFFFFF);
  static const primaryButtonHover = Color(0xFF333333);
}
```

### ThemeData Override
```dart
ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.canvas,
  colorScheme: const ColorScheme.light(
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    primary: AppColors.primaryButton,
    onPrimary: AppColors.primaryButtonText,
    outline: AppColors.border,
  ),
  textTheme: _textTheme(),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.textPrimary,
    surfaceTintColor: Colors.transparent,
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.border,
    thickness: 1,
    space: 0,
  ),
  cardTheme: const CardThemeData(
    elevation: 0,
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: AppColors.border),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.textPrimary, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryButton,
      foregroundColor: AppColors.primaryButtonText,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textPrimary,
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  ),
);
```

## 5. Component Specifications

### Bento Box Feature Grids
Use `Wrap`, `GridView`, or `LayoutBuilder` for responsive asymmetrical grids.
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.surface,
    border: Border.all(color: AppColors.border),
    borderRadius: BorderRadius.circular(8),
  ),
  padding: const EdgeInsets.all(24),
  child: /* content */,
)
```
- Border-radius: `8` or `12` maximum.
- Internal padding: `24` to `40`.
- Never use default `Card` widget — use styled `Container`.

### Primary Buttons
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.primaryButton,
    borderRadius: BorderRadius.circular(6),
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Text('Action', style: TextStyle(
          color: AppColors.primaryButtonText,
          fontSize: 14, fontWeight: FontWeight.w600,
        )),
      ),
    ),
  ),
)
```
- No box shadow. No elevation.
- Hover/press: subtle scale `Transform.scale(scale: 0.98)` via `GestureDetector`.

### Tags & Status Badges
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: AppColors.paleGreen,
    borderRadius: BorderRadius.circular(9999),
  ),
  child: Text('ACTIVE',
    style: GoogleFonts.dmSans(
      fontSize: 11, fontWeight: FontWeight.w600,
      letterSpacing: 0.8, color: AppColors.paleGreenText,
    ),
  ),
)
```
- Pill-shaped, very small text, uppercase with wide tracking.

### Divider-Based Lists (Not ListTile)
```dart
Column(
  children: items.map((item) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.border)),
    ),
    child: Row(
      children: [
        Expanded(child: /* content */),
        Icon(Icons.chevron_right, size: 16, color: AppColors.textTertiary),
      ],
    ),
  )).toList(),
)
```

### Custom Bottom Navigation
Do NOT use default `BottomNavigationBar`. Build custom:
```dart
Container(
  decoration: const BoxDecoration(
    color: AppColors.surface,
    border: Border(top: BorderSide(color: AppColors.border)),
  ),
  padding: const EdgeInsets.symmetric(vertical: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: /* nav items with Phosphor icons */,
  ),
)
```

### Custom App Bar
```dart
Container(
  padding: EdgeInsets.only(
    top: MediaQuery.of(context).padding.top + 8,
    left: 20, right: 20, bottom: 12,
  ),
  decoration: const BoxDecoration(
    color: AppColors.surface,
    border: Border(bottom: BorderSide(color: AppColors.border)),
  ),
  child: Row(/* title + actions */),
)
```

## 6. Iconography
- Use `phosphor_flutter` package for icons — Bold or Fill weight.
- Icon size: `20` for inline, `24` for navigation, `32` for feature highlights.
- Icon color: `AppColors.textTertiary` default, `AppColors.textPrimary` for active state.
- DO NOT use Material Icons default set — they produce generic look.

## 7. Spacing System
Establish consistent spacing via constants:
```dart
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double section = 64;
  static const double hero = 96;
}
```
- Between sections: `AppSpacing.section` or `AppSpacing.hero`.
- Card internal padding: `AppSpacing.lg` to `AppSpacing.xl`.
- Content max-width: constrain with `ConstrainedBox(constraints: BoxConstraints(maxWidth: 600))` for mobile readability.

## 8. Subtle Motion & Micro-Animations
Motion should feel invisible — present but never distracting.

### Scroll Entry
```dart
// Use AnimatedOpacity + SlideTransition triggered by scroll visibility
AnimatedOpacity(
  duration: const Duration(milliseconds: 600),
  curve: Curves.easeOutQuart,
  opacity: isVisible ? 1.0 : 0.0,
  child: AnimatedSlide(
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeOutQuart,
    offset: isVisible ? Offset.zero : const Offset(0, 0.05),
    child: content,
  ),
)
```

### Staggered List Entry
```dart
// Use AnimationController with interval-based stagger
Future.delayed(Duration(milliseconds: index * 80), () {
  controller.forward();
});
```

### Page Transitions
Use `PageRouteBuilder` with fade + slight slide:
```dart
PageRouteBuilder(
  transitionDuration: const Duration(milliseconds: 300),
  pageBuilder: (_, __, ___) => page,
  transitionsBuilder: (_, animation, __, child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    );
  },
)
```

### Performance Rules
- Animate only `opacity` and `transform` (use `Transform` widget).
- Use `RepaintBoundary` around animated widgets.
- Prefer `AnimatedContainer` for simple property transitions.
- Use `const` constructors wherever possible.

## 9. Flutter-Specific Patterns

### State Management
- Prefer `Riverpod` or `bloc` for state management. Avoid `setState` in complex widgets.
- Keep UI widgets thin — extract business logic to providers/cubits.

### Responsive Layout
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 900) return _desktopLayout();
    if (constraints.maxWidth > 600) return _tabletLayout();
    return _mobileLayout();
  },
)
```

### Image Handling
- Use `CachedNetworkImage` for remote images.
- Apply subtle warm color filter: `ColorFiltered(colorFilter: ColorFilter.mode(Color(0x08D4A574), BlendMode.overlay))`.
- Never use oversaturated stock photos.

### Scroll Behavior
- Use `CustomScrollView` with `SliverList`/`SliverGrid` for complex scrollable layouts.
- Apply `BouncingScrollPhysics()` on iOS, `ClampingScrollPhysics()` on Android.
- Prefer `ListView.builder` over `ListView(children: [])` for lists > 10 items.

## 10. Package Dependencies
Required packages for this design system:
```yaml
dependencies:
  google_fonts: ^6.0.0
  phosphor_flutter: ^2.0.0
  cached_network_image: ^3.3.0
```

## 11. Execution Protocol
When tasked with writing Flutter UI code:
1. Override `ThemeData` completely — never rely on Material defaults.
2. Establish the spacing system first. Use generous vertical padding between sections.
3. Constrain content width for readability (`maxWidth: 600` mobile, `maxWidth: 1200` desktop).
4. Apply the custom typographic hierarchy immediately — serif for display, sans-serif for body.
5. Every card/container uses `Border.all(color: AppColors.border)` — no elevation shadows.
6. Use `phosphor_flutter` icons exclusively, never default Material icons.
7. Add scroll-entry animations to all major content blocks.
8. Build custom navigation (app bar, bottom nav, drawers) — never use Material defaults unstyled.
9. Test on both iOS and Android — ensure the editorial feel carries across platforms.
10. Use `const` constructors aggressively for performance.
