enum CanvasMode { create, edit }

class CanvasArgs {
  final CanvasMode mode;
  final String? imageId;
  final String? imageUrl;

  const CanvasArgs.create()
    : mode = CanvasMode.create,
      imageId = null,
      imageUrl = null;

  const CanvasArgs.edit({
    required String this.imageId,
    required String this.imageUrl,
  }) : mode = CanvasMode.edit;
}
