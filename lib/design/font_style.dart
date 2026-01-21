import 'package:flutter/material.dart';
import 'package:pheditor/design/pallete.dart';

class FontStyles {
  // static const _fontFamilyPrimary = 'Roboto';
  static const _fontFamilySecondary = 'PressStart2P';

  static final TextStyle ps2p = TextStyle(
    color: Pallete.primaryWhiteText,
    fontSize: 20,
    fontFamily: _fontFamilySecondary,
    shadows: [
      Shadow(
        color: Pallete.gradientLightViolet,
        blurRadius: 15,
        offset: Offset(0, -1),
      ),
      Shadow(
        color: Pallete.gradientLightViolet,
        blurRadius: 30,
        offset: Offset(0, -2),
      ),

      Shadow(
        color: Pallete.gradientDarkViolet,
        blurRadius: 15,
        offset: Offset(0, 1),
      ),
      Shadow(
        color: Pallete.gradientDarkViolet,
        blurRadius: 30,
        offset: Offset(0, 2),
      ),
    ],
  );
}
