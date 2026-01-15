import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pheditor/DS/icons.dart';
import 'package:pheditor/pages/canvas/canvas_cubit.dart';
import 'package:pheditor/pages/canvas/canvas_state.dart';
import 'package:pheditor/pages/canvas/widgets/color_picker_dialog.dart';
import 'package:pheditor/pages/canvas/widgets/stroke_width_picker.dart';
import 'package:pheditor/pages/canvas/widgets/tool_button.dart';

class CanvasToolbar extends StatefulWidget {
  final VoidCallback onDownloadTap;
  final VoidCallback onPickImageTap;

  const CanvasToolbar({
    super.key,
    required this.onDownloadTap,
    required this.onPickImageTap,
  });

  @override
  State<CanvasToolbar> createState() => _CanvasToolbarState();
}

class _CanvasToolbarState extends State<CanvasToolbar> {
  final _paletteKey = GlobalKey();
  final _strokeWidthKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
      buildWhen: (previous, current) {
        if (previous is CanvasReady && current is CanvasReady) {
          return previous.selectedTool != current.selectedTool ||
              previous.selectedColor != current.selectedColor ||
              previous.strokeWidth != current.strokeWidth;
        }
        return true;
      },
      builder: (context, state) {
        if (state is! CanvasReady) return const SizedBox.shrink();

        final cubit = context.read<CanvasCubit>();

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ToolButton(
              icon: Icons.ios_share,
              onPressed: widget.onDownloadTap,
            ),
            ToolButton(
              icon: Icons.photo_library_outlined,
              onPressed: widget.onPickImageTap,
            ),
            ToolButton(
              icon: Icons.brush,
              isSelected: state.selectedTool == CanvasTool.brush,
              onPressed: () => cubit.selectTool(CanvasTool.brush),
            ),
            ToolButton(
              icon: Icons.auto_fix_high,
              isSelected: state.selectedTool == CanvasTool.eraser,
              onPressed: () => cubit.selectTool(CanvasTool.eraser),
            ),
            ToolButton(
              key: _strokeWidthKey,
              icon: Icons.line_weight,
              onPressed: () => _showStrokeWidthPicker(context, state.strokeWidth, cubit),
            ),
            ToolButton(
              key: _paletteKey,
              icon: PhIcons.pallete,
              color: state.selectedColor,
              onPressed: () => _showColorPicker(context, state.selectedColor, cubit),
            ),
          ],
        );
      },
    );
  }

  void _showColorPicker(BuildContext context, Color currentColor, CanvasCubit cubit) {
    showColorPickerPopup(
      context: context,
      anchorKey: _paletteKey,
      currentColor: currentColor,
      onColorSelected: cubit.selectColor,
    );
  }

  void _showStrokeWidthPicker(BuildContext context, double currentWidth, CanvasCubit cubit) {
    showStrokeWidthPicker(
      context: context,
      anchorKey: _strokeWidthKey,
      currentWidth: currentWidth,
      onWidthSelected: cubit.selectStrokeWidth,
    );
  }
}
