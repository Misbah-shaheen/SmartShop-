// utils/constants.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary     = Color(0xFF0D0D0D);
  static const Color accent      = Color(0xFFFF6B35);
  static const Color accentSoft  = Color(0xFFFFF0EB);
  static const Color surface     = Color(0xFF1C1C1E);
  static const Color white       = Color(0xFFFFFFFF);
  static const Color background  = Color(0xFFF7F7F8);
  static const Color cardBg      = Color(0xFFFFFFFF);
  static const Color border      = Color(0xFFEEEEEE);
  static const Color midGrey     = Color(0xFF9E9E9E);
  static const Color darkGrey    = Color(0xFF424242);
  static const Color lightGrey   = Color(0xFFF2F2F2);
  static const Color shimmer     = Color(0xFFE8E8E8);
  static const Color success     = Color(0xFF34C759);
  static const Color error       = Color(0xFFFF3B30);
  static const Color star        = Color(0xFFFFCC00);
}

class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: -0.5);
  static TextStyle get h2 => GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: -0.3);
  static TextStyle get h3 => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary);
  static TextStyle get body => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkGrey, height: 1.5);
  static TextStyle get bodySmall => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.midGrey);
  static TextStyle get label => GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.midGrey, letterSpacing: 0.2);
  static TextStyle get price => GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary);
  static TextStyle get button => GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.white, letterSpacing: 0.2);
  static TextStyle get caption => GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.midGrey);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent, brightness: Brightness.light),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error)),
      hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.midGrey),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
    ),
    textTheme: GoogleFonts.interTextTheme(),
  );
}

class AppRoutes {
  static const String splash        = '/';
  static const String login         = '/login';
  static const String home          = '/home';
  static const String productDetail = '/product-detail';
  static const String cart          = '/cart';
}

class DummyAuth {
  static const String email    = 'demo@smartshop.com';
  static const String password = 'password123';
}
