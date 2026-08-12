import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  const AppTheme();

  static const String _notoSansFamily = 'NotoSans';

  ThemeData light(BuildContext context) {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightSecondaryBackground,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lightPrimary),
      textTheme: _notoSansTextTheme(base.textTheme, context, false),
    );
  }

  ThemeData dark(BuildContext context) {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkPrimary,
        brightness: Brightness.dark,
      ),
      textTheme: _notoSansTextTheme(base.textTheme, context, true)
          .apply(bodyColor: AppColors.darkTextPrimary),
    );
  }

  TextTheme _notoSansTextTheme(TextTheme base, BuildContext ctx, bool isDark) {
    double r(double size) => size * MediaQuery.textScaleFactorOf(ctx);

    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return TextTheme(
      bodySmall: base.bodySmall?.copyWith(
        fontSize: r(14),
        fontWeight: FontWeight.w300,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: r(16),
        fontWeight: FontWeight.w400,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: r(18),
        fontWeight: FontWeight.w400,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),

      labelSmall: base.labelSmall?.copyWith(
        fontSize: r(11),
        fontWeight: FontWeight.w500,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: r(12),
        fontWeight: FontWeight.w500,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: r(14),
        fontWeight: FontWeight.w600,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),

      titleSmall: base.titleSmall?.copyWith(
        fontSize: r(14),
        fontWeight: FontWeight.w500,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: r(16),
        fontWeight: FontWeight.w500,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: r(22),
        fontWeight: FontWeight.w600,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),

      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: r(24),
        fontWeight: FontWeight.w600,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: r(28),
        fontWeight: FontWeight.w600,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: r(32),
        fontWeight: FontWeight.w800,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),

      displaySmall: base.displaySmall?.copyWith(
        fontSize: r(36),
        fontWeight: FontWeight.w700,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: r(45),
        fontWeight: FontWeight.w800,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
      displayLarge: base.displayLarge?.copyWith(
        fontSize: r(57),
        fontWeight: FontWeight.w900,
        color: textColor,
        fontFamily: _notoSansFamily,
      ),
    );
  }
}
