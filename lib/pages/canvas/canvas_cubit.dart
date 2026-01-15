import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pheditor/pages/canvas/canvas_args.dart';
import 'package:pheditor/pages/canvas/canvas_state.dart';
import 'package:pheditor/pages/canvas/models/drawing_path.dart';
import 'package:pheditor/repositories/image_repository.dart';
import 'package:pheditor/services/cloudinary_service.dart';

/// Управление состоянием холста для рисования
class CanvasCubit extends Cubit<CanvasState> {
  final CloudinaryService _cloudinaryService;
  final ImageRepository _imageRepository;
  final String _userId;

  CanvasCubit({
    required CloudinaryService cloudinaryService,
    required ImageRepository imageRepository,
    required String userId,
  }) : _cloudinaryService = cloudinaryService,
       _imageRepository = imageRepository,
       _userId = userId,
       super(const CanvasInitial());

  void init(CanvasArgs args) {
    switch (args.mode) {
      case CanvasMode.create:
        emit(const CanvasReady());
      case CanvasMode.edit:
        emit(CanvasReady(bgUrl: args.imageUrl, imageId: args.imageId));
    }
  }

  // Обработка жестов рисования: начало, обновление, завершение линии
  void startPath(Offset point) {
    final currentState = state;
    if (currentState is! CanvasReady) return;

    final isEraser = currentState.selectedTool == CanvasTool.eraser;

    final newPath = DrawingPath(
      points: [point],
      color: currentState.selectedColor,
      strokeWidth: currentState.strokeWidth,
      isEraser: isEraser,
    );

    emit(currentState.copyWith(currentPath: newPath));
  }

  void updatePath(Offset point) {
    final currentState = state;
    if (currentState is! CanvasReady) return;
    if (currentState.currentPath == null) return;

    final updatedPath = currentState.currentPath!.addPoint(point);
    emit(currentState.copyWith(currentPath: updatedPath));
  }

  void endPath() {
    final currentState = state;
    if (currentState is! CanvasReady) return;
    if (currentState.currentPath == null) return;

    // Переносим текущий путь в список завершённых
    final updatedPaths = [...currentState.paths, currentState.currentPath!];
    emit(currentState.copyWith(paths: updatedPaths, clearCurrentPath: true));
  }

  void selectColor(Color color) {
    final currentState = state;
    if (currentState is! CanvasReady) return;

    emit(currentState.copyWith(selectedColor: color));
  }

  void selectStrokeWidth(double width) {
    final currentState = state;
    if (currentState is! CanvasReady) return;

    emit(currentState.copyWith(strokeWidth: width));
  }

  void selectTool(CanvasTool tool) {
    final currentState = state;
    if (currentState is! CanvasReady) return;

    emit(currentState.copyWith(selectedTool: tool));
  }

  void undo() {
    final currentState = state;
    if (currentState is! CanvasReady) return;
    if (!currentState.canUndo) return;

    final updatedPaths = List<DrawingPath>.from(currentState.paths)
      ..removeLast();

    emit(currentState.copyWith(paths: updatedPaths));
  }

  void clear() {
    final currentState = state;
    if (currentState is! CanvasReady) return;

    emit(currentState.copyWith(paths: [], clearCurrentPath: true));
  }

  void setBackgroundImage(String imagePath) {
    final currentState = state;
    if (currentState is! CanvasReady) return;

    emit(currentState.copyWith(localImagePath: imagePath));
  }

  /// Сохранение: захват виджета -> загрузка в Cloudinary -> запись в Firestore
  Future<void> saveImage(GlobalKey canvasKey) async {
    final currentState = state;
    if (currentState is! CanvasReady) return;

    if (currentState.imageId == null && currentState.isEmpty) {
      emit(
        CanvasError(
          message: 'Холст пуст. Нарисуйте что-нибудь перед сохранением.',
          previousState: currentState,
        ),
      );
      return;
    }

    emit(const CanvasSaving());

    try {
      final bytes = await _captureCanvas(canvasKey);
      if (bytes == null) {
        throw Exception('Не удалось захватить изображение');
      }

      final fileName = 'canvas_${DateTime.now().millisecondsSinceEpoch}';
      final imageUrl = await _cloudinaryService.uploadImage(bytes, fileName);
      if (imageUrl == null) {
        throw Exception('Ошибка загрузки в Cloudinary');
      }

      // Обновляем существующее или создаём новое
      if (currentState.imageId != null) {
        final existingImage = await _imageRepository.getImageById(
          currentState.imageId!,
        );
        if (existingImage != null) {
          await _imageRepository.updateImage(
            existingImage.copyWith(url: imageUrl),
          );
        }
      } else {
        await _imageRepository.saveImage(userId: _userId, url: imageUrl);
      }

      emit(CanvasSaved(imageUrl: imageUrl));
    } catch (e) {
      emit(
        CanvasError(
          message: 'Не удалось сохранить изображение',
          previousState: currentState,
        ),
      );
    }
  }

  void dismissError() {
    final currentState = state;
    if (currentState is! CanvasError) return;

    if (currentState.previousState != null) {
      emit(currentState.previousState!);
    } else {
      emit(const CanvasReady());
    }
  }

  // Захват содержимого RepaintBoundary в PNG
  Future<Uint8List?> _captureCanvas(GlobalKey canvasKey) async {
    try {
      final boundary =
          canvasKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // pixelRatio 3.0 для хорошего качества на retina
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
}
