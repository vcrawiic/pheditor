import 'package:flutter/material.dart';
import 'package:pheditor/design/pallete.dart';

class ToolButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  final bool isSelected;
  final Color? color;

  const ToolButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Pallete.borderInactive,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Pallete.primaryWhiteText, width: 2)
              : null,
        ),
        child: Icon(
          icon,
          color: color ?? Pallete.primaryWhiteText,
          size: 18,
        ),
      ),
    );
  }
}
