import 'package:flutter/material.dart';

// обертка для имитации эффекта внутренней тени
class InnerShadow {
  final Color color;
  final double blurRadius;
  final Offset offset;

  const InnerShadow({
    required this.color,
    required this.blurRadius,
    this.offset = Offset.zero,
  });
}

class InnerShadowPainter extends CustomPainter {
  final double borderRadius;
  final List<InnerShadow> shadows;

  InnerShadowPainter({required this.borderRadius, required this.shadows});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    for (final shadow in shadows) {
      final sigma = shadow.blurRadius / 2;

      canvas.saveLayer(rect, Paint());

      final path = Path()
        ..addRect(rect.inflate(shadow.blurRadius * 2))
        ..addRRect(rrect.shift(shadow.offset))
        ..fillType = PathFillType.evenOdd;

      canvas.drawPath(
        path,
        Paint()
          ..color = shadow.color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma),
      );

      canvas.drawRRect(rrect, Paint()..blendMode = BlendMode.dstIn);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(InnerShadowPainter oldDelegate) =>
      borderRadius != oldDelegate.borderRadius || shadows != oldDelegate.shadows;
}
