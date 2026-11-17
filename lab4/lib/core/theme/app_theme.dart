import 'package:flutter/material.dart';

/// Paleta learning app (varianta 4) — păstrată din Laboratorul 3.
const Color kOrange = Color(0xFFFF6F00);
const Color kOrangeDark = Color(0xFFF47C00);
const Color kOrangeSoft = Color(0xFFFFE0CC);
const Color kInk = Color(0xFF101012);
const Color kInkSoft = Color(0xFF4A4D52);
const Color kGrey = Color(0xFF7E858C);
const Color kGreyLight = Color(0xFF898C93);
const Color kBackground = Color(0xFFF6F6F8);
const Color kCard = Colors.white;
const Color kGreen = Color(0xFF2BB673);
const Color kRed = Color(0xFFE5484D);
const Color kFieldFill = Color(0xFFEFEFF2);

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kOrange,
    primary: kOrange,
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
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kInk),
      bodyMedium: TextStyle(fontSize: 13.5, color: kInkSoft, height: 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kOrange,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}
