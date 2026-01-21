import 'package:flutter/material.dart';
import 'package:pheditor/design/pallete.dart';

class StrokeWidthPicker extends StatelessWidget {
  final double currentWidth;
  final ValueChanged<double> onWidthSelected;
  final VoidCallback onClose;

  const StrokeWidthPicker({
    super.key,
    required this.currentWidth,
    required this.onWidthSelected,
    required this.onClose,
  });

  static const List<double> presetWidths = [2, 4, 8, 12, 16, 24, 32];

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: Pallete.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: presetWidths.map((width) {
            final isSelected = width == currentWidth;
            return GestureDetector(
              onTap: () {
                onWidthSelected(width);
                onClose();
              },
              child: Container(
                width: 120,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Pallete.gradientLightViolet.withValues(alpha: 0.1)
                      : Pallete.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: width,
                    decoration: BoxDecoration(
                      color: Pallete.black,
                      borderRadius: BorderRadius.circular(width / 2),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

void showStrokeWidthPicker({
  required BuildContext context,
  required GlobalKey anchorKey,
  required double currentWidth,
  required ValueChanged<double> onWidthSelected,
}) {
  final overlay = Overlay.of(context);
  final renderBox = anchorKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final position = renderBox.localToGlobal(Offset.zero);
  final anchorSize = renderBox.size;
  final screenSize = MediaQuery.of(context).size;

  const popupWidth = 144.0;
  final popupHeight =
      StrokeWidthPicker.presetWidths.length * 48.0 + 24; 

  var left = position.dx + anchorSize.width - popupWidth;
  final top = position.dy + anchorSize.height + 8;

  if (left < 8) left = 8;
  if (left + popupWidth > screenSize.width - 8) {
    left = screenSize.width - popupWidth - 8;
  }

  var adjustedTop = top;
  if (top + popupHeight > screenSize.height - 8) {
    adjustedTop = position.dy - popupHeight - 8;
  }

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => entry.remove(),
            behavior: HitTestBehavior.opaque,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),
        Positioned(
          left: left,
          top: adjustedTop,
          child: StrokeWidthPicker(
            currentWidth: currentWidth,
            onWidthSelected: onWidthSelected,
            onClose: () => entry.remove(),
          ),
        ),
      ],
    ),
  );

  overlay.insert(entry);
}
