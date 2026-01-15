import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:pheditor/pages/canvas/models/drawing_path.dart';

enum CanvasTool { brush, eraser }

sealed class CanvasState extends Equatable {
  const CanvasState();

  @override
  List<Object?> get props => [];
}

class CanvasInitial extends CanvasState {
  const CanvasInitial();
}

class CanvasReady extends CanvasState {
  final List<DrawingPath> paths;
  final DrawingPath? currentPath;
  final Color selectedColor;
  final double strokeWidth;
  final CanvasTool selectedTool;
  final String? bgUrl;
  final String? localImagePath;
  final String? imageId;

  const CanvasReady({
    this.paths = const [],
    this.currentPath,
    this.selectedColor = const Color(0xFF000000),
    this.strokeWidth = 4.0,
    this.selectedTool = CanvasTool.brush,
    this.bgUrl,
    this.localImagePath,
    this.imageId,
  });

  CanvasReady copyWith({
    List<DrawingPath>? paths,
    DrawingPath? currentPath,
    bool clearCurrentPath = false,
    Color? selectedColor,
    double? strokeWidth,
    CanvasTool? selectedTool,
    String? bgUrl,
    String? localImagePath,
    String? imageId,
  }) {
    return CanvasReady(
      paths: paths ?? this.paths,
      currentPath: clearCurrentPath ? null : (currentPath ?? this.currentPath),
      selectedColor: selectedColor ?? this.selectedColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      selectedTool: selectedTool ?? this.selectedTool,
      bgUrl: bgUrl ?? this.bgUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      imageId: imageId ?? this.imageId,
    );
  }
  bool get hasBackground => bgUrl != null || localImagePath != null;

  bool get canUndo => paths.isNotEmpty;

  bool get isEmpty => paths.isEmpty && currentPath == null && !hasBackground;

  @override
  List<Object?> get props => [
    paths,
    currentPath,
    selectedColor,
    strokeWidth,
    selectedTool,
    bgUrl,
    localImagePath,
    imageId,
  ];
}

class CanvasSaving extends CanvasState {
  const CanvasSaving();
}

class CanvasSaved extends CanvasState {
  final String imageUrl;

  const CanvasSaved({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class CanvasError extends CanvasState {
  final String message;

  final CanvasReady? previousState;

  const CanvasError({required this.message, this.previousState});

  @override
  List<Object?> get props => [message, previousState];
}
