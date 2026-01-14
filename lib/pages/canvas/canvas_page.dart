import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pheditor/DS/pallete.dart';
import 'package:pheditor/pages/canvas/canvas_args.dart';
import 'package:pheditor/pages/canvas/widgets/drawing_painter.dart';
import 'package:pheditor/pages/gallery/widgets/gallery_app_bar.dart';

class CanvasPage extends StatefulWidget {
  final CanvasArgs args;

  const CanvasPage({super.key, required this.args});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  List<List<Offset>> paths = [];
  List<Color> colors = [];
  Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/splash.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Pallete.transparent,
        appBar: CustomAppBar(
          onLeftButtonTap: () => context.pop(),
          leftIcon: Icons.chevron_left_sharp,
          leftIconColor: Pallete.primaryWhiteText,
          title: widget.args.mode == CanvasMode.edit
              ? 'Редактирование'
              : 'Новое изображение',
          rightIcon: Icons.check,
          onRightButtonTap: _saveImage,
          iconSize: 32,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            spacing: 24,
            children: [
              Row(),
              Expanded(
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      paths.add([details.localPosition]);
                      colors.add(selectedColor);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      paths.last.add(details.localPosition);
                    });
                  },
                  child: Container(
                    child: CustomPaint(
                      painter: DrawingPainter(paths, colors),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveImage() {}
}
