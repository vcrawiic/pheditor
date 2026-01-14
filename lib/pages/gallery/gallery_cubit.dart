import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pheditor/repositories/image_repository.dart';
import 'package:pheditor/services/cloudinary_service.dart';
import 'package:pheditor/pages/gallery/gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  final ImageRepository _imageRepository;
  final String _userId;

  GalleryCubit({
    required ImageRepository imageRepository,
    required String userId,
  }) : _imageRepository = imageRepository,
       _userId = userId,
       super(GalleryInitial());

  Future<void> loadImages() async {
    emit(GalleryLoading());
    try {
      final images = await _imageRepository.getUserImages(_userId);
      final items = images
          .map(
            (image) => GalleryImageItem(
              id: image.id,
              url: image.url,
              thumbnailUrl: CloudinaryService.getThumbnailUrl(image.url),
            ),
          )
          .toList();
      emit(GalleryLoaded(items));
    } catch (_) {
      emit(const GalleryError('Не удалось загрузить изображения'));
    }
  }

  Future<void> deleteImage(String imageId) async {
    try {
      await _imageRepository.deleteImage(imageId);
      await loadImages();
    } catch (_) {
      emit(const GalleryError('Не удалось удалить изображение'));
    }
  }

  void refresh() {
    loadImages();
  }
}
