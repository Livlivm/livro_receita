import 'package:flutter/material.dart';

class AppTheme {
  static const laranja = Color(0xFFFFAB70);
  static const laranjaEscuro = Color(0xFFE98543);
  static const amarelo = Color(0xFFFFE6A0);
  static const creme = Color(0xFFFFFAF2);
  static const marrom = Color(0xFF604431);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: creme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: laranjaEscuro,
        primary: laranjaEscuro,
        secondary: amarelo,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: creme,
        foregroundColor: marrom,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFF0DFC9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: laranjaEscuro, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: laranjaEscuro,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
