import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pheditor/design/pallete.dart';
import 'package:pheditor/pages/canvas/canvas_cubit.dart';
import 'package:pheditor/pages/canvas/canvas_state.dart';
import 'package:pheditor/pages/canvas/widgets/drawing_painter.dart';

class DrawingCanvas extends StatelessWidget {
  final GlobalKey canvasKey;

  const DrawingCanvas({super.key, required this.canvasKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
      buildWhen: (previous, current) {
        return current is CanvasReady || current is CanvasInitial;
      },
      builder: (context, state) {
        final readyState = state is CanvasReady ? state : null;
        if (readyState == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Pallete.gradientLightViolet,
            ),
          );
        }

        final cubit = context.read<CanvasCubit>();

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: RepaintBoundary(
            key: canvasKey,
            child: GestureDetector(
              onPanStart: (details) => cubit.startPath(details.localPosition),
              onPanUpdate: (details) => cubit.updatePath(details.localPosition),
              onPanEnd: (_) => cubit.endPath(),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildBackground(readyState),
                  CustomPaint(
                    painter: DrawingPainter(
                      paths: readyState.paths,
                      currentPath: readyState.currentPath,
                    ),
                    size: Size.infinite,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackground(CanvasReady state) {
    if (state.localImagePath != null) {
      return Image.file(
        File(state.localImagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Pallete.white,
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Pallete.secondaryGreyText,
            ),
          );
        },
      );
    }

    if (state.bgUrl != null) {
      return Image.network(
        state.bgUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              color: Pallete.gradientLightViolet,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Pallete.white,
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Pallete.secondaryGreyText,
            ),
          );
        },
      );
    }
    return Container(color: Pallete.white);
  }
}
