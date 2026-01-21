import 'package:flutter/material.dart';
import 'package:pheditor/design/pallete.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Gradient? gradient;
  final bool enabled;

  const Button(
    this.label,
    this.onTap, {
    super.key,
    this.gradient,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isGradient = gradient != null && enabled;

    final button = ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isGradient
            ? Pallete.transparent
            : Pallete.primaryWhiteText,
        foregroundColor: enabled
            ? (isGradient ? Pallete.primaryWhiteText : Pallete.primaryBlackText)
            : Pallete.secondaryGreyText,
        disabledBackgroundColor: Pallete.secondaryGreyText,
        disabledForegroundColor: Pallete.disabledGreyText,
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );

    if (!isGradient) return button;

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: button,
    );
  }
}
