import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pheditor/DS/inner_shadow_painter.dart';
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: CustomPaint(
          foregroundPainter: InnerShadowPainter(
            borderRadius: 8,
            shadows: const [
              InnerShadow(
                color: Color.fromRGBO(227, 227, 227, 0.2),
                blurRadius: 40,
                offset: Offset(0, 1),
              ),
              InnerShadow(
                color: Color.fromRGBO(96, 68, 144, 0.3),
                blurRadius: 68,
                offset: Offset(0, -82),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Pallete.transparent,
            surfaceTintColor: Pallete.transparent,
            leading: IconButton(
              onPressed: onLeftButtonTap,
              icon: Icon(leftIcon, color: leftIconColor ?? Pallete.error, size: iconSize),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: Pallete.primaryWhiteText,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: rightIcon != null
                ? [IconButton(onPressed: onRightButtonTap, icon: Icon(rightIcon, size: 28))]
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
