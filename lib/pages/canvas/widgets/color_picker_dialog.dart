import 'package:flutter/material.dart';
import 'package:pheditor/DS/pallete.dart';

/// Палитра цветов 12x10 с градиентами
class ColorPickerPopup extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;
  final VoidCallback onClose;

  const ColorPickerPopup({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
    required this.onClose,
  });

  static const int columns = 12;
  static const int rows = 10;

  // Базовые насыщенные цвета (4-я строка)
  static const List<Color> _brightRow = [
    Color(0xFF00B4D8),
    Color(0xFF0077B6),
    Color(0xFF5E60CE),
    Color(0xFF9D4EDD),
    Color(0xFFE22400),
    Color(0xFFFF5400),
    Color(0xFFFF8500),
    Color(0xFFFFAA00),
    Color(0xFFFFD000),
    Color(0xFFD4E400),
    Color(0xFF8AC926),
    Color(0xFF22B814),
  ];

  static Color _colorAt(int column, int row) {
    // Первая строка - градиент серого
    if (row == 0) {
      final t = column / (columns - 1);
      return Color.lerp(Colors.white, Colors.black, t)!;
    }

    final brightColor = _brightRow[column];

    // Строки 1-4: от тёмного к насыщенному (через HSV value)
    if (row <= 4) {
      final t = (row - 1) / 3;
      final darkColor = HSVColor.fromColor(brightColor)
          .withValue(0.2)
          .toColor();
      return Color.lerp(darkColor, brightColor, t)!;
    } else {
      // Строки 5-9: от насыщенного к пастельному (уменьшаем saturation)
      final t = (row - 4) / (rows - 5);
      final hsv = HSVColor.fromColor(brightColor);
      return hsv
          .withSaturation(hsv.saturation * (1 - t * 0.9))
          .withValue(hsv.value + (1 - hsv.value) * t)
          .toColor();
    }
  }

  static List<Color> generatePalette() {
    final colors = <Color>[];

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < columns; x++) {
        colors.add(_colorAt(x, y));
      }
    }

    return colors;
  }

  static const double cellSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final colors = generatePalette();

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      color: Pallete.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: columns * cellSize,
          height: rows * cellSize,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
            ),
            itemCount: columns * rows,
            itemBuilder: (context, index) {
              final color = colors[index];
              final isSelected = color.toARGB32() == currentColor.toARGB32();

              return GestureDetector(
                onTap: () {
                  onColorSelected(color);
                  onClose();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    border: isSelected
                        ? Border.all(color: Pallete.white, width: 2)
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
void showColorPickerPopup({
  required BuildContext context,
  required GlobalKey anchorKey,
  required Color currentColor,
  required ValueChanged<Color> onColorSelected,
}) {
  final overlay = Overlay.of(context);
  final renderBox = anchorKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final position = renderBox.localToGlobal(Offset.zero);
  final anchorSize = renderBox.size;
  final screenSize = MediaQuery.of(context).size;

  const popupWidth = ColorPickerPopup.columns * ColorPickerPopup.cellSize + 16;

  var left = position.dx + anchorSize.width - popupWidth;
  final top = position.dy + anchorSize.height + 8;

  if (left < 8) left = 8;
  if (left + popupWidth > screenSize.width - 8) {
    left = screenSize.width - popupWidth - 8;
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
          top: top,
          child: ColorPickerPopup(
            currentColor: currentColor,
            onColorSelected: onColorSelected,
            onClose: () => entry.remove(),
          ),
        ),
      ],
    ),
  );

  overlay.insert(entry);
}
void showColorPickerDialog({
  required BuildContext context,
  required Color currentColor,
  required ValueChanged<Color> onColorSelected,
}) {
  final overlay = Overlay.of(context);
  final screenSize = MediaQuery.of(context).size;

  const popupWidth = 300.0;
  const popupHeight = 300.0 * 10 / 12 + 16; // aspect ratio + padding

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => entry.remove(),
            behavior: HitTestBehavior.opaque,
            child: const ColoredBox(color: Colors.black26),
          ),
        ),
        Positioned(
          left: (screenSize.width - popupWidth) / 2,
          top: (screenSize.height - popupHeight) / 2,
          child: ColorPickerPopup(
            currentColor: currentColor,
            onColorSelected: onColorSelected,
            onClose: () => entry.remove(),
          ),
        ),
      ],
    ),
  );

  overlay.insert(entry);
}
