import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pheditor/dependencies/global_dependencies.dart';
import 'package:pheditor/design/pallete.dart';
import 'package:pheditor/navigation/routes.dart';
import 'package:pheditor/pages/canvas/canvas_args.dart';
import 'package:pheditor/pages/auth_page/auth_cubit.dart';
import 'package:pheditor/pages/gallery/gallery_cubit.dart';
import 'package:pheditor/pages/gallery/widgets/gallery_app_bar.dart';
import 'package:pheditor/pages/gallery/widgets/gallery_content.dart';
import 'package:pheditor/widgets/button.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = GlobalDependencies.authService.currentUser?.uid ?? '';

    return BlocProvider(
      create: (_) => GalleryCubit(
        imageRepository: GlobalDependencies.imageRepository,
        userId: userId,
      )..loadImages(),
      child: const _GalleryView(),
    );
  }
}

class _GalleryView extends StatelessWidget {
  const _GalleryView();

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
          onLeftButtonTap: () => _showLogoutDialog(context),
          // onRightButtonTap: () {},
          leftIcon: Icons.login,
          // rightIcon: PhIcons.paint,
          title: 'Галерея',
          iconSize: 28,
        ),
        body: Stack(
          children: [
            const GalleryContent(),
            Positioned(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 20,
              child: Button(
                'Создать',
                () async {
                  final result = await context.push<bool>(
                    AppRoutes.canvas,
                    extra: const CanvasArgs.create(),
                  );
                  if (result == true && context.mounted) {
                    context.read<GalleryCubit>().refresh();
                  }
                },
                gradient: Pallete.primaryGradient,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Pallete.inputFieldBG,
        title: const Text(
          'Выход',
          style: TextStyle(color: Pallete.primaryWhiteText),
        ),
        content: const Text(
          'Вы уверены, что хотите выйти?',
          style: TextStyle(color: Pallete.secondaryGreyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Отмена',
              style: TextStyle(color: Pallete.secondaryGreyText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().signOut();
            },
            child: const Text(
              'Выйти',
              style: TextStyle(color: Pallete.error),
            ),
          ),
        ],
      ),
    );
  }
}
