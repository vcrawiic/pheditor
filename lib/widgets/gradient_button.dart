import 'package:flutter/material.dart';
import 'package:pheditor/DS/pallete.dart';

class GradientButton extends StatelessWidget {
  final String _label;
  final VoidCallback _onTap;
  const GradientButton(this._label, this._onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Pallete.gradientLightViolet, Pallete.gradientDarkViolet],
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomCenter,
        ),
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      child: ElevatedButton(
        onPressed: _onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          _label,
          style: const TextStyle(fontSize: 16, color: Pallete.primaryWhiteText),
        ),
      ),
    );
  }
}
