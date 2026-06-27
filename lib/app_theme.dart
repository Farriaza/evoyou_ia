/// ============================================================
/// APP THEME — EvoYou AI
/// Paleta centralizada. Importar en cualquier pantalla con:
///   import '../../app_theme.dart';
/// ============================================================
///
/// PALETA BASE
///   0A1931  → navyDark      (fondo principal, muy oscuro)
///   1A3D63  → navyMid       (fondo secundario / petróleo)
///   4A7FA7  → steel         (acento / bordes activos)
///   B3CFE5  → skyPastel     (acento claro / texto destacado)
///   F6FAFD  → snowBlue      (blanco azulado / texto principal)
///
/// USO RÁPIDO:
///   backgroundColor: AppColors.bgPrimary
///   color: AppColors.accent
///   color: AppColors.textMuted          ← ya tiene opacidad incluida
///   color: AppColors.textPrimary.withOpacity(0.5)  ← withOpacity() solo en runtime
/// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Colores ──────────────────────────────────────────────────

abstract class AppColors {
  // ── Paleta base ──────────────────────────────────────────
  static const Color navyDark   = Color(0xFF0A1931);
  static const Color navyMid    = Color(0xFF1A3D63);
  static const Color steel      = Color(0xFF4A7FA7);
  static const Color skyPastel  = Color(0xFFB3CFE5);
  static const Color snowBlue   = Color(0xFFF6FAFD);

  // ── Fondos ───────────────────────────────────────────────
  static const Color bgPrimary   = Color(0xFF0A1931); // = navyDark
  static const Color bgSecondary = Color(0xFF0F2440);
  static const Color bgCard      = Color(0xFF112845);
  static const Color bgBubble    = Color(0xFF163354);

  // ── Acentos ──────────────────────────────────────────────
  static const Color accent      = Color(0xFF4A7FA7); // = steel
  static const Color accentLight = Color(0xFFB3CFE5); // = skyPastel
  static const Color accentGlow  = Color(0xFF6FA8CC);

  // ── Texto ─────────────────────────────────────────────────
  // Usar sin .withOpacity() para contextos const.
  // Si necesitás opacidad, usá los sufijos _60 / _50 / _40 o llamá .withOpacity() fuera de const.
  static const Color textPrimary = Color(0xFFF6FAFD); // = snowBlue
  static const Color textMuted   = Color(0xFFB3CFE5); // = skyPastel  (~70 %)
  static const Color textSubtle  = Color(0xFF7AAAC8); // azul suave   (~50 %)

  // Variantes con alfa precalculado (úsalas en lugar de .withOpacity en widgets const)
  static const Color textMuted60  = Color(0x99B3CFE5); // textMuted   60 %
  static const Color textMuted50  = Color(0x80B3CFE5); // textMuted   50 %
  static const Color textSubtle60 = Color(0x997AAAC8); // textSubtle  60 %
  static const Color textSubtle50 = Color(0x807AAAC8); // textSubtle  50 %
  static const Color textSubtle40 = Color(0x667AAAC8); // textSubtle  40 %

  // ── Divisores / bordes ────────────────────────────────────
  static const Color divider    = Color(0x264A7FA7); // steel 15 %
  static const Color borderSoft = Color(0x334A7FA7); // steel 20 %

  // Variantes de divider con alfa precalculado
  static const Color divider30  = Color(0x4D4A7FA7); // 30 %
  static const Color divider40  = Color(0x664A7FA7); // 40 %

  // ── Estados semánticos ────────────────────────────────────
  static const Color success = Color(0xFF4CAF82);
  static const Color warning = Color(0xFFE8A838);
  static const Color error   = Color(0xFFE05C5C);

  // ── Degradados ────────────────────────────────────────────
  static const LinearGradient gradientPrimary = LinearGradient(
    colors: [Color(0xFF4A7FA7), Color(0xFF1A3D63)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientAccent = LinearGradient(
    colors: [Color(0xFF6FA8CC), Color(0xFF4A7FA7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientBg = LinearGradient(
    colors: [Color(0xFF0A1931), Color(0xFF0F2440)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// ── Tema Material ─────────────────────────────────────────────

abstract class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary:     AppColors.steel,
        secondary:   AppColors.skyPastel,
        surface:     AppColors.bgCard,
        error:       AppColors.error,
        onPrimary:   AppColors.snowBlue,
        onSecondary: AppColors.navyDark,
        onSurface:   AppColors.snowBlue,
      ),

      scaffoldBackgroundColor: AppColors.bgPrimary,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgSecondary,
        foregroundColor: AppColors.snowBlue,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.snowBlue),
        titleTextStyle: TextStyle(
          color: AppColors.snowBlue,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.bgPrimary,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgSecondary,
        selectedItemColor: AppColors.accentLight,
        unselectedItemColor: AppColors.textSubtle50,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgBubble,
        hintStyle: const TextStyle(color: AppColors.textSubtle50, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSubtle),
        prefixIconColor: AppColors.steel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.steel, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.steel,
          foregroundColor: AppColors.snowBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.skyPastel,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.divider),
        ),
      ),

      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1),

      iconTheme: const IconThemeData(color: AppColors.textSubtle),

      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.steel),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.steel : Colors.transparent),
        checkColor: WidgetStateProperty.all(AppColors.snowBlue),
        side: const BorderSide(color: AppColors.steel, width: 1.5),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.snowBlue : AppColors.textSubtle),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.steel : AppColors.bgBubble),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.bgCard,
        contentTextStyle: TextStyle(color: AppColors.snowBlue, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        behavior: SnackBarBehavior.floating,
      ),

      textTheme: const TextTheme(
        displayLarge:   TextStyle(color: AppColors.snowBlue),
        displayMedium:  TextStyle(color: AppColors.snowBlue),
        displaySmall:   TextStyle(color: AppColors.snowBlue),
        headlineLarge:  TextStyle(color: AppColors.snowBlue, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.snowBlue, fontWeight: FontWeight.w600),
        headlineSmall:  TextStyle(color: AppColors.snowBlue, fontWeight: FontWeight.w600),
        titleLarge:     TextStyle(color: AppColors.snowBlue, fontWeight: FontWeight.w600),
        titleMedium:    TextStyle(color: AppColors.snowBlue),
        titleSmall:     TextStyle(color: AppColors.textMuted),
        bodyLarge:      TextStyle(color: AppColors.snowBlue),
        bodyMedium:     TextStyle(color: AppColors.textMuted),
        bodySmall:      TextStyle(color: AppColors.textSubtle),
        labelLarge:     TextStyle(color: AppColors.snowBlue, fontWeight: FontWeight.w600),
        labelMedium:    TextStyle(color: AppColors.textMuted),
        labelSmall:     TextStyle(color: AppColors.textSubtle),
      ),
    );
  }

  static void applySystemUI({
    Color navBarColor = AppColors.bgPrimary,
    Brightness navBarIconBrightness = Brightness.light,
  }) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: navBarColor,
      systemNavigationBarIconBrightness: navBarIconBrightness,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }
}
