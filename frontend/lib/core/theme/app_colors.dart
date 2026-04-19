import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  static const Color background = Color(0xFF050C1C);

  static const Color surface = Color(0xFF0B1F3A);

  static const Color surfaceElevated = Color(0xFF182436);

  static const Color surfaceMuted = Color(0xFF1A2436);

  static const Color surfaceFooter = Color(0xFF080D18);

  static const Color surfaceDeep = Color(0xFF0A1120);

  static const Color accent = Color(0xFF5B8CFF);
  static const Color accentBlue = Color(0xFF001B43);
  static const Color accentMuted = Color(0xFF3D5A8C);
  static const Color accentIcon = Color(0xFFADC6FF);

  static const Color border = Color(0x33FFFFFF);

  static const Color borderHairline = Color(0x22FFFFFF);

  static const Color borderOnSurface = Color(0x14FFFFFF);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8C0CC);

  static const Color navBarBackground = background;
  static const Color navActiveUnderline = accent;
  static const Color pillInactiveBackground = surface;
  static const Color dropdownMenuBackground = surfaceElevated;

  static const Color badgeBorder = Color(0x66D7E3FF);
  static const Color primaryText = Color(0xFFE8EEF9);
  static const Color secondaryText = Color(0xFF9EABC1);
  static const Color tertiaryText = Color(0xFF7D8AA3);
  static const Color actionText = Color(0xFFC9D8FF);
  static const Color visitText = Color(0xFF002E6A);
  static const Color titleText = Color(0xFFADC6FF);
}
