import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_theme_colors.dart';

class AppTheme {
  AppTheme._();

  // -----------------------------------------------------------------------
  // Theme lookup by name (matches strings stored in SettingsState.themes)
  // -----------------------------------------------------------------------

  static ThemeData fromName(String name) {
    switch (name) {
      case 'Ocean Blue':
        return _buildDark(
          accent: const Color(0xFF29B6F6),
          accentDark: const Color(0xFF0288D1),
          accentGlow: const Color(0x3029B6F6),
          accentSubtle: const Color(0x1529B6F6),
          background: const Color(0xFF0A141F),
          surface: const Color(0xFF0F1E2D),
          card: const Color(0xFF152637),
          cardLight: const Color(0xFF1A2F42),
          navBackground: const Color(0xFF0C1925),
          navBorder: const Color(0xFF182D3E),
          navActive: const Color(0xFF29B6F6),
          navInactive: const Color(0xFF3D5E75),
          divider: const Color(0xFF182D3E),
          switchTrackOn: const Color(0xFF29B6F6),
          switchTrackOff: const Color(0xFF1A2F42),
        );
      case 'Sunset Gold':
        return _buildDark(
          accent: const Color(0xFFFF7043),
          accentDark: const Color(0xFFE64A19),
          accentGlow: const Color(0x30FF7043),
          accentSubtle: const Color(0x15FF7043),
          background: const Color(0xFF1A0F0A),
          surface: const Color(0xFF201510),
          card: const Color(0xFF2B1C14),
          cardLight: const Color(0xFF34221A),
          navBackground: const Color(0xFF180E0A),
          navBorder: const Color(0xFF38201A),
          navActive: const Color(0xFFFF7043),
          navInactive: const Color(0xFF6B3A2A),
          divider: const Color(0xFF38201A),
          switchTrackOn: const Color(0xFFFF7043),
          switchTrackOff: const Color(0xFF34221A),
        );
      default: // 'Sage Green (Dark Mode)'
        return dark;
    }
  }

  // -----------------------------------------------------------------------
  // Default — Sage Green
  // -----------------------------------------------------------------------

  static ThemeData get dark => _buildDark(
    accent: AppColors.accent,
    accentDark: AppColors.accentDark,
    accentGlow: AppColors.accentGlow,
    accentSubtle: AppColors.accentSubtle,
    background: AppColors.background,
    surface: AppColors.surface,
    card: AppColors.card,
    cardLight: AppColors.cardLight,
    navBackground: AppColors.navBackground,
    navBorder: AppColors.navBorder,
    navActive: AppColors.navActive,
    navInactive: AppColors.navInactive,
    divider: AppColors.divider,
    switchTrackOn: AppColors.switchTrackOn,
    switchTrackOff: AppColors.switchTrackOff,
  );

  // -----------------------------------------------------------------------
  // Shared builder
  // -----------------------------------------------------------------------

  static ThemeData _buildDark({
    required Color accent,
    required Color accentDark,
    required Color accentGlow,
    required Color accentSubtle,
    required Color background,
    required Color surface,
    required Color card,
    required Color cardLight,
    required Color navBackground,
    required Color navBorder,
    required Color navActive,
    required Color navInactive,
    required Color divider,
    required Color switchTrackOn,
    required Color switchTrackOff,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: accentDark,
        surface: surface,
        error: AppColors.error,
      ),
      // ---- Attach our custom palette as a ThemeExtension ----
      extensions: [
        AppThemeColors(
          accent: accent,
          accentDark: accentDark,
          accentGlow: accentGlow,
          accentSubtle: accentSubtle,
          background: background,
          surface: surface,
          card: card,
          cardLight: cardLight,
          navBackground: navBackground,
          navBorder: navBorder,
          navActive: navActive,
          navInactive: navInactive,
          divider: divider,
          switchTrackOn: switchTrackOn,
          switchTrackOff: switchTrackOff,
        ),
      ],
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineMedium,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: navBackground,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: navBorder,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: navBackground,
        indicatorColor: accentSubtle,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelMedium.copyWith(color: navActive);
          }
          return AppTextStyles.labelMedium;
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: navActive, size: 24);
          }
          return IconThemeData(color: navInactive, size: 24);
        }),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return switchTrackOn;
          return switchTrackOff;
        }),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          textStyle: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent),
          textStyle: AppTextStyles.titleMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: cardLight,
        thumbColor: accent,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: cardLight,
      ),
    );
  }
}
