import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pheditor/DS/pallete.dart';
import 'package:pheditor/navigation/routes.dart';
import 'package:pheditor/pages/canvas/canvas_args.dart';
import 'package:pheditor/pages/gallery/gallery_cubit.dart';
import 'package:pheditor/pages/gallery/gallery_state.dart';
import 'package:pheditor/widgets/image_card.dart';

class GalleryContent extends StatelessWidget {
  const GalleryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryCubit, GalleryState>(
      builder: (context, state) {
        if (state is GalleryLoading) {
          return const _LoadingView();
        }

        if (state is GalleryError) {
          return _ErrorView(message: state.message);
        }

        if (state is GalleryLoaded) {
          if (state.images.isEmpty) {
            return const _EmptyView();
          }
          return _GridView(images: state.images);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Pallete.primaryWhiteText),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Pallete.error)),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Нет изображений',
        style: TextStyle(color: Pallete.secondaryGreyText, fontSize: 16),
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List<GalleryImageItem> images;

  const _GridView({required this.images});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 100;

    return GridView.builder(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 46,
        bottom: bottomPadding,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return ImageCard(
          imageUrl: image.thumbnailUrl,
          onTap: () async {
            final result = await context.push<bool>(
              AppRoutes.canvas,
              extra: CanvasArgs.edit(imageId: image.id, imageUrl: image.url),
            );
            if (result == true && context.mounted) {
              context.read<GalleryCubit>().refresh();
            }
          },
        );
      },
    );
  }
}
