import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFFF25D3A);
  static const primaryDeep = Color(0xFFC9421F);
  static const primarySoft = Color(0xFFFDD8C8);
  static const accent = Color(0xFF2E8F88);
  static const accentSoft = Color(0xFFD4EAE7);

  static const bg = Color(0xFFF4D9C8);
  static const bgDeep = Color(0xFFEBC2A8);
  static const surface = Color(0xFFFFF8F1);
  static const ink = Color(0xFF3A1F10);
  static const inkSoft = Color(0xFF7A5540);
  static const inkFaint = Color(0xFFB89880);

  static const border = Color(0xFFE8C8B0);
  static const chipBg = Color(0xFFF8E6D6);

  static const tint1 = Color(0xFFF7C66B);
  static const tint2 = Color(0xFF6FA8A0);
  static const tint3 = Color(0xFF8B6FBF);
  static const tint4 = Color(0xFFE87A9B);

  static const openGreen = Color(0xFF0E8F5E);
  static const openGreenBg = Color(0xFFE6F7EE);
  static const userBlue = Color(0xFF2D7EF5);
}

enum BusinessCategory { cafe, restaurant, shop, service, fitness, bar }

extension BusinessCategoryColor on BusinessCategory {
  Color get color {
    switch (this) {
      case BusinessCategory.cafe:
        return AppColors.primary;
      case BusinessCategory.restaurant:
        return AppColors.tint4;
      case BusinessCategory.shop:
        return AppColors.tint3;
      case BusinessCategory.service:
        return AppColors.tint1;
      case BusinessCategory.fitness:
        return AppColors.accent;
      case BusinessCategory.bar:
        return AppColors.tint2;
    }
  }

  String get label {
    switch (this) {
      case BusinessCategory.cafe:
        return 'Cafes';
      case BusinessCategory.restaurant:
        return 'Food';
      case BusinessCategory.shop:
        return 'Shops';
      case BusinessCategory.service:
        return 'Services';
      case BusinessCategory.fitness:
        return 'Fitness';
      case BusinessCategory.bar:
        return 'Bars';
    }
  }
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primarySoft,
    onPrimaryContainer: AppColors.primaryDeep,
    secondary: AppColors.accent,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.accentSoft,
    onSecondaryContainer: AppColors.accent,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    surfaceContainerHighest: AppColors.chipBg,
    onSurfaceVariant: AppColors.inkSoft,
    outline: AppColors.border,
    outlineVariant: AppColors.border,
    error: Color(0xFFD93025),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
  ),
  scaffoldBackgroundColor: AppColors.bg,
  cardColor: AppColors.surface,
  dividerColor: AppColors.border,
  textTheme: GoogleFonts.interTextTheme(
    const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    ),
  ).apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: AppColors.primary.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.ink,
      side: const BorderSide(color: AppColors.border, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    hintStyle: const TextStyle(color: AppColors.inkFaint, fontSize: 15),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.border, width: 1),
    ),
    margin: const EdgeInsets.only(bottom: 10),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surface,
    selectedColor: AppColors.primary,
    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    shape: const StadiumBorder(),
    side: const BorderSide(color: AppColors.border, width: 1.5),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.surface.withValues(alpha: 0.94),
    indicatorColor: Colors.transparent,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: AppColors.primary, size: 22);
      }
      return const IconThemeData(color: AppColors.inkFaint, size: 22);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        );
      }
      return const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        color: AppColors.inkFaint,
      );
    }),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    foregroundColor: AppColors.ink,
    titleTextStyle: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      letterSpacing: -0.3,
    ),
  ),
);

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  static const double cardRadius = 16;
  static const double buttonRadius = 14;
  static const double inputRadius = 12;
  static const double chipRadius = 20;
  static const double tileRadius = 14;
  static const double sheetRadius = 24;
}

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static List<BoxShadow> primaryButton(Color primary) => [
    BoxShadow(
      color: primary.withValues(alpha: 0.35),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> mapControl = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> floatingButton = [
    BoxShadow(color: Color(0x38000000), blurRadius: 18, offset: Offset(0, 6)),
  ];
}
