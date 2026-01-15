import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pheditor/pages/canvas/models/drawing_path.dart';

/// Отрисовка линий на холсте
class DrawingPainter extends CustomPainter {
  final List<DrawingPath> paths;
  final DrawingPath? currentPath;

  DrawingPainter({
    required this.paths,
    this.currentPath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // saveLayer нужен для корректной работы ластика (BlendMode.clear)
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (final path in paths) {
      _drawPath(canvas, path);
    }

    if (currentPath != null) {
      _drawPath(canvas, currentPath!);
    }

    canvas.restore();
  }

  void _drawPath(Canvas canvas, DrawingPath path) {
    if (path.points.length < 2) return;

    final paint = Paint()
      ..strokeWidth = path.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Ластик стирает через прозрачность
    if (path.isEraser) {
      paint.blendMode = ui.BlendMode.clear;
    } else {
      paint.color = path.color;
    }

    for (int i = 0; i < path.points.length - 1; i++) {
      canvas.drawLine(path.points[i], path.points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.paths != paths || oldDelegate.currentPath != currentPath;
  }
}
