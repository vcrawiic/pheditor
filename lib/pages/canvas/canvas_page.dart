import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pheditor/DI/global_dependencies.dart';
import 'package:pheditor/DS/pallete.dart';
import 'package:pheditor/pages/canvas/canvas_args.dart';
import 'package:pheditor/pages/canvas/canvas_cubit.dart';
import 'package:pheditor/pages/canvas/canvas_state.dart';
import 'package:pheditor/pages/canvas/widgets/canvas_toolbar.dart';
import 'package:pheditor/pages/canvas/widgets/drawing_canvas.dart';
import 'package:pheditor/pages/gallery/widgets/gallery_app_bar.dart';
import 'package:pheditor/widgets/app_toast.dart';

class CanvasPage extends StatelessWidget {
  final CanvasArgs args;

  const CanvasPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final userId = GlobalDependencies.authService.currentUser?.uid ?? '';

    return BlocProvider(
      create: (_) => CanvasCubit(
        cloudinaryService: GlobalDependencies.cloudinaryService,
        imageRepository: GlobalDependencies.imageRepository,
        userId: userId,
      )..init(args),
      child: _CanvasView(args: args),
    );
  }
}

class _CanvasView extends StatefulWidget {
  final CanvasArgs args;

  const _CanvasView({required this.args});

  @override
  State<_CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<_CanvasView> {
  final GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CanvasCubit, CanvasState>(
      listener: _handleStateChanges,
      builder: (context, state) {
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
              onRightButtonTap: () => _saveImage(context),
              iconSize: 32,
            ),
            body: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      CanvasToolbar(
                        onDownloadTap: () => _shareImage(context),
                        onPickImageTap: () => _pickImage(context),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 120),
                          child: DrawingCanvas(canvasKey: _canvasKey),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is CanvasSaving)
                  Container(
                    color: Pallete.overlayBG,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Pallete.white),
                          SizedBox(height: 16),
                          Text(
                            'Сохранение...',
                            style: TextStyle(color: Pallete.primaryWhiteText),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, CanvasState state) {
    if (state is CanvasSaved) {
      AppToast.show(
        context,
        message: 'Изображение сохранено',
        type: ToastType.success,
      );
      context.pop(true);
    } else if (state is CanvasError) {
      AppToast.show(
        context,
        message: state.message,
        type: ToastType.error,
      );
      context.read<CanvasCubit>().dismissError();
    }
  }

  void _saveImage(BuildContext context) {
    context.read<CanvasCubit>().saveImage(_canvasKey);
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      final boundary = _canvasKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/pheditor_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Изображение из Pheditor',
      );
    } catch (e) {
      if (context.mounted) {
        AppToast.show(
          context,
          message: 'Не удалось поделиться изображением',
          type: ToastType.error,
        );
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null && context.mounted) {
        context.read<CanvasCubit>().setBackgroundImage(pickedFile.path);
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.show(
          context,
          message: 'Не удалось выбрать изображение',
          type: ToastType.error,
        );
      }
    }
  }
}
