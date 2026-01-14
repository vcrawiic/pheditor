import 'package:flutter/material.dart';

class Pallete {
  static final Color transparent = Colors.transparent;

  static const Color gradientLightViolet = Color(0xFF8924E7);
  static const Color gradientDarkViolet = Color(0xFF6A46F9);

  static const Gradient primaryGradient = LinearGradient(
    colors: [gradientLightViolet, gradientDarkViolet],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color primaryBlackText = Color(0xFF131313);
  static const Color secondaryGreyText = Color(0xFF87858F);
  static const Color primaryWhiteText = Color(0xFFFFFFFF);
  static const Color disabledGreyText = Color(0xFF404040);
  static const Color errorText = Colors.red;


  static const Color inputFieldBG = Color(0xFF131313);
  static const Color borderInactive = Color(0xFF87858F);
  static const Color borderActive = Color(0xFFFFFFFF);
  static const Color borderError = Colors.red;
}
