import 'package:flutter/material.dart';
import 'package:pheditor/DS/pallete.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLeftButtonTap;
  final VoidCallback? onRightButtonTap;
  final Color? leftIconColor;

  final IconData leftIcon;
  final IconData? rightIcon;

  final String title;
  final double iconSize;

  const CustomAppBar({
    super.key,
    required this.onLeftButtonTap,
    this.onRightButtonTap,
    required this.leftIcon,
    this.rightIcon,
    required this.title,
    this.leftIconColor,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Pallete.transparent,
      surfaceTintColor: Pallete.transparent,
      leading: IconButton(
        onPressed: onLeftButtonTap,
        icon: Icon(
          leftIcon,
          color: leftIconColor ?? Pallete.errorText,
          size: iconSize,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Pallete.primaryWhiteText,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: rightIcon != null
          ? [
              IconButton(
                onPressed: onRightButtonTap,
                icon: Icon(rightIcon, size: 28),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
