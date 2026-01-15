import 'dart:ui';
import 'package:equatable/equatable.dart';

class DrawingPath extends Equatable {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool isEraser;

  const DrawingPath({
    required this.points,
    required this.color,
    this.strokeWidth = 4.0,
    this.isEraser = false,
  });

  DrawingPath copyWith({
    List<Offset>? points,
    Color? color,
    double? strokeWidth,
    bool? isEraser,
  }) {
    return DrawingPath(
      points: points ?? this.points,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isEraser: isEraser ?? this.isEraser,
    );
  }

  DrawingPath addPoint(Offset point) {
    return copyWith(points: [...points, point]);
  }

  @override
  List<Object?> get props => [points, color, strokeWidth, isEraser];
}
