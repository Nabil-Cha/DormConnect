import 'package:flutter/material.dart';

class AppColors {
  static const Color lightPrimary = Color(0xFFED6A5A);
  static const Color lightPrimaryAccent = Color(0xFFF28E82);
  static const Color lightSecondary = Color(0xFF8628BC);
  static const Color lightSecondaryAccent = Color(0xFFDFB4F0);
  static const Color lightSecondaryBackground = Color(0xFFFFFFFF);
  static const Color lightJoinEvent = Color(0xFF1B5025);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF333333);
  static const Color lightTextTertiary = Color(0xFF3C3C3C);
  static const Color lightTextDisabled = Color(0xFFBDBDBD);
  static const Color lightSelectedIcon = Color(0xFF212121);
  static const Color lightUnselectedIcon = Color(0xFF7F7F81);
  static const Color lightError = Color(0xFFFF3B30);

  // Dark Mode Colors
  static const Color darkPrimary = Color(0xFFED6A5A);
  static const Color darkPrimaryAccent = Color(0xFFF28E82);
  static const Color darkSecondary = Color(0xFF9BC5C1);
  static const Color darkSecondaryAccent = Color(0xFFB2DFDB);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextTertiary = Color(0xFF8E8E8E);
  static const Color darkTextDisabled = Color(0xFF6C6C6C);
  static const Color darkSelectedIcon = Color(0xFFE0E0E0);
  static const Color darkUnselectedIcon = Color(0xFF9E9E9E);
  static const Color darkError = Color(0xFFFF453A);

  // Dynamic color getters based on current theme
  static Color primary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimary
        : lightPrimary;
  }

  static Color primaryAccent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryAccent
        : lightPrimaryAccent;
  }

  static Color secondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondary
        : lightSecondary;
  }

  static Color secondaryAccent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondaryAccent
        : lightSecondaryAccent;
  }

  static Color secondaryBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightSecondaryBackground;
  }

  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightSecondaryBackground;
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }

  static Color textTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextTertiary
        : lightTextTertiary;
  }

  static Color textDisabled(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextDisabled
        : lightTextDisabled;
  }

  static Color selectedIcon(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSelectedIcon
        : lightSelectedIcon;
  }

  static Color unselectedIcon(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkUnselectedIcon
        : lightUnselectedIcon;
  }

  static Color error(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkError
        : lightError;
  }
}