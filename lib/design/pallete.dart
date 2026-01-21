import 'package:flutter/material.dart';

class Pallete {
  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Gradients
  static const Color gradientLightViolet = Color(0xFF8924E7);
  static const Color gradientDarkViolet = Color(0xFF6A46F9);

  static const Gradient primaryGradient = LinearGradient(
    colors: [gradientLightViolet, gradientDarkViolet],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Text
  static const Color primaryBlackText = Color(0xFF131313);
  static const Color secondaryGreyText = Color(0xFF87858F);
  static const Color primaryWhiteText = Color(0xFFFFFFFF);
  static const Color disabledGreyText = Color(0xFF404040);

  // Status
  static const Color error = Color(0xFFE22400);
  static const Color success = Color(0xFF22B814);
  static const Color warning = Color(0xFFFFAA00);


  // Backgrounds
  static const Color inputFieldBG = Color(0xFF131313);
  static const Color cardBG = Color(0xFF1E1E1E);
  static const Color overlayBG = Color(0x80000000);

  // Borders
  static const Color borderInactive = Color(0xFF87858F);
  static const Color borderActive = Color(0xFFFFFFFF);
}
