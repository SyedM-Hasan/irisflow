import 'package:flutter/material.dart';

/// Carries all palette-specific color tokens as a Flutter ThemeExtension.
/// Access via [BuildContext.themeColors] from any widget's build method.
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.accent,
    required this.accentDark,
    required this.accentGlow,
    required this.accentSubtle,
    required this.background,
    required this.surface,
    required this.card,
    required this.cardLight,
    required this.navBackground,
    required this.navBorder,
    required this.navActive,
    required this.navInactive,
    required this.divider,
    required this.switchTrackOn,
    required this.switchTrackOff,
  });

  final Color accent;
  final Color accentDark;
  final Color accentGlow;
  final Color accentSubtle;
  final Color background;
  final Color surface;
  final Color card;
  final Color cardLight;
  final Color navBackground;
  final Color navBorder;
  final Color navActive;
  final Color navInactive;
  final Color divider;
  final Color switchTrackOn;
  final Color switchTrackOff;

  @override
  AppThemeColors copyWith({
    Color? accent,
    Color? accentDark,
    Color? accentGlow,
    Color? accentSubtle,
    Color? background,
    Color? surface,
    Color? card,
    Color? cardLight,
    Color? navBackground,
    Color? navBorder,
    Color? navActive,
    Color? navInactive,
    Color? divider,
    Color? switchTrackOn,
    Color? switchTrackOff,
  }) {
    return AppThemeColors(
      accent: accent ?? this.accent,
      accentDark: accentDark ?? this.accentDark,
      accentGlow: accentGlow ?? this.accentGlow,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      cardLight: cardLight ?? this.cardLight,
      navBackground: navBackground ?? this.navBackground,
      navBorder: navBorder ?? this.navBorder,
      navActive: navActive ?? this.navActive,
      navInactive: navInactive ?? this.navInactive,
      divider: divider ?? this.divider,
      switchTrackOn: switchTrackOn ?? this.switchTrackOn,
      switchTrackOff: switchTrackOff ?? this.switchTrackOff,
    );
  }

  // Lerp enables smooth animated transitions between themes
  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      accent: Color.lerp(accent, other.accent, t)!,
      accentDark: Color.lerp(accentDark, other.accentDark, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardLight: Color.lerp(cardLight, other.cardLight, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navBorder: Color.lerp(navBorder, other.navBorder, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      switchTrackOn: Color.lerp(switchTrackOn, other.switchTrackOn, t)!,
      switchTrackOff: Color.lerp(switchTrackOff, other.switchTrackOff, t)!,
    );
  }
}

/// Convenience extension — use `context.themeColors.accent` anywhere.
extension AppThemeColorsX on BuildContext {
  // Null-safe fallback to Sage Green default so hot-reloads never throw.
  static const _sageFallback = AppThemeColors(
    accent: Color(0xFF48C91D),
    accentDark: Color(0xFF35991A),
    accentGlow: Color(0x3048C91D),
    accentSubtle: Color(0x1548C91D),
    background: Color(0xFF0D1512),
    surface: Color(0xFF131E19),
    card: Color(0xFF1A2B23),
    cardLight: Color(0xFF1F3228),
    navBackground: Color(0xFF0F1B17),
    navBorder: Color(0xFF1E3028),
    navActive: Color(0xFF48C91D),
    navInactive: Color(0xFF4A6859),
    divider: Color(0xFF1E3028),
    switchTrackOn: Color(0xFF48C91D),
    switchTrackOff: Color(0xFF253D31),
  );

  AppThemeColors get themeColors =>
      Theme.of(this).extension<AppThemeColors>() ?? _sageFallback;
}
