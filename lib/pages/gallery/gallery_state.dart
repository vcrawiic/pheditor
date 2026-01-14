import 'package:equatable/equatable.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<GalleryImageItem> images;

  const GalleryLoaded(this.images);

  @override
  List<Object?> get props => [images];
}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError(this.message);

  @override
  List<Object?> get props => [message];
}

class GalleryImageItem extends Equatable {
  final String id;
  final String url;
  final String thumbnailUrl;

  const GalleryImageItem({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [id, url, thumbnailUrl];
}
