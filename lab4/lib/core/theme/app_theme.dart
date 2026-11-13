import 'package:flutter/material.dart';

/// Paleta editorială a aplicației.
const Color kIndigo = Color(0xFF4F5BD5);
const Color kIndigoDark = Color(0xFF2B327E);
const Color kIndigoSoft = Color(0xFF8B93E8);
const Color kInk = Color(0xFF1A1D2B);
const Color kInkSoft = Color(0xFF3C4158);
const Color kMuted = Color(0xFF8A90A6);
const Color kMutedLight = Color(0xFFB9BED0);
const Color kBackground = Color(0xFFF5F6FB);
const Color kCard = Colors.white;
const Color kLavender = Color(0xFFEDEFFA);
const Color kFieldFill = Color(0xFFEEF0F7);
const Color kAmber = Color(0xFFF5A623);
const Color kDanger = Color(0xFFE5484D);

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kIndigo,
    primary: kIndigo,
    surface: kCard,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: kBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: kInk,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: kInk,
      ),
      bodyMedium: TextStyle(fontSize: 13.5, color: kInkSoft, height: 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kIndigo,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}
